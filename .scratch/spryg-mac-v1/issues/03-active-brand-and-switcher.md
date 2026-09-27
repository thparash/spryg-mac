# 03: Active Brand and Brand switcher

**What to build:** Every signed-in User has one Active Brand for the whole app. The app opens on the Brand they used last, or their first Brand alphabetically on a first sign-in. A toolbar switcher, with search and a keyboard shortcut, changes the Active Brand from anywhere, and the window title always shows it.

**Blocked by:** 01 (Walking skeleton: sign in and see your Brands)

**Status:** ready-for-agent

- [ ] The Active Brand persists across launches as the last used Brand.
- [ ] On a first sign-in, or if the last used Brand is no longer assigned, the Active Brand is the first assigned Brand alphabetically.
- [ ] The switcher lists only the User's assigned Brands.
- [ ] The switcher has a search field that filters Brands by name.
- [ ] A keyboard shortcut opens the switcher.
- [ ] The window title shows the Active Brand's name.
- [ ] Changing the Active Brand keeps the current screen and reloads it for the new Brand.
- [ ] The token is attached to a Brand request only if the Brand's host matches `<name>.api.spryg.io`. Any other host is refused.
- [ ] `SprygKit` tests cover persistence, the alphabetical fallback, a removed Brand, and the host check rejecting a host outside the allowlist.
- [ ] An XCUITest smoke test switches the Active Brand and sees the window title change.
