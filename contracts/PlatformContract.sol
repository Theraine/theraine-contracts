// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract PlatformContract {

    mapping(address => uint256) private usersSubDated;

    struct Plan {
        uint256 price;
        uint256 duration;
    }

    Plan[] private plans;

    function subscribe(uint8 _planId) public payable {
        if(msg.value != plans[_planId].price) {    revert();    }

        if(_userStatus(msg.sender)) {
            usersSubDated[msg.sender] += plans[_planId].duration;
        } else {
            usersSubDated[msg.sender] = block.timestamp + plans[_planId].duration;
        }
        
        (bool success, ) = payable(address(this)).call{value: plans[_planId].price}("");
        if(!success) {    revert();    }
    }

    function addPlan(uint256 _price, uint256 _duration) public {
        Plan memory p = Plan({
            price: _price,
            duration: _duration * 86_400
        });
        plans.push(p);
    }

    function removePlan(uint8 _id) public {
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

    function userStatus(address _user) public view returns(bool status) {
        if(msg.sender != _user) {    revert();    }
        status = _userStatus(_user);
    }

    function _userStatus(address _user) internal view returns(bool status) {
        if(usersSubDated[_user] >= block.timestamp) {
            status = true;
        }
    }

    receive() payable external {}
}