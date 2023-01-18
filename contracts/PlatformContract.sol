// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract PlatformContract {

    /**
     * @dev address of the contract owner
     */
    address public owner;

    /**
     * @dev mapping of users to their subscription date
     */
    mapping(address => uint256) private usersSubDated;

    /**
     * @dev Plan structure contains the plan's price and duration
     */
    struct Plan {
        uint256 price;
        uint256 duration;
    }

    /**
     * @dev all the plans
     */
    Plan[] private plans;

    /**
     * @dev constructor sets the owner
     */
    constructor() {
        owner = tx.origin;
    }

    /**
     * @dev subscribes a user to a plan.
     * @param _planId the plan ID
     */
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

    /**
     * @dev adds a new plan.
     * @param _price the plan price
     * @param _duration the plan duration in days
     */
    function addPlan(uint256 _price, uint256 _duration) public {
        if(msg.sender != owner) {    revert();    }
        Plan memory p = Plan({
            price: _price,
            duration: _duration * 86_400
        });
        plans.push(p);
    }

    /**
     * @dev removes a plan.
     * @param _id the plan ID
     */
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

    /**
     * @dev gets a plan.
     * @param _planId the plan ID
     * @return the plan
     */
    function getPlan(uint8 _planId) public view returns(Plan memory) {
        return plans[_planId];
    }

    /**
     * @dev gets all plans.
     * @return all the plans
     */
    function getPlans() public view returns(Plan[] memory) {
        return plans;
    }

    /**
     * @dev gets the user's subscription date.
     * @param _user the user address
     * @return the user's subscription date
     */
    function getUserSubDated(address _user) public view returns(uint256) {
        if(msg.sender != owner) {
            if(msg.sender != _user) {    revert();    }
        }
        return usersSubDated[_user];
    }

    /**
     * @dev checks if the user is subscribed.
     * @param _user the user address
     * @return status the user's subscription status
     */
    function userStatus(address _user) public view returns(bool status) {
        if(msg.sender != owner) {
            if(msg.sender != _user) {    revert();    }
        }
        if(usersSubDated[_user] >= block.timestamp) {
            status = true;
        }
    }

    /**
     * @dev withdraws the contract's balance.
     */
    receive() payable external {}
}