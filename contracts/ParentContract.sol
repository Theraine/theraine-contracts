// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./PlatformContract.sol";

contract ParentContract {
    
    /**
     * @dev mapping of users to their latest platform
     */
    mapping(address => Platform) private userLatestPlatform;

    /**
     * @dev mapping of users to their all platforms
     */
    mapping(address => Platform[]) private userPlatforms;

    /**
     * @dev Platform structure contains the platform's details and its address
     */
    struct Platform {
        uint256 id;
        address platform;
        bytes details;
    }

    /**
     * @dev all the platforms
     */
    Platform[] private platforms;

    /**
     * @dev Creates a new platform.
     * @param _details the details of the platform
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
     * @param _id the platform ID
     * @return the platform
     */
    function getPlatform(uint256 _id) public view returns (Platform memory) {
        return platforms[_id];
    }

    /**
     * @dev gets all platforms.
     * @return all the platforms
     */
    function getPlatforms() public view returns (Platform[] memory) {
        return platforms;
    }

    /**
     * @dev gets all platforms for a user.
     * @return all the platforms for a user
     */
    function getUserPlatforms() public view returns (Platform[] memory) {
        return userPlatforms[msg.sender];
    }

    /**
     * @dev gets the latest platform for a user.
     * @return the latest platform for a user
     */
    function getUserLatestPlatform() public view returns (Platform memory) {
        return userLatestPlatform[msg.sender];
    }
}
