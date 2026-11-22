# HARDWARE — What to Buy, When, and Why

> **Rule zero:** about 70% of this roadmap needs no hardware at all. Phases 00–07 run entirely in simulation.
> Buy hardware when a phase needs it, except for long-lead items, which you order early enough that customs
> and shipping cannot stall you.
>
> **Prices:** US list prices checked in November 2026 where marked ✓; others are typical ranges. The INR
> column is a rough guide: shipping and import duty usually make Indian retail 10–40% higher than US list.
> Memory shortages pushed computer-board prices up sharply in 2025–26, so check before ordering.

---

## Contents

- [The Short Version](#the-short-version)
- [Your Laptop: What It Can and Cannot Do](#your-laptop-what-it-can-and-cannot-do)
- [Tier 1 — Electronics Starter Kit (Phase 08 Week 1)](#tier-1--electronics-starter-kit-phase-08-week-1)
- [Tier 2 — Rover-1, Your Mobile Robot (Phase 08 Weeks 2–3)](#tier-2--rover-1-your-mobile-robot-phase-08-weeks-23)
- [Tier 3 — The Arm: LeRobot SO-101 (Phase 09 Week 2)](#tier-3--the-arm-lerobot-so-101-phase-09-week-2)
- [Tier 4 — Upgrades Worth Having](#tier-4--upgrades-worth-having)
- [Tools for the Bench](#tools-for-the-bench)
- [Cloud GPU Time](#cloud-gpu-time)
- [Where to Buy in India](#where-to-buy-in-india)
- [Order Timeline](#order-timeline)
- [Safety](#safety)
- [If the Hardware Never Arrives](#if-the-hardware-never-arrives)
- [Budget Summary](#budget-summary)

---

## The Short Version

| Tier | What | First needed | Order by (Path A) | ≈ Cost |
|---|---|---|---|---|
| 0 | Your laptop | Week 0 | — | ₹0 |
| — | Gamepad (optional, makes teleop pleasant) | Phase 03 (Week 7) | Dec 31, 2026 | ₹2–5k |
| 1 | Electronics starter kit + bench tools | Phase 08 W1 (Week 19) | **Feb 15, 2027** | ₹8–14k |
| 2 | Rover-1: computer, lidar, motors, battery, chassis | Phase 08 W2 (Week 20) | **Mar 1, 2027** | ₹35–45k (Pi 5) / ₹60–75k (Jetson) |
| 3 | SO-101 arm, leader + follower | Phase 09 W2 (Week 23) | **Mar 15, 2027** (Jan 15 if you want it for Phase 05) | ₹28–40k |
| 4 | Depth camera, Jetson, 3D printer, logic analyser | Optional | as wanted | ₹10–60k |
| ☁️ | Cloud RTX GPU hours for Isaac Sim and VLA fine-tuning | Phase 09 (Week 22) | set up an account by Apr 26 | $30–80 total |

**Realistic total for Tiers 1–3 plus tools: about ₹75k–1.2 lakh.** You can spread it across four months,
and nothing needs buying before February.

---

## Your Laptop: What It Can and Cannot Do

Windows 11 · Intel Core Ultra · 31.5 GB RAM · NVIDIA RTX 1000 Ada Laptop GPU (6 GB VRAM)

| Workload | Verdict | Notes |
|---|---|---|
| ROS 2, RViz2, Gazebo Harmonic in WSL2 | ✅ | Make WSLg use the NVIDIA GPU (SETUP.md Step 2) |
| Nav2, MoveIt 2, ros2_control, slam_toolbox | ✅ | Mostly CPU-bound; fine |
| YOLO training and TensorRT inference | ✅ | Small models and datasets |
| PyTorch: behaviour cloning, ACT training | ✅ | Small batches; or a cloud GPU to go faster |
| Isaac Lab 3.0 (Newton backend, headless) | ✅ | Needs a Turing-or-newer GPU (yours is Ada); use fewer parallel environments |
| Isaac ROS on x86 | ⚠️ | Officially an Ampere-or-newer GPU with 8 GB; 6 GB is best-effort. The Jetson is the real target |
| **Isaac Sim 6.2** | ❌ | Needs an RTX GPU with **16 GB** VRAM and 32 GB RAM: use a cloud RTX instance |
| VLA fine-tuning (SmolVLA, π0) | ❌ | Needs 16–24 GB+: cloud GPU |
| USB serial (ESP32, lidar, servo boards) into WSL | ✅ | `usbipd-win` (SETUP.md Step 12) |
| USB webcams into WSL | ⚠️ | WSL's default kernel lacks UVC drivers: use the robot computer for real cameras |
| Talking to a robot on Wi-Fi | ⚠️ | Mirrored networking or Zenoh (SETUP.md Step 13); corporate IT policy may limit this |

> **Plan B for a locked-down corporate laptop:** a used mini PC or laptop running native Ubuntu 24.04
> (roughly ₹15–25k second-hand) makes a perfect dedicated robotics machine: no WSL networking or USB
> passthrough to fight with.

---

## Tier 1 — Electronics Starter Kit (Phase 08 Week 1)

Cheap, fun, and useful long before Phase 08 if you want to tinker on weekends ([Path D](README.md#entry-paths)).

| Part | Recommended | Why | ≈ USD | ≈ INR |
|---|---|---|---|---|
| Microcontroller | ESP32 DevKit (or ESP32-S3 DevKitC) ×2 | Officially supported by micro-ROS for Jazzy ✓; Wi-Fi; one spare | $6–15 each | ₹500–1,500 |
| Motor driver | TB6612FNG module (small motors) or Cytron MDD3A | Clean PWM control of two DC motors | $4–12 | ₹300–1,000 |
| Gear motors with encoders | 2 × N20 or JGB37-520 with Hall encoders | Real closed-loop practice; the JGB37 pair can become Rover-1's drive | $10–15 each | ₹800–1,500 each |
| IMU | ICM-20948 or BNO085 breakout (MPU-6050 if on a tight budget) | I2C practice; the BNO085 does sensor fusion on-chip | $3–25 | ₹200–3,000 |
| Current sensor | INA219 breakout | Battery and motor current telemetry | $3–5 | ₹200–400 |
| Power for the bench | 2S/3S battery or a 12 V adapter + a buck converter | Run motors without the robot | $10–20 | ₹800–1,800 |
| Prototyping | Breadboard, jumper wires, perfboard, header pins, JST connectors, heat-shrink | — | $15 | ₹800–1,500 |

---

## Tier 2 — Rover-1, Your Mobile Robot (Phase 08 Weeks 2–3)

The robot you design in Phase 03 and build in Phase 08: a FastBot-class differential-drive robot, but your
own design, with better parts where it matters (an ESP32 instead of an Arduino Nano, a modern lidar, an IMU,
proper power protection).

| Part | Recommended | Alternatives | Why | ≈ USD | ≈ INR |
|---|---|---|---|---|---|
| Robot computer | **Raspberry Pi 5, 4 or 8 GB** ✓ ($110 / $175) + active cooler | **Jetson Orin Nano Super** ✓ ($399) | Pi 5 runs Ubuntu 24.04 + Jazzy, SLAM and Nav2 well. Jetson adds CUDA, Isaac ROS and on-board AI | $115–180 / $399 | ₹12–20k / ₹38–48k |
| Storage | 64 GB A2 microSD | NVMe HAT + SSD (Pi), NVMe SSD (Jetson, 128 GB+ for Isaac ROS) | Bags and logs need space | $10–40 | ₹700–4,000 |
| Lidar | **RPLIDAR C1** ✓ | LD19 ✓ (better in sunlight) | 360°, 12 m, solid ROS 2 Jazzy drivers | $72–79 / ~$70 | ₹7–10k |
| Microcontroller | ESP32 (from Tier 1) | — | Motor control, encoders, IMU, watchdog | — | — |
| Drive motors | 2 × JGB37-520 12 V with Hall encoders | Pololu metal gearmotors (pricier, better) | Size them with your Phase 06 calculator | $10–15 each | ₹800–1,500 each |
| Motor driver | Cytron MDD3A or MDD10A | TB6612FNG for small motors only | Handles the motors' stall current | $8–25 | ₹700–2,500 |
| Wheels + caster | 65–85 mm wheels with hubs; one ball caster | — | — | $10–15 | ₹500–1,200 |
| IMU | BNO085 or ICM-20948 (Tier 1) | — | Fused with wheel odometry | — | — |
| Camera | USB webcam (Logitech C270/C920 class) | Raspberry Pi Camera Module 3 | Perception on the robot; USB is the easy path on Ubuntu | $20–70 | ₹1,500–6,000 |
| Battery | 3S (11.1 V) LiPo 2,200 mAh, or a 3S 18650 pack with BMS | 4S for more torque | Powers motors directly; computer through a regulator | $15–30 | ₹1,500–3,000 |
| Charger | Balance charger (ISDT, ToolkitRC class) + LiPo safety bag | — | Never charge LiPo without balance and supervision | $40–70 | ₹3,500–7,000 |
| Regulation | 5 V / 5 A buck converter rated for continuous current | Pololu 5 V 5 A regulator | A Pi 5 browns out on weak converters | $8–20 | ₹600–1,800 |
| Protection | Inline fuse + holder, rocker switch (or a proper e-stop), XT60 connectors | — | A short without a fuse is a fire | $10 | ₹500–1,000 |
| Chassis | 3D-printed PLA/PETG plates (your CAD) | Laser-cut acrylic or aluminium; a printing service | Your design, your mounts | $10–40 | ₹1,000–4,000 |
| Hardware | M2.5/M3 standoffs, screws, nuts, heat-set inserts | — | — | $10 | ₹500–1,000 |

**Rover-1 total:** about **$400 (≈ ₹35–45k)** with a Pi 5, or **$690 (≈ ₹60–75k)** with a Jetson Orin Nano
Super, before tools.

**Pi 5 or Jetson?** If you will add the SO-101 and run learned policies, cameras and Isaac ROS on the robot,
buy the Jetson. If the robot mainly navigates and heavy AI runs on your laptop, the Pi 5 is enough. You can
start with a Pi and add a Jetson later; the ROS 2 software is identical.

**Prefer a ready-made kit?** The Construct's **FastBot** ✓ (€489 + shipping + duties) is the masterclass's own
robot: Raspberry Pi 4 (2 GB), LSLiDAR N10, Pi camera, two 12 V encoder motors, L298N driver, Arduino Nano,
3S LiPo and charger. It saves design time and matches the masterclass labs, but you skip the electronics and
mechanical design that Phase 08 teaches. Other ROS 2 kits (Waveshare, Yahboom, Hiwonder) exist at similar
prices; check for ROS 2 Jazzy support before buying.

---

## Tier 3 — The Arm: LeRobot SO-101 (Phase 09 Week 2)

The open-source arm Hugging Face's LeRobot is built around. A **leader** arm you move by hand and a
**follower** that copies it is the standard way to collect demonstrations for imitation learning.

| Option | What you get | ≈ USD ✓ | ≈ INR (incl. shipping/duty) |
|---|---|---|---|
| Servo kit, leader + follower | 12 Feetech STS3215 servos, 2 driver boards, power supplies; print the frame yourself | $237–250 + $30 printed frame | ₹28–35k |
| Assembled leader + follower + 1 camera | Ready in under an hour | $284–299 | ₹32–40k |
| Imitation Learning Kit | Assembled arms, 2 cameras, third-person mount | $349 | ₹38–45k |
| Follower only (from the open BOM) | 6 servos, 1 board; drive it from code, no teleoperation | ~$122–150 | ₹14–20k |

**Buy the leader + follower pair** if you want imitation learning (you do). Mounted on Rover-1 it makes a real
mobile manipulator for the capstone. Order it by **January 15** instead if you want to run MoveIt on the
real arm during Phase 05.

---

## Tier 4 — Upgrades Worth Having

| Upgrade | Why | ≈ Cost |
|---|---|---|
| **Depth camera**: Luxonis OAK-D Lite, Intel RealSense D435i, or Orbbec Gemini | Real 3D perception and grasping (Phase 07 Week 2 on hardware, capstone) | $150–450 |
| **Jetson Orin Nano Super** ✓ (if Rover-1 has a Pi) | Isaac ROS, TensorRT and learned policies on the robot | $399 |
| **3D printer** (Bambu Lab A1 mini / A1 class) | Iterate chassis designs in hours instead of days | $250–450 |
| **Logic analyser** (8-channel, 24 MHz) | See I2C/UART/PWM signals when firmware misbehaves | $10–15 |
| **Bench power supply** (30 V / 5 A, current-limited) | Safe first power-up of anything new | ₹4–8k |
| **Gamepad** (Xbox, PlayStation or 8BitDo) | Teleop from Phase 03 onward with `teleop_twist_joy` | ₹2–5k |

---

## Tools for the Bench

| Tool | Notes | ≈ INR |
|---|---|---|
| Temperature-controlled soldering iron | Pinecil-class, or a good local station | ₹1,500–4,000 |
| Auto-ranging multimeter | You will use it every hardware day | ₹1,000–2,500 |
| Wire strippers, flush cutters, small pliers | — | ₹600–1,500 |
| Crimper for JST/Dupont connectors | Makes reliable connectors instead of fragile jumpers | ₹1,000–2,000 |
| Digital calipers | Measure parts for CAD and the URDF | ₹800–1,500 |
| Precision screwdriver set, hex keys | The SO-101 needs Phillips #0 and #1 | ₹500–1,500 |
| Heat-shrink kit, solder, flux, helping hands, hot-glue gun | — | ₹1,000–2,000 |

---

## Cloud GPU Time

| Use | Instance | Rough cost |
|---|---|---|
| Isaac Sim 6.2 (Phase 09 Week 1 Day 5) | An RTX-class GPU: L4, L40S, A10G, RTX 6000 Ada. **Not A100/H100** (no RT cores; unsupported) | $1–3 per hour; a day of work ≈ $10–25 |
| SmolVLA fine-tuning (Phase 09 Week 3 Day 2) | Any 24 GB+ GPU | a few hours ≈ $5–20 |
| Faster ACT training (optional) | Any modern GPU | ≈ $2–10 |

Providers: NVIDIA Brev, AWS, Azure, GCP, and GPU marketplaces. **Stop instances when you finish.**

---

## Where to Buy in India

- **Robotics and maker stores:** Robu.in, Robocraze, ThinkRobotics, Evelta (genuine components), Amazon.in
- **Raspberry Pi:** the approved resellers listed on raspberrypi.com for India
- **Jetson:** NVIDIA's distributor list for India on developer.nvidia.com, and the stores above
- **Distributors (faster, pricier, genuine parts):** element14 India, DigiKey India, Mouser India
- **Import when needed:** Seeed Studio and WowRobo (SO-101), Slamtec resellers (lidar). Expect 1–4 weeks and
  customs duty; this is why the order-by dates are early

---

## Order Timeline

Dates assume you start Week 0 on **November 23, 2026** and follow Path A. Shift them if your path differs.

| Order by | What | Why then |
|---|---|---|
| Dec 31, 2026 | Gamepad (optional) | Phase 03 starts Jan 11 |
| Jan 15, 2027 | SO-101 (only if you want it in Phase 05) | Phase 05 Week 2 starts Feb 15 |
| **Feb 15, 2027** | Tier 1 kit + bench tools | Phase 08 starts Apr 5; earlier tinkering is a bonus |
| **Mar 1, 2027** | Tier 2 Rover-1 parts | Needed Apr 12; leaves 4–6 weeks for imports and mistakes |
| **Mar 15, 2027** | SO-101 (Tier 3); printer or printing-service decision | Needed May 3; prints needed Apr 12 |
| Apr 26, 2027 | Cloud GPU account set up and tested | Phase 09 starts Apr 26 |

---

## Safety

Read this before the first battery touches anything. It applies to every hardware day.

**Lithium batteries**
- Charge only with a balance charger, on a non-flammable surface, in a LiPo bag, **never unattended**
- Never discharge a LiPo below about 3.3 V per cell; never use a puffed, dented or hot pack
- Store at about 3.8 V per cell; carry and store in a LiPo bag
- Every robot has a **fuse** close to the battery and a **physical switch** that cuts all power

**Electrical**
- First power-up of anything new: a current-limited bench supply, or with the motors disconnected
- Check polarity twice; a reversed battery destroys boards instantly
- Common ground between the microcontroller, the driver and the computer

**Motion**
- First test of any new motion code: **wheels off the ground**
- Speed and acceleration limits in software *and* a watchdog in firmware that stops the motors when commands stop
- Keep hands out of an arm's reach while it is powered; lower torque limits while testing new code
- An e-stop you can reach without thinking, from Phase 08 onward

**Privacy**
- Maps and camera recordings of your home are private. Keep them in `_internal/`, never in the public repo

---

## If the Hardware Never Arrives

Decide the fallback now, so a late parcel costs you a redirect, not a month.

| If you cannot get | Then | What you lose |
|---|---|---|
| **Rover-1 parts** (Phase 08) | Do Week 1 with a bench ESP32 and one motor; run your hardware interface against the fake board; do Week 3 (dashboard, Docker, tests, CI) entirely against Gazebo | Real-world navigation experience. You keep roughly 70% of the phase |
| **Any electronics at all** | Phase 08 Week 3 in simulation; Week 1 theory with an online simulator such as Wokwi for the ESP32 | Hands-on hardware; the software skills remain |
| **SO-101** (Phase 09 Week 2) | LeRobot's simulated environments and Isaac Lab's SO-101 tasks; NVIDIA's sim-to-real course still teaches the method | An honest real-world success rate |
| **Cloud GPU** | Skip the Isaac Sim day (do Isaac Lab locally with Newton); run VLA inference only, not fine-tuning | Isaac Sim hands-on |
| **Jetson** | Run Isaac ROS on the laptop where VRAM allows; skip on-robot GPU perception | On-robot acceleration |
| **3D printer** | A printing service, laser-cut acrylic, or a bought chassis | Nothing that matters |

> **The rule:** never let a missing part idle you. If Rover-1's parts are not in hand by the start of Phase 08,
> swap Phase 08 and Phase 09's Weeks 1 and 3 (which need no robot), and come back to the build when they arrive.

---

## Budget Summary

| Item | ≈ INR |
|---|---|
| Tier 1 starter kit | 3–6k |
| Bench tools (one-time) | 5–9k |
| Tier 2 Rover-1 with a Pi 5 | 35–45k |
| Tier 3 SO-101 leader + follower | 28–40k |
| Cloud GPU time | 3–7k |
| **Core total** | **≈ 75k–1.1 lakh** |
| Optional: Jetson instead of / in addition to the Pi | +25–45k |
| Optional: depth camera | +13–40k |
| Optional: 3D printer | +22–40k |
