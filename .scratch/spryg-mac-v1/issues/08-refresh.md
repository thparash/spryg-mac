# 08: Refresh

**What to build:** Data stays current without the User thinking about it. A screen refreshes when it opens, when its window comes back into focus, when the User presses ⌘R, and every 15 minutes while its window is visible.

**Blocked by:** 06 (Home: headline metrics)

**Status:** ready-for-agent

- [ ] Opening a screen loads fresh data.
- [ ] A window becoming key again reloads its screen.
- [ ] ⌘R reloads the current screen.
- [ ] A visible window reloads every 15 minutes. Hidden or minimized windows don't.
- [ ] Nothing polls faster than this.
- [ ] `SprygKit` tests drive the 15-minute timer and the triggers with the fake clock.
