# my_robot/ — Your Robot's Software, Growing Across Phases

The phase folders hold lessons: each day's code is a snapshot of one idea. This folder holds the opposite:
**one ROS 2 workspace for the robot you design in Phase 03, simulate, give a brain, build in Phase 08, and
teach in Phase 09.** When code from a lesson becomes part of your robot, it graduates here and keeps
evolving.

By the end it is the most important repository in your portfolio: a robot you can rebuild from scratch,
in sim or on hardware, with one command.

## Name your robot

You pick the name in Phase 03 Week 1 (this roadmap calls it **Rover-1** until then). Every package is
prefixed with it, the usual ROS convention: `rover_description`, `rover_bringup`, and so on.

## What grows here, phase by phase

| Phase | Package(s) | What it holds |
|---|---|---|
| 03 Modeling & Simulation | `<name>_description` | URDF/xacro, meshes, inertias, sensor frames, `ros2_control` tags |
| 03 | `<name>_gazebo` | Worlds (including your flat), spawn launch, `ros_gz_bridge` config |
| 03 | `<name>_bringup` | One launch per mode: `sim.launch.py`, later `real.launch.py` |
| 04 Navigation | `<name>_navigation` | Nav2 and slam_toolbox parameters, maps, behaviour-tree XMLs, keepout/speed masks |
| 05 Manipulation & Control | `<name>_control` | Controllers YAML, your `ros2_control` hardware interface (mock first, real in 08) |
| 05 | `<name>_moveit_config` | The arm's MoveIt configuration (SO-101 on your base) |
| 05 | `<name>_tasks` | Task orchestration: fetch/deliver behaviour trees |
| 06 How Robots Really Work | `<name>_algorithms` | Your EKF, particle filter, planners and controllers, as Nav2 plugins where possible |
| 07 Perception | `<name>_perception` | Detection, AprilTag localization, point-cloud pipeline, calibration files |
| 08 Build Your Own Robot | `<name>_firmware` | ESP32 firmware (PlatformIO; not a colcon package: add a `COLCON_IGNORE` file) |
| 08 | `<name>_web` | The browser dashboard (rosbridge) |
| 08 | `docker/`, `.github/` (repo root) | Multi-arch images; CI that builds, tests and runs a headless sim test |
| 09 Physical AI | `<name>_ai` | Policy runners (ONNX), the LLM agent's tool server, voice interface |
| 10 Capstone | whatever your capstone needs | |

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
- **Parameters live in YAML, not code.** Sim and real differ in parameters, not in source.
- **Every package has a README** saying what it does, how to run it, and what it depends on.
- **Tests run in CI** from Phase 08 onwards. A package without a test is a draft.

When you are ready to show it off, this folder can become its own GitHub repository with its history
intact: `git subtree split --prefix=my_robot -b my_robot-only`, then push that branch to a new repo.
