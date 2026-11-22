# 00 — Launchpad: Lab, Linux, Python, Git, Math

> **Week:** Week 0 (one week) · **Load:** ~15–18 h
> **Masterclass:** the stated prerequisites (basic Linux, Python 3, high-school math) plus Phase 1's "Git and GitHub"
> **Saturday build:** 🔨 **Turtle Artist** + your own lab check
> **Map:** [../README.md](../README.md) · **Lab reference:** [../SETUP.md](../SETUP.md)

This week has one job: make every later week possible. By Sunday you have a robotics lab you trust (ROS 2
Jazzy and Gazebo Harmonic in WSL2, rendering on your RTX GPU, with a workspace and sync scripts), and you
have refreshed the four things every robotics course assumes you already know: the Linux shell, Python,
Git, and the math of "where is that point relative to me?"

**Do not move on until `check_lab.sh` passes and you have driven a turtle with your own code.**

## Can I Start Here?

Everyone starts here. If you are impatient, **Day 1 and the Saturday lab check are the non-negotiable
minimum**; Days 2–5 can be back-filled later from the [Catch-up Ledger](../README.md#catch-up-ledger).

## After This Week, You Can

- [ ] Run ROS 2 Jazzy, RViz2 and Gazebo Harmonic in WSL2, rendering on the NVIDIA GPU
- [ ] Explain what `source /opt/ros/jazzy/setup.bash` changes in your shell, and why forgetting it breaks everything
- [ ] Move code between the Windows repo and WSL with `rpull` / `rpush`, and build one day's code with `rb`
- [ ] Use the shell, processes, environment variables, devices and `ssh` comfortably
- [ ] Write Python classes with callbacks, and NumPy code that simulates a moving robot
- [ ] Work with Git branches and pull requests, and pull many repos into a workspace with `vcs import`
- [ ] Transform a point seen by a sensor into the world frame, by hand

## Software and Hardware

Everything is installed by [SETUP.md](../SETUP.md) Steps 1–6. No hardware.

---

## Week 0 — Plan

### Day 1 — The Lab: WSL2, ROS 2 Jazzy, Gazebo Harmonic
- [ ] Create a **dedicated** WSL2 distro for robotics (`Ubuntu-24.04`), separate from the kernel lab. Your existing `Ubuntu` distro runs 26.04, which has no ROS 2 Jazzy packages, and ROS installs hundreds of packages you do not want next to your kernel toolchain anyway
- [ ] Review `%USERPROFILE%\.wslconfig` (shared with the kernel lab): memory, processors, swap
- [ ] Put WSLg on the RTX GPU instead of the Intel iGPU: `glxinfo -B`, `MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA`
- [ ] Install ROS 2 Jazzy (`ros-jazzy-desktop` + `ros-dev-tools`), initialise `rosdep`, source Jazzy in `~/.bashrc`
- [ ] Install Gazebo Harmonic with `ros-jazzy-ros-gz`; run `gz sim shapes.sdf`
- [ ] Smoke tests: C++ talker → Python listener, `turtlesim` + teleop, `rviz2`, `ros2 doctor`
- [ ] Bootstrap the working copy (`setup/sync_from_repo.sh`) and run `setup/check_lab.sh`
- [ ] **Journal:** the GPU renderer string, versions that worked, every error and its fix

### Day 2 — Linux for Robotics
- [ ] Shell fluency: paths, pipes, redirection, `grep`/`find`/`rg`, globbing, job control, `history`
- [ ] Environment: variables, `export`, `source` vs running a script, `~/.bashrc`; exactly what `install/setup.bash` adds to `PATH`, `AMENT_PREFIX_PATH`, `PYTHONPATH` and `LD_LIBRARY_PATH`
- [ ] Processes: `ps`, `htop`, signals (why Ctrl-C shuts a node down cleanly and `kill -9` does not), `systemd` units (you will autostart your robot with one in Phase 08)
- [ ] Devices and permissions: `/dev/ttyUSB*` and `/dev/ttyACM*`, the `dialout` group, `udev` rules for stable names; preview of plugging in a lidar
- [ ] Working on a robot with no screen: `ssh` with keys, `scp`/`rsync`, `tmux`
- [ ] **Code:** `robot_env.sh`, which prints every ROS-related environment variable and warns about the classic mistakes (Jazzy not sourced, domain ID 0, workspace sourced twice)

### Day 3 — Python for Robotics
- [ ] Python 3.12 on Ubuntu 24.04: system Python, PEP 668, and why ROS uses `apt install python3-*`; a venv with `--system-site-packages` when you need extras
- [ ] Classes, inheritance, `super()`, dataclasses, type hints: every `rclpy` node is a class
- [ ] Callbacks, closures and lambdas: every `rclpy` subscription is a callback
- [ ] NumPy essentials (arrays, broadcasting, vectorised math) and Matplotlib plots
- [ ] One paragraph on threads: why a callback that blocks freezes the whole node (preview of executors)
- [ ] **Code:** simulate a robot driving with constant speed and turn rate in NumPy, plot its path, then add noise and watch the path drift — your first motion model

### Day 4 — Git and GitHub the Robotics-Team Way
- [ ] Branches, commits, `rebase` vs `merge`, resolving a conflict, `git log --graph --oneline`
- [ ] Pull-request workflow: feature branch → push → PR → review → squash-merge
- [ ] Robotics specifics: `.gitignore` for colcon (`build/ install/ log/`), never committing bags, datasets or weights, Git LFS for meshes and maps, `vcstool` and `.repos` files for multi-repo workspaces
- [ ] Practise on a scratch repo (your Robotics repo is yours to initialise; see [Repo Layout](../README.md#repo-layout))
- [ ] **Code:** a `.repos` file that pulls two public ROS 2 example repositories into a scratch workspace with `vcs import`, then builds them

### Day 5 — Math Warm-up: "Where Is That Point?"
- [ ] Vectors, dot and cross product, norms; radians; `atan2` and why plain `atan` is a bug
- [ ] Matrices as transformations: the 2D rotation matrix; rotation followed by translation
- [ ] Rates and accumulation: derivative = velocity, integral = position (odometry *is* an integral)
- [ ] The probability you need on the first day of state estimation: mean, variance, the Gaussian, noise
- [ ] **Code:** a lidar on a robot at (3, 1) facing 45° sees an obstacle 2 m away at 30° to its left. Compute the obstacle's world position by hand, then in NumPy. This is your first TF problem

### 🔨 Saturday — Turtle Artist + Lab Check
- [ ] A Python node that makes `turtlesim` draw something you choose (a spirograph, your initials, a robot) using `/turtle1/cmd_vel` and the `teleport_absolute` and `set_pen` services
- [ ] Size and colour as parameters; one launch file starts `turtlesim` and your node
- [ ] Add one check of your own to `setup/check_lab.sh`, then make it fail on purpose to prove it works
- [ ] Record a GIF of the drawing: the first entry in `journal/media/`

### 📄 Sunday
- [ ] ROS 2 docs: [Concepts → Basic](https://docs.ros.org/en/jazzy/Concepts/Basic.html), every page
- [ ] [REP-103](https://www.ros.org/reps/rep-0103.html) (units and coordinate conventions) and [REP-105](https://www.ros.org/reps/rep-0105.html) (`map` / `odom` / `base_link`). You will lean on these for six months
- [ ] Re-read the [Phase Map](../README.md#phase-map) and choose your entry path

---

## ✅ Gate

- [ ] `bash ~/Robotics/setup/check_lab.sh` exits 0
- [ ] Gazebo renders on the NVIDIA GPU (the renderer string names NVIDIA, not llvmpipe or Intel)
- [ ] You can explain underlay, overlay and what `source install/setup.bash` does
- [ ] Turtle Artist starts from one launch command
- [ ] You have written your entry path (A–E) in the journal

## This Folder

```text
theory/Week_0/Day_1.md      <->   codes/Week_0/Day_1/
theory/Week_0/Saturday.md   <->   codes/Week_0/Saturday/
```

Lessons are generated one day at a time when you reach that day. Ask for **"P00·W0·D1"**; see
[How the Daily Notes Work](../README.md#daily-notes).

## Resources

- [ROS 2 Jazzy installation (Ubuntu, deb packages)](https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html): the source of truth if anything in SETUP.md drifts
- [Gazebo + ROS installation guide](https://gazebosim.org/docs/latest/ros_installation/)
- The Construct's free *Linux for Robotics* and *Python 3 for Robotics* courses, if Day 2 or 3 feels thin
- [Pro Git](https://git-scm.com/book/en/v2), chapters 2–3 (free)
- 3Blue1Brown, *Essence of Linear Algebra*, episodes 1–4 (YouTube)
