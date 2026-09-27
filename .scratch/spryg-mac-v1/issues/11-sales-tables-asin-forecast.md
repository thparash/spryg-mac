# 11: Sales: tables, ASIN summary and forecast

**What to build:** On Sales, a User can also compare periods in the monthly and weekly sales tables, see which products sold in the ASIN sales summary, and see where the month is heading in the monthly forecast.

**Blocked by:** 10 (Sales: cards, daily chart and period presets)

**Status:** ready-for-agent

- [ ] Sales shows the monthly and weekly sales tables, using SwiftUI `Table`.
- [ ] The `period1..13` keys, which run backwards, are decoded into correctly ordered periods.
- [ ] Sales shows the ASIN sales summary and the monthly forecast.
- [ ] `SprygKit` tests with recorded JSON cover the tables (including period order), the ASIN summary and the forecast.
