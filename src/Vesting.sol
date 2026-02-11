//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

/**
 * @title TokenVesting
 * @notice Linear vesting contract for token distribution
 */
contract TokenVesting {
    address public immutable beneficiary;
    uint256 public immutable startTime;
    uint256 public immutable duration;
    uint256 public immutable totalAmount;
    uint256 public claimed;

    error NotBeneficiary();
    error NothingToClaim();

    constructor(
        address _beneficiary,
        uint256 _duration,
        uint256 _totalAmount
    ) {
        beneficiary = _beneficiary;
        startTime = block.timestamp;
        duration = _duration;
        totalAmount = _totalAmount;
    }

    /**
     * @notice Calculate vested amount at current time
     * @return Amount vested so far
     */
    function vestedAmount() public view returns (uint256) {
        // Before vesting starts
        if (block.timestamp < startTime) {
            return 0;
        }

        // After vesting completes
        if (block.timestamp >= startTime + duration) {
            return totalAmount;
        }

        // During vesting period - linear interpolation
        uint256 timeElapsed = block.timestamp - startTime;
        return (totalAmount * timeElapsed) / duration;
    }

    /**
     * @notice Claim vested tokens
     * @return Amount claimed
     */
    function claim() external returns (uint256) {
        if (msg.sender != beneficiary) revert NotBeneficiary();

        uint256 vested = vestedAmount();
        uint256 claimable = vested - claimed;

        if (claimable == 0) revert NothingToClaim();

        claimed += claimable;

        // In production, transfer tokens here

        return claimable;
    }
}