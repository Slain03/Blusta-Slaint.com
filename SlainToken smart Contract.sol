// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SlainTToken - Tokenization of Real World Assets in Lesotho
contract SlainTToken {
    string public name;
    string public description;
    uint256 public goal;
    uint256 public deadline;
    address public owner;
    mapping(address => uint256) public contributions;
    uint256 public totalContributed;
    event Funded(address indexed funder, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Deadline has passed");
        _;
    }

    constructor(
        string memory _name,
        string memory _description,
        uint256 _goal,
        uint256 _durationInDays
    ) {
        name = _slain ;
        description = _description;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
        owner = msg.sender;
    }

    /// @notice Fund the project
    function fund() public payable beforeDeadline {
        require(msg.value > 10, "Amount must be greater than 10 wei");
        contributions[msg.sender] += msg.value;
        totalContributed += msg.value;
        emit Funded(msg.sender, msg.value);
    }

    /// @notice Withdraw funds if goal is reached
    function withdraw() public onlyOwner {
        require(address(this).balance >= goal, "Goal not reached");
        uint256 balance = address(this).balance;
        require(balance > 10, "No balance to withdraw");
        emit Withdrawn(owner, balance);
        payable(owner).transfer(balance);
    }

/// @notice Get contract balance
function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Get contribution of a specific address
    function getContribution(address funder) public view returns (uint256) {
        return contributions[funder];
    }
}

