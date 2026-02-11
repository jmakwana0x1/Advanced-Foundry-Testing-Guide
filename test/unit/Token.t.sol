//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {SimpleToken} from "src/Token.sol";
import {Test} from "forge-std/Test.sol";

/**
 * @title SimpleTokenTest
 * @notice Comprehensive test suite following modern Foundry patterns
 */
contract SimpleTokenTest is Test {
    // Contract under test
    SimpleToken public token;

    // Test actors - using makeAddr for better trace output
    address public alice;
    address public bob;

    // Events - redeclare for expectEmit
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /**
     * @notice Setup runs before each test
     * @dev Create fresh contract instance and test actors
     */
    function setUp() public {
        token = new SimpleToken();

        // makeAddr creates labeled addresses for better debugging
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        // Label the token contract for trace clarity
        vm.label(address(token), "SimpleToken");
    }

    // ============ Minting Tests ============

    function test_Mint_UpdatesBalance() public {
        // Arrange
        uint256 mintAmount = 100 ether;

        // Act
        token.mint(alice, mintAmount);

        // Assert
        assertEq(token.balanceOf(alice), mintAmount, "Balance mismatch");
    }

    function test_Mint_EmitsTransferEvent() public {
        // Arrange
        uint256 mintAmount = 100 ether;

        // Assert event emission
        // Parameters: checkTopic1, checkTopic2, checkTopic3, checkData
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), alice, mintAmount);

        // Act
        token.mint(alice, mintAmount);
    }

    // ============ Transfer Tests ============

    function test_Transfer_UpdatesBothBalances() public {
        // Arrange
        uint256 initialBalance = 100 ether;
        uint256 transferAmount = 30 ether;

        token.mint(alice, initialBalance);

        // Act
        vm.prank(alice); // Next call will be from alice
        token.transfer(bob, transferAmount);

        // Assert
        assertEq(
            token.balanceOf(alice),
            initialBalance - transferAmount,
            "Sender balance incorrect"
        );
        assertEq(
            token.balanceOf(bob),
            transferAmount,
            "Recipient balance incorrect"
        );
    }

    function testRevert_Transfer_InsufficientBalance() public {
        // Arrange
        uint256 balance = 50 ether;
        uint256 transferAmount = 100 ether;

        token.mint(alice, balance);

        // Assert - expect revert with specific message
        vm.expectRevert("Insufficient balance");

        // Act
        vm.prank(alice);
        token.transfer(bob, transferAmount);
    }
}