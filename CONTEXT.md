# Spryg

Spryg is Amazon seller analytics: sales, advertising, inventory and operations data for the Brands Quantifi manages. spryg-mac is the native macOS client for it.

## Language

### Access

**Brand**:
One Amazon seller account in one marketplace, and the unit that all Spryg data belongs to.
_Avoid_: Tenant, seller account, client

**Marketplace**:
The Amazon country store a Brand sells in (US, UK, DE, JP and so on). A Brand's currency follows from its Marketplace.
_Avoid_: Region, store, locale

**Portfolio**:
A named roll-up of several Brands, reported as one aggregate. "Quantifi" is the only Portfolio today.
_Avoid_: Parent, brand group

**User**:
A person who signs in to Spryg and sees only the Brands assigned to them.
_Avoid_: Client, customer, member

**Superuser**:
A User who can also manage other Users, authorize Brands, and see Portfolios and cross-Brand views.
_Avoid_: Admin, internal staff, MA, manager

**Active Brand**:
The one Brand the app is currently showing. Every screen except Command Center shows the Active Brand's data.
_Avoid_: Current tenant, selected brand

**Command Center**:
The Superuser view that compares every Brand and Portfolio side by side.
_Avoid_: Portfolio dashboard, all-brands view

### Products and data

**Product Brand**:
The brand name on an Amazon listing. One Brand can sell under several Product Brands.
_Avoid_: brand (when you mean the listing's brand name)

**Saved Filter**:
A named set of filter selections (channel, Product Brand, category, products) that belongs to one Brand.
_Avoid_: Tag, users tag, filter preset

**Data Through**:
The latest date for which Spryg holds a Brand's data from Amazon.
_Avoid_: Last updated, as of, refreshed
