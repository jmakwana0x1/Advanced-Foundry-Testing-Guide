// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AccessControlled {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    mapping(bytes32 => mapping(address => bool)) public roles;
    
    constructor() {
        roles[ADMIN_ROLE][msg.sender] = true;
    }
    
    modifier onlyRole(bytes32 role) {
        require(roles[role][msg.sender], "Unauthorized");
        _;
    }
    
    function grantRole(bytes32 role, address account) external onlyRole(ADMIN_ROLE) {
        roles[role][account] = true;
    }
    
    function revokeRole(bytes32 role, address account) external onlyRole(ADMIN_ROLE) {
        roles[role][account] = false;
    }
    
    function adminFunction() external onlyRole(ADMIN_ROLE) {}
    function minterFunction() external onlyRole(MINTER_ROLE) {}
}