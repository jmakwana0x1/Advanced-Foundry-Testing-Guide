//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract Math {
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
    
    function mulDiv(uint256 x, uint256 y, uint256 z) public pure returns (uint256) {
        require(z != 0, "Division by zero");
        return (x * y) / z;
    }
}
