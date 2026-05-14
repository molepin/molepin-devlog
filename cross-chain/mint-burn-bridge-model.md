# Mint/Burn Bridge Model

One of the most important architectural decisions was adopting a mint/burn bridge-oriented supply flow model.

The goal was:

- keep global supply fixed
- allow liquidity migration between chains
- prevent uncontrolled inflation
- support cross-chain ecosystem growth

The core assumption was:

- tokens leaving one chain may be burned or locked
- tokens arriving on another chain may be minted
- total global supply remains constant

This means chain dominance is determined by actual ecosystem activity rather than static deployment ratios.

Over time, a smaller allocation chain could eventually become the dominant liquidity chain through bridge migration.
