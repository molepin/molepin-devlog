# Old Contracts

This folder contains archived experimental versions of the MOLEPIN token contract.

These contracts are preserved as part of the MOLEPIN builder history and should not be used in production.

## Contract Evolution

| Version | File | Notes |
|---|---|---|
| V0.1 | 001-first-molepin-token.sol | Initial ERC-20 style implementation with custom SafeMath, inheritance structure, transfer lock, allowlist, and blocklist. |
| V0.2 | 002-molepin-basic-erc20-refactor.sol | Simplified into a single contract, removed custom SafeMath, fixed burn balance deduction, and reorganized transfer/admin logic. |




## Cross-Chain Architecture Notes

- global-supply-accounting.md
- multi-chain-genesis-allocation.md
- mint-burn-bridge-model.md
- tron-separate-pipeline.md
- deployment-accounting-lessons.md
