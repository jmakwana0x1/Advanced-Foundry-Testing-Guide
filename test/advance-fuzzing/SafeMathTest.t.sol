//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Math} from "src/math.sol";
contract MathFuzzTest is Test {
    Math math;
    
    function setUp() public {
        math = new Math();
    }
    
    // Fuzz test addition
    function testFuzz_Add(uint128 a, uint128 b) public {
        uint256 result = math.add(a, b);
        assertEq(result, uint256(a) + uint256(b));
        assertGe(result, a);
        assertGe(result, b);
    }
    
    // Fuzz test with assumptions
    function testFuzz_MulDiv(uint256 x, uint256 y, uint256 z) public {
        vm.assume(z != 0);
        vm.assume(y == 0 || x <= type(uint256).max / y); // Prevent overflow
        
        uint256 result = math.mulDiv(x, y, z);
        
        // Verify the result
        if (z == 1) {
            assertEq(result, x * y);
        }
    }
    
    // Bounded fuzz testing
    function testFuzz_AddBounded(uint256 a, uint256 b) public {
        a = bound(a, 0, type(uint128).max);
        b = bound(b, 0, type(uint128).max);
        
        uint256 result = math.add(a, b);
        assertLe(result, type(uint256).max);
    }
}