# 01: Walking skeleton: sign in and see your Brands

**What to build:** A User opens spryg-mac, signs in with their Spryg email and password, and sees the list of Brands assigned to them. They stay signed in across relaunches and can sign out from the app menu. This ticket also sets up the project and the test seams every later ticket builds on. See the spec's Implementation Decisions and Testing Decisions.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [x] A macOS app target (macOS 14+, SwiftUI) and a local `SprygKit` Swift package exist. The app depends only on `SprygKit`'s public interface.
- [x] `SprygKit` takes four dependencies: network transport, clock (time and time zone), token store, and cache location. The production versions are URLSession, the system clock, the Keychain and Application Support.
- [x] Signing in calls the global API's login endpoint. On success, only the access and refresh tokens are stored, in the Keychain. The password is never stored.
- [x] A wrong email or password shows a clear error.
- [x] After sign-in, the app shows the User's Brands and whether they are a Superuser. The `role` token field is ignored.
- [x] Relaunching the app keeps the User signed in.
- [x] Sign-out from the app menu removes the tokens and returns to the sign-in screen.
- [x] "Create account" and "Forgot password" open the matching Spryg website pages.
- [x] Debug builds can override the global API host. Release builds always use production.
- [x] A launch flag swaps in a fake transport that replays recorded JSON.
- [x] `make test` runs Swift Testing tests for `SprygKit` and the XCUITest suite.
- [x] `SprygKit` tests cover successful sign-in, a wrong password, sign-out, and session restore, using the fake transport and an in-memory token store.
- [x] An XCUITest smoke test signs in through the fake transport and sees the Brand list.

## Comments

**2026-09-28, implemented on `feat/01-walking-skeleton`.** 13 `SprygKit` tests and 1 XCUITest smoke test pass (`make test`). Notes for later tickets:

- Fixtures use made-up values in the shape `spryg-mobile` measured against the live API. They aren't live recordings.
- The stored session holds the tokens plus the User and their Brands, so the Brand list shown after relaunch is whatever was true at the last sign-in. The password is never stored. Refreshing the Brand list on launch (`/users/user-tenants/`) isn't built yet. The spec's "only the tokens are stored" wording needs a decision: re-fetch the User on launch, or reword the spec.
- With ad-hoc signing (`CODE_SIGN_IDENTITY: "-"`), the login Keychain may ask for access after a rebuild. Developer ID signing in ticket 05 fixes this.
- `ReplayTransport` and the fixtures ship in release builds. The launch flag that uses them is Debug-only. Consider keeping them out of release in ticket 05.
- `Brand.marketplace` is still a raw marketplace ID string. Give it a Marketplace type in ticket 06, alongside currency.

**2026-09-28, live check.** The product owner signed in against the production API with a real account and saw their Brand list. The login contract matches the live API.
