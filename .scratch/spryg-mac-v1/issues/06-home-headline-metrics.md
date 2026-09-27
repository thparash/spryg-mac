# 06: Home: headline metrics

**What to build:** A User opens Home and sees the Active Brand's headline sales and advertising metrics, in the Brand's currency, with a Data Through date. This is the first screen with real data. It sets the pattern every later screen follows: a `SprygKit` loader per screen area that returns domain values, API traps handled once while decoding, Marketplace currency, and local-time dates.

**Blocked by:** 03 (Active Brand and Brand switcher)

**Status:** ready-for-agent

- [ ] Home shows the Active Brand's sales metrics and ad metrics from the Brand's homepage endpoints.
- [ ] `SprygKit` exposes a Home loader that returns domain values with Data Through attached. Raw API field names never reach the screen.
- [ ] Amounts use the Active Brand's Marketplace currency (US→USD, UK→GBP, DE/FR/IT/ES/NL→EUR, SE→SEK, PL→PLN, JP→JPY, AU→AUD, CA→CAD, MX→MXN). If the Marketplace is missing, the web app's legacy seller-ID-and-domain rule applies.
- [ ] "Today" and period boundaries use the Mac's local time zone. Calendar dates from the API are shown as the same date, never shifted.
- [ ] API traps that affect these metrics (for example `last_` meaning prior year) are handled while decoding, checked against `spryg-mobile`'s `HANDOFF.md` §3.
- [ ] Data Through comes from the latest date in the data, or from the data pipeline's last-pulled date where the endpoint lacks one.
- [ ] Changing the Active Brand reloads Home for the new Brand.
- [ ] `SprygKit` tests with recorded JSON cover the Home values, prior-year fields, every Marketplace in the currency mapping plus the fallback, and calendar dates in time zones both ahead of and behind UTC.
