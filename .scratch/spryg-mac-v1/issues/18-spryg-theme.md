# 18: Spryg theme

**What to build:** spryg-mac looks like Spryg. The web dashboard's colors, the Switzer font, the SPRYG logo, its card style and its chart palette are ported into one theme in the app. Sign-in and the Brand list are restyled with it. The app is light mode only. Controls stay native (ADR 0002). Every later screen builds on this theme instead of stock styling.

**Blocked by:** 01 (Walking skeleton: sign in and see your Brands)

**Status:** ready-for-agent

- [x] One theme in the app target defines the brand colors, fonts, corner radius and card style, taken from the web dashboard's actual values.
- [x] Colors live in the asset catalog as named colors. The app stays in light mode even when the Mac is dark.
- [x] ~~Switzer is bundled and registered~~ The theme uses the system font. See the comment below for why.
- [x] The SPRYG logo appears on the sign-in screen and in the main window.
- [x] The sign-in screen and the Brand list use the theme: brand colors, typography and card style.
- [x] A chart palette of the web app's series colors is defined for later chart tickets.
- [x] Nothing in the app hardcodes a color or font outside the theme.
- [x] Text contrast meets WCAG AA.
- [x] The UI smoke test still passes.

## Comments

**2026-09-28, implemented on `feat/01-walking-skeleton`.**

- The palette comes from `spryg-spa`. The brand is one green, `#379f7e`, used for titles, primary buttons and the sidebar gradient. The page is teal-50 `#f0fdfa`, with white rounded cards. The second chart series is orange `#f28c38`.
- Not ported yet, because no screen uses them: navy `#203149` (table total rows), taupe `#9d8769` (secondary buttons), the sidebar gradient `#379f7e`→`#2e8568`, and the delta colors green-600/red-600. Add them to the theme when those screens arrive.
- Font: Switzer's license (ITF FFL) does allow bundling it. But the web dashboard renders Home, Sales and Advertising in `-apple-system`, which is SF on a Mac. Switzer only appears on marketing and a few secondary pages. The system font matches what Spryg users actually see.
- Contrast: the web app's white text on `#379f7e` is 3.3:1 and fails WCAG AA. Buttons and small green text use the web app's darker green, `#2a7d61` (5:1). `#379f7e` is kept for large titles (3:1 needed). Every text pair was checked in both modes.
- Dark mode: the web app defines dark colors but never switches them on. The dark palette is derived. The dark chart colors (`#31a07d`, `#d2762e`) passed the dataviz palette validator, as did the light ones. The light orange sits under 3:1 against white, so charts must show labels or a legend.
- The logos are PNG only (`logo.png` in light mode, `logo-white.png` in dark). No SVG exists.
- Found by the smoke test: a clipped aspect-fill image still catches clicks at full size, so the sign-in artwork ignores hit-testing.

**2026-09-28, later: light mode only.** At the product owner's request, the app no longer follows the Mac's dark mode. Info.plist sets `NSRequiresAquaSystemAppearance`, and the dark color values and white logo are removed from the asset catalog. The dark palette above (including the validated dark chart colors `#31a07d` and `#d2762e`) is the starting point if dark mode comes back.
