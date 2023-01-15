// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract PlatformContract {

    constructor() {
        owner = tx.origin;
    }

    address public owner;

    mapping(address => uint256) private usersSubDated;

    struct Plan {
        uint256 price;
        uint256 duration;
    }

    Plan[] private plans;

    function subscribe(uint8 _planId) public payable {
        if(msg.value != plans[_planId].price) {    revert();    }

        if(userStatus(msg.sender)) {
            usersSubDated[msg.sender] += plans[_planId].duration;
        } else {
            usersSubDated[msg.sender] = block.timestamp + plans[_planId].duration;
        }
        
        (bool success, ) = payable(address(this)).call{value: plans[_planId].price}("");
        if(!success) {    revert();    }
    }

    function addPlan(uint256 _price, uint256 _duration) public {
        if(msg.sender != owner) {    revert();    }
        Plan memory p = Plan({
            price: _price,
            duration: _duration * 86_400
        });
        plans.push(p);
    }

    function removePlan(uint8 _id) public {
        if(msg.sender != owner) {    revert();    }
        for (uint8 i = 0; i < plans.length; i++) {
            if (i == _id) {
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

    function getUserSubDated(address _user) public view returns(uint256) {
        if(msg.sender != owner) {
            if(msg.sender != _user) {    revert();    }
        }
        return usersSubDated[_user];
    }


    function userStatus(address _user) public view returns(bool status) {
        if(msg.sender != owner) {
            if(msg.sender != _user) {    revert();    }
        }
        if(usersSubDated[_user] >= block.timestamp) {
            status = true;
        }
    }

    receive() payable external {}
}