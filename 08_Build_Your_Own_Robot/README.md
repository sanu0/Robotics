# 08 — Build Your Own Robot: Electronics, Firmware, Mechanics, and Shipping Software

> **Weeks:** 3 (calendar Weeks 19–21 on Path A) · **Load:** ~16–18 h/week, more if you love soldering
> **Masterclass:** Phase 4 (assemble and program a robot kit, web dashboard, Docker, testing and CI), plus the hardware design it explicitly does *not* teach
> **Stack:** ESP32 + micro-ROS / your serial protocol · ros2_control · Raspberry Pi 5 or Jetson Orin Nano Super · RPLIDAR · Onshape/Fusion · rosbridge · Docker · GitHub Actions
> **Phase project:** 🏆 **Rover-1 Complete**: your own real robot, mapped, navigating, dashboarded, containerised and CI-tested
> **Hardware:** this phase needs it. See [HARDWARE.md](../HARDWARE.md) and order early
> **Map:** [../README.md](../README.md)

The masterclass ships you a pre-designed kit to assemble. This phase goes further: you **design** the robot
you modelled in Phase 03, wire its electronics, write its firmware, print or cut its chassis, bring up its
computer, and run the same Nav2 stack on it that you tuned in simulation. Then you do what the masterclass
does do in its Phase 4: a web dashboard, Docker images and continuous integration, so your robot's software
is something another engineer could pick up and run.

Week 1 is electrons: power, batteries, microcontrollers, motors and encoders, firmware. Week 2 is atoms:
CAD, fabrication, assembly, bring-up, calibration and real-world navigation. Week 3 is software
engineering: dashboard, containers, tests and CI.

> **Safety first, every session.** Read [Safety Rules](../README.md#safety) before you connect a battery.
> Wheels off the ground for every first test; a fuse and a physical power switch on every robot; never leave
> a lithium battery charging unattended.

## Can I Start Here?

| | |
|---|---|
| **Must have** | 03 (your URDF), 04 (Nav2 configuration), 05 Week 1 (your hardware interface and protocol) |
| **Can start any time** | Week 1 Days 1–3 (electronics, microcontrollers, motors) need no ROS. Do them on Saturdays during Phases 02–05 if your parts arrive early ([Path D](../README.md#entry-paths)) |
| **Buying a kit instead?** | The FastBot (€489) or another ROS 2 kit works: skip Week 2 Days 1–2 (CAD and fabrication), keep the rest |
| **No hardware at all?** | See "If the hardware never arrives" in [HARDWARE.md](../HARDWARE.md): Week 3 still works entirely in simulation |

## After This Phase, You Can

- [ ] Power a robot safely: batteries, protection, regulation, fusing, wiring, and a power budget
- [ ] Program a microcontroller with interrupts, PWM, timers and I2C/UART/SPI
- [ ] Close a wheel-speed loop on a microcontroller and plot its step response
- [ ] Connect a microcontroller to ROS 2 with micro-ROS, or with your own protocol through `ros2_control`
- [ ] Design a chassis in CAD and fabricate it (3D printing or laser cutting)
- [ ] Bring up a robot computer: Ubuntu, ROS 2, networking, udev rules, autostart with systemd
- [ ] Calibrate odometry and sensors, and make the URDF match the real robot
- [ ] Run SLAM and Nav2 on real hardware and debug the gap between simulation and reality
- [ ] Build a browser dashboard over rosbridge, multi-arch Docker images, tests and a CI pipeline

## Hardware for This Phase

Tier 1 (electronics starter kit) for Week 1; Tier 2 (the Rover-1 parts) for Weeks 2–3; Tier 3 (the SO-101
arm) if you want the arm on board for Phases 09–10. Full lists, prices and order-by dates:
[HARDWARE.md](../HARDWARE.md).

## Software

```bash
# Laptop (WSL)
sudo apt install -y ros-jazzy-rosbridge-suite ros-jazzy-web-video-server ros-jazzy-usb-cam
# Robot computer: Ubuntu 24.04 + ros-jazzy-ros-base (or JetPack 7.2 + ROS 2 Jazzy on a Jetson)
# Firmware: PlatformIO (VS Code/Cursor extension or CLI) with micro_ros_platformio set to jazzy
# micro-ROS agent: docker run -it --rm --net=host -v /dev:/dev --privileged microros/micro-ros-agent:jazzy serial --dev /dev/ttyUSB0
```

USB devices reach WSL through `usbipd-win`, and a real robot on Wi-Fi needs WSL's mirrored networking or
Zenoh: SETUP.md Steps 12–13.

---

## Week 1 — Electrons: Power, Microcontrollers, Motors, Firmware 🔧

### Day 1 — Electronics for Robots, and Safety
- [ ] Voltage, current, power; Ohm's law; series and parallel; using a multimeter (voltage, continuity, current)
- [ ] Batteries: Li-ion 18650 packs vs LiPo; C-rating; battery management systems; safe charging, storage and disposal
- [ ] Regulation (buck, boost, LDO), wire gauge, connectors (XT30/XT60, JST), fuses, a kill switch, common ground, decoupling and noise
- [ ] **Bench work:** a power budget for Rover-1 (motors at stall, computer, lidar, camera) and a power-distribution plan you can defend; measure real voltages on the bench

### Day 2 — Microcontrollers
- [ ] The ESP32: cores, FreeRTOS, GPIO, PWM (LEDC), ADC, timers and interrupts, UART, I2C, SPI
- [ ] PlatformIO; flashing and serial monitoring from WSL through `usbipd`
- [ ] **Code:** blink → fade an LED with PWM → read an IMU over I2C → stream readings over serial at a fixed rate

### Day 3 — Motors, Drivers and Encoders
- [ ] Brushed DC motors and H-bridge drivers; PWM frequency; reading quadrature encoders with interrupts or the ESP32's pulse-counter peripheral
- [ ] **The PID speed controller you wrote in Phase 06**, now on real hardware: tuning, saturation, anti-windup
- [ ] Bus servos (like the SO-101's STS3215), steppers (TMC2209), and BLDC motors with field-oriented control (SimpleFOC), briefly
- [ ] **Code:** closed-loop wheel speed on the ESP32 with a plotted step response (commanded vs measured)

### Day 4 — micro-ROS
- [ ] Architecture: the agent on the computer, the client on the microcontroller, XRCE-DDS in between
- [ ] `micro_ros_platformio` for Jazzy; serial and Wi-Fi (UDP) transports; publishers, subscribers and services on the microcontroller; the rclc executor; memory limits
- [ ] **Code:** the ESP32 publishes encoder ticks and IMU data and subscribes to wheel-velocity commands through the micro-ROS agent

### Day 5 — Firmware Architecture and Failsafes
- [ ] Two clean designs: (a) micro-ROS on the microcontroller; (b) your Phase 05 serial protocol with a `ros2_control` hardware interface on the computer. Their trade-offs, and why many robots use (b)
- [ ] Failsafes: a command watchdog that stops the motors, an emergency-stop circuit that cuts motor power in hardware, brown-out handling
- [ ] **Code:** implement **your Phase 05 protocol** on the ESP32, so the hardware interface you wrote against a fake board now drives real motors

### 🔨 Saturday — Wheel Module
- [ ] A bench rig: two motors with encoders, the driver, the ESP32 and a battery, controlled from ROS 2 (`diff_drive_controller` → your hardware interface → ESP32 → wheels)
- [ ] Plots of commanded vs measured wheel speed; a demo of the watchdog stopping the wheels when you kill the ROS side
- [ ] The firmware graduates into `my_robot/src/<name>_firmware` (with a `COLCON_IGNORE` file)

### 📄 Sunday
- [ ] Scherz & Monk, *Practical Electronics for Inventors*: the chapters on power supplies and motors
- [ ] The [micro-ROS tutorials](https://micro.ros.org/docs/tutorials/core/overview/)
- [ ] Phil's Lab or GreatScott! (YouTube) on batteries and motor drivers

---

## Week 2 — Atoms: CAD, Fabrication, Bring-up, Real-World Navigation 🔧

### Day 1 — Mechanical Design
- [ ] CAD fundamentals in Onshape or Fusion (free plans for personal use): sketch, extrude, assemble, mate
- [ ] Designing for 3D printing: tolerances, wall thickness, heat-set inserts, print orientation and strength
- [ ] Robot layout: centre of mass, wheel and caster placement, lidar height and field of view, camera placement, cable paths
- [ ] **CAD:** the chassis plate, motor mounts and lidar mount for Rover-1; export STL for printing and meshes for the URDF

### Day 2 — Fabrication and Assembly
- [ ] 3D printing (slicing, infill, PLA vs PETG) or ordering prints and laser-cut plates from a service
- [ ] Mounting the computer and power distribution; cable management and strain relief
- [ ] First power-on checklist: continuity checks, a current-limited first power-up, then the wheels-up test
- [ ] **Build:** assemble Rover-1

### Day 3 — Robot Computer Bring-up
- [ ] Raspberry Pi 5 with Ubuntu 24.04 Server, or Jetson Orin Nano Super with JetPack 7.2; ROS 2 Jazzy (`ros-base`)
- [ ] Networking: Wi-Fi, a fixed IP, SSH keys, time synchronisation (chrony); talking to your laptop (domain ID, mirrored networking or a Zenoh router)
- [ ] udev rules for stable device names (`/dev/lidar`, `/dev/esp32`); a systemd service that starts the robot's bringup at boot
- [ ] **Code:** `real.launch.py` on the robot (hardware interface, controllers, `robot_state_publisher`, lidar driver), teleoperated from the laptop

### Day 4 — Sensors and Calibration
- [ ] Lidar driver (`sllidar_ros2` or `ldlidar`), IMU driver and calibration (bias, axis alignment to REP-103), camera (USB, or a Pi camera through `camera_ros`)
- [ ] Odometry calibration with the UMBmark square test: correct wheel radius and track width
- [ ] Make the URDF match reality: measure sensor offsets with a tape measure and check them in RViz
- [ ] **Code:** run UMBmark before and after calibration; record the improvement

### Day 5 — SLAM and Nav2 on Real Hardware
- [ ] slam_toolbox on the real robot: map your actual home (keep the map in `_internal/`; it is private)
- [ ] `robot_localization` with real wheel odometry and IMU; Nav2 parameters adapted from simulation (footprint, speed and acceleration limits, inflation); the collision monitor as a safety layer
- [ ] The sim-to-real gap: wheel slip, reflective surfaces, latency, Wi-Fi; debugging it with bags
- [ ] **Code:** autonomous navigation between rooms of your home

### 🔨 Saturday — First Autonomous Run
- [ ] Rover-1 maps your home and drives to rooms on command
- [ ] A demo video and a bag of the run
- [ ] A published bill of materials with prices, and a wiring diagram (KiCad schematic, or a clear drawing)

### 📄 Sunday
- [ ] Borenstein & Feng, "Measurement and correction of systematic odometry errors in mobile robots" (the UMBmark paper, 1996)
- [ ] Articulated Robotics (YouTube): the real-robot build videos
- [ ] The Onshape learning centre (or Fusion's) introductory course

---

## Week 3 — Shipping Robot Software: Dashboard, Docker, Tests, CI

### Day 1 — Web Dashboard I
- [ ] rosbridge (websocket) and roslibjs; HTML, CSS and JavaScript basics, or a small Vite app (you have built some already)
- [ ] Teleoperation with an on-screen joystick; subscribing, publishing and calling services from the browser
- [ ] **Code:** a dashboard with drive controls, battery level and robot status

### Day 2 — Web Dashboard II
- [ ] The map in the browser (draw `OccupancyGrid` onto a canvas); click-to-navigate through a Nav2 action; camera stream via `web_video_server`; the 3D robot model with three.js and the URDF
- [ ] Security: never expose rosbridge to the internet; authentication; read-only views
- [ ] **Code:** click on the map and the robot drives there, with the camera feed beside it

### Day 3 — Docker for Robotics
- [ ] Images (`ros:jazzy-ros-base`, `osrf/ros:jazzy-desktop`), Dockerfile practice (multi-stage builds, rosdep caching, a non-root user), docker compose for multi-container bringup
- [ ] GPUs in containers (NVIDIA Container Toolkit), devices (`/dev/tty*`), host networking, dev containers
- [ ] Multi-architecture builds with `buildx` (amd64 for the laptop, arm64 for the Pi or Jetson)
- [ ] **Code:** containerise the robot's bringup and dashboard; run the same image in simulation on the laptop and on the real robot

### Day 4 — Testing
- [ ] Unit tests (gtest, pytest), `launch_testing` integration tests, mock hardware for testing control code, headless simulation tests
- [ ] Coverage and linters (`ament_lint_auto`), pre-commit
- [ ] **Code:** a test suite for `my_robot`, including a headless simulation test that the robot reaches a goal

### Day 5 — Continuous Integration
- [ ] GitHub Actions with `ros-tooling/setup-ros` and `action-ros-ci`; caching; building and pushing Docker images to GitHub's container registry; release tags
- [ ] Documentation that stays current (rosdoc2 or MkDocs)
- [ ] **Code:** a CI pipeline that builds, tests and publishes your robot's image on every push (it runs once you have a GitHub remote)

### 🏆 Saturday + Sunday — Phase Project: Rover-1 Complete
See the brief below. Sunday reading this week:
- [ ] The [ROS 2 Developer Guide](https://docs.ros.org/en/jazzy/The-ROS2-Project/Contributing/Developer-Guide.html) and [REP-2004](https://www.ros.org/reps/rep-2004.html) (package quality levels)

---

## 🏆 Phase Project — Rover-1 Complete

**What:** your robot, finished and shippable. You designed it (Phase 03 and this phase), wired and
programmed it, and it maps and navigates your home on command from a browser. Its software runs from the
same Docker image in simulation and on hardware, and CI tests every change.

**Deliverables:**
- [ ] Real robot: mapping, localization and navigation between rooms, with the collision monitor active
- [ ] Web dashboard: map, click-to-go, camera, 3D model, battery and status
- [ ] Docker images for amd64 and arm64; one command to run sim or real
- [ ] Tests, including a headless simulation test, and a CI pipeline definition
- [ ] Published CAD files, bill of materials and wiring diagram
- [ ] 🌶️ The SO-101 mounted on the base and driven by MoveIt: a real mobile manipulator for Phases 09–10
- [ ] A demo video and a README that someone else could follow to build their own

**Skills used:** every phase so far. **Evidence:** video, success rate over 10 navigation goals in your home, CI run.

---

## ✅ Gate

- [ ] Explain your robot's power system, including what the fuse and the kill switch protect against
- [ ] Show a step response of your wheel-speed loop and explain how you tuned it
- [ ] Your hardware interface drives real motors through your own protocol, with a working watchdog
- [ ] The URDF matches the real robot within a centimetre, verified with a tape measure
- [ ] Rover-1 navigates between rooms of your home, and you can explain three sim-to-real differences you fixed
- [ ] The same Docker image runs the robot in simulation and on hardware
- [ ] Tests pass locally, and the CI pipeline is written

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md   <->   codes/Week_1/Saturday/
theory/Phase_Project.md     <->   codes/Phase_Project/   (most real code lives in ../my_robot/)
```

Lessons are generated one day at a time; ask for **"P08·W1·D1"**.

## Resources

- Scherz & Monk, *Practical Electronics for Inventors*; Platt, *Make: Electronics* (hands-on)
- [micro-ROS documentation](https://micro.ros.org/) and [micro_ros_platformio](https://github.com/micro-ROS/micro_ros_platformio)
- [ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/) docs on LEDC (PWM) and PCNT (pulse counting)
- [rosbridge_suite](https://github.com/RobotWebTools/rosbridge_suite) and [roslibjs](https://github.com/RobotWebTools/roslibjs)
- [ros-tooling/action-ros-ci](https://github.com/ros-tooling/action-ros-ci)
- Articulated Robotics (YouTube), the mobile-robot build series; Josh Newans's write-ups are the best match for this phase
