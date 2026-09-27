# 14: Operations

**What to build:** A User opens Operations for the Active Brand and sees inventory and buy-box (Featured Offer %) cards and the per-SKU operations table, filtered the same way as Sales, including Saved Filters.

**Blocked by:** 12 (Sales: filters and Saved Filters)

**Status:** ready-for-agent

- [ ] Operations shows the inventory and buy-box cards and the per-SKU table.
- [ ] The table is keyed by SKU, as the operations endpoint is.
- [ ] Buy-box period boundaries are handled as `HANDOFF.md` §3 describes, with labels never shifted by a day.
- [ ] The filter controls and Saved Filters from 12 work on Operations.
- [ ] `SprygKit` tests with recorded JSON cover the cards, the SKU table, buy-box periods and filtering.
