# spryg-mac is a native SwiftUI app, not a wrapper around the web dashboard

The Spryg dashboard already exists three times in JavaScript: the Next.js web app, `spryg-spa` (Vite) and `spryg-mobile` (Expo). `spryg-desktop` already wraps it in Electron for macOS. We still chose to rebuild the Mac client natively in SwiftUI, targeting macOS 14 and later. The only reason for a separate Mac app is to feel like a Mac app: native tables, Swift Charts, menus, Keychain storage and offline caching. A web wrapper can't provide that, and the cheaper routes to "Spryg on Mac" were already there.

## Considered Options

- Tauri wrapping `spryg-spa` would give near parity from day one, but it's still a web UI, and the SPA carries about 129 type errors.
- React Native for macOS or Expo would share logic with `spryg-mobile`, but its macOS support is weak and its layouts are built for phones.
- Improving `spryg-desktop` (notarizing it and adding native features to Electron) would need no new repo, but it stays a web UI.

## Consequences

- Every screen, and its charts, is rebuilt from scratch. None of the JavaScript clients' code is shared.
- The Swift API models are written fresh from how the web app uses the API. No OpenAPI spec exists.
