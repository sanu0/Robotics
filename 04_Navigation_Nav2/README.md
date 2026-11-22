# 04 — Navigation: SLAM, Localization, and Nav2

> **Where it sits:** Month 3 · Week 11, and Month 4 · Week 13
> **The plan (tick boxes there):** [Week 11](../README.md#week-11) · [Week 13](../README.md#week-13) · [✅ Phase 04 gate](../README.md#gate-04)
> **Projects:** 🔨 PatrolBot (Week 11) · 🔨 ButlerBot (Week 13) · 🏆 [NavBench](../README.md#m3-project-b) (Month 3 Project B, Buffer Week 12) · your A* becomes a real Nav2 planner plugin (Week 13)
> **Stack:** slam_toolbox · AMCL · robot_localization · Nav2 (planners, controllers, costmaps, behaviour trees, docking) · Groot2
> **Map:** [../README.md](../README.md)

A robot that can be told "go to the kitchen" and simply goes there, around furniture and people, is the first
thing that feels like magic. This phase builds exactly that: your robot maps your simulated flat, works out
where it is on the map, plans paths, follows them while avoiding obstacles, and recovers when it gets stuck.

Week 11 makes you a confident Nav2 *user*: you understand every server and tune it with data instead of
guesswork. Week 13 makes you a Nav2 *developer*: you drive it from code, restrict where the robot may go and
how fast, add behaviour-tree nodes, and turn your Month 1 A* planner into a real Nav2 plugin. Between them,
Buffer Week 12 builds NavBench, the tool you use to measure all of it.

## Can I Start Here?

| | |
|---|---|
| **Must have** | Weeks 9–10: a robot in Gazebo with a lidar, an IMU and `diff_drive_controller` |
| **Also needs** | Week 7 Day 4 (lifecycle nodes): every Nav2 server is one |
| **⚙️ C++ needed for** | Week 13 Days 3–4 (behaviour-tree and planner plugins). Without Weeks 1–3, do the Python Simple Commander work and log the plugins |
| **Bridge kit** | No robot of your own yet? Use Nav2's minimal TurtleBot simulation (`nav2_bringup`) for Week 11 and come back for your robot |

## What You Will Be Able To Do

- Build a map with slam_toolbox and localize on it with AMCL
- Fuse wheel odometry and IMU with `robot_localization`, and explain the `map → odom → base_link` chain
- Configure Nav2 for a new robot from scratch: footprint, costmap layers, planner, controller, behaviour tree
- Choose and tune planners (NavFn, Smac, Theta*) and controllers (DWB, Regulated Pure Pursuit, MPPI, Graceful) with measurements
- Read, edit and extend Nav2 behaviour trees with Groot2
- Command missions from Python with the Simple Commander API
- Use keepout and speed-limit zones, the collision monitor and the docking server
- Write Nav2 plugins: a global planner and a behaviour-tree node

## Software

```bash
sudo apt install -y ros-jazzy-navigation2 ros-jazzy-nav2-bringup ros-jazzy-slam-toolbox \
  ros-jazzy-robot-localization
```

Install [Groot2](https://www.behaviortree.dev/groot/) (free edition) for viewing behaviour trees. No hardware.

## This Folder

```text
theory/Week_11/Day_1.md       <->   codes/Week_11/Day_1/
theory/Week_13/Saturday.md    <->   codes/Week_13/Saturday/
theory/Projects/NavBench.md   <->   codes/Projects/NavBench/
```

Lessons are generated one day at a time: ask for **"M3W11D1"**. Nav2 parameters, maps and trees graduate into
[`../my_robot/`](../my_robot/README.md) as `<name>_navigation`.

## Resources

- [Nav2 documentation](https://docs.nav2.org/): concepts, setup guides, tuning guide, plugin tutorials, configuration reference
- [slam_toolbox](https://github.com/SteveMacenski/slam_toolbox) README and Steve Macenski's ROSCon talks on Nav2 and MPPI
- [BehaviorTree.CPP documentation](https://www.behaviortree.dev/)
- [robot_localization documentation](https://docs.ros.org/en/jazzy/p/robot_localization/)
