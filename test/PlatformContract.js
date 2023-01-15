const { ethers } = require("hardhat");
const hre = require("hardhat");
const { expect } = require("chai");

describe("Platform Contract Tests", function() {
    let platform;
    let owner;
    let otherAccount;
    beforeEach(async function() {
        const Platform = await ethers.getContractFactory("PlatformContract");
        platform = await Platform.deploy();
        [owner, otherAccount] = await ethers.getSigners();
    });

    describe("Subscribe", function() {
        it("reverts when msg.value is not equal to the plan's price", async function() {
            await expect(platform.subscribe(0, { value: ethers.utils.parseEther("1") })).to.be.reverted;
        });

        it("subscribes user to plan when msg.value is equal to the plan's price", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            await expect(platform.subscribe(0, { value: ethers.utils.parseEther("1") })).to.be.fulfilled;
        });

        it("subscribes user to plan when user does not have an active subscription", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            await platform.connect(otherAccount).subscribe(0, { value: ethers.utils.parseEther("1") });
            const userStatus = await platform.userStatus(otherAccount.address);
            expect(userStatus).to.be.true;
        });

        it("subscribes user to plan and extends subscription duration when user already has an active subscription", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            await platform.subscribe(0, { value: ethers.utils.parseEther("1") });
            const previousDated = await platform.getUserSubDated(owner.address);

            await platform.subscribe(0, { value: ethers.utils.parseEther("1") });
            const currentDated = await platform.getUserSubDated(owner.address);

            expect(currentDated).to.be.greaterThan(previousDated);
        });
    });

    describe("Add Plan", function() {
        it("adds a new plan when called by the contract owner", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            const plan = await platform.getPlan(0);

            expect(plan.price).to.equal(ethers.utils.parseEther("1"));
            expect(plan.duration).to.equal(1 * 86400);
        });

        it("reverts when called by a non-owner address", async function() {
            await expect(platform.connect(otherAccount).addPlan(ethers.utils.parseEther("1"), 1)).to.be.reverted;
        });
    });

    describe("Remove Plan", function() {
        it("removes a plan when called by the contract owner", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            await platform.removePlan(0);
            
            await expect(platform.getPlan(0)).to.be.reverted;
        });

        it("reverts when called by a non-owner address", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            await expect(platform.connect(otherAccount).removePlan(0)).to.be.reverted;
        });
    });

    describe("Get Plan", function() {
        it("returns the correct plan when given a valid plan ID", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            const plan = await platform.getPlan(0);

            expect(plan.price).to.equal(ethers.utils.parseEther("1"));
            expect(plan.duration).to.equal(1 * 86400);
        });

        it("reverts when given an invalid plan ID", async function() {
            await expect(platform.getPlan(1)).to.be.reverted;
        });
    });

    describe("Get Plans", function() {
        it("returns all existing plans", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            await platform.addPlan(ethers.utils.parseEther("2"), 2);
            const plans = await platform.getPlans();

            expect(plans[0].price).to.equal(ethers.utils.parseEther("1"));
            expect(plans[0].duration).to.equal(1 * 86400);
            expect(plans[1].price).to.equal(ethers.utils.parseEther("2"));
            expect(plans[1].duration).to.equal(2 * 86400);
        });
    });

    describe("User Status", function() {
        it("returns true when user has an active subscription", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            await platform.connect(otherAccount).subscribe(0, { value: ethers.utils.parseEther("1") });
            const status = await platform.userStatus(otherAccount.address);

            expect(status).to.be.true;
        });

        it("returns false when user does not have an active subscription", async function() {
            await platform.addPlan(ethers.utils.parseEther("1"), 1);
            const status = await platform.userStatus(otherAccount.address);
            
            expect(status).to.be.false;
        });
        
        it("reverts when called by a non-owner address for a user that is not msg.sender", async function() {
            await expect(platform.connect(otherAccount).userStatus(owner.address)).to.be.reverted;
        });
    });
});
