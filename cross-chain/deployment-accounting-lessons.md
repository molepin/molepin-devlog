# Deployment Accounting Lessons

The earliest deployment scripts contained several dangerous assumptions.

One of the biggest mistakes was allowing fallback mint allocations.

Example:

```ts
const maxSupplyForThisChain =
  chainAllocations[chainIdNum] || "1000000000000";
