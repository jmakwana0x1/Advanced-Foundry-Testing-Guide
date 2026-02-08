// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract EventEmitter {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    
    function transfer(address to, uint256 amount) external {
        emit Transfer(msg.sender, to, amount);
    }
    
    function approve(address spender, uint256 amount) external {
        emit Approval(msg.sender, spender, amount);
    }
}