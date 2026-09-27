# 16: Command Center: daily view

**What to build:** A Superuser with more than one Brand opens Command Center and compares every Brand and Portfolio side by side for the current day. Portfolio cards come first, showing which Brands they include, and then Brand cards A to Z. Users who aren't Superusers never see Command Center.

**Blocked by:** 06 (Home: headline metrics)

**Status:** ready-for-agent

- [ ] Command Center appears only for Superusers with more than one Brand.
- [ ] The daily view shows Portfolio cards first, then Brand cards sorted A to Z.
- [ ] Each Portfolio card lists the Brands it includes.
- [ ] Portfolio totals sum amounts across Brands and show "$", as the web app does.
- [ ] A Portfolio card warns when its Brands' Data Through dates differ.
- [ ] `SprygKit` tests with recorded JSON cover gating, card order, Portfolio membership, totals and the mixed-dates warning.
- [ ] An XCUITest smoke test confirms Command Center is hidden for a User who isn't a Superuser.
