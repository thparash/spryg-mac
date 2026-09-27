# 02: Session expiry

**What to build:** When a User's session expires (the 48-hour JWT runs out, or any request returns 401), a sign-in sheet appears over the current window. After they sign in again, the screen they were on reloads. Nothing else is lost.

**Blocked by:** 01 (Walking skeleton: sign in and see your Brands)

**Status:** ready-for-agent

- [ ] A 401 from any request opens a sign-in sheet over the current window.
- [ ] A token known to be expired (by its expiry claim and the injected clock) opens the sheet before a request is sent.
- [ ] Signing in from the sheet replaces the stored tokens and reloads the current screen.
- [ ] Cancelling the sheet signs the User out.
- [ ] The password is never stored at any point in this flow.
- [ ] `SprygKit` tests cover a 401 leading to a sign-in prompt, and an expired token detected with the fake clock.
