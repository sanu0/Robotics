# 02 — ROS 2 Core: From First Node to Intermediate ROS 2

> **Weeks:** 3 (calendar Weeks 4–6 on Path A) · **Load:** ~16–18 h/week
> **Masterclass:** Phase 1 "ROS 2 basics" + Phase 2 "Intermediate ROS 2" (parameters, threading and callbacks, QoS, DDS, lifecycle nodes)
> **Distro:** ROS 2 Jazzy on Ubuntu 24.04 · **Tracks:** 🐍 Python first, ⚙️ C++ alongside
> **Phase project:** 🏆 **RoboTelemetry**, a fleet health monitor with a black-box recorder
> **Map:** [../README.md](../README.md)

ROS 2 is three things at once: a set of conventions (nodes, topics, services, actions, parameters, frames),
a communication layer underneath them (DDS, or Zenoh), and a toolbox (colcon, launch, rosbag2, RViz, rqt).
Every robot in the rest of this roadmap is built from those three. This phase teaches all of them, from your
first node to the parts most tutorials skip and real robots depend on: executors, QoS, the RMW layer,
lifecycle nodes and composition.

**How a day works:** each idea is taught in 🐍 Python first, the quickest way to see a graph working, and
the core of it is repeated in ⚙️ C++. If you have not done Phase 01 yet, do the 🐍 parts, log the ⚙️ parts
in the [Catch-up Ledger](../README.md#catch-up-ledger), and come back after Phase 01. Week 3 Day 5
(components) is C++ only.

> **Holiday note (Path A):** Weeks 4 and 5 contain Christmas and New Year. Take days off if you want them;
> protect the Saturday builds, and let Sunday reading slip first.

## Can I Start Here?

| | |
|---|---|
| **Must have** | 00 Launchpad |
| **Python track** | Needs nothing else. Start here before C++ if you like ([Path B](../README.md#entry-paths)) |
| **⚙️ C++ blocks** | Need 01 Weeks 1–2. Week 3 Day 5 needs 01 Week 3 |
| **Bridge kit if you skipped 01** | None for the Python track; budget 2–3 days later to do the ⚙️ blocks |

## After This Phase, You Can

- [ ] Write publishers, subscribers, services, actions and parameterised nodes in Python and C++
- [ ] Design custom interfaces and organise a multi-package workspace that `rosdep` can install from scratch
- [ ] Launch complex systems with arguments, namespaces, remapping and YAML parameters
- [ ] Inspect, record and replay any robot with the CLI, rqt, RViz, rosbag2 (MCAP) and Foxglove
- [ ] Reason about time: ROS time, sim time, header stamps
- [ ] Diagnose a callback deadlock and fix it with callback groups and executors
- [ ] Predict QoS compatibility, choose QoS deliberately, and switch between DDS and Zenoh middleware
- [ ] Write lifecycle-managed nodes and composable components with zero-copy intra-process communication

## Software

Included in `ros-jazzy-desktop` and `ros-dev-tools`, plus:

```bash
sudo apt install -y ros-jazzy-rmw-cyclonedds-cpp ros-jazzy-rmw-zenoh-cpp ros-jazzy-foxglove-bridge \
  ros-jazzy-diagnostic-updater ros-jazzy-diagnostic-aggregator ros-jazzy-rqt-robot-monitor
```

No hardware. Foxglove (or the open-source Lichtblick) runs on Windows; see SETUP.md Step 8.

---

## Week 1 — The ROS 2 Graph

### Day 1 — Concepts, the CLI, and Your First Package
- [ ] The graph live: nodes, topics, services, actions and parameters, explored with `turtlesim` and `ros2 node / topic (echo, hz, bw, pub) / service call / action send_goal / param`
- [ ] `rqt_graph`; discovery in one paragraph; `ROS_DOMAIN_ID` and `ROS_AUTOMATIC_DISCOVERY_RANGE` (which replaced `ROS_LOCALHOST_ONLY`)
- [ ] Workspaces: underlay vs overlay, `colcon build`, `source install/setup.bash`, and the `rb` helper
- [ ] 🐍 `ros2 pkg create --build-type ament_python`, a node class, `entry_points`, `ros2 run`
- [ ] ⚙️ The same with `ament_cmake` and `rclcpp`
- [ ] **Code:** `hello_robot`, a node that logs its name, a counter and the current ROS time once a second

### Day 2 — Topics: Publishers, Subscribers, Timers
- [ ] Message types: `std_msgs`, `geometry_msgs/Twist`, `turtlesim/Pose`, `sensor_msgs/LaserScan`; `ros2 interface show`
- [ ] 🐍 Publisher, subscriber and timer in one node; logging levels
- [ ] ⚙️ The same in `rclcpp`, with member-function callbacks and lambdas
- [ ] **Code:** `wall_bouncer`, a turtle that drives forward and turns away from the walls using `/turtle1/pose`

### Day 3 — Services and Custom Interfaces
- [ ] `.srv` files; servers and clients; synchronous vs asynchronous calls
- [ ] The rclpy trap: calling a service synchronously from inside a callback deadlocks. See it happen, then fix it with `call_async`
- [ ] A dedicated interfaces package (`ament_cmake` + `rosidl_default_generators`) for `.msg` and `.srv`
- [ ] **Code:** `robot_interfaces` with `SetSpeedLimit.srv` and `RobotStatus.msg`, and a server that enforces the limit on `wall_bouncer`

### Day 4 — Actions
- [ ] Goal, feedback, result and cancellation; when to use a topic, a service or an action
- [ ] 🐍 Action server and client; ⚙️ an action client in C++
- [ ] **Code:** `DrawPolygon.action`: the turtle draws an N-sided polygon, reports percent complete, and stops cleanly when cancelled

### Day 5 — Parameters and Launch
- [ ] Declaring, reading and changing parameters; validation callbacks; YAML parameter files
- [ ] Python launch: `Node`, arguments, substitutions, namespaces, remapping, `IncludeLaunchDescription`, `GroupAction`; when XML or YAML launch files read better
- [ ] **Code:** one launch file starts two namespaced turtles with different parameters loaded from YAML

### 🔨 Saturday — Turtle Swarm Commander
- [ ] Spawn N turtles with the `/spawn` service: one leader you teleoperate, followers that chase the turtle ahead with a proportional controller (gains as parameters)
- [ ] An action that makes the swarm form a shape (line, circle, V) and reports progress
- [ ] One launch file, one YAML config; N is a launch argument
- [ ] A GIF in the journal

### 📄 Sunday
- [ ] ROS 2 docs: Concepts → Basic again, now with experience, plus any Beginner tutorials you skipped
- [ ] Macenski et al., ["Robot Operating System 2: Design, architecture, and uses in the wild"](https://www.science.org/doi/10.1126/scirobotics.abm6074), *Science Robotics* (2022)

---

## Week 2 — Tools, the Build System, Time, and First TF

### Day 1 — Seeing Inside a Running Robot
- [ ] `rqt` (plot, console, topic monitor), `ros2 doctor`, logger configuration
- [ ] `ros2 bag record / play / info`: MCAP is Jazzy's default storage; `--clock` on playback
- [ ] Foxglove (or Lichtblick) through `foxglove_bridge`; RViz2 basics (fixed frame, displays, saving a config)
- [ ] **Code:** record ten minutes of the swarm, replay it into a fresh graph, and plot follower error in Foxglove

### Day 2 — Packages, Dependencies, and colcon in Depth
- [ ] `package.xml` dependency tags; `rosdep install --from-paths src --ignore-src -y`
- [ ] `ament_cmake` properly: `find_package`, linking exported targets with `target_link_libraries` (the newer style) vs `ament_target_dependencies`, `install()` rules for launch and config files, `ament_package()`
- [ ] `ament_python`: `setup.py`, `setup.cfg`, data files; mixed C++/Python packages with `ament_cmake_python`
- [ ] colcon flags you will use daily: `--symlink-install`, `--packages-select`, `--packages-up-to`, `--event-handlers console_direct+`, `--cmake-args`
- [ ] **Code:** reorganise Week 1 into a clean multi-package workspace that installs from scratch with `rosdep`

### Day 3 — Time, Clocks, and Headers
- [ ] ROS time vs system time vs steady time; `use_sim_time` and `/clock`; what timers do when time pauses or jumps
- [ ] `std_msgs/Header`: `stamp` and `frame_id`, the two fields every sensor message depends on
- [ ] **Code:** a latency probe that compares header stamps with arrival time, then replays a bag with `--clock` and explains the difference

### Day 4 — tf2, First Contact
- [ ] Static vs dynamic transforms; broadcasters and listeners; `lookupTransform` with timeouts
- [ ] `ros2 run tf2_ros tf2_echo`, `ros2 run tf2_tools view_frames`; why you ask for the transform *at the time the data was taken*
- [ ] **Code:** the classic, in 🐍 and ⚙️: turtle 2 follows turtle 1 using TF instead of pose topics

### Day 5 — C++/Python Parity, Style, and Tests
- [ ] An idiomatic `rclcpp` node (composition-ready class, `SharedPtr`, lambdas vs `std::bind`) and an idiomatic `rclpy` node
- [ ] Unit tests: `pytest` for Python logic, `ament_cmake_gtest` for C++; `ament_lint_auto`; pre-commit hooks
- [ ] **Code:** pull `wall_bouncer`'s decision logic into a pure function and test it in both languages

### 🔨 Saturday — BlackBox: A Flight Recorder for Robots
- [ ] Use rosbag2's snapshot mode (`ros2 bag record --snapshot-mode` plus its snapshot service) to keep the last 30 seconds of chosen topics in memory
- [ ] A trigger node that saves a snapshot when something goes wrong: an `/emergency` message, a node disappearing, a value out of range
- [ ] A Foxglove layout that opens a snapshot and shows exactly what happened
- [ ] Prove it: crash a turtle into a wall on purpose and replay its last 30 seconds

### 📄 Sunday
- [ ] The rosbag2 README (storage plugins, snapshot mode) and the MCAP format overview
- [ ] ROS 2 docs: Tutorials → Intermediate. Skim the list; you will do most of it next week

---

## Week 3 — Intermediate ROS 2: Executors, QoS, DDS, Lifecycle, Components

### Day 1 — Executors and Callback Groups
- [ ] Single-threaded and multi-threaded executors (and `rclcpp`'s experimental events executor)
- [ ] Mutually exclusive vs reentrant callback groups; what "my callback never runs" looks like from outside
- [ ] **Code:** reproduce the service-call-inside-a-callback deadlock in both languages, fix it with a callback group and a multi-threaded executor, and measure callback latency before and after

### Day 2 — Quality of Service
- [ ] Reliability, durability, history and depth, deadline, lifespan, liveliness; `SensorDataQoS` and the other presets
- [ ] Compatibility rules (a reliable subscriber hears nothing from a best-effort publisher); incompatible-QoS events; `ros2 topic info --verbose`
- [ ] `transient_local`: how `/robot_description` and maps reach nodes that start late
- [ ] **Code:** a QoS lab with five mismatched publisher/subscriber pairs: predict which pairs talk, then check

### Day 3 — DDS and the RMW Layer
- [ ] What DDS (RTPS) does: participants, discovery, transports, shared memory
- [ ] Middleware choices: Fast DDS (default), Cyclone DDS, and Zenoh (`rmw_zenoh_cpp`, router-based, friendly to Wi-Fi and WSL); switching with `RMW_IMPLEMENTATION`
- [ ] Discovery server, domain IDs, and a first look at SROS2 security
- [ ] **Code:** benchmark latency and throughput for 1 KB and 1 MB messages on all three; the table goes in your journal

### Day 4 — Lifecycle (Managed) Nodes
- [ ] States and transitions: unconfigured → inactive → active → finalized; `on_configure`, `on_activate`, `on_deactivate`, `on_cleanup`, `on_shutdown`
- [ ] Lifecycle publishers; driving transitions from the CLI and from a manager; why Nav2 manages every server this way
- [ ] **Code:** a lifecycle `FakeLidarDriver` and a small manager that brings several nodes up in order and takes them down on error

### Day 5 — Components and Composition ⚙️
- [ ] `rclcpp_components`: writing a component, component containers, `ros2 component load`, `ComposableNodeContainer` in launch files
- [ ] Intra-process communication: zero-copy with `std::unique_ptr` (compare with MiniROS)
- [ ] Type adaptation (REP-2007) in one paragraph: how Isaac ROS keeps images on the GPU between nodes (NITROS, Phase 07)
- [ ] **Code:** a camera-like publisher and an image processor, first as two processes, then composed into one container; measure the latency difference

### 🏆 Saturday + Sunday — Phase Project: RoboTelemetry
See the brief below. Sunday reading this week:
- [ ] ROS 2 docs: Concepts → Intermediate (executors, QoS, DDS tuning, lifecycle, composition), as review

---

## 🏆 Phase Project — RoboTelemetry: Fleet Health Monitor

**What:** three namespaced fake robots publish battery level, CPU temperature, motor currents and status.
A lifecycle-managed aggregator turns them into OK/WARN/ERROR per subsystem with `diagnostic_updater` and
`diagnostic_aggregator`. BlackBox saves a snapshot whenever anything goes to ERROR, and a Foxglove dashboard
shows the whole fleet.

**What makes it more than a tutorial:** every topic's QoS is chosen deliberately and justified in a table;
nodes are composed where zero-copy matters and the latency gain is measured; and the README ends with a
written comparison of your **MiniROS** design against `rclcpp`: what ROS 2 did the same, what it did
differently, and why.

**Deliverables:**
- [ ] Fake robots (🐍), aggregator as a lifecycle node (⚙️ if Phase 01 is done), BlackBox integration
- [ ] A QoS decision table for every topic
- [ ] One launch command for the whole system, with parameters in YAML; works under Fast DDS and Zenoh
- [ ] A Foxglove layout file committed with the project
- [ ] Unit tests for the health logic; one `launch_testing` test that checks the aggregator reports ERROR when a fake robot overheats
- [ ] README: architecture diagram, QoS table, measured numbers, MiniROS-vs-rclcpp comparison

**Skills used:** Phase 02 (all), Phase 01 (C++, MiniROS). **Evidence:** a recorded snapshot of a simulated failure, and the test run.

---

## ✅ Gate

- [ ] From a blank workspace, write a publisher, subscriber, service, action and parameterised node in Python, and the publisher/subscriber pair in C++
- [ ] Build a multi-package workspace with custom interfaces that installs with `rosdep` alone
- [ ] Explain and fix a callback deadlock and a QoS mismatch, each in under five minutes
- [ ] Switch a running system between Fast DDS, Cyclone and Zenoh, and explain when you would choose each
- [ ] Write a lifecycle node and a component; explain why Nav2 uses both
- [ ] Record, replay and analyse a bag in Foxglove
- [ ] RoboTelemetry runs from one command and its test passes

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md   <->   codes/Week_1/Saturday/
theory/Phase_Project.md     <->   codes/Phase_Project/RoboTelemetry/
```

Lessons are generated one day at a time; ask for **"P02·W1·D1"**. See
[How the Daily Notes Work](../README.md#daily-notes).

## Resources

- [ROS 2 Jazzy documentation](https://docs.ros.org/en/jazzy/): Tutorials (Beginner and Intermediate) and Concepts
- *A Concise Introduction to Robot Programming with ROS 2* (Francisco Martín Rico): clear, C++-focused, robot-oriented
- [ROS 2 design articles](https://design.ros2.org/), especially "ROS on DDS" and the node lifecycle article
- [rmw_zenoh](https://github.com/ros2/rmw_zenoh) README, for Day 3 and for WSL networking later
- Articulated Robotics (YouTube): the ROS 2 basics videos are an excellent second explanation
