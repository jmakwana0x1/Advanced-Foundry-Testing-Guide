# Advanced Foundry Testing Guide 🔨

[![Medium](https://img.shields.io/badge/Medium-12100E?style=for-the-badge&logo=medium&logoColor=white)](YOUR_MEDIUM_BLOG_LINK)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive guide to advanced testing patterns in Foundry for Ethereum smart contract development. This repository contains all the code examples and patterns discussed in my Medium blog series.

## 📝 Blog Post

I've written an in-depth article about advanced Foundry testing patterns. Read it on Medium:

**[Advanced Foundry Testing Patterns: A Complete Guide](https://medium.com/@jaymakwanna/advanced-foundry-testing-guide-9f83a44a97fa)**

This repository serves as the companion code for the blog post, providing working examples of all the patterns and techniques discussed.

## 🎯 What's Inside

This guide covers advanced testing patterns that go beyond basic unit tests:

### Core Testing Patterns
- ✅ State tree testing
- ✅ Time-based testing patterns
- ✅ Access control testing
- ✅ Event testing with `vm.expectEmit`
- ✅ Snapshot and rollback patterns

### Advanced Techniques
- 🔍 Fuzz testing with bounds and assumptions
- 🔄 Invariant testing with handlers
- 🍴 Fork testing with mainnet state
- 🔐 Security pattern testing (reentrancy, access control)
- 📊 Gas optimization testing
- 🔄 Differential testing
- 🎭 Mock and stub patterns

### Real-World Scenarios
- 💸 DeFi protocol integration testing
- 🌉 Cross-chain bridge testing
- ⬆️ Proxy and upgradeability testing
- 🚨 Attack vector testing
- 💰 Multi-user stateful fuzzing

## 📚 Documentation Files

### Main Guides
- **[foundry-advanced-guide.md](./foundry-advanced-guide.md)** - Core testing patterns and fundamentals
- **[foundry-real-world-examples.md](./foundry-real-world-examples.md)** - Production scenarios and security testing

### Code Examples
All examples are fully functional and can be run with Foundry.

## 🚀 Getting Started

### Prerequisites

Make sure you have Foundry installed:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Installation

1. Clone the repository:
```bash
git clone https://github.com/jmakwana0x1/foundry-advanced-testing.git
cd foundry-advanced-testing
```

2. Install dependencies:
```bash
forge install
```

3. Run the tests:
```bash
forge test
```

### Running Specific Examples

```bash
# Run all tests
forge test

# Run tests with gas reporting
forge test --gas-report

# Run specific test file
forge test --match-path test/ReentrancyTest.t.sol

# Run with verbosity for detailed output
forge test -vvvv

# Run fuzz tests only
forge test --match-test testFuzz

# Run invariant tests
forge test --match-test invariant

# Generate coverage report
forge coverage

# Create gas snapshot
forge snapshot
```

## 📖 Guide Structure

### 1. Basic Testing Patterns
Learn the fundamentals of writing effective Foundry tests:
- Setting up test environments
- Using cheat codes (`vm.prank`, `vm.warp`, `vm.roll`)
- Assertions and expectations
- Test organization

### 2. Fuzz Testing
Master property-based testing:
- Bounded fuzzing with `bound()`
- Using assumptions with `vm.assume()`
- Testing invariants across random inputs
- Structured fuzzing strategies

### 3. Invariant Testing
Build robust invariant test suites:
- Handler-based testing
- Ghost variables for tracking
- Multi-actor scenarios
- Stateful fuzzing patterns

### 4. Fork Testing
Test against real deployed contracts:
- Creating and managing forks
- Impersonating accounts
- Testing with live data
- Multi-chain testing

### 5. Security Testing
Identify vulnerabilities:
- Reentrancy attack patterns
- Access control bypass testing
- Flash loan manipulation
- Integer overflow/underflow
- Front-running scenarios

### 6. Gas Optimization
Optimize your contracts:
- Gas profiling techniques
- Comparative gas analysis
- Snapshot-based regression testing
- Identifying optimization opportunities

## 🔧 Project Structure

```
foundry-advanced-testing/
├── README.md
├── foundry-advanced-guide.md
├── foundry-real-world-examples.md
├── foundry.toml
├── src/
│   ├── examples/
│   │   ├── Token.sol
│   │   ├── Vault.sol
│   │   ├── LendingPool.sol
│   │   ├── AMM.sol
│   │   └── ...
│   └── security/
│       ├── VulnerableBank.sol
│       ├── ProtectedBank.sol
│       └── ...
└── test/
    ├── unit/
    │   ├── Token.t.sol
    │   └── Vault.t.sol
    ├── integration/
    │   ├── DeFiIntegration.t.sol
    │   └── MultiContract.t.sol
    ├── invariant/
    │   ├── BankInvariant.t.sol
    │   └── AMMInvariant.t.sol
    ├── fork/
    │   └── MainnetFork.t.sol
    └── security/
        ├── ReentrancyTest.t.sol
        └── AccessControlTest.t.sol
```

## 💡 Key Concepts

### Cheat Codes Reference

| Cheat Code | Purpose | Example |
|------------|---------|---------|
| `vm.prank(address)` | Set msg.sender for next call | `vm.prank(alice); token.transfer(bob, 100);` |
| `vm.startPrank(address)` | Set msg.sender for all calls | `vm.startPrank(alice);` |
| `vm.warp(timestamp)` | Set block.timestamp | `vm.warp(block.timestamp + 1 days);` |
| `vm.roll(number)` | Set block.number | `vm.roll(block.number + 100);` |
| `vm.deal(address, amount)` | Set ETH balance | `vm.deal(alice, 100 ether);` |
| `vm.expectRevert()` | Expect next call to revert | `vm.expectRevert("Error");` |
| `vm.expectEmit()` | Expect event emission | `vm.expectEmit(true, true, false, true);` |

### Test Naming Conventions

```solidity
test_Description()              // Basic test
testFail_Description()          // Expected to fail (deprecated, use expectRevert)
testRevert_Description()        // Expect revert with reason
testFuzz_Description(args)      // Fuzz test
invariant_Description()         // Invariant test
```

## 🎓 Learning Path

1. **Start with the basics** - Read `foundry-advanced-guide.md` sections 1-3
2. **Try simple examples** - Run the unit tests
3. **Explore fuzzing** - Understand property-based testing
4. **Master invariants** - Build handler-based test suites
5. **Real-world scenarios** - Study `foundry-real-world-examples.md`
6. **Security focus** - Learn attack vectors and defenses

## 🛠️ Advanced Configuration

### foundry.toml

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
solc_version = "0.8.24"

[profile.default.fuzz]
runs = 256
max_test_rejects = 65536

[profile.default.invariant]
runs = 256
depth = 15
fail_on_revert = false

[profile.ci]
fuzz = { runs = 5000 }
invariant = { runs = 1000 }
```

## 📊 Example Test Output

```bash
$ forge test --gas-report

Running 47 tests for test/Token.t.sol:TokenTest
[PASS] test_Mint() (gas: 45123)
[PASS] test_Transfer() (gas: 67234)
[PASS] testFuzz_TransferAmounts(uint256) (runs: 256, μ: 65432, ~: 65234)
[PASS] invariant_totalSupplyEqualsBalances() (runs: 256, calls: 3840, reverts: 156)

Test result: ok. 47 passed; 0 failed; finished in 2.34s

| Contract | Function      | Gas     |
|----------|---------------|---------|
| Token    | mint          | 45123   |
| Token    | transfer      | 67234   |
| Token    | approve       | 44567   |
```

## 🤝 Contributing

While this is primarily an educational repository for my blog post, I welcome:

- 🐛 Bug reports
- 💡 Suggestions for additional patterns
- 📝 Improvements to documentation
- ✨ Additional examples

Please open an issue or submit a pull request!

## 📬 Contact & Follow

- **Medium**: [@YOUR_MEDIUM_USERNAME](YOUR_MEDIUM_PROFILE_LINK)
- **Twitter**: [@YOUR_TWITTER](https://twitter.com/YOUR_TWITTER)
- **GitHub**: [@YOUR_GITHUB](https://github.com/YOUR_GITHUB)

If you found this guide helpful, please:
- ⭐ Star this repository
- 👏 Clap for the Medium article
- 🔄 Share with fellow developers

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- The Foundry team for creating an amazing development framework
- The Ethereum development community
- Everyone who contributed feedback and suggestions

## 📚 Additional Resources

- [Foundry Book](https://book.getfoundry.sh/) - Official Foundry documentation
- [Foundry GitHub](https://github.com/foundry-rs/foundry) - Source code and issues
- [Ethereum Smart Contract Best Practices](https://consensys.github.io/smart-contract-best-practices/)
- [Smart Contract Security](https://github.com/sigp/solidity-security-blog)

---

**Happy Testing! 🎉**


---

<p align="center">
  Made with ❤️ for the Ethereum developer community
</p>

<p align="center">
  <sub>Last updated: February 2026</sub>
</p>
