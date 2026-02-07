//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {AccessControlled} from "src/AccessControlled.sol";

contract AccessControlTest is Test{
    AccessControlled ac;
    address admin = makeAddr("admin");
    address minter = makeAddr("minter");
    address user = makeAddr("user");

    function setUp()public{
    
        ac = new AccessControlled();
        ac.grantRole(ac.ADMIN_ROLE(), admin);
    }

    function test_AdminCanGrantRoles()public{
        vm.prank(admin);
        ac.grantRole(ac.MINTER_ROLE(), minter);
        
        assertTrue(ac.roles(ac.MINTER_ROLE(), minter));
    }

    function test_RevertNonAdminGrantRoles() public {
        vm.startPrank(user);
        bytes32 minterRole = ac.MINTER_ROLE();
        vm.expectRevert("Unauthorized");
        ac.grantRole(minterRole, minter);
        vm.stopPrank();
    }

    function test_GrantedRoleCanExecute() public {
        vm.prank(admin);
        ac.grantRole(ac.MINTER_ROLE(), minter);
        
        vm.prank(minter);
        ac.minterFunction(); 
    }
    
    function testRevert_RevokedRoleCannotExecute() public {
        vm.startPrank(admin);
        ac.grantRole(ac.MINTER_ROLE(), minter);
        ac.revokeRole(ac.MINTER_ROLE(), minter);
        vm.stopPrank();
        
        vm.expectRevert("Unauthorized");
        vm.prank(minter);
        ac.minterFunction();
    }

}