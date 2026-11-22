# 05 — Manipulation and Control: ros2_control, MoveIt 2, Mobile Manipulation

> **Weeks:** 3 (calendar Weeks 11–13 on Path A) · **Load:** ~16–18 h/week
> **Masterclass:** Phase 2 "ros2_control" (including the quadruped exercise), "Perception and manipulation", "Agentic robotics" and the **Warehouse Lab** project
> **Stack:** ros2_control · MoveIt 2 (OMPL, Pilz, MoveIt Task Constructor, MoveIt Servo) · UR3e and SO-101 descriptions · BehaviorTree.CPP
> **Phase project:** 🏆 **WarehouseBot**, a mobile manipulator that fetches and delivers (the Warehouse Lab, in your own warehouse)
> **Map:** [../README.md](../README.md)

Navigation moves the robot; manipulation lets it change the world. This phase has three parts.

**Week 1 is ros2_control from the inside.** You write a hardware interface and a controller: the C++ code
that sits between ROS 2 and real motors. You write it against a *fake* serial motor board now, with a
protocol you design, and in Phase 08 your ESP32 firmware implements the same protocol, so the driver works
on the real robot unchanged.

**Week 2 is MoveIt 2.** You configure an arm, plan collision-free motions from code, build pick-and-place
pipelines with MoveIt Task Constructor, and locate objects with fiducial markers.

**Week 3 puts it together.** Your base from Phase 03 gets an SO-101 arm; Nav2 and MoveIt run side by side;
a behaviour tree orchestrates fetch-and-deliver; and an AI agent turns plain-language requests into tasks.
It is the masterclass's Warehouse Lab project, built on your own robot.

## Can I Start Here?

| | |
|---|---|
| **Must have** | 03 (URDF, Gazebo, `ros2_control` basics) and 01 (hardware interfaces and controllers are C++ only) |
| **Also needs** | 02 Week 3 Day 4 (lifecycle); Week 3 of this phase needs 04 (Nav2) |
| **Bridge kit** | Skipped 04? Weeks 1–2 do not need it; do Week 3 after 04 |

## After This Phase, You Can

- [ ] Explain ros2_control's architecture: controller manager, resource manager, hardware components, command and state interfaces
- [ ] Write a `SystemInterface` hardware component and a custom controller in C++
- [ ] Configure and tune `joint_trajectory_controller`, gripper controllers and `diff_drive_controller`
- [ ] Generate a MoveIt 2 configuration for a new arm and plan from C++ and Python
- [ ] Manage the planning scene: collision objects, attaching and detaching, octomaps
- [ ] Build pick-and-place pipelines with MoveIt Task Constructor and teleoperate with MoveIt Servo
- [ ] Locate objects with AprilTag/ArUco markers and convert detections into grasp poses
- [ ] Run Nav2 and MoveIt together on a mobile manipulator, orchestrated by a behaviour tree
- [ ] Let an LLM agent issue robot tasks through a safe, constrained tool interface

## Software

```bash
sudo apt install -y ros-jazzy-moveit ros-jazzy-ur ros-jazzy-pick-ik ros-jazzy-apriltag-ros \
  ros-jazzy-moveit-servo
```

MoveIt Task Constructor and some quadruped controllers may need building from source on Jazzy; the day's
lesson will say how. No hardware is required. If an SO-101 arm arrives early (see
[HARDWARE.md](../HARDWARE.md)), Week 2 is a great time to run MoveIt on the real arm.

---

## Week 1 — ros2_control from the Inside ⚙️

### Day 1 — The Architecture
- [ ] Controller manager, resource manager, hardware components (System, Actuator, Sensor), command and state interfaces, controller lifecycle
- [ ] The `<ros2_control>` URDF tag; `mock_components/GenericSystem` for running without hardware
- [ ] `ros2 control list_controllers`, `list_hardware_interfaces`, `switch_controllers`, `load_controller`
- [ ] **Code:** bring up the UR3e with mock hardware and `joint_trajectory_controller`; send it trajectories from the command line and from a Python script

### Day 2 — Writing a Hardware Interface
- [ ] `hardware_interface::SystemInterface`: `on_init`, `on_configure`, `on_activate`, `read()`, `write()`; parameters from the URDF; exporting the plugin
- [ ] Real-time rules inside `read()` and `write()`: no allocation, no blocking I/O, bounded time
- [ ] **Design:** a small serial protocol for a two-wheel motor board (set wheel velocities, read encoder ticks, heartbeat). Write it down; your ESP32 firmware will implement it in Phase 08
- [ ] **Code:** a fake motor board (a Python process on a pseudo-terminal that simulates two motors) and a hardware interface that drives your robot through it with `diff_drive_controller`

### Day 3 — Controllers in Depth
- [ ] `joint_trajectory_controller`: interpolation, tolerances, goal and path constraints
- [ ] `forward_command_controller`, `pid_controller`, gripper action controllers; chaining controllers
- [ ] **Code:** tune trajectory tolerances until goals succeed reliably; add a gripper and close it on an object in Gazebo

### Day 4 — Writing a Controller
- [ ] `controller_interface::ControllerInterface`: claiming interfaces, `update()`, `realtime_tools` (`RealtimeBuffer`, `RealtimePublisher`)
- [ ] **Code:** a custom controller, e.g. a velocity limiter with acceleration ramps for the diff drive, or a simple joint impedance-style controller for the arm

### Day 5 — The Legged-Robot Exercise
- [ ] A 12-joint quadruped in Gazebo (a CHAMP-based model or the Unitree Go2 description, whichever builds on Jazzy) with `joint_trajectory_controller`
- [ ] Gait basics: stance and swing phases, foot trajectories, a trot pattern
- [ ] **Code:** make it stand, sit, and walk a scripted trot with open-loop trajectories. In Phase 09 a learned policy replaces your script

### 🔨 Saturday — Fake-to-Real Driver
- [ ] Polish the hardware interface and fake board: watchdog (stop the motors when commands stop), error reporting, reconnect
- [ ] A protocol specification document, ready for the ESP32 firmware in Phase 08
- [ ] Unit tests for protocol encoding and decoding; an integration test with the fake board
- [ ] A one-page "ros2_control debugging cheat sheet" in the journal
- [ ] Graduates into `my_robot/src/<name>_control`

### 📄 Sunday
- [ ] [ros2_control docs](https://control.ros.org/jazzy/index.html): Getting Started, "Writing a Hardware Component", "Writing a Controller"
- [ ] The `ros2_control_demos` repository: read examples 1, 2, 4 and 7

---

## Week 2 — MoveIt 2

### Day 1 — MoveIt Concepts and Setup
- [ ] `move_group`, the planning scene, SRDF (planning groups, end effectors, disabled collisions), kinematics plugins (KDL, pick_ik)
- [ ] The MoveIt Setup Assistant; the MotionPlanning panel in RViz
- [ ] **Code:** use the official UR3e MoveIt configuration; then generate your own configuration for the **SO-101** with the Setup Assistant and plan with both in RViz

### Day 2 — Planning from Code
- [ ] `MoveGroupInterface` (C++) and `moveit_py` (Python): joint goals, pose goals, Cartesian paths, path constraints
- [ ] Planning pipelines: OMPL, Pilz industrial motion planner (PTP, LIN, CIRC), STOMP, CHOMP; time parameterisation
- [ ] **Code:** draw a square in the air with the end effector using a Cartesian path, then with Pilz LIN moves; compare the results

### Day 3 — The Planning Scene
- [ ] Adding, moving and removing collision objects; attaching objects to the gripper; the allowed collision matrix
- [ ] The perception pipeline: octomaps from a depth camera
- [ ] **Code:** a scripted pick of a box from a table in Gazebo, with a known pose and no vision yet

### Day 4 — MoveIt Task Constructor and MoveIt Servo
- [ ] MTC: stages (current state, move-to, move-relative, connect, generate grasp pose, compute IK), containers, introspection in RViz
- [ ] MoveIt Servo: real-time Cartesian jogging from a keyboard or gamepad
- [ ] **Code:** a full pick-and-place in MTC; jog the arm with Servo

### Day 5 — Finding Objects to Pick
- [ ] AprilTag/ArUco detection and pose estimation; colour segmentation as a fallback
- [ ] Detections → TF frames → grasp poses in the arm's base frame
- [ ] Hand-eye calibration in one lesson: eye-in-hand vs eye-to-hand (full treatment in Phase 07)
- [ ] **Code:** detect a tagged cube in the simulated camera image and pick it

### 🔨 Saturday — Pick-Anything v1
- [ ] The arm picks tagged objects from a table and sorts them into bins by tag ID
- [ ] Retries on failure; a success-rate log over 20 attempts
- [ ] Runs the same on the UR3e and on your SO-101 configuration

### 📄 Sunday
- [ ] [MoveIt 2 tutorials](https://moveit.picknik.ai/main/index.html): MoveGroup C++ interface, MoveItPy, MoveIt Task Constructor, MoveIt Servo
- [ ] Russ Tedrake, [*Robotic Manipulation*](https://manipulation.csail.mit.edu/), chapters 1–2 (free online)

---

## Week 3 — Mobile Manipulation and Agentic Robotics

### Day 1 — A Mobile Manipulator
- [ ] Your base plus the SO-101 in one URDF (from Phase 03's Robot Designer), one `robot_state_publisher`, two controller sets
- [ ] Nav2 and MoveIt in one system: frames, namespaces, and keeping the arm stowed while driving
- [ ] **Code:** bring up the mobile manipulator in a Gazebo warehouse world with shelves and a drop zone

### Day 2 — Orchestrating Long Tasks
- [ ] Behaviour trees for multi-step tasks: navigate → align → detect → pick → navigate → place
- [ ] Alternatives worth knowing: YASMIN and FlexBE state machines, SMACC2
- [ ] Error handling: retries, fallbacks, aborting safely
- [ ] **Code:** a behaviour tree for "fetch the item from shelf A"

### Day 3 — Precise Final Approach
- [ ] Why Nav2 alone is not accurate enough for picking; visual servoing to a marker; Nav2's docking server with your own dock plugin
- [ ] **Code:** align the base to a shelf within ±2 cm and ±2°, measured over 10 trials

### Day 4 — Agentic Robotics 101
- [ ] An LLM agent with tool calling, where the tools are robot capabilities: `go_to(room)`, `pick(object)`, `place(location)`, `describe_scene()`
- [ ] Natural language → plan → confirmation → execution; reporting back
- [ ] Guardrails: an allow-list of tools, geofences through keepout zones, speed limits, a human confirmation step, rate limits; cloud vs local models
- [ ] **Code:** "Bring the blue box to the dock" works in simulation, and a dangerous request is refused

### Day 5 — Testing a Whole System
- [ ] `launch_testing` integration tests: start the simulation headless, send a task, assert success within a time limit
- [ ] Failure injection: move the object, block the aisle, drop a detection
- [ ] **Code:** an integration test for the fetch task that you could run in CI

### 🏆 Saturday + Sunday — Phase Project: WarehouseBot
See the brief below. Sunday reading this week:
- [ ] Ahn et al., ["Do As I Can, Not As I Say" (SayCan)](https://say-can.github.io/) and Liang et al., ["Code as Policies"](https://code-as-policies.github.io/) (2022): the two papers that started LLM-driven robots

---

## 🏆 Phase Project — WarehouseBot: Mobile Pick-and-Place

**What:** the masterclass's Warehouse Lab task (an RB-1 base with a UR3e arm), built on your own mobile
manipulator in your own simulated warehouse. The robot navigates to a shelf, aligns precisely, detects the
requested item, picks it, carries it to the drop zone and places it. Tasks can be given in plain language
through the agent.

**Deliverables:**
- [ ] Nav2 + MoveIt + MTC + perception, orchestrated by a behaviour tree
- [ ] Precise final approach (docking server or visual servoing)
- [ ] Natural-language task entry through the guarded agent
- [ ] An integration test that runs headless; a success rate over 20 tasks
- [ ] A demo video; control, MoveIt config and task packages graduate into `my_robot/`

**Skills used:** 05, 04 (Nav2), 03 (robot and world), 02 (actions, lifecycle, launch), 01 (C++ plugins). **Evidence:** success rate over 20 tasks plus the test run.

---

## ✅ Gate

- [ ] Write a ros2_control hardware interface and a controller from a blank file
- [ ] Explain the path from a `/cmd_vel` message to a wheel command and back to `/odom`, naming every component
- [ ] Configure MoveIt for an arm you have never used, and plan pose and Cartesian goals from code
- [ ] Build a pick-and-place with MTC and explain each stage
- [ ] Run Nav2 and MoveIt together and orchestrate them with a behaviour tree
- [ ] Explain the guardrails on your agent and demonstrate a refused request
- [ ] WarehouseBot succeeds in at least 16 of 20 tasks

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md   <->   codes/Week_1/Saturday/
theory/Phase_Project.md     <->   codes/Phase_Project/WarehouseBot/
```

Lessons are generated one day at a time; ask for **"P05·W1·D1"**.

## Resources

- [ros2_control documentation](https://control.ros.org/jazzy/index.html) and `ros2_control_demos`
- [MoveIt 2 documentation](https://moveit.picknik.ai/main/index.html) and the MoveIt Task Constructor docs
- [Universal Robots ROS 2 driver and descriptions](https://github.com/UniversalRobots/Universal_Robots_ROS2_Driver)
- [SO-ARM100/101 repository](https://github.com/TheRobotStudio/SO-ARM100) (URDF and CAD) and the LeRobot SO-101 docs
- Russ Tedrake, [*Robotic Manipulation*](https://manipulation.csail.mit.edu/) (MIT 6.4210, free online)
