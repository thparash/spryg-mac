# 09: Offline cache

**What to build:** A User without a network connection still sees the last data the app loaded for each screen, marked with when it was fetched. A screen with nothing cached shows a clear offline state. Signing out clears the cache.

**Blocked by:** 06 (Home: headline metrics)

**Status:** ready-for-agent

- [ ] The last successful response for each Brand, screen, period and filter combination is cached in Application Support.
- [ ] When a request fails because the network is down, the cached copy is shown with a "Fetched" note (for example "Offline · fetched Mon 09:00"), alongside its Data Through date.
- [ ] A screen with no cached data shows an offline state.
- [ ] Sign-out deletes the cache.
- [ ] `SprygKit` tests cover a cached fallback with its Fetched time, the empty offline state, and sign-out clearing the cache, using a temporary cache directory.
- [ ] An XCUITest smoke test sees the Fetched label when the fake transport simulates being offline.
