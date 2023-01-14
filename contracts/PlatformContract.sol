// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";

contract PlatformContract {
    using Counters for Counters.Counter;
    Counters.Counter private _planIds;

    struct Plan {
        uint8 id;
        uint256 price;
        uint256 duration;
    }
    Plan[] private plans;

    function addPlan(uint256 _price, uint256 _duration) public {
        Plan memory p = Plan({
            id: uint8(_planIds.current()),
            price: _price,
            duration: _duration
        });
        _planIds.increment();
        plans.push(p);
    }

    function removePlan(uint8 _id) public {
        for (uint8 i = 0; i < plans.length; i++) {
            if (plans[i].id == _id) {
                plans[i] = plans[plans.length - 1];
                plans.pop();
                break;
            }
        }
    }

    function getPlan(uint8 _planId) public view returns(Plan memory) {
        return plans[_planId];
    }

    function getPlans() public view returns(Plan[] memory) {
        return plans;
    }

    function subscribe(uint8 _planId) public payable {
        if(msg.value != plans[_planId].price) {    revert();    }
        (bool success, ) = payable(address(this)).call{value: plans[_planId].price}("");
        if(!success) {    revert();    }
    }

    receive() payable external {}
}