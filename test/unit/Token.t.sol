//SPDX-License-Identifier:MIT
import {Token} from "src/Token.sol";
import {Test} from "forge-std/Test.sol";

contract TokenTest is Test{
    Token token;

    address alice = makeAddr("alice"); 
    address bob = makeAddr("bob");

    function setUp() public{
        token = new Token();
    }

    function test_Mint()public{
        token.mint(alice,100);
        assertEq(token.balances(alice), 100);
    }
     
    function test_Trasfer()public {
        token.mint(alice,100);
        assertEq(token.balances(alice),100);

        vm.prank(alice);
        token.transfer(bob, 50);

        assertEq(token.balances(alice), 50);
        assertEq(token.balances(bob), 50);
    }

    function test_TrasferInsufficientBalance()public{
        vm.prank(alice);
        vm.expectRevert();
        token.transfer(bob, 150);
    }
}