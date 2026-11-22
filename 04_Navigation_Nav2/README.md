# 04 — Navigation: SLAM, Localization, and Nav2

> **Weeks:** 2 (calendar Weeks 9–10 on Path A) · **Load:** ~16–18 h/week
> **Masterclass:** Phase 2 "Navigation with Nav2" and "Advanced Nav2"
> **Stack:** slam_toolbox · AMCL · robot_localization · Nav2 (planners, controllers, costmaps, behaviour trees, docking) · Groot2
> **Phase project:** 🏆 **ButlerBot**, a home-service robot that takes requests by room name
> **Map:** [../README.md](../README.md)

A robot that can be told "go to the kitchen" and simply goes there, around furniture and people, is the
first thing that feels like magic. This phase builds exactly that: your robot maps your simulated flat,
works out where it is on the map, plans paths, follows them while avoiding obstacles, and recovers when it
gets stuck.

Week 1 makes you a confident Nav2 *user*: you understand every server and can tune it with data instead of
guesswork. Week 2 makes you a Nav2 *developer*: you drive it from code, restrict where the robot may go and
how fast, add behaviour-tree nodes, and turn your Phase 01 A* planner into a real Nav2 plugin.

## Can I Start Here?

| | |
|---|---|
| **Must have** | 03: a robot in Gazebo with a lidar, an IMU and `diff_drive_controller` |
| **Also needs** | 02 Week 3 Day 4 (lifecycle nodes): every Nav2 server is one |
| **⚙️ C++ needed for** | Week 2 Days 3–4 (behaviour-tree and planner plugins). Without Phase 01, do the Python Simple Commander work and log the plugins |
| **Bridge kit** | No robot of your own yet? Use Nav2's minimal TurtleBot simulation (`nav2_bringup`) for Week 1 and come back for your robot |

## After This Phase, You Can

- [ ] Build a map with slam_toolbox and localize on it with AMCL
- [ ] Fuse wheel odometry and IMU with `robot_localization`, and explain the `map → odom → base_link` chain
- [ ] Configure Nav2 for a new robot from scratch: footprint, costmap layers, planner, controller, behaviour tree
- [ ] Choose and tune planners (NavFn, Smac, Theta*) and controllers (DWB, Regulated Pure Pursuit, MPPI, Graceful) with measurements
- [ ] Read, edit and extend Nav2 behaviour trees with Groot2
- [ ] Command missions from Python with the Simple Commander API
- [ ] Use keepout and speed-limit zones, the collision monitor and the docking server
- [ ] Write Nav2 plugins: a global planner and a behaviour-tree node

## Software

```bash
sudo apt install -y ros-jazzy-navigation2 ros-jazzy-nav2-bringup ros-jazzy-slam-toolbox \
  ros-jazzy-robot-localization
```

Install [Groot2](https://www.behaviortree.dev/groot/) (free edition) for viewing behaviour trees. No hardware.

---

## Week 1 — Mapping, Localization, and Nav2 as a User

### Day 1 — Maps and SLAM
- [ ] Occupancy grids and log-odds; scan matching; pose graphs and loop closure, intuitively
- [ ] slam_toolbox: online asynchronous mapping, mapping vs localization mode, serialising and resuming maps; `map_saver_cli`
- [ ] **Code:** map your simulated flat by teleoperating through it; save the map (PGM + YAML) and compare it against the floor plan you built

### Day 2 — Localization and Sensor Fusion
- [ ] AMCL: particle-filter localization, intuitively (you will write one in Phase 06); initial pose; laser model parameters
- [ ] Odometry drift and why it is unavoidable; `robot_localization`'s EKF fusing wheel odometry and IMU for `odom → base_link`, with AMCL providing `map → odom`
- [ ] **Code:** configure `robot_localization`, then plot raw vs fused odometry against Gazebo's ground truth after a few laps

### Day 3 — Nav2 Architecture
- [ ] The lifecycle-managed servers: planner, controller, smoother, behaviour, BT navigator, waypoint follower, velocity smoother, collision monitor, docking; the lifecycle manager
- [ ] Costmap 2D: static, obstacle/voxel and inflation layers; footprint vs radius; global vs local costmap
- [ ] Walking through a complete Nav2 parameters file, one block at a time
- [ ] **Code:** bring up Nav2 on your robot with your own parameters file; send goals from RViz; tune inflation and footprint until it threads your doorways

### Day 4 — Planners and Controllers
- [ ] Global planners: NavFn (Dijkstra/A*), Smac 2D, Hybrid-A* and State Lattice, Theta*; path smoothers
- [ ] Controllers: DWB, Regulated Pure Pursuit, MPPI, Graceful; the rotation shim; how each one decides a velocity
- [ ] A tuning method: change one thing, measure, keep a log (journal `tuning/`)
- [ ] **Code:** a benchmark script that sends the same 10 goals with different planner/controller pairs and records time, path length, minimum obstacle distance and failures

### Day 5 — Behaviour Trees
- [ ] BehaviorTree.CPP v4: tick, sequence, fallback, decorators, ports, blackboard
- [ ] Nav2's default trees (navigate with replanning and recovery); recovery behaviours: spin, back up, wait, clear costmap
- [ ] Groot2 for viewing and editing trees
- [ ] **Code:** modify the navigation tree, e.g. replan only when the path is blocked, or wait at a closed door before recovering

### 🔨 Saturday — PatrolBot
- [ ] Map, localize, then patrol a list of waypoints forever using the Simple Commander API
- [ ] Log every lap: time, distance, recoveries triggered
- [ ] Handle failure: retry a waypoint once, then skip it and report
- [ ] Drop a moving obstacle (your Phase 03 plugin) into a corridor and watch it cope

### 📄 Sunday
- [ ] Nav2 docs: [Concepts](https://docs.nav2.org/concepts/index.html) and the whole [First-Time Robot Setup Guide](https://docs.nav2.org/setup_guides/index.html), the most useful document in this phase
- [ ] Macenski et al., "The Marathon 2: A Navigation System" (IROS 2020)
- [ ] Nav2 [Tuning Guide](https://docs.nav2.org/tuning/index.html)

---

## Week 2 — Advanced Nav2: Missions, Zones, Plugins

### Day 1 — The Simple Commander API
- [ ] `goToPose`, `followWaypoints`, `followPath`, `getPath`, task status and cancellation, docking calls
- [ ] Missions as code: named poses in YAML, feedback, timeouts
- [ ] **Code:** a "room service" command line: `go kitchen`, `go bedroom`, `patrol`, `stop`

### Day 2 — Keepout Zones, Speed Zones, and Safety Layers
- [ ] Costmap filters: filter masks, the costmap filter info server, keepout and speed-limit filters
- [ ] The collision monitor (stop, slow-down and approach polygons) and the velocity smoother
- [ ] **Code:** a no-go zone around a "sleeping baby" room and a slow zone in the hallway; prove both work with your benchmark script

### Day 3 — Custom Behaviour-Tree Nodes ⚙️
- [ ] Writing a BehaviorTree.CPP condition and action node as a Nav2 BT plugin; registering it; using it in your XML
- [ ] Writing a custom behaviour-server plugin
- [ ] **Code:** a battery-aware tree: an `IsBatteryLow` condition (from a simulated battery topic) that sends the robot to its dock

### Day 4 — Writing Nav2 Plugins ⚙️
- [ ] `pluginlib` and the `nav2_core` interfaces: `GlobalPlanner`, `Controller`, costmap layers
- [ ] **Code:** port your Phase 01 **GridPlanner** A* into a real Nav2 global-planner plugin, select it at run time, and compare it with Smac
- [ ] 🌶️ A custom costmap layer, e.g. one that raises the cost around detected people

### Day 5 — Docking, Multiple Robots, and Real-World Concerns
- [ ] The docking server: dock plugins, staging poses, charging detection (simulated)
- [ ] Namespaces for multiple robots, one Nav2 stack each
- [ ] Making Nav2 light enough for a Raspberry Pi: costmap resolution and size, controller frequency, CPU measurement
- [ ] **Code:** two robots patrolling the same flat without colliding

### 🏆 Saturday + Sunday — Phase Project: ButlerBot
See the brief below. Sunday reading this week:
- [ ] Nav2 plugin tutorials: "Writing a New Planner Plugin", "Writing a New Costmap2D Plugin", "Writing a New Behavior Tree Plugin"

---

## 🏆 Phase Project — ButlerBot: A Home-Service Robot

**What:** the robot lives in your simulated flat. Ask it to go somewhere by room name, from a command line
or a minimal web page, and it navigates there, respecting keepout and speed zones, recovering when blocked
and returning to its dock when its battery runs low.

**What makes it yours:** your own A* planner plugin is selectable at run time alongside Smac, and the README
includes a benchmark comparing them (and two controllers) on the same 20 goals.

**Deliverables:**
- [ ] Room-name requests (CLI or web page), named poses in YAML
- [ ] A battery-aware behaviour tree with docking, using your custom BT node
- [ ] Keepout and speed zones, collision monitor enabled
- [ ] Your A* planner plugin, plus a benchmark table: success rate, time, path length, CPU
- [ ] A demo video; the parameters and tree files graduate into `my_robot/src/<name>_navigation`

**Skills used:** 04, 03 (your robot and world), 02 (actions, lifecycle), 01 (A*, plugins in C++). **Evidence:** the benchmark table.

---

## ✅ Gate

- [ ] Map an unfamiliar world and localize on it, from a blank terminal
- [ ] Explain who publishes `map → odom` and `odom → base_link`, and why there are two
- [ ] Configure Nav2 for a new robot from scratch and tune it with logged measurements
- [ ] Explain how MPPI and Regulated Pure Pursuit each choose a velocity
- [ ] Write a Nav2 plugin and a behaviour-tree node, and use both
- [ ] ButlerBot's benchmark table is in the journal

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md   <->   codes/Week_1/Saturday/
theory/Phase_Project.md     <->   codes/Phase_Project/ButlerBot/
```

Lessons are generated one day at a time; ask for **"P04·W1·D1"**.

## Resources

- [Nav2 documentation](https://docs.nav2.org/): concepts, setup guides, tuning guide, plugin tutorials, configuration reference
- [slam_toolbox](https://github.com/SteveMacenski/slam_toolbox) README and Steve Macenski's ROSCon talks on Nav2 and MPPI
- [BehaviorTree.CPP documentation](https://www.behaviortree.dev/)
- [robot_localization documentation](https://docs.ros.org/en/jazzy/p/robot_localization/)
