//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {TokenVesting } from "src/Vesting.sol";

/**
 * @title TokenVestingTest
 * @notice Comprehensive time-based testing
 */
contract TokenVestingTest is Test {
    TokenVesting public vesting;

    address public beneficiary;

    uint256 constant DURATION = 365 days;
    uint256 constant TOTAL_AMOUNT = 1_000_000 ether;

    function setUp() public {
        beneficiary = makeAddr("beneficiary");

        vesting = new TokenVesting(
            beneficiary,
            DURATION,
            TOTAL_AMOUNT
        );
    }

    // ============ Vesting Amount Tests ============

    function test_VestingAmount_AtStart() public view {
        // At deployment, nothing should be vested
        assertEq(vesting.vestedAmount(), 0, "Should be 0 at start");
    }

    function test_VestingAmount_At25Percent() public {
        // Fast-forward 25% of duration
        vm.warp(block.timestamp + (DURATION / 4));

        uint256 expected = TOTAL_AMOUNT / 4;
        assertEq(
            vesting.vestedAmount(),
            expected,
            "Should be 25% vested"
        );
    }

    function test_VestingAmount_At50Percent() public {
        // Fast-forward 50% of duration
        vm.warp(block.timestamp + (DURATION / 2));

        uint256 expected = TOTAL_AMOUNT / 2;
        assertEq(
            vesting.vestedAmount(),
            expected,
            "Should be 50% vested"
        );
    }

    function test_VestingAmount_AfterCompletion() public {
        // Fast-forward past vesting period
        vm.warp(block.timestamp + DURATION + 1 days);

        assertEq(
            vesting.vestedAmount(),
            TOTAL_AMOUNT,
            "Should be fully vested"
        );
    }

    // ============ Claim Tests ============

    function test_Claim_MultiplePartialClaims() public {
        // First claim at 25%
        vm.warp(block.timestamp + (DURATION / 4));

        vm.prank(beneficiary);
        uint256 firstClaim = vesting.claim();

        assertEq(firstClaim, TOTAL_AMOUNT / 4, "First claim incorrect");
        assertEq(vesting.claimed(), TOTAL_AMOUNT / 4);

        // Second claim at 75% (additional 50%)
        vm.warp(block.timestamp + (DURATION / 2));

        vm.prank(beneficiary);
        uint256 secondClaim = vesting.claim();

        assertEq(secondClaim, TOTAL_AMOUNT / 2, "Second claim incorrect");
        assertEq(vesting.claimed(), (TOTAL_AMOUNT * 3) / 4);
    }

    function test_Claim_FullAmountAfterVesting() public {
        // Fast-forward to end
        vm.warp(block.timestamp + DURATION);

        vm.prank(beneficiary);
        uint256 claimAmount = vesting.claim();

        assertEq(claimAmount, TOTAL_AMOUNT, "Should claim full amount");
        assertEq(vesting.claimed(), TOTAL_AMOUNT);
    }

    function testRevert_Claim_NonBeneficiary() public {
        vm.warp(block.timestamp + DURATION);

        address attacker = makeAddr("attacker");

        vm.expectRevert(TokenVesting.NotBeneficiary.selector);
        vm.prank(attacker);
        vesting.claim();
    }

    function testRevert_Claim_NothingVested() public {
        // Try to claim immediately
        vm.expectRevert(TokenVesting.NothingToClaim.selector);

        vm.prank(beneficiary);
        vesting.claim();
    }

    function testRevert_Claim_AlreadyClaimed() public {
        // Claim at 50%
        vm.warp(block.timestamp + (DURATION / 2));

        vm.prank(beneficiary);
        vesting.claim();

        // Try to claim again immediately
        vm.expectRevert(TokenVesting.NothingToClaim.selector);
        vm.prank(beneficiary);
        vesting.claim();
    }

    // ============ Fuzz Testing ============

    /**
     * @notice Fuzz test: vesting is monotonically increasing
     * @dev Tests that vested amount never decreases over time
     */
    function testFuzz_VestingMonotonicallyIncreases(
        uint256 time1,
        uint256 time2
    ) public {
        // Bound times to reasonable range
        time1 = bound(time1, 0, DURATION * 2);
        time2 = bound(time2, 0, DURATION * 2);

        // Ensure time1 < time2
        if (time1 > time2) {
            (time1, time2) = (time2, time1);
        }

        // Check vesting at time1
        vm.warp(block.timestamp + time1);
        uint256 vested1 = vesting.vestedAmount();

        // Check vesting at time2
        vm.warp(block.timestamp + time2 - time1);
        uint256 vested2 = vesting.vestedAmount();

        // Vesting should never decrease
        assertGe(
            vested2,
            vested1,
            "Vesting should be monotonically increasing"
        );
    }

    /**
     * @notice Fuzz test: vesting is bounded
     * @dev Vested amount should never exceed total amount
     */
    function testFuzz_VestingBounded(uint256 timeOffset) public {
        // Test at any point in time
        timeOffset = bound(timeOffset, 0, DURATION * 10);

        vm.warp(block.timestamp + timeOffset);

        uint256 vested = vesting.vestedAmount();

        // Should never exceed total amount
        assertLe(vested, TOTAL_AMOUNT, "Vested exceeds total");
    }
}