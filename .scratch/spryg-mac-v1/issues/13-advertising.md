# 13: Advertising

**What to build:** A User opens Advertising for the Active Brand and sees spend, sales, ROAS, ACoS and TACoS, a chart over time, and a campaign table. They can filter by campaign type, campaign name and placement, and can only pick dates where advertising data exists.

**Blocked by:** 06 (Home: headline metrics)

**Status:** ready-for-agent

- [ ] Advertising shows the dashboard metrics, chart and table from the unified advertising endpoints.
- [ ] ROAS is decoded according to what each endpoint means by it, as `HANDOFF.md` §3 describes.
- [ ] Filters for campaign type, campaign name and placement work.
- [ ] The date picker is limited to the range the advertising date-range endpoint returns.
- [ ] `SprygKit` tests with recorded JSON cover the dashboard, chart series, table, ROAS variants, filters and the date limit.
