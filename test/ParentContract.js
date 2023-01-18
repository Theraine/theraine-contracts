const { ethers } = require("hardhat");
const { expect } = require("chai");
const web3 = require("web3");

describe("Parent Contract Tests", function() {
    let parent;
    let owner;
    let otherAccount;

    beforeEach(async function() {
        const Parent = await ethers.getContractFactory("ParentContract");
        parent = await Parent.deploy();
        [owner, otherAccount] = await ethers.getSigners();
    });

    describe("Parent Contract", function() {
        it("creates a new platform", async function() {
            const details = web3.utils.fromAscii("Test Platform");
            await parent.createPlatform(details);
            const platformStruct = await parent.getPlatform(0);
            
            expect(platformStruct.details).to.equal(details);
        });

        it("gets a platform by id", async function() {
            const details = web3.utils.fromAscii("Test Platform");
            await parent.createPlatform(details);
            const platformStruct = await parent.getPlatform(0);

            expect(platformStruct.details).to.equal(details);
        });

        it("gets all platforms", async function() {
            const details1 = web3.utils.fromAscii("Test Platform 1");
            const details2 = web3.utils.fromAscii("Test Platform 2");
            await parent.createPlatform(details1);
            await parent.createPlatform(details2);
            const platforms = await parent.getPlatforms();

            expect(platforms.length).to.equal(2);
            expect(platforms[0].details).to.equal(details1);
            expect(platforms[1].details).to.equal(details2);
        });

        it("gets all platforms of sender", async function() {
            const details1 = web3.utils.fromAscii("Test Platform 1");
            const details2 = web3.utils.fromAscii("Test Platform 2");
            const details3 = web3.utils.fromAscii("Test Platform 3");
            await parent.connect(otherAccount).createPlatform(details1);
            await parent.createPlatform(details2);
            await parent.connect(otherAccount).createPlatform(details3);
            const platforms = await parent.connect(otherAccount).getUserPlatforms();

            expect(platforms.length).to.equal(2);
            expect(platforms[0].details).to.equal(details1);
            expect(platforms[1].details).to.equal(details3);
        });

        it("gets latest platform of sender", async function() {
            const details1 = web3.utils.fromAscii("Test Platform 1");
            const details2 = web3.utils.fromAscii("Test Platform 2");
            const details3 = web3.utils.fromAscii("Test Platform 3");
            await parent.connect(otherAccount).createPlatform(details1);
            await parent.createPlatform(details2);
            await parent.connect(otherAccount).createPlatform(details3);
            const ownerLatest = await parent.getUserLatestPlatform();
            const otherAccountLatest = await parent.connect(otherAccount).getUserLatestPlatform();

            expect(ownerLatest.details).to.equal(details2);
            expect(otherAccountLatest.details).to.equal(details3);
        })
    });
});    