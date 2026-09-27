# 05: Signed release with auto-update

**What to build:** A User downloads spryg-mac as a notarized `.dmg` from the Spryg website, installs it without Gatekeeper warnings, and receives updates automatically through Sparkle.

**Blocked by:** 01 (Walking skeleton: sign in and see your Brands)

**Status:** ready-for-human

This needs the organization Apple Developer account, a Developer ID certificate, notarization credentials and a Sparkle signing key. An agent can't create those.

- [ ] Release builds are signed with Developer ID and notarized.
- [ ] A release script builds, signs, notarizes and packages a `.dmg`.
- [ ] A new `spryg-io/spryg-mac-releases` repo hosts the Sparkle appcast and `.dmg` files as GitHub Releases.
- [ ] The app checks the appcast and installs updates through Sparkle.
- [ ] The website's `/download` page links to the latest `.dmg`.
- [ ] The app includes no analytics SDK. Crash reports come only from Apple's built-in reporting.
