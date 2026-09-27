# spryg-mac uses the web app's brand on native Mac controls

Users should recognize spryg-mac as Spryg. We port the web dashboard's brand into a small theme in the app: its colors, the Switzer font, the logo, the card style and the chart palette. Tables, menus, text fields, sidebars and toolbars stay standard SwiftUI and AppKit controls, styled with that theme but never redrawn. Light and dark mode follow the Mac's appearance setting.

## Considered Options

- A pixel-for-pixel copy of the web app, with every control custom-drawn. We rejected it because it gives up keyboard handling, accessibility and system behaviors that native controls provide for free. It also cuts against ADR 0001: if the goal is an exact web look, wrapping the web app is cheaper.
- Stock macOS styling with only the logo and an accent color. We rejected it because it doesn't read as Spryg.

## Consequences

- Screens use theme colors and fonts from one place, never hardcoded values, so the brand can change in one file.
- Where the web app has no dark-mode colors, the dark values are derived for the Mac and may differ from any future web dark theme.
