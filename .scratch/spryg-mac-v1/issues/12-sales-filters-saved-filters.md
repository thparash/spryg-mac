# 12: Sales: filters and Saved Filters

**What to build:** A User can narrow Sales by channel, Product Brand, category and ASIN, or apply one of the Active Brand's Saved Filters. Switching Brands clears an applied Saved Filter, so Brand B is never filtered by Brand A's selections.

**Blocked by:** 10 (Sales: cards, daily chart and period presets)

**Status:** ready-for-agent

- [ ] Sales has filter controls for channel, Product Brand, category and ASIN, sent as the API expects (including the web app's limit of 10 ASINs).
- [ ] The Active Brand's Saved Filters are listed. Applying one fills the four filter controls.
- [ ] v1 has no way to create, edit or delete Saved Filters.
- [ ] Changing the Active Brand clears filters and any applied Saved Filter.
- [ ] The filter controls are reusable by other screens.
- [ ] `SprygKit` tests cover loading Saved Filters, applying one, the resulting query, and clearing on Brand switch.
