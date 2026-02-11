// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


/**
 * @title Vault
 * @notice A vault contract with lifecycle states
 */
contract Vault {
    enum State { 
        Inactive,  // Initial state, deposits not allowed
        Active,    // Deposits allowed
        Paused,    // Temporarily suspended
        Closed     // Permanently closed
    }

    State public currentState;
    mapping(address => uint256) public deposits;
    address public immutable owner;

    event StateChanged(State indexed from, State indexed to);
    event Deposit(address indexed user, uint256 amount);

    error InvalidStateTransition();
    error Unauthorized();
    error InvalidState();

    constructor() {
        owner = msg.sender;
        currentState = State.Inactive;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    modifier inState(State _state) {
        if (currentState != _state) revert InvalidState();
        _;
    }

    /**
     * @notice Activate the vault for deposits
     */
    function activate() external onlyOwner inState(State.Inactive) {
        _transitionState(State.Active);
    }

    /**
     * @notice Pause the vault temporarily
     */
    function pause() external onlyOwner inState(State.Active) {
        _transitionState(State.Paused);
    }

    /**
     * @notice Resume from paused state
     */
    function unpause() external onlyOwner inState(State.Paused) {
        _transitionState(State.Active);
    }

    /**
     * @notice Permanently close the vault
     */
    function close() external onlyOwner {
        if (currentState == State.Inactive) revert InvalidStateTransition();
        _transitionState(State.Closed);
    }

    /**
     * @notice Deposit into the vault
     */
    function deposit(uint256 amount) external inState(State.Active) {
        deposits[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    function _transitionState(State newState) private {
        emit StateChanged(currentState, newState);
        currentState = newState;
    }
}
