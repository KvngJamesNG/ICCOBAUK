# ICCOBA UK Website

Rails 7.1 website for ICCOBA UK/Europe with public pages and a lightweight admin CMS.

## Requirements

- Ruby 3.3.2
- Bundler
- SQLite3

## Setup

```bash
bundle install
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails server
```

Open http://localhost:3000.

## Admin CMS

Admin area is available at `/admin`.

### What admin can manage

- Articles (title, summary, body, author, category, publish date, feature image)
- Gallery images (title, caption, image upload)
- Homepage sliders (title, image, order, visibility, optional link)
- Info pages (custom pages like Privacy Policy, Data Subject Rights, etc.)

### Authentication

Admin uses HTTP Basic authentication.

Set credentials via environment variables:

```bash
export ADMIN_USERNAME=admin
export ADMIN_PASSWORD=strong-password
```

In development only, defaults are:

- username: `admin`
- password: `change-me`

Set secure credentials before deploying.

## GDPR Operations (Admin Notes)

- Public pages are available for `Privacy Policy` and `Data Subject Rights` via info pages.
- Cookie consent is implemented with explicit `Accept all` and `Reject optional` controls.
- Recommended admin workflow for privacy requests:
  1.  Log request and timestamp
  2.  Verify identity
  3.  Locate relevant data records
  4.  Perform requested action (access/rectify/delete/restrict)
  5.  Respond within GDPR timelines and record completion
