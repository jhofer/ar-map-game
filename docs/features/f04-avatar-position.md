# F04 — Avatar on the Map

[← Features](README.md)

**Goal:** the player sees their own avatar standing and walking at their real GPS position, with every fix accepted or rejected by the server.

**Implements:** [Client § Avatar Position Pipeline](../architecture/client.md#avatar-position-pipeline), [Client § Camera](../architecture/client.md#camera), [Anti-Cheat](../architecture/anti-cheat.md#anti-cheat), [Game Design § View & Presentation](../design/presentation.md#view--presentation), [Placeholder Assets](../architecture/placeholder-assets.md#placeholder-assets).

## Scope

### Location Sources

| Deliverable | Detail |
|---|---|
| `ILocationSource` | Interface in `Game.Client.Core`; the implementation is chosen in the `LifetimeScope` and nothing downstream knows which — see [Location Sources](../architecture/code-patterns.md#location-sources) |
| Device | Unity `Input.location` for P1; the native plugin is explicitly deferred — see [Tech Stack § Client](../architecture/tech-stack.md#client) |
| GPX replay | Plays recorded real walks, including bad-accuracy segments, in the editor and in automated tests |
| Editor joystick | Manual driving of a fake fix for fast iteration |
| Permissions | Request, denial and "while in use" paths each have a defined UI state; denial leaves a usable map without an avatar position |

### Position Pipeline

| Deliverable | Detail |
|---|---|
| Accuracy classes | < 10 m, 10–25 m, > 25 m with the smoothing and rejection rules from [Avatar Position Pipeline](../architecture/client.md#avatar-position-pipeline) |
| Smoothing | Exponential moving average, α per class; presentation only |
| Speed clamp | Fixes implying implausible walking speed are damped for presentation and still sent |
| Projection | WGS84 → ENU against a local origin, with floating-origin shift past a distance threshold |
| Interpolation | Per-frame interpolation between fixes at 0.2–1 Hz, so the avatar walks instead of jumping |
| Heading | Course over ground above 1.0 m/s, compass below, last heading otherwise |

### Server Side

| Deliverable | Detail |
|---|---|
| `PositionFix` intent | `(lat, lon, accuracy, clientTime)`, ~24 B, 0.2–1 Hz, over the F03 session |
| Plausibility check | Speed between fixes, jump detection, accuracy floor; a rejected fix is journalled with a reason and never becomes the accepted fix |
| Accepted fix store | One row per player, in memory with write-behind; this is the position every later presence rule reads |
| Speed lock | Server-derived speed with the hysteresis from [Speed Lock](../design/combat.md#speed-lock); exposed as session state, with nothing to gate yet |
| Metrics | Fix rate, rejection rate by reason, accuracy distribution — the first real gameplay-adjacent metrics |

### Presentation

| Deliverable | Detail |
|---|---|
| Avatar view | Placeholder capsule with `root` / `base` / `turret` / `muzzle` transforms — see [Prefab Contract](../architecture/placeholder-assets.md#prefab-contract) |
| Facing | Base yaw from heading; turret centred, since nothing is targetable yet — see [Rotation & Facing](../architecture/rotation.md#rotation--facing) |
| Camera | Cinemachine follow rig: tilted top-down, clamped orbit and pitch, zoom band 40–400 m (provisional), snap-to-north control |
| Ground | Flat ground plane with a no-data hint; tiles arrive in F05 and replace it without touching this feature |
| Debug HUD | Raw vs. smoothed position, accuracy class, fix age, accepted/rejected counter |

## Out of Scope

| Item | Goes to |
|---|---|
| Interest subscription, cell snapshots, other players | P2 |
| Conquest, placement, any presence-gated action | P2 |
| Native location plugin, background location | P2 |
| Map geometry | F05 |

## Acceptance

| # | Check |
|---|---|
| 1 | A GPX replay of a recorded city walk moves the avatar smoothly; standing still produces no visible drift or spin |
| 2 | A replayed segment with > 25 m accuracy holds the avatar in place instead of teleporting it |
| 3 | A fix implying 200 km/h is rejected server-side, logged with its reason, and the accepted fix is unchanged |
| 4 | Driving speed sustained in a replay sets the speed lock, and stopping clears it, per the hysteresis windows |
| 5 | A real walk on a real device: the avatar tracks the player, and the path recorded by the app matches the ground truth within GPS error |
| 6 | Crossing the floating-origin threshold produces no visible jump and no precision artefacts |
| 7 | 30 minutes of walking on a mid-range device: battery drain and average frame rate recorded (estimate, to be re-measured per device tier) |
| 8 | Denying the location permission leaves the app usable and states what is missing |
| 9 | The rejection-rate metric is visible on the Grafana dashboard from a real session |

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| `Input.location` update interval and accuracy are coarse | Avatar feels laggy or jumpy; wrong conclusions about the design | Judge feel on a real walk, not in the editor; the native plugin stays a known, scheduled fix |
| Over-smoothing hides real movement | Avatar lags behind the player; later radius actions feel broken | α per accuracy class, tuned against a GPX ground truth, not by eye |
| Urban canyon accuracy | Constant rejections in exactly the places the game is played | Rejection reasons are metrics from day one; thresholds are config, not code |
| Compass unusable when the phone tilts in hand | Avatar spins while standing | Course over ground above the speed threshold; compass low-passed and only used below it |
| Battery drain at 1 Hz fixes | Sessions end early | Fix rate is config; measure at 0.2, 0.5 and 1 Hz before choosing a default |
