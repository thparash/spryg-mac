# 03: Active Brand and Brand switcher

**What to build:** Every signed-in User has one Active Brand for the whole app. The app opens on the Brand they used last, or their first Brand alphabetically on a first sign-in. A toolbar switcher, with search and a keyboard shortcut, changes the Active Brand from anywhere, and the window title always shows it.

**Blocked by:** 01 (Walking skeleton: sign in and see your Brands)

**Status:** ready-for-agent

- [x] The Active Brand persists across launches as the last used Brand.
- [x] On a first sign-in, or if the last used Brand is no longer assigned, the Active Brand is the first assigned Brand alphabetically.
- [x] The switcher lists only the User's assigned Brands.
- [x] The switcher has a search field that filters Brands by name.
- [x] A keyboard shortcut opens the switcher.
- [x] The window title shows the Active Brand's name.
- [ ] Changing the Active Brand keeps the current screen and reloads it for the new Brand. (Keeps the screen. Reloading is deferred to ticket 06; see below.)
- [x] The token is attached to a Brand request only if the Brand's host matches `<name>.api.spryg.io`. Any other host is refused.
- [x] `SprygKit` tests cover persistence, the alphabetical fallback, a removed Brand, and the host check rejecting a host outside the allowlist.
- [x] An XCUITest smoke test switches the Active Brand and sees the window title change.

## Comments

**2026-09-28, implemented on `feat/03-active-brand`.** 25 `SprygKit` tests and 2 XCUITests pass (`make test`).

- **Reload on switch is deferred to ticket 06.** There's no data screen yet, so nothing to reload. Ticket 06 already requires "Changing the Active Brand reloads Home for the new Brand".
- **The switcher opens as a sheet, not a popover.** SwiftUI popovers anchored to toolbar buttons don't present on macOS (confirmed by experiment: the same popover works in the page and fails in the toolbar). The toolbar button is icon-only, because the window title beside it shows the Brand name.
- **⌘K is a "Switch Brand…" menu command.** Shortcuts on toolbar buttons don't fire, and menu commands are the Mac convention.
- **Brand list rows switch the Active Brand too.** The list is a stand-in until Home exists, and clicking a row is the obvious interaction.
- **Signing in again as the same User keeps their Active Brand.** Ticket 02 (session expiry) relies on this.
- **Brand requests** are built with `URLComponents` from the Brand's host, and the final URL's host is checked, so nothing in the path can redirect the token.
- **Open decisions for the product owner:**
  - Signing out forgets the Active Brand, so the next sign-in lands on the first Brand alphabetically. That's safer on a shared Mac, but story 13 says "open on the Brand I used last".
  - The Brand list isn't refreshed from the API on launch; it's whatever was saved at the last sign-in.
