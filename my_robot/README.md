# my_robot/ — Your Robot's Software, Growing Month by Month

The phase folders hold lessons: each day's code is a snapshot of one idea. This folder holds the opposite:
**one ROS 2 workspace for the robot you design in Week 9, simulate, give a brain in Months 3–5, build in
Weeks 21–22, and teach in Weeks 23–24.** When code from a lesson or a monthly project becomes part of your
robot, it graduates here and keeps evolving.

By the end it is the most important repository in your portfolio: a robot you can rebuild from scratch, in
simulation or on hardware, with one command.

## Name your robot

You pick the name in Week 9 Day 2 (the roadmap calls it **Rover-1** until then). Every package is prefixed
with it, the usual ROS convention: `rover_description`, `rover_bringup`, and so on.

## What grows here, week by week

| Week(s) | Package(s) | What it holds |
|---|---|---|
| 9 (Robot Designer) | `<name>_description` | URDF/xacro, meshes, inertias, sensor frames, `ros2_control` tags |
| 10 | `<name>_gazebo` | Worlds (including your flat), spawn launch, `ros_gz_bridge` config |
| 10 | `<name>_bringup` | One launch per mode: `sim.launch.py`, later `real.launch.py` |
| 11–13 (ButlerBot) | `<name>_navigation` | Nav2 and slam_toolbox parameters, maps, behaviour-tree XMLs, keepout and speed masks |
| 14–16 (MotorBridge) | `<name>_control` | Controllers YAML and the MotorBridge hardware interface (fake board first, real in Week 21) |
| 15–16 (WarehouseBot) | `<name>_moveit_config`, `<name>_tasks` | The arm's MoveIt configuration (SO-101 on your base); fetch-and-deliver behaviour trees |
| 17–20 (NavFromScratch) | `<name>_algorithms` | Your EKF, particle filter, planners and controllers, as Nav2 plugins where possible |
| 19–20 (SeeAndServe) | `<name>_perception` | Detection, AprilTag localization, the point-cloud pipeline, calibration files |
| 21 | `<name>_firmware` | ESP32 firmware (PlatformIO; not a colcon package, so add a `COLCON_IGNORE` file) |
| 22 | `<name>_web` | The browser dashboard (rosbridge) |
| 22 | `docker/`, `.github/` (repo root) | Multi-arch images; CI that builds, tests and runs a headless simulation test |
| 23–24 | `<name>_ai` | Policy runners (ONNX), the LLM agent's tool server, the voice interface |
| 25–26 (Magnum Opus) | whatever your option needs | |

## Building it

```bash
rpull              # repo -> WSL
rb my_robot        # builds every package in this folder into ~/ros2_ws and sources it
ros2 launch <name>_bringup sim.launch.py
```

## Rules for this folder

- **Graduate, don't copy-paste.** When lesson code moves here, clean it up, give it tests, and delete the
  experiments you no longer need.
- **One bringup command per mode.** `sim.launch.py` and `real.launch.py` must be all anyone needs.
- **Parameters live in YAML, not code.** Simulation and the real robot differ in parameters, not in source.
- **Every package has a README** saying what it does, how to run it, and what it depends on.
- **Tests run in CI** from Week 22 onward. A package without a test is a draft.

When you are ready to show it off, this folder can become its own GitHub repository with its history intact:
`git subtree split --prefix=my_robot -b my_robot-only`, then push that branch to a new repository.
