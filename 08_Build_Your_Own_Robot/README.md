# 08 — Build Your Own Robot: Electronics, Firmware, Mechanics, and Shipping Software

> **Where it sits:** Month 6 · Weeks 21–22
> **The plan (tick boxes there):** [Week 21](../README.md#week-21) · [Week 22](../README.md#week-22) · [✅ Phase 08 gate](../README.md#gate-08)
> **Projects:** 🔨 Wheel Module (Week 21) · 🔨 First Autonomous Run (Week 22) · feeds the 🎖 [Magnum Opus](../README.md#magnum-opus)
> **Stack:** ESP32 + MotorBridge / micro-ROS · ros2_control · Raspberry Pi 5 or Jetson Orin Nano Super · RPLIDAR · Onshape/Fusion · rosbridge · Docker · GitHub Actions
> **Hardware:** this phase needs it. See [HARDWARE.md](../HARDWARE.md) and order by **Mar 15**
> **Map:** [../README.md](../README.md)

This is where you stop simulating and start building. You **design** the robot you modelled in Week 9, wire
its electronics, write its firmware, print or cut its chassis, bring up its computer, and run the same Nav2
stack on it that you tuned in simulation. Then you ship its software properly: Docker images that run the same
in simulation and on hardware, a browser dashboard, tests and CI.

Week 21 is electrons: power, batteries, microcontrollers, motors and encoders, firmware (MotorBridge on a real
ESP32), and CAD. Week 22 is atoms to autonomy: assembly, bring-up, calibration, real-world SLAM and Nav2, and
shipping.

> **Safety first, every session.** Read the [Safety Rules](../README.md#safety) before you connect a battery.
> Wheels off the ground for every first test; a fuse and a physical power switch on every robot; never leave
> a lithium battery charging unattended.

## Can I Start Here?

| | |
|---|---|
| **Must have** | Weeks 9–10 (your URDF), Weeks 11 and 13 (Nav2 configuration), Week 14 (your hardware interface and protocol) |
| **Can start any time** | Week 21 Days 1–3 (electronics, microcontrollers, motors) need no ROS. Do them on Saturdays from Month 3 if your parts arrive early ([Path D](../README.md#entry-paths)) |
| **Buying a ready-made kit instead?** | A ROS 2 kit such as The Construct's FastBot (€489) works: skip Week 21 Day 5 and Week 22 Day 1 (CAD and fabrication), keep the rest |
| **No hardware at all?** | See "If the hardware never arrives" in [HARDWARE.md](../HARDWARE.md): Week 22's software parts still work against Gazebo |

## What You Will Be Able To Do

- Power a robot safely: batteries, protection, regulation, fusing, wiring, and a power budget
- Program a microcontroller with interrupts, PWM, timers and I2C/UART/SPI
- Close a wheel-speed loop on a microcontroller and plot its step response
- Drive real motors from ros2_control through your own protocol, with a watchdog (or use micro-ROS)
- Design a chassis in CAD and fabricate it
- Bring up a robot computer: Ubuntu, ROS 2, networking, udev rules, autostart with systemd
- Calibrate odometry and sensors, and make the URDF match the real robot
- Run SLAM and Nav2 on real hardware and debug the gap between simulation and reality
- Ship robot software as multi-architecture Docker images with a dashboard, tests and CI

## Hardware

Tier 3 (electronics kit) for Week 21; Tier 4 (Rover-1's parts) for Week 22; Tier 5 (the SO-101) if you want
the arm on board for the Magnum Opus. Lists, prices, order-by dates and Indian suppliers:
[HARDWARE.md](../HARDWARE.md).

## Software

```bash
# Laptop (WSL)
sudo apt install -y ros-jazzy-rosbridge-suite ros-jazzy-web-video-server ros-jazzy-usb-cam
# Robot computer: Ubuntu 24.04 + ros-jazzy-ros-base (or JetPack 7.2 + ROS 2 Jazzy on a Jetson)
# Firmware: PlatformIO (Cursor extension or CLI); micro_ros_platformio set to jazzy if you use micro-ROS
# micro-ROS agent: docker run -it --rm --net=host -v /dev:/dev --privileged microros/micro-ros-agent:jazzy serial --dev /dev/ttyUSB0
```

USB devices reach WSL through `usbipd-win`, and a real robot on Wi-Fi needs WSL's mirrored networking or
Zenoh: SETUP.md Steps 12–13.

## This Folder

```text
theory/Week_21/Day_1.md       <->   codes/Week_21/Day_1/
theory/Week_22/Saturday.md    <->   codes/Week_22/Saturday/
```

Most of the real code lives in [`../my_robot/`](../my_robot/README.md): `<name>_firmware`, `<name>_bringup`,
`<name>_web`, Dockerfiles and CI. Lessons are generated one day at a time: ask for **"M6W21D1"**.

## Resources

- Scherz & Monk, *Practical Electronics for Inventors*; Platt, *Make: Electronics* (hands-on)
- [micro-ROS documentation](https://micro.ros.org/) and [micro_ros_platformio](https://github.com/micro-ROS/micro_ros_platformio)
- [ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/) docs on LEDC (PWM) and PCNT (pulse counting)
- [rosbridge_suite](https://github.com/RobotWebTools/rosbridge_suite) and [roslibjs](https://github.com/RobotWebTools/roslibjs)
- [ros-tooling/action-ros-ci](https://github.com/ros-tooling/action-ros-ci)
- Articulated Robotics (YouTube), the mobile-robot build series
