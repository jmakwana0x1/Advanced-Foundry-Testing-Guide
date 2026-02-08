// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {EventEmitter} from "src/EventEmitter.sol";

contract EventTest is Test{
    EventEmitter emitter;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    
    function setUp() public {
        emitter = new EventEmitter();
    }
    
    function test_EmitTransferEvent() public {
        vm.expectEmit(true, true, false, true);
        emit EventEmitter.Transfer(alice, bob, 100);
        
        vm.prank(alice);
        emitter.transfer(bob, 100);
    }
    
    function test_EmitMultipleEvents() public {
        vm.prank(alice);
        
        vm.expectEmit(true, true, false, true);
        emit EventEmitter.Transfer(alice, bob, 100);
        emitter.transfer(bob, 100);
        
        vm.prank(alice);        
        vm.expectEmit(true, true, false, true);
        emit EventEmitter.Approval(alice, bob, 200);
        emitter.approve(bob, 200);
    }
}