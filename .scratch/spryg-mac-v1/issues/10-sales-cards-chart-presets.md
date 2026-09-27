# 10: Sales: cards, daily chart and period presets

**What to build:** A User opens Sales for the Active Brand, picks a period from presets, and sees the sales cards (totals, pacing, targets) and a daily sales chart. Superusers also see the extra Sales cards the web app shows only to them.

**Blocked by:** 06 (Home: headline metrics)

**Status:** ready-for-agent

- [ ] Sales shows the sales cards and the daily sales chart (Swift Charts) for the chosen period.
- [ ] Period presets match the web app (today, yesterday, last 7 days, MTD, YTD and so on), computed in the Mac's local time zone.
- [ ] Requests use the `date_range` format the API expects. Endpoints that ignore `date_range` are handled as `HANDOFF.md` §3 describes.
- [ ] The extra Superuser-only Sales cards appear only for Superusers.
- [ ] `SprygKit` tests cover the cards, the daily series, every preset's date range in time zones ahead of and behind UTC, and Superuser gating.
