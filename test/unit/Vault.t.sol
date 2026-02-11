//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Vault} from "src/Vault.sol";
import {Test} from "forge-std/Test.sol";


/**
 * @title VaultTest
 * @notice Test suite covering all state transitions
 */
contract VaultTest is Test {
    Vault public vault;

    address public owner;
    address public user;

    event StateChanged(Vault.State indexed from, Vault.State indexed to);

    function setUp() public {
        owner = makeAddr("owner");
        user = makeAddr("user");

        // Deploy vault as owner
        vm.prank(owner);
        vault = new Vault();
    }

    // ============ State Transition Tests ============

    function test_StateTransition_InactiveToActive() public {
        // Verify initial state
        assertEq(
            uint256(vault.currentState()),
            uint256(Vault.State.Inactive),
            "Should start inactive"
        );

        // Expect state change event
        vm.expectEmit(true, true, false, false);
        emit StateChanged(Vault.State.Inactive, Vault.State.Active);

        // Transition to active
        vm.prank(owner);
        vault.activate();

        // Verify new state
        assertEq(
            uint256(vault.currentState()),
            uint256(Vault.State.Active),
            "Should be active"
        );
    }

    function test_StateTransition_ActiveToPausedToActive() public {
        // Activate vault
        vm.startPrank(owner);
        vault.activate();

        // Pause it
        vault.pause();
        assertEq(
            uint256(vault.currentState()),
            uint256(Vault.State.Paused)
        );

        // Unpause it
        vault.unpause();
        assertEq(
            uint256(vault.currentState()),
            uint256(Vault.State.Active)
        );
        vm.stopPrank();
    }

    function test_StateTransition_ActiveToClosed() public {
        vm.startPrank(owner);
        vault.activate();
        vault.close();
        vm.stopPrank();

        assertEq(
            uint256(vault.currentState()),
            uint256(Vault.State.Closed)
        );
    }

    // ============ Invalid Transition Tests ============

    function testRevert_CannotActivateTwice() public {
        vm.startPrank(owner);
        vault.activate();

        // Trying to activate again should fail
        vm.expectRevert(Vault.InvalidState.selector);
        vault.activate();
        vm.stopPrank();
    }

    function testRevert_CannotPauseInactiveVault() public {
        vm.expectRevert(Vault.InvalidState.selector);

        vm.prank(owner);
        vault.pause();
    }

    function testRevert_CannotCloseInactiveVault() public {
        vm.expectRevert(Vault.InvalidStateTransition.selector);

        vm.prank(owner);
        vault.close();
    }

    // ============ Deposit Tests ============

    function test_Deposit_OnlyInActiveState() public {
        // Activate vault
        vm.prank(owner);
        vault.activate();

        // User deposits
        vm.prank(user);
        vault.deposit(100 ether);

        assertEq(vault.deposits(user), 100 ether);
    }

    function testRevert_Deposit_WhenInactive() public {
        vm.expectRevert(Vault.InvalidState.selector);

        vm.prank(user);
        vault.deposit(100 ether);
    }

    function testRevert_Deposit_WhenPaused() public {
        // Activate then pause
        vm.startPrank(owner);
        vault.activate();
        vault.pause();
        vm.stopPrank();

        // Deposit should fail
        vm.expectRevert(Vault.InvalidState.selector);
        vm.prank(user);
        vault.deposit(100 ether);
    }

    // ============ Access Control Tests ============

    function testRevert_OnlyOwnerCanChangeState() public {
        vm.expectRevert(Vault.Unauthorized.selector);

        vm.prank(user); // Non-owner tries to activate
        vault.activate();
    }
}