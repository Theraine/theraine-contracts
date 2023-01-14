// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./PlatformContract.sol";

contract ParentContract {
    using Counters for Counters.Counter;
    Counters.Counter private _platformIds;
    struct Platform {
        uint256 id;
        bytes32 details;
    }

    Platform[] private platforms;

    /**
     * @dev Creates a new platform.
     */
    function createPlatform(bytes32 _details) public returns(address) {
        Platform memory p = Platform({
            id: _platformIds.current(),
            details: _details
        });
        platforms.push(p);
        PlatformContract pc = new PlatformContract();
        _platformIds.increment();
        return address(pc);
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
}