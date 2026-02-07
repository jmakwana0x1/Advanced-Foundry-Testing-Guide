//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

contract Vesting {
    uint256 public immutable startTime;
    uint256 public immutable duration;
    uint256 public immutable totalAmount;
    address public immutable beneficiary;
    uint256 public claimed;
    
    constructor(address _beneficiary, uint256 _duration, uint256 _amount) {
        beneficiary = _beneficiary;
        startTime = block.timestamp;
        duration = _duration;
        totalAmount = _amount;
    }
    
    function vestedAmount() public view returns (uint256) {
        if (block.timestamp < startTime) return 0;
        if (block.timestamp >= startTime + duration) return totalAmount;
        return (totalAmount * (block.timestamp - startTime)) / duration;
    }
    
    function claim() external {
        require(msg.sender == beneficiary, "Not beneficiary");
        uint256 vested = vestedAmount();
        uint256 claimable = vested - claimed;
        require(claimable > 0, "Nothing to claim");
        claimed += claimable;
    }
}