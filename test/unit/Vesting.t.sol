//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Vesting} from "src/Vesting.sol";

contract VestingTest is Test{
    Vesting vesting;
    address beneficiary = makeAddr("beneficiary");
    uint256 constant DURATION = 365 days;
    uint256 constant AMOUNT = 1000 ether;

    function setUp()public{
        vesting= new Vesting(beneficiary,DURATION,AMOUNT);
    }

    function test_vestingAtStart()public{
        assertEq(vesting.vestedAmount(),0);
    }

    function test_vestingAt25Percent()public{
        vm.warp(block.timestamp + DURATION/4);
        assertEq(vesting.vestedAmount(),AMOUNT/4);
    }

    function test_vestingAt50Percent()public{
        vm.warp(block.timestamp + DURATION/2);
        assertEq(vesting.vestedAmount(),AMOUNT/2);
    }

    function test_vestingAtEnd()public{
        vm.warp(block.timestamp + DURATION+1);
        assertEq(vesting.vestedAmount(),AMOUNT);
    }

    function test_MultpleClaims()public{
        //claim at 25%
        vm.warp(block.timestamp+DURATION/4);
        vm.prank(beneficiary);
        vesting.claim();
        assertEq(vesting.claimed(), AMOUNT/4);
        // claim at 75%
        vm.warp(block.timestamp+DURATION/2);
        vm.prank(beneficiary);
        vesting.claim();
        assertEq(vesting.claimed(), (AMOUNT*3)/4);

    }


}