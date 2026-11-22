# Journal

The engineering journal. In robotics it earns its place twice over: robots fail in ways you cannot
reproduce on demand, and the difference between "it worked once" and "it works" lives in numbers you
wrote down.

## Why bother

- **Robots fail physically and intermittently.** A wheel slips on one tile, the lidar sees a mirror, the
  battery sags under load. If you did not write down what happened, you will not reproduce it.
- **Tuning is invisible without a log.** Nav2 and PID gains drift through a hundred small changes. The log
  is the only way back to the version that worked.
- **Measurements decay.** "Localization was pretty good" is useless. "Mean error 4.1 cm over 20 goals,
  command below" is evidence.
- **Your project write-ups, demo videos and interview stories come from here.**

## Layout

```text
journal/
├── README.md            # this file
├── 2026-W48.md          # one file per calendar week (ISO week), using the weekly template
├── experiments/         # one file per experiment worth repeating (sim vs real, A vs B)
├── incidents/           # the robot did something wrong: crash, runaway, brown-out, bad map
├── tuning/              # parameter changes with before/after numbers (Nav2, PID, EKF, MoveIt)
├── hardware/            # wiring changes, parts bought, parts that died, measured currents
└── media/               # small GIFs and screenshots only; videos go to YouTube, linked from here
```

## Weekly template

```markdown
# 2026-W48 — <month and week, e.g. Month 2 · Week 5 (02_ROS2_Core)>  (YYYY-MM-DD to YYYY-MM-DD)

## Plan
<the week's goal from the phase README>

## Built
<what runs now, with paths: 02_ROS2_Core/codes/Week_5/Saturday/...>

## Broke, and why
<the failures. The most valuable section: do not skip it>

## Numbers
<success rates, errors, latencies, rates, CPU — each with the exact command that produced it>

## Did not understand
<honest list; it becomes next week's reading and the catch-up ledger>

## Can now explain
<one paragraph, in your own words, without notes>

## Demo
<GIF or link>
```

## Experiment template (`experiments/`)

```markdown
# YYYY-MM-DD — <question, e.g. "Does MPPI beat Regulated Pure Pursuit in my flat?">

**Setup:** <robot, sim or real, world/map, software commit, parameters file>
**Method:** <N trials, start/goal list, what counts as success>
**Command:** <exact launch command; bag names>

| Variant | Success | Mean time | Path length | Min obstacle distance | CPU |
|---|---|---|---|---|---|

## Conclusion
## What I would change next time
```

## Incident template (`incidents/`)

```markdown
# YYYY-MM-DD — <one-line summary, e.g. "Rover drove into the sofa at full speed">

**Robot / software state:** <commit, parameters, battery level>
**What happened:** <timeline, with the bag name>
**Severity:** <cosmetic / damaged part / could have hurt someone>

## Root cause
## Fix
<and why it fixes the cause rather than hiding the symptom>
## Safety lesson
<what check, limit or e-stop rule prevents this whole class of failure>
```

## Tuning template (`tuning/`)

```markdown
# <system> tuning log — e.g. Nav2 controller (MPPI) on Rover-1

| Date | Parameter | Old → New | Why | Result (number + command) |
|---|---|---|---|---|
```

## The rules

1. **Write it the same day.** An entry written a week later is fiction.
2. **Record a bag for every run you might want to talk about.** Note its name here.
3. **Record the command, not just the number.** A result you cannot reproduce is not a measurement.
4. **Write the failures more carefully than the successes.** The successes are in the code; the failures
   are only here.
5. **Keep it public-safe.** No home maps, faces, IP addresses, tokens or internal material: those belong in
   `_internal/`.
