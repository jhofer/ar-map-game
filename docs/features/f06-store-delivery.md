# F06 — Store Delivery & P1 Release

[← Features](README.md)

**Goal:** a tester who is not the author installs the game from TestFlight and the Play internal track, plays it against the deployed server, and every store declaration matches what the app actually does.

**Implements:** [Slice Rules](../architecture/operations.md#slice-rules) — *done means deployed, a phase ends with a store test build against the deployed server* — plus [Tech Stack § Tooling & Delivery](../architecture/tech-stack.md#tooling--delivery) and [Operations](../architecture/operations.md#operations).

This feature closes **P1**. It adds no gameplay and no rendering.

## Scope

### Signing and Accounts

| Deliverable | Detail |
|---|---|
| Store records | App Store Connect and Play Console apps created; bundle id / application id fixed and recorded in the version matrix |
| iOS signing | App Store Connect API key in CI secrets; certificates and profiles managed by fastlane, never by hand on a laptop |
| Android signing | Upload keystore generated, stored in CI secrets, **and backed up offline** — a lost upload key is unrecoverable |
| iOS build job | macOS runner archive + export, deferred from [F02](f02-solution-and-ci.md#out-of-scope) and landed here |

### Release Lanes

| Deliverable | Detail |
|---|---|
| fastlane | `beta_ios` → TestFlight internal, `beta_android` → Play internal track; one command each, no interactive steps |
| Trigger | Manual dispatch plus every tag `v0.1.*`; the workflow refuses to build a dirty or untagged tree for a release lane |
| Versioning | `0.<phase>.<build>`; build number from the run number, the commit SHA embedded in the binary |
| Symbols | dSYM and Android mapping uploaded to Sentry as part of the lane, tagged with the same release |
| Changelog | Commit subjects since the previous tag, pasted into the tester notes |

### Store Compliance

| Deliverable | Detail |
|---|---|
| Location purpose strings | `NSLocationWhenInUseUsageDescription` and the Android rationale screen state the real reason: showing and validating the player's position on the map |
| Privacy declarations | iOS privacy manifest and App Store data-collection answers; Android Data safety form. Declared exactly: provider subject (identifier) and coarse/precise location, both linked to the account, both used for app functionality |
| Account deletion | `DELETE /account` plus an in-app entry point — required for an app with account creation, and deferred to here from [F03](f03-session-and-transport.md#out-of-scope) |
| Attribution | The OSM/ODbL and Overture attribution screen from F05 reachable from settings — see [Risks](../architecture/operations.md#risks) |
| Store metadata | Icon, splash, age rating, export-compliance answer, placeholder listing text and screenshots from the current build |

### Release Hygiene

| Deliverable | Detail |
|---|---|
| Protocol gate | A build is only distributed against a server that accepts its `ProtocolVersion`; the lane checks the deployed server's version before promoting |
| Release checklist | One page in the repo: tag, lanes, smoke test on a real device, tester notes, rollback |
| Rollback | Re-promote the previous TestFlight build and Play release; documented and executed once as a drill |
| About screen | Version, build number, commit SHA, server environment — the first thing a tester is asked for |

## Out of Scope

| Item | Goes to |
|---|---|
| Public App Store / Play release, review submission | After P2 at the earliest — internal tracks only |
| Platform attestation | P2 — see [Attestation Strictness](../architecture/anti-cheat.md#attestation-strictness) |
| Localization | When there is text worth translating |
| Push notification entitlements | P4, with the offline-attack journal |
| Background location | Not planned — see [Tech Stack § Client](../architecture/tech-stack.md#client) |

## Acceptance

| # | Check |
|---|---|
| 1 | A tester who is not the author installs from TestFlight and from the Play internal track, signs in, and sees their avatar on the map against the deployed server |
| 2 | A tag produces both builds with no manual step beyond approving the run |
| 3 | A deliberate crash in a release build appears in Sentry, symbolicated, tagged with the matching release |
| 4 | In-app account deletion removes the player row, revokes the Apple token, and a re-login creates a new player |
| 5 | An audit of one full session shows the only personal data leaving the device is the provider subject and position fixes — matching the store declarations exactly |
| 6 | A fresh install shows the real location purpose string; denying the permission leaves the app usable |
| 7 | The attribution screen is reachable in at most two taps and names ODbL and Overture |
| 8 | An older TestFlight build against the current server shows the update hint from `UnsupportedProtocol`, never a crash |
| 9 | The rollback drill: the previous build is back in testers' hands within one run |

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Review rejection over location usage | P1 cannot close | Foreground-only, purpose string states the real reason, no background entitlement requested |
| Privacy declaration does not match traffic | Rejection, or a compliance problem later | Acceptance row 5 is an actual traffic audit, repeated whenever a new field is sent |
| Upload keystore or API key lost | Android app id unusable forever | Offline backup of the keystore, documented restore, access recorded |
| Provisioning and certificate expiry | Builds break months later, at the worst moment | fastlane manages renewal; expiry dates recorded in the release checklist |
| macOS runner minutes | Cost | iOS lane runs on tags only, not per PR |
| TestFlight processing delays | Slow feedback loop | Android internal track is the fast path; iOS is not on the critical path for a daily build |
