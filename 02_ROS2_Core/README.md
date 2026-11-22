# 02 — ROS 2 Core: From First Node to Intermediate ROS 2

> **Where it sits:** Month 2 · Weeks 5–7, then Buffer Week 8 for the monthly projects
> **The plan (tick boxes there):** [Week 5](../README.md#week-5) · [Week 6](../README.md#week-6) · [Week 7](../README.md#week-7) · [✅ Phase 02 gate](../README.md#gate-02) · [🔄 Buffer Week 8](../README.md#buffer-2)
> **Projects:** 🔨 Turtle Swarm Commander (Week 5) · 🔨 BlackBox v0.1 (Week 6) · 🔨 RoboTelemetry v0.1 (Week 7) · 🏆 [RoboTelemetry](../README.md#m2-project-a) and [BlackBox](../README.md#m2-project-b) (Month 2 Projects A and B)
> **Distro:** ROS 2 Jazzy on Ubuntu 24.04 · **Tracks:** 🐍 Python first, ⚙️ C++ alongside
> **Map:** [../README.md](../README.md)

ROS 2 is three things at once: a set of conventions (nodes, topics, services, actions, parameters, frames),
a communication layer underneath them (DDS, or Zenoh), and a toolbox (colcon, launch, rosbag2, RViz, rqt).
Every robot in the rest of this roadmap is built from those three. This phase teaches all of them, from your
first node to the parts most tutorials skip and real robots depend on: executors, QoS, the middleware layer,
lifecycle nodes and composition.

**How a day works:** each idea is taught in 🐍 Python first, the quickest way to see a graph working, and the
core of it is repeated in ⚙️ C++. If you start here before C++ ([Path B](../README.md#entry-paths)), do the 🐍
parts, log the ⚙️ parts in the [Catch-up Ledger](../README.md#catch-up-ledger), and come back after Weeks 1–3.
Week 7 Day 5 (components) is C++ only.

## Can I Start Here?

| | |
|---|---|
| **Must have** | Week 0 |
| **Python track** | Needs nothing else. You can start here before C++ |
| **⚙️ C++ blocks** | Need Weeks 1–2. Week 7 Day 5 needs Week 3 |
| **Bridge kit if you skipped C++** | None for the Python track; budget 2–3 days later for the ⚙️ blocks |

## What You Will Be Able To Do

- Write publishers, subscribers, services, actions and parameterised nodes in Python and C++
- Design custom interfaces and organise a multi-package workspace that `rosdep` can install from scratch
- Launch complex systems with arguments, namespaces, remapping and YAML parameters
- Inspect, record and replay any robot with the CLI, rqt, RViz, rosbag2 (MCAP) and Foxglove
- Reason about time: ROS time, sim time, header stamps
- Diagnose a callback deadlock and fix it with callback groups and executors
- Predict QoS compatibility, choose QoS deliberately, and switch between DDS and Zenoh middleware
- Write lifecycle-managed nodes and composable components with zero-copy intra-process communication

## Software

Included in `ros-jazzy-desktop` and `ros-dev-tools`, plus:

```bash
sudo apt install -y ros-jazzy-rmw-cyclonedds-cpp ros-jazzy-rmw-zenoh-cpp ros-jazzy-foxglove-bridge \
  ros-jazzy-diagnostic-updater ros-jazzy-diagnostic-aggregator ros-jazzy-rqt-robot-monitor
```

No hardware. Foxglove (or the open-source Lichtblick) runs on Windows; see SETUP.md Step 8.

## This Folder

```text
theory/Week_5/Day_1.md              <->   codes/Week_5/Day_1/
theory/Week_5/Saturday.md           <->   codes/Week_5/Saturday/
theory/Projects/RoboTelemetry.md    <->   codes/Projects/RoboTelemetry/
theory/Projects/BlackBox.md         <->   codes/Projects/BlackBox/
```

Lessons are generated one day at a time, when you reach that day: ask for **"M2W5D1"**. See
[How the daily notes work](../README.md#daily-notes).

## Resources

- [ROS 2 Jazzy documentation](https://docs.ros.org/en/jazzy/): Tutorials (Beginner and Intermediate) and Concepts
- *A Concise Introduction to Robot Programming with ROS 2* (Francisco Martín Rico): clear, C++-focused, robot-oriented
- [ROS 2 design articles](https://design.ros2.org/), especially "ROS on DDS" and the node lifecycle article
- [rmw_zenoh](https://github.com/ros2/rmw_zenoh) README, for Week 7 Day 3 and for WSL networking later
- Articulated Robotics (YouTube): the ROS 2 basics videos are an excellent second explanation
