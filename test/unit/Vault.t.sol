//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Vault} from "src/Vault.sol";
import {Test} from "forge-std/Test.sol";


contract VaultStateTest is Test{
    Vault vault;

    address owner = makeAddr("owner");
    address user = makeAddr("user");

    function setUp()public{
        vm.prank(owner);
        vault = new Vault();
    }
    function test_StateTransition_InactiveToActive()public{
        assertEq(uint(vault.state()),uint(Vault.State.Inactive));

        vm.prank(owner);
        vault.activate();
        
        assertEq( uint(vault.state()),  uint(Vault.State.Active));
    }

    function test_StateTransition_ActiveToPaused()public{
        vm.startPrank(owner);
        vault.activate();
        vault.pause();
        vm.stopPrank();

        assertEq(uint256(vault.state()), uint256(Vault.State.Paused));
    }

    function test_RevertDepositWhenInactive()public{
        vm.expectRevert("Not active");
        vm.prank(user);
        vault.deposit(100);
    }
}