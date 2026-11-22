# 00 — Launchpad: Lab, Linux, Python, Git, Math

> **Where it sits:** Month 1 · Week 0
> **The plan (tick boxes there):** [Week 0](../README.md#week-0) · [✅ Phase 00 gate](../README.md#gate-00)
> **Project:** 🔨 Turtle Artist + your own lab check (Week 0 Saturday)
> **Lab reference:** [../SETUP.md](../SETUP.md) · **Map:** [../README.md](../README.md)

This week has one job: make every later week possible. By Sunday you have a robotics lab you trust (ROS 2
Jazzy and Gazebo Harmonic in a dedicated WSL2 distro, rendering on your RTX GPU, with a workspace and sync
scripts), and you have refreshed the four things every robotics course assumes you already know: the Linux
shell, Python, Git, and the math of "where is that point relative to me?"

**Do not move on until `check_lab.sh` passes and you have driven a turtle with your own code.**

## Can I Start Here?

Everyone starts here. If you are impatient, **Day 1 and the Saturday lab check are the non-negotiable
minimum**; Days 2–5 can be back-filled later from the [Catch-up Ledger](../README.md#catch-up-ledger).

## What You Will Be Able To Do

- Run ROS 2 Jazzy, RViz2 and Gazebo Harmonic in WSL2, rendering on the NVIDIA GPU
- Explain what `source /opt/ros/jazzy/setup.bash` changes in your shell, and why forgetting it breaks everything
- Move code between the Windows repo and WSL with `rpull` / `rpush`, and build one folder with `rb`
- Use the shell, processes, environment variables, devices and `ssh` comfortably
- Write Python classes with callbacks, and NumPy code that simulates a moving robot
- Work with Git branches and pull requests, and pull many repositories into a workspace with `vcs import`
- Transform a point seen by a sensor into the world frame, by hand

## Software and Hardware

Everything is installed by [SETUP.md](../SETUP.md) Steps 1–6. No hardware.

## This Folder

```text
theory/Week_0/Day_1.md      <->   codes/Week_0/Day_1/
theory/Week_0/Saturday.md   <->   codes/Week_0/Saturday/
```

Lessons are generated one day at a time, when you reach that day: ask for **"M1W0D1"**. See
[How the daily notes work](../README.md#daily-notes).

## Resources

- [ROS 2 Jazzy installation (Ubuntu, deb packages)](https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html): the source of truth if anything in SETUP.md drifts
- [Gazebo + ROS installation guide](https://gazebosim.org/docs/latest/ros_installation/)
- [Pro Git](https://git-scm.com/book/en/v2), chapters 2–3 (free)
- 3Blue1Brown, *Essence of Linear Algebra*, episodes 1–4 (YouTube)
- The Construct's free *Linux for Robotics* and *Python 3 for Robotics* courses, if Day 2 or 3 feels thin
