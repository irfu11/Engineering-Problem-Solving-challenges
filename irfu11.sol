// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EngineeringProblemSolvingChallenges {

    // Struct for a Challenge
    struct Challenge {
        uint id;
        string description;
        address creator;
        uint rewardAmount;
        bool isCompleted;
    }

    // Mapping to store challenges by ID
    mapping(uint => Challenge) public challenges;

    // Counter for challenge ID
    uint public challengeCount;

    // Event to be emitted when a new challenge is created
    event ChallengeCreated(uint indexed id, string description, address indexed creator, uint rewardAmount);
    
    // Event to be emitted when a challenge is completed
    event ChallengeCompleted(uint indexed id, address indexed solver);

    // Constructor to initialize the contract
    constructor() {
        challengeCount = 0;
    }

    // Function to create a new challenge
    function createChallenge(string memory _description, uint _rewardAmount) public {
        challengeCount++;
        challenges[challengeCount] = Challenge(challengeCount, _description, msg.sender, _rewardAmount, false);
        emit ChallengeCreated(challengeCount, _description, msg.sender, _rewardAmount);
    }

    // Function to mark a challenge as completed
    function completeChallenge(uint _challengeId) public {
        require(challenges[_challengeId].id == _challengeId, "Challenge does not exist.");
        require(!challenges[_challengeId].isCompleted, "Challenge is already completed.");

        // Ensure only the creator can mark the challenge as completed
        require(msg.sender == challenges[_challengeId].creator, "Only the creator can complete the challenge.");

        challenges[_challengeId].isCompleted = true;
        emit ChallengeCompleted(_challengeId, msg.sender);
    }

    // Function to withdraw the reward after challenge completion (only for the creator)
    function withdrawReward(uint _challengeId) public payable {
        require(challenges[_challengeId].id == _challengeId, "Challenge does not exist.");
        require(challenges[_challengeId].isCompleted, "Challenge is not completed yet.");
        require(msg.sender == challenges[_challengeId].creator, "Only the creator can withdraw the reward.");

        uint rewardAmount = challenges[_challengeId].rewardAmount;
        payable(msg.sender).transfer(rewardAmount);
    }

    // Function to fund the contract with ether for rewards
    function fundContract() public payable {}

    // Getter function to retrieve challenge details
    function getChallenge(uint _challengeId) public view returns (Challenge memory) {
        return challenges[_challengeId];
    }
}


