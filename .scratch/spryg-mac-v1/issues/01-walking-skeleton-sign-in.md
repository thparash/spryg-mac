# 01: Walking skeleton: sign in and see your Brands

**What to build:** A User opens spryg-mac, signs in with their Spryg email and password, and sees the list of Brands assigned to them. They stay signed in across relaunches and can sign out from the app menu. This ticket also sets up the project and the test seams every later ticket builds on. See the spec's Implementation Decisions and Testing Decisions.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] A macOS app target (macOS 14+, SwiftUI) and a local `SprygKit` Swift package exist. The app depends only on `SprygKit`'s public interface.
- [ ] `SprygKit` takes four dependencies: network transport, clock (time and time zone), token store, and cache location. The production versions are URLSession, the system clock, the Keychain and Application Support.
- [ ] Signing in calls the global API's login endpoint. On success, only the access and refresh tokens are stored, in the Keychain. The password is never stored.
- [ ] A wrong email or password shows a clear error.
- [ ] After sign-in, the app shows the User's Brands and whether they are a Superuser. The `role` token field is ignored.
- [ ] Relaunching the app keeps the User signed in.
- [ ] Sign-out from the app menu removes the tokens and returns to the sign-in screen.
- [ ] "Create account" and "Forgot password" open the matching Spryg website pages.
- [ ] Debug builds can override the global API host. Release builds always use production.
- [ ] A launch flag swaps in a fake transport that replays recorded JSON.
- [ ] `make test` runs Swift Testing tests for `SprygKit` and the XCUITest suite.
- [ ] `SprygKit` tests cover successful sign-in, a wrong password, sign-out, and session restore, using the fake transport and an in-memory token store.
- [ ] An XCUITest smoke test signs in through the fake transport and sees the Brand list.
