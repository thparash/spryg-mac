# Spec: spryg-mac v1

Status: ready-for-agent

## Problem Statement

People who use Spryg on a Mac have two choices: a browser tab, or `spryg-desktop`, an Electron wrapper around the web dashboard. Neither feels like a Mac app. There are no native tables, menus or keyboard shortcuts. The login token sits in browser storage rather than the Keychain. Nothing works offline, and the Electron build isn't notarized, so external Users have to get past Gatekeeper warnings to install it.

Superusers watching many Brands and Users watching their own have the same need: open the app, see how a Brand is doing, trust that the numbers are current, and move between Brands quickly.

## Solution

spryg-mac is a native SwiftUI app for macOS 14 and later (see ADR 0001). It covers the read-only core of the web dashboard: Home, Sales, Advertising, Operations, Product Detail, Glossary and Settings. Superusers also get Command Center.

It talks to the same Spryg API as the other clients. One Active Brand drives every screen except Command Center. Each screen shows how current its data is (Data Through), and when the Mac is offline it shows the last data it loaded, marked with when it was fetched. The login token is stored only in the Keychain. The app ships as a notarized `.dmg` and updates itself through Sparkle.

## User Stories

### Signing in and session

1. As a User, I want to sign in with my Spryg email and password, so that I can see my Brands' data on my Mac.
2. As a User, I want my session to survive quitting and relaunching the app, so that I don't sign in every time I open it.
3. As a User, I want my login token stored in the macOS Keychain, so that my credentials are protected like other Mac apps' credentials.
4. As a User, I want the app never to store my password, so that a lost laptop doesn't expose it.
5. As a User, I want a sign-in sheet to appear when my session expires (after 48 hours), so that I can continue without losing my place.
6. As a User, I want the screen I was on to reload after I sign in again, so that an expired session costs me only a sign-in.
7. As a User, I want a clear error when my email or password is wrong, so that I know to retry instead of assuming the app is broken.
8. As a User, I want a "Forgot password" link that opens the Spryg website, so that I can reset my password without a native flow.
9. As a new User, I want a "Create account" link that opens the Spryg website, so that I can sign up.
10. As an invited User, I want my emailed invite link to open the website, where I accept, then sign in on the Mac, so that invites work the same as on the web.
11. As a User, I want to sign out from the app menu, so that I can hand the Mac to someone else safely.
12. As a User, I want signing out to remove my token and cached data from the Mac, so that the next person can't see my Brands.

### Active Brand

13. As a User, I want the app to open on the Brand I used last, so that I can pick up where I left off. Signing out forgets it, so the next person on a shared Mac starts fresh.
14. As a User signing in for the first time, I want the app to open on my first Brand alphabetically, so that I land somewhere sensible.
15. As a User with several Brands, I want a Brand switcher in the toolbar, so that I can change the Active Brand from any screen.
16. As a Superuser with many Brands, I want to search the Brand switcher, so that I can find a Brand without scrolling a long list.
17. As a User, I want to stay on the same screen when I switch Brands, so that I can compare Sales for Brand A and then Brand B quickly.
18. As a User, I want an applied Saved Filter cleared when I switch Brands, so that I never see Brand B filtered by Brand A's selections.
19. As a User, I want the switcher to list only the Brands assigned to me, so that I'm never shown Brands I can't access.
20. As a User, I want the window title to show the Active Brand, so that I always know whose data I'm looking at.
21. As a User, I want a keyboard shortcut to open the Brand switcher, so that I can change Brands without the mouse.

### Home

22. As a User, I want a Home screen with the Active Brand's headline sales and advertising metrics, so that I can see how the Brand is doing at a glance.
23. As a User, I want Home to show weekly sales metrics, so that I can see the recent trend.
24. As a User, I want Home to show leaders and gainers/drainers, so that I can see which products are driving or dragging results.
25. As a User, I want Home to show active promotions and Subscribe & Save totals, so that I see the same summary as on the web.

### Sales

26. As a User, I want the Sales screen to show sales cards for the chosen period, so that I can read totals, pacing and targets.
27. As a User, I want a daily sales chart, so that I can see day-by-day movement.
28. As a User, I want monthly and weekly sales tables, so that I can compare periods side by side.
29. As a User, I want the ASIN sales summary, so that I can see which products sold.
30. As a User, I want the monthly forecast, so that I can see where the month is heading.
31. As a User, I want to pick a period from presets (today, yesterday, last 7 days, MTD, YTD and so on), so that I can change the time window quickly.
32. As a User, I want "today" to mean today on my Mac's clock, so that the dates match what I expect.
33. As a User, I want to filter Sales by channel, Product Brand, category and ASIN, so that I can focus on part of the catalog.
34. As a User, I want to apply one of the Active Brand's Saved Filters, so that I can reuse a filter set up on the web.
35. As a Superuser, I want the extra Sales info cards the web app shows only to Superusers, so that I get the same detail I get on the web.
36. As a User who isn't a Superuser, I want those cards hidden, so that I see only what my access allows.

### Advertising

37. As a User, I want an Advertising dashboard for the Active Brand, so that I can see spend, sales, ROAS, ACoS and TACoS.
38. As a User, I want an advertising chart over time, so that I can spot changes in ad performance.
39. As a User, I want an advertising table, so that I can dig into campaigns.
40. As a User, I want to filter Advertising by campaign type, campaign name and placement, so that I can isolate a slice of spend.
41. As a User, I want the date picker limited to the range where advertising data exists, so that I can't pick an empty period.

### Operations

42. As a User, I want an Operations screen with inventory and buy-box (Featured Offer %) cards, so that I can spot stock and listing problems.
43. As a User, I want the per-SKU operations table, so that I can see which SKUs need attention.
44. As a User, I want to filter Operations and apply a Saved Filter, the same as on Sales, so that I can focus on the SKUs I care about.

### Product Detail

45. As a User, I want to open a product from any table, so that I can see its details.
46. As a User, I want Product Detail to show the product's info and its sales and inventory figures, so that I can understand one product in depth.

### Command Center

47. As a Superuser with more than one Brand, I want Command Center, so that I can compare every Brand and Portfolio side by side.
48. As a Superuser, I want daily, month-to-date and historical views in Command Center, so that I can see results over different horizons.
49. As a Superuser, I want Portfolio cards shown first, followed by Brand cards A to Z, so that the roll-up comes before the detail.
50. As a Superuser, I want to see which Brands a Portfolio includes, so that I know what its total covers.
51. As a Superuser, I want a warning when a Portfolio's Brands have different Data Through dates, so that I don't compare mismatched periods.
52. As a User who isn't a Superuser, I want Command Center absent from the app, so that the navigation shows only what I can use.

### Data freshness, refresh and offline

53. As a User, I want every screen to show its Data Through date, so that I know how current Amazon's data is.
54. As a User, I want data to refresh when I open a screen, so that I see current numbers.
55. As a User, I want data to refresh when the window comes back into focus, so that a window left open overnight isn't stale.
56. As a User, I want ⌘R to refresh the current screen, so that I can force an update.
57. As a User, I want visible windows to refresh every 15 minutes, so that numbers keep up while I work.
58. As a User without a network connection, I want to see the last data the app loaded, so that I can still work on a plane.
59. As a User offline, I want a "Fetched" note on cached data, so that I know how old my copy is.
60. As a User, I want a clear offline state on screens with no cached data, so that I understand why they're empty.
61. As a User, I want to move between recently viewed screens quickly, so that the app feels faster than the web.

### Currency and dates

62. As a User, I want amounts shown in the Active Brand's Marketplace currency, so that a UK Brand shows £ and a German Brand shows €.
63. As a Superuser, I want Portfolio totals shown the same way as on the web, so that Command Center matches the numbers people already quote.
64. As a User, I want dates the API returns as calendar dates shown as the same date, so that a label never shifts by a day because of my time zone.

### Glossary and Settings

65. As a User, I want an in-app Glossary of Spryg metrics, so that I can check what TACoS or Pacing means.
66. As a User, I want to change my password in Settings, so that I don't need the website for it.
67. As a Superuser, I want the useful-links section in Settings, so that I have the same shortcuts as on the web.

### Installing and updating

68. As a User, I want to download a notarized `.dmg` from the Spryg website, so that macOS installs it without warnings.
69. As a User, I want the app to update itself, so that I always have the latest version without reinstalling.
70. As a User, I want crash reports to go to Spryg's developers through Apple's built-in reporting, so that problems get fixed without a third-party tracker.
71. As a User, I want the app to send no analytics or email address to third parties, so that my usage stays private.

### Developer

72. As a developer, I want a debug-build option to point the app at another API host, so that I can test without touching production.
73. As a developer, I want a launch flag that swaps in recorded API responses, so that UI tests run without the real API.

### Look and feel

74. As a User, I want spryg-mac to use Spryg's colors, font and logo, so that it feels like the same product as the web app.
75. As a User, I want the app to look the same as the web dashboard, in light mode, whatever my Mac's appearance setting.

## Implementation Decisions

- The app is native SwiftUI for macOS 14 and later (ADR 0001). Charts use Swift Charts, tables use SwiftUI `Table`, and state uses `@Observable`.
- The app carries the web dashboard's brand on native controls (ADR 0002): its colors, the Switzer font, the logo, card style and chart palette, all defined in one theme. The app is light mode only, even when the Mac is set to dark.
- There are two modules. The macOS app target holds the SwiftUI screens and menus. A local Swift package, `SprygKit`, holds everything else: the API client, domain models, session, Active Brand, date and currency rules, caching and refresh. Screens depend only on `SprygKit`'s public interface.
- `SprygKit`'s public interface uses the glossary's terms. Raw API names stay inside it. It offers:
  - session: sign in, sign out, current User, whether the User is a Superuser, their Brands
  - Active Brand: get, set, and remember the last used one
  - one loader per screen area (Home, Sales, Advertising, Operations, Product Detail, Command Center, Saved Filters, Glossary), each taking a period and filter selections and returning domain values with Data Through and Fetched attached
  - change password
- `SprygKit` takes four dependencies: the network transport, the clock (current time and time zone), the token store, and the cache location. In production these are URLSession, the system clock, the Keychain and Application Support.
- The app uses the same Spryg API as the web app:
  - The global host (`global.api.spryg.io`) handles sign-in, the User's Brands, Command Center, change password and the data pipeline.
  - Each Brand's own host (the Brand's `domain`) handles its data.
  - Requests carry a bearer JWT that lasts 48 hours and can't be refreshed yet.
  - There's no OpenAPI spec. Swift models are written fresh from how the web app uses each endpoint.
  - Each API trap is handled once, while decoding, and checked against the list in `spryg-mobile`'s `HANDOFF.md` §3. Examples: `last_` means prior year, `period1..13` keys run backwards, daily endpoints ignore `date_range`, `roas` means different things on different endpoints, and trailing slashes are inconsistent. Raw API field names never reach the screens.
- The token is attached to a request only if the Brand's host matches `<name>.api.spryg.io`.
- Access is just User or Superuser (the `is_superuser` flag), plus the User's Brands. The `role` field in the token is ignored. Superuser-only screens and content are gated exactly as the web app gates them: Command Center needs Superuser and more than one Brand, and the extra Sales cards and Settings links are Superuser-only.
- There is one Active Brand per app. It persists across launches as the last used Brand, falling back to the first Brand alphabetically. Signing out forgets it. Changing it reloads the current screen for the new Brand and clears any applied Saved Filter.
- Saved Filters are read from the Active Brand's host and applied as channel, Product Brand, category and ASIN selections. v1 doesn't create, edit or delete them.
- "Today" and period presets are computed in the Mac's local time zone, as the web app does. Calendar dates from the API are shown as the same calendar date and never shifted by time zone. Request ranges use the `date_range` format the API expects.
- A Brand's currency comes from its Marketplace: US→USD, UK→GBP, DE/FR/IT/ES/NL→EUR, SE→SEK, PL→PLN, JP→JPY, AU→AUD, CA→CAD, MX→MXN. If the Marketplace is missing, fall back to the web app's legacy rule based on seller ID and domain. Portfolio totals copy the web app: amounts are summed across Brands and shown with "$".
- Data Through comes from each screen's own data (the latest date it contains), matching the web app's "Data available through". Where an endpoint doesn't carry it, use the data pipeline's last-pulled date.
- Data reloads when a screen opens, when a window becomes key again, on ⌘R, and every 15 minutes while a window is visible. There's no faster polling.
- The app caches the last successful response for each Brand, screen, period and filter combination in Application Support. When a request fails because the network is down, it serves the cached copy with its Fetched time. Sign-out clears the cache.
- A 401 or an expired token opens a sign-in sheet over the current window, and the screen reloads after sign-in succeeds. The Keychain holds the access and refresh tokens, the User and their Brands as of the last sign-in, and the Active Brand. The password is never stored. The Brand list refreshes only when the User signs in, not on launch.
- Sign-in is native. Sign-up, forgot password and accepting invites open the matching pages on the Spryg website.
- The app is signed with Developer ID, notarized and shipped as a `.dmg`. Updates come through Sparkle, with the appcast and `.dmg` files published as GitHub Releases in a new `spryg-io/spryg-mac-releases` repo. The website's `/download` page links to it.
- Crash reports come from Apple's built-in reporting only (Xcode Organizer). There's no Mixpanel or other analytics SDK.
- The app uses the production API by default, and debug builds can override the global host. A launch flag swaps in a fake transport that replays recorded responses, for UI tests.

## Testing Decisions

- Tests check external behavior through a public seam. They don't reach into decoders, private types or view internals, so the code underneath can be restructured without rewriting tests.
- The main seam is `SprygKit`'s public interface. Tests call it the way a screen would and check the domain values it returns. The fakes are a transport that replays recorded JSON, a fixed clock and time zone, an in-memory token store and a temporary cache directory. The network is the only boundary that gets stubbed.
- Tests at the main seam cover:
  - sign in, sign out, and a 401 leading to a sign-in prompt
  - Superuser gating, including when Command Center is available
  - Active Brand persistence and fallback, and Saved Filters clearing on switch
  - API traps producing correct domain values: prior-year fields, reversed periods, ROAS variants
  - local-time "today" and presets, and calendar dates never shifting across time zones (test time zones both ahead of and behind UTC)
  - the Marketplace currency mapping and the legacy fallback
  - Portfolio totals matching the web app
  - Data Through on every loader
  - refresh triggers and the 15-minute timer, driven by the fake clock
  - the offline fallback returning cached data with Fetched, and sign-out clearing the cache
  - the Brand host check rejecting hosts outside the allowlist
- The secondary seam is a set of XCUITest smoke tests against the running app, launched with the fake-transport flag. They cover signing in, switching Active Brand, Command Center hidden for a non-Superuser, and the offline Fetched label.
- SwiftUI views and view models aren't tested directly. Keep them thin enough that the two seams cover them.
- `SprygKit` tests use Swift Testing, and the smoke tests use XCUITest. `make test` runs both locally. GitHub Actions on a macOS runner runs them once the repo has a remote.
- This repo has no tests yet. `spryg-mobile` has 435 tests and API-shape validation. Its measured responses and `HANDOFF.md` §3 are the best reference for recorded fixtures and trap cases.

## Out of Scope

- Screens and flows that write data: Admin, Authorize (Amazon SP-API and Ads sign-in), Weekly Report, Product Management, Finance, Configure Events, Live Event editing, and creating, editing or deleting Saved Filters.
- Realtime Orders, Quantifiable Actions, Reports and Manage Filters.
- Native sign-up, forgot password and invite acceptance, and `spryg://` deep links.
- Data that only the Spryg connector has: stockout history, customer cohorts and lifetime value, promo redemptions, the retail calendar, Bloomifi roll-ups and pipeline status views.
- Showing several Brands at once, whether one Brand per window or tabs per Brand.
- Currency conversion, or totals split by currency, for Portfolios.
- Notifications, a menu bar extra and widgets.
- Mac App Store distribution.
- Analytics.
- Changes to `spryg-desktop`, whose future is still to be decided.
- Backend changes (see Further Notes).

## Further Notes

- The backend team needs to do three things, outside this repo:
  - Make refresh tokens work. Until then, Users sign in again every 48 hours.
  - Fix the brand endpoints that return data without a login, and the inventory endpoint that doesn't check which Brands the caller may see. v1 goes to brand clients before this fix, by deliberate decision. Until the fix lands, the app's Brand scoping only controls what is displayed. The server doesn't enforce it.
  - Eventually publish an OpenAPI spec.
- Two web app behaviors are carried over on purpose: Portfolio totals sum mixed currencies under "$", and "today" follows the Mac's clock. Keep them unless a later decision changes them.
- The first external build needs an organization Apple Developer account for Developer ID signing and notarization.
- Use the terms in `CONTEXT.md` (Brand, Marketplace, Portfolio, User, Superuser, Active Brand, Command Center, Product Brand, Saved Filter, Data Through) throughout the code and tickets.
