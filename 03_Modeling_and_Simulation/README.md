# 03 — Robot Modeling and Simulation: URDF, TF, Gazebo, ros2_control

> **Where it sits:** Month 3 · Weeks 9–10
> **The plan (tick boxes there):** [Week 9](../README.md#week-9) · [Week 10](../README.md#week-10) · [✅ Phase 03 gate](../README.md#gate-03)
> **Projects:** 🔨 Robot Designer (Week 9) · 🔨 CityBot v0.1 (Week 10) · 🏆 [CityBot Challenge](../README.md#m3-project-a) (Month 3 Project A, Buffer Week 12)
> **Stack:** URDF/xacro · tf2 · RViz2 · Gazebo Harmonic (gz-sim 8) · `ros_gz` · `gz_ros2_control`
> **Map:** [../README.md](../README.md)

This is the phase where your robot is born. You design it in URDF (the same differential-drive robot you will
build for real in Week 22), give it a lidar, a camera and an IMU, and drop it into a Gazebo copy of your own
flat. You learn TF properly, because almost every bug in robotics eventually turns out to be a frame problem,
and you drive the robot through ros2_control, the same interface a real motor driver plugs into later.

By the end of the month the robot completes a small autonomy course on its own: following a lane, stopping
for obstacles, getting through a tunnel and parking. Nothing after this is possible without it.

## Can I Start Here?

| | |
|---|---|
| **Must have** | Week 5 (nodes, topics, launch) and Week 6 Day 4 (tf2 first contact) |
| **⚙️ C++ needed for** | Week 10 Day 4 (a Gazebo system plugin). Without Weeks 1–3, use existing plugins and log the day |
| **Bridge kit** | If you skipped Weeks 6–7: do Week 6 Day 2 (colcon and packages) and Day 3 (sim time) first, about one evening |

## What You Will Be Able To Do

- Describe any robot in URDF/xacro with correct joints, collision geometry and inertias
- Explain REP-103/REP-105 frames and debug a broken TF tree quickly
- Transform sensor data between frames at the right timestamp, in Python and C++
- Build Gazebo worlds, spawn robots with lidar, camera, depth camera and IMU, and bridge them to ROS 2
- Drive a simulated robot through ros2_control (`diff_drive_controller`, `joint_state_broadcaster`)
- Write a Gazebo system plugin
- Use an AI coding assistant to scaffold ROS 2 code, and verify what it wrote

## Software

```bash
sudo apt install -y ros-jazzy-xacro ros-jazzy-joint-state-publisher-gui ros-jazzy-ros2-control \
  ros-jazzy-ros2-controllers ros-jazzy-gz-ros2-control ros-jazzy-teleop-twist-keyboard \
  ros-jazzy-teleop-twist-joy ros-jazzy-twist-mux ros-jazzy-urdf-tutorial
```

No hardware. A gamepad makes teleop much nicer (see [HARDWARE.md](../HARDWARE.md)).

## This Folder

```text
theory/Week_9/Day_1.md        <->   codes/Week_9/Day_1/
theory/Week_9/Saturday.md     <->   codes/Week_9/Saturday/
theory/Projects/CityBot.md    <->   codes/Projects/CityBot/
```

Your robot's description, worlds and bringup graduate into [`../my_robot/`](../my_robot/README.md) this month.
Lessons are generated one day at a time: ask for **"M3W9D1"**.

## Resources

- [Gazebo Harmonic documentation](https://gazebosim.org/docs/harmonic/getstarted/) and [ROS 2 integration](https://gazebosim.org/docs/harmonic/ros2_integration/)
- [ros2_control documentation (Jazzy)](https://control.ros.org/jazzy/index.html) and the `ros2_control_demos` repository
- ROS 2 docs: [URDF tutorials](https://docs.ros.org/en/jazzy/Tutorials/Intermediate/URDF/URDF-Main.html) and [tf2 tutorials](https://docs.ros.org/en/jazzy/Tutorials/Intermediate/Tf2/Tf2-Main.html)
- Articulated Robotics (YouTube), "Building a mobile robot" series: the closest match to this phase and to Month 6
