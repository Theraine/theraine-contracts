# Theraine Contracts
This repository contains the smart contract for a platform subscription service. The contract allows users to subscribe to different plans, and allows the contract owner to add and remove plans.

## Contract Structure
The repository contains two smart contracts:

- `ParentContract.sol`: This contract allows the creation of new platforms, and allows users to access their platforms.

- `PlatformContract.sol`: This contract implements the subscription service and handles the plans, subscription dates and payments.


## Contract Methods

The `ParentContract` contract has the following methods:

- `createPlatform(bytes memory _details)`: Allows the creation of a new platform and stores it in the contract.
- `getPlatform(uint256 _id)`: Allows to get a platform by its ID.
- `getPlatforms()`: Allows to get all the platforms.
- `getUserPlatforms()`: Allows to get all the platforms for a user.
- `getUserLatestPlatform()`: Allows to get the latest platform for a user.


The `PlatformContract` contract has the following methods:

- `subscribe(uint8 _planId)`: Allows a user to subscribe to a plan.
- `addPlan(uint256 _price, uint256 _duration)`: Allows the owner to add a new plan.
- `removePlan(uint8 _id)`: Allows the owner to remove a plan.
- `getPlan(uint8 _planId)`: Allows to get a plan by its ID.
- `getPlans()`: Allows to get all the plans.
- `getUserSubDated(address _user)`: Allows to get a user's subscription date.
- `userStatus(address _user)`: Allows to check a user's subscription status.

## Contributions
We welcome contributions to this repository. If you wish to contribute, please follow these steps:

1. Fork the repository
2. Create a new branch with a descriptive name
3. Make your changes
4. Create a pull request with a clear explanation of your changes
5. Wait for review and feedback
6. Make any necessary changes based on feedback
7. Once your changes are approved, they will be merged into the main branch

Please make sure to write test cases and update the documentation accordingly.

## Deployment
The contracts are deployed on the Goerli testnet using Hardhat.

1. Clone the repository
2. Navigate to the repository's root directory
3. Run npx hardhat run to start Hardhat
4. In the Hardhat console, run compile to compile the contracts
5. In the Hardhat console, run migrate to deploy the contracts to the Goerli testnet
6. Once the deployment is complete, the contracts' addresses will be displayed in the console

Note: Make sure to have the necessary dependencies installed, including Hardhat and an Ethereum client such as Goerli.

## Testing
The contracts include test cases that can be run using Hardhat. To run the tests, navigate to the repository's root directory and run npx hardhat test.

Please note that, tests are meant to be run on a local blockchain instance like ganache or testrpc.

## License
This project is UNLICENSED.

## Disclaimer
Please note that this code is for educational and demonstration purposes only, and should not be used in production without proper testing and security audits.