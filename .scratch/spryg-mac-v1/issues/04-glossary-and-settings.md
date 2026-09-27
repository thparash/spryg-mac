# 04: Glossary and Settings

**What to build:** A User can look up any Spryg metric in an in-app Glossary, and change their password in Settings. Superusers also see the useful-links section in Settings, as on the web.

**Blocked by:** 01 (Walking skeleton: sign in and see your Brands)

**Status:** ready-for-agent

- [ ] The Glossary lists the same terms and definitions as the web app's glossary, grouped by the same categories, with search.
- [ ] Settings lets a User change their password through the global API's change-password endpoint, with clear success and error states.
- [ ] The useful-links section appears only for Superusers.
- [ ] `SprygKit` tests cover a successful password change and a rejected one.
