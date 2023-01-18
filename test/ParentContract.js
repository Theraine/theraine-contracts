const { ethers } = require("hardhat");
const { expect } = require("chai");
const web3 = require("web3");

describe("Parent Contract Tests", function() {
    let parent;

    beforeEach(async function() {
        const Parent = await ethers.getContractFactory("ParentContract");
        parent = await Parent.deploy();
    });

    describe("Parent Contract", function() {
        it("creates a new platform", async function() {
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
    });
});    