//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;
contract Vault {
    enum State { Inactive, Active, Paused, Closed }
    
    State public state;
    mapping(address => uint256) public deposits;
    address public owner;
    
    constructor() {
        owner = msg.sender;
        state = State.Inactive;
    }
    
    function activate() external {
        require(msg.sender == owner, "Not owner");
        require(state == State.Inactive, "Invalid state");
        state = State.Active;
    }
    
    function pause() external {
        require(msg.sender == owner, "Not owner");
        require(state == State.Active, "Invalid state");
        state = State.Paused;
    }
    
    function deposit(uint256 amount) external {
        require(state == State.Active, "Not active");
        deposits[msg.sender] += amount;
    }
}