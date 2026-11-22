# 05 — Manipulation and Control: ros2_control and MoveIt 2

> **Where it sits:** Month 4 · Weeks 14–15, then Buffer Week 16 for the monthly projects
> **The plan (tick boxes there):** [Week 14](../README.md#week-14) · [Week 15](../README.md#week-15) · [✅ Phase 05 gate](../README.md#gate-05) · [🔄 Buffer Week 16](../README.md#buffer-4)
> **Projects:** 🔨 MotorBridge v0.1 (Week 14) · 🔨 Pick-Anything v1 (Week 15) · 🏆 [WarehouseBot ⭐](../README.md#m4-project-a) and [MotorBridge](../README.md#m4-project-b) (Month 4 Projects A and B)
> **Stack:** ros2_control · MoveIt 2 (OMPL, Pilz, MoveIt Task Constructor, MoveIt Servo) · UR3e and SO-101 descriptions · BehaviorTree.CPP
> **Map:** [../README.md](../README.md)

Navigation moves the robot; manipulation lets it change the world.

**Week 14 is ros2_control from the inside.** You write a hardware interface and a controller: the C++ that sits
between ROS 2 and real motors. You write it against a *fake* serial motor board now, with a protocol you
design. In Week 21 your ESP32 firmware implements the same protocol, so the driver (MotorBridge) works on the
real robot unchanged.

**Week 15 is MoveIt 2.** You configure an arm, plan collision-free motions from code, build pick-and-place
pipelines with MoveIt Task Constructor, find objects with fiducial markers, and bring up your base with an
SO-101 arm on top.

**Buffer Week 16 puts it together** in WarehouseBot, the month's milestone: Nav2 and MoveIt side by side, a
behaviour tree orchestrating fetch-and-deliver, and an AI agent turning plain-language requests into tasks.

## Can I Start Here?

| | |
|---|---|
| **Must have** | Weeks 9–10 (URDF, Gazebo, ros2_control basics) and Weeks 1–3 (hardware interfaces and controllers are C++ only) |
| **Also needs** | Week 7 Day 4 (lifecycle). WarehouseBot also needs Weeks 11 and 13 (Nav2) |
| **Bridge kit** | Skipped navigation? Weeks 14–15 do not need it; build WarehouseBot after Week 13 |

## What You Will Be Able To Do

- Explain ros2_control's architecture: controller manager, resource manager, hardware components, command and state interfaces
- Write a `SystemInterface` hardware component and a custom controller in C++
- Configure and tune `joint_trajectory_controller`, gripper controllers and `diff_drive_controller`
- Generate a MoveIt 2 configuration for a new arm and plan from C++ and Python
- Manage the planning scene: collision objects, attaching and detaching, octomaps
- Build pick-and-place pipelines with MoveIt Task Constructor and teleoperate with MoveIt Servo
- Locate objects with AprilTag/ArUco markers and convert detections into grasp poses
- Run Nav2 and MoveIt together on a mobile manipulator, orchestrated by a behaviour tree
- Let an LLM agent issue robot tasks through a safe, constrained tool interface

## Software

```bash
sudo apt install -y ros-jazzy-moveit ros-jazzy-ur ros-jazzy-pick-ik ros-jazzy-apriltag-ros \
  ros-jazzy-moveit-servo
```

MoveIt Task Constructor and some quadruped controllers may need building from source on Jazzy; the day's
lesson says how. No hardware is required. If an SO-101 arrives early (see [HARDWARE.md](../HARDWARE.md)), Week 15
is a great time to run MoveIt on the real arm.

## This Folder

```text
theory/Week_14/Day_1.md           <->   codes/Week_14/Day_1/
theory/Week_15/Saturday.md        <->   codes/Week_15/Saturday/
theory/Projects/WarehouseBot.md   <->   codes/Projects/WarehouseBot/
theory/Projects/MotorBridge.md    <->   codes/Projects/MotorBridge/
```

Lessons are generated one day at a time: ask for **"M4W14D1"**. Control, MoveIt config and task packages
graduate into [`../my_robot/`](../my_robot/README.md).

## Resources

- [ros2_control documentation](https://control.ros.org/jazzy/index.html) and `ros2_control_demos`
- [MoveIt 2 documentation](https://moveit.picknik.ai/main/index.html) and the MoveIt Task Constructor docs
- [Universal Robots ROS 2 driver and descriptions](https://github.com/UniversalRobots/Universal_Robots_ROS2_Driver)
- [SO-ARM100/101 repository](https://github.com/TheRobotStudio/SO-ARM100) (URDF and CAD) and the LeRobot SO-101 docs
- Russ Tedrake, [*Robotic Manipulation*](https://manipulation.csail.mit.edu/) (MIT 6.4210, free online)
