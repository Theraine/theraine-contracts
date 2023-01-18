// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./PlatformContract.sol";

contract ParentContract {
    mapping(address => Platform) private userLatestPlatform;
    mapping(address => Platform[]) private userPlatforms;

    struct Platform {
        uint256 id;
        address platform;
        bytes details;
    }

    Platform[] private platforms;

    /**
     * @dev Creates a new platform.
     */
    function createPlatform(bytes memory _details) public {
        PlatformContract pc = new PlatformContract();
        Platform memory p = Platform({
            id: platforms.length,
            platform: address(pc),
            details: _details
        });
        platforms.push(p);
        userLatestPlatform[msg.sender] = p;
        userPlatforms[msg.sender].push(p);
    }

    /**
     * @dev gets a platform.
     */
    function getPlatform(uint256 _id) public view returns (Platform memory) {
        return platforms[_id];
    }

    /**
     * @dev gets all platforms.
     */
    function getPlatforms() public view returns (Platform[] memory) {
        return platforms;
    }

    /**
     * @dev gets all platforms for a user.
     */
    function getUserPlatforms() public view returns (Platform[] memory) {
        return userPlatforms[msg.sender];
    }

    /**
     * @dev gets the latest platform for a user.
     */
    function getUserLatestPlatform() public view returns (Platform memory) {
        return userLatestPlatform[msg.sender];
    }
}