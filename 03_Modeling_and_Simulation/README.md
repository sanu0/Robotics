# 03 — Robot Modeling and Simulation: URDF, TF, Gazebo, ros2_control

> **Weeks:** 2 (calendar Weeks 7–8 on Path A) · **Load:** ~16–18 h/week
> **Masterclass:** Phase 1 "URDF", "TF", "Gazebo Sim", "vibe coding" and the **City Lab** project
> **Stack:** URDF/xacro · tf2 · RViz2 · Gazebo Harmonic (gz-sim 8) · `ros_gz` · `gz_ros2_control`
> **Phase project:** 🏆 **CityBot Challenge** (the masterclass's City Lab, in your own simulated city)
> **Map:** [../README.md](../README.md)

This is the phase where your robot is born. You design it in URDF (the same differential-drive robot you
will build for real in Phase 08), give it a lidar, a camera and an IMU, and drop it into a Gazebo copy of
your own flat. You learn TF properly, because almost every bug in robotics eventually turns out to be a
frame problem, and you drive the robot through `ros2_control`, the same interface a real motor driver will
plug into later.

By the end, the robot completes a small autonomy course on its own: following a lane, stopping for
obstacles, getting through a tunnel and parking. Nothing in Phases 04–07 is possible without this phase.

## Can I Start Here?

| | |
|---|---|
| **Must have** | 02 Week 1 (nodes, topics, launch) and 02 Week 2 Day 4 (tf2 first contact) |
| **⚙️ C++ needed for** | Week 2 Day 4 (a Gazebo system plugin). Without Phase 01, use existing plugins and log the day |
| **Bridge kit** | If you skipped 02 Weeks 2–3: do 02 W2 D2 (colcon/packages) and D3 (sim time) first, about one evening |

## After This Phase, You Can

- [ ] Describe any robot in URDF/xacro with correct joints, collision geometry and inertias
- [ ] Explain REP-103/REP-105 frames and debug a broken TF tree quickly
- [ ] Transform sensor data between frames at the right timestamp, in Python and C++
- [ ] Build Gazebo worlds, spawn robots with lidar, camera, depth camera and IMU, and bridge them to ROS 2
- [ ] Drive a simulated robot through `ros2_control` (`diff_drive_controller`, `joint_state_broadcaster`)
- [ ] Write a Gazebo system plugin
- [ ] Use an AI coding assistant to scaffold ROS 2 code, and verify what it wrote

## Software

```bash
sudo apt install -y ros-jazzy-xacro ros-jazzy-joint-state-publisher-gui ros-jazzy-ros2-control \
  ros-jazzy-ros2-controllers ros-jazzy-gz-ros2-control ros-jazzy-teleop-twist-keyboard \
  ros-jazzy-teleop-twist-joy ros-jazzy-twist-mux ros-jazzy-urdf-tutorial
```

No hardware. A gamepad makes teleop much nicer (see [HARDWARE.md](../HARDWARE.md)).

---

## Week 1 — Describing a Robot: Frames, URDF, Xacro

### Day 1 — Coordinate Frames and the Conventions Everyone Uses
- [ ] REP-103: right-handed axes, X forward, Y left, Z up, SI units; REP-105: `map`, `odom`, `base_footprint`, `base_link`, sensor frames, and who publishes each
- [ ] Rotations in practice: roll/pitch/yaw vs quaternions (the theory comes in Phase 06)
- [ ] The question you will answer a thousand times: "the cup is 30 cm in front of the camera; where should the gripper go relative to the arm's base?"
- [ ] **Code:** static transforms for a sensor rig, then transform a `PointStamped` from the camera frame to `base_link` in 🐍 and ⚙️

### Day 2 — URDF: Links, Joints, Geometry
- [ ] Links (visual, collision, inertial) and joints (fixed, revolute, continuous, prismatic); origins; meshes and materials
- [ ] `check_urdf`, `urdf_to_graphviz`, `robot_state_publisher`, `joint_state_publisher_gui`, RViz `RobotModel` and `TF` displays
- [ ] **Code:** model **your** robot: chassis, two drive wheels, a caster, and frames for lidar, camera and IMU. Pick realistic dimensions; this is the robot you will build in Phase 08. **Give it a name** (see [`my_robot/`](../my_robot/README.md))

### Day 3 — Xacro, Inertia, and Physical Realism
- [ ] Xacro properties, math, macros, includes, arguments and conditionals
- [ ] Inertia tensors for boxes, cylinders and spheres, and why wrong inertia makes a simulation explode or slide
- [ ] Friction (`mu1`, `mu2`), damping, collision simplification (boxes and cylinders instead of meshes)
- [ ] **Code:** refactor your robot into xacro macros (a `wheel` macro used twice) with an inertia macro library

### Day 4 — Arms: Joint Limits, Grippers, and a Second Robot
- [ ] Joint limits (position, velocity, effort), mimic joints for grippers, the `<ros2_control>` tag (preview)
- [ ] Load real arm descriptions: the UR3e from `ur_description`, and the SO-101 from its open-source repository
- [ ] **Code:** move both arms with the joint sliders, inspect their TF trees, and write down the frame names you will need for MoveIt

### Day 5 — tf2 in Depth
- [ ] The tf2 buffer: looking up transforms in the past, interpolation, cache length
- [ ] `tf2_ros::MessageFilter`: process a sensor message only once its transform is available
- [ ] The classic errors (extrapolation into the future, two unconnected trees, a frame published by two nodes) and how to find them with `view_frames` and `tf2_monitor`
- [ ] **Code:** transform a `LaserScan` into the `odom` frame and accumulate the points while you drive: a crude map, and your first taste of mapping

### 🔨 Saturday — Robot Designer
- [ ] Finish your robot's xacro, with one launch file that shows it in RViz with joint sliders
- [ ] Generate documentation automatically: a TF-tree PDF and a table of link masses and inertias
- [ ] A **mobile-manipulator variant**: your base with an SO-101 arm mounted on top (you will use it in Phase 05)
- [ ] Move the description into `my_robot/src/<name>_description` (its first graduation)

### 📄 Sunday
- [ ] REP-103 and REP-105 again (now they make sense), and skim [REP-120](https://www.ros.org/reps/rep-0120.html) on humanoid frames
- [ ] ROS 2 docs: the URDF tutorials and the tf2 tutorials
- [ ] Articulated Robotics (YouTube): the URDF and TF videos

---

## Week 2 — Gazebo Harmonic and ros2_control

### Day 1 — Gazebo Sim Fundamentals
- [ ] Architecture: server and GUI, entity-component-system, systems (plugins), SDF worlds and models, Gazebo Fuel
- [ ] `gz sim`, `gz topic`, `gz service`; physics settings and real-time factor
- [ ] Rendering in WSLg: GPU selection, `--render-engine ogre` as a fallback, headless mode (`-s`)
- [ ] **Code:** a world of **your own flat**: walls from a floor plan, a few furniture models, lighting

### Day 2 — Spawning Robots and Bridging to ROS 2
- [ ] `ros_gz_sim create` (spawning from `robot_description`), `ros_gz_bridge` with a YAML config, `ros_gz_image`
- [ ] Simulated sensors: GPU lidar, camera, depth camera and IMU via Gazebo's sensor systems; the `/clock` bridge and `use_sim_time`
- [ ] **Code:** spawn your robot with all four sensors and view everything in RViz

### Day 3 — ros2_control in Simulation
- [ ] `gz_ros2_control`, the controller manager, `joint_state_broadcaster`, `diff_drive_controller`, the controllers YAML
- [ ] The Jazzy detail that trips everyone up: `diff_drive_controller` expects `geometry_msgs/TwistStamped`; make teleop publish stamped messages or bridge with `twist_mux`/a stamper node
- [ ] `ros2 control list_controllers`, `list_hardware_interfaces`, `switch_controllers`
- [ ] **Code:** drive your robot around the flat with keyboard or gamepad; check that wheel odometry and TF look right in RViz

### Day 4 — Gazebo Plugins and Dynamic Worlds ⚙️
- [ ] Writing a Gazebo system plugin in C++: configure, pre-update, update, post-update; talking to it through Gazebo transport
- [ ] Moving obstacles: actors (walking people) and scripted models
- [ ] **Code:** a plugin that moves an obstacle back and forth across a corridor, which you will use to test obstacle avoidance

### Day 5 — Simulation-Driven Development, and Coding with AI
- [ ] A clean bringup structure: description, gazebo, control and bringup packages; one `sim.launch.py`
- [ ] Headless simulation for tests; recording bags of simulated runs; when to use Gazebo vs Isaac Sim vs MuJoCo vs Webots
- [ ] **"Vibe coding," done responsibly** (new in the masterclass for 2027): use Cursor to scaffold a `wall_follower` package, then review every line, write tests for it, and fix what it got wrong. Note in the journal what it got wrong
- [ ] **Code:** the AI-assisted `wall_follower`, reviewed and tested, following walls in your flat

### 🏆 Saturday + Sunday — Phase Project: CityBot Challenge
See the brief below. Sunday reading this week:
- [ ] Gazebo docs (Harmonic): SDF worlds, sensors, and the ROS 2 integration tutorials

---

## 🏆 Phase Project — CityBot Challenge (the City Lab, in your own city)

**What:** a small Gazebo "city" with lanes, obstacles, a tunnel, a traffic sign and a parking bay. Your
robot must, on its own:

1. Follow the lane using its camera (simple OpenCV line detection is enough)
2. Stop for an obstacle in its path, detected by lidar, and continue when it moves away (use your Day 4 plugin)
3. Get through the tunnel by wall-following, where the lane markings disappear
4. Park inside a marked bay

A state machine orchestrates the behaviours. An automatic **referee node** scores every run: time,
collisions, lane departures, and parking accuracy.

**Deliverables:**
- [ ] The city world and your robot in it, started by one launch command
- [ ] Lane follower, obstacle stop, wall follower and parking, coordinated by a state machine
- [ ] The referee node, and a results table over 10 runs
- [ ] A demo video and a README describing the architecture and what failed along the way

**Skills used:** 03 (URDF, TF, Gazebo, ros2_control), 02 (nodes, parameters, launch, bags). **Evidence:** referee scores over 10 runs.

---

## ✅ Gate

- [ ] Write a URDF/xacro for a new robot with correct inertias, and explain each joint type
- [ ] Draw your robot's TF tree from memory and say which node publishes each transform
- [ ] Diagnose a deliberately broken TF tree in under ten minutes
- [ ] Spawn a robot with sensors in Gazebo and drive it through `ros2_control`
- [ ] Explain the TwistStamped change in Jazzy's `diff_drive_controller`
- [ ] CityBot passes its course at least 8 times out of 10

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md   <->   codes/Week_1/Saturday/
theory/Phase_Project.md     <->   codes/Phase_Project/CityBot/
```

Your robot's description, worlds and bringup graduate into [`../my_robot/`](../my_robot/README.md) this
phase. Lessons are generated one day at a time; ask for **"P03·W1·D1"**.

## Resources

- [Gazebo Harmonic documentation](https://gazebosim.org/docs/harmonic/getstarted/) and [ROS 2 integration](https://gazebosim.org/docs/harmonic/ros2_integration/)
- [ros2_control documentation (Jazzy)](https://control.ros.org/jazzy/index.html) and the `ros2_control_demos` repository
- ROS 2 docs: [URDF tutorials](https://docs.ros.org/en/jazzy/Tutorials/Intermediate/URDF/URDF-Main.html) and [tf2 tutorials](https://docs.ros.org/en/jazzy/Tutorials/Intermediate/Tf2/Tf2-Main.html)
- Articulated Robotics (YouTube), "Building a mobile robot" series: the closest match to this phase and Phase 08
