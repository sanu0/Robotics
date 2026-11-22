# 01 — Modern C++ for Robotics

> **Where it sits:** Month 1 · Weeks 1–3, then Buffer Week 4 for the monthly projects
> **The plan (tick boxes there):** [Week 1](../README.md#week-1) · [Week 2](../README.md#week-2) · [Week 3](../README.md#week-3) · [✅ Phase 01 gate](../README.md#gate-01) · [🔄 Buffer Week 4](../README.md#buffer-1)
> **Projects:** 🔨 OdomCalc (Week 1) · 🔨 GridPlanner v0.1 (Week 2) · 🔨 MiniROS v0.1 (Week 3) · 🏆 [MiniROS](../README.md#m1-project-a) and [GridPlanner Bench](../README.md#m1-project-b) (Month 1 Projects A and B)
> **Toolchain:** GCC 13 with C++20 · CMake 3.28 · GoogleTest · Eigen 3.4, all from Ubuntu 24.04's apt
> **Map:** [../README.md](../README.md)

Nav2, MoveIt 2, ros2_control, Gazebo and most of Isaac ROS are written in C++. Python gets a robot moving
quickly; C++ is what you need to write a Nav2 planner plugin, a ros2_control hardware interface that talks to
motors hundreds of times a second, or a perception node that does not drop frames.

This phase gets you there in three weeks by leaning on what you already know. You write C every week on the
kernel track and you are learning Rust, so each new idea appears next to its C and Rust equivalent: RAII next
to `Drop`, `unique_ptr` next to `Box`, references next to borrows (and the checks C++ does not do for you).

It ends with something unusual: you build a miniature ROS 2 core (typed topics, callbacks, executors,
zero-copy hand-off) **before** you learn ROS 2 properly. When you meet `rclcpp` in Month 2, its design reads
like a list of decisions you already had to make yourself.

## Can I Start Here?

| | |
|---|---|
| **Must have** | Week 0 (the lab, `g++`, `cmake`) |
| **Nice to have** | Nothing: this phase needs no ROS |
| **Run in parallel with** | Weeks 5–7's Python track ([Path C](../README.md#entry-paths)): ROS on Mon/Wed/Fri, C++ on Tue/Thu |
| **If you postpone it** | Month 2's ⚙️ blocks, Week 10 Day 4 (Gazebo plugin), Week 13 Days 3–4 (Nav2 plugins) and all of Week 14 wait for you. Log them in the [Catch-up Ledger](../README.md#catch-up-ledger) |

## What You Will Be Able To Do

- Write, build and debug multi-file C++20 programs with CMake, warnings as errors and sanitizers on
- Design classes with RAII and correct copy/move behaviour, and map each idea to Rust ownership
- Use smart pointers deliberately, and explain why ROS 2 hands you `SharedPtr` and `UniquePtr` everywhere
- Use STL containers and algorithms fluently, including `priority_queue` for planners
- Write lambdas, callbacks, templates and C++20 concepts, the vocabulary of every ROS 2 API
- Write thread-safe code that is clean under ThreadSanitizer, and measure a control loop's jitter
- Use Eigen for rotations, quaternions and rigid transforms
- Test with GoogleTest and keep code tidy with clang-format and clang-tidy

## Software

```bash
sudo apt install -y build-essential cmake ninja-build gdb clangd clang-format clang-tidy \
  libgtest-dev libgmock-dev libeigen3-dev ccache valgrind
```

No hardware.

## This Folder

```text
theory/Week_1/Day_1.md                <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md             <->   codes/Week_1/Saturday/
theory/Projects/MiniROS.md            <->   codes/Projects/MiniROS/
theory/Projects/GridPlannerBench.md   <->   codes/Projects/GridPlannerBench/
```

Lessons are generated one day at a time, when you reach that day: ask for **"M1W1D1"**, and for the projects
**"M1 Project A"** / **"M1 Project B"**. See [How the daily notes work](../README.md#daily-notes).

## Resources

- *A Tour of C++*, 3rd ed. (Stroustrup): the fastest complete overview of modern C++
- *Effective Modern C++* (Meyers): still the best book on move semantics, smart pointers and lambdas
- *C++ Concurrency in Action*, 2nd ed. (Williams): chapters 2–5 for Week 3
- [cppreference.com](https://en.cppreference.com/) and [learncpp.com](https://www.learncpp.com/) (free)
- [Eigen documentation: Geometry module](https://eigen.tuxfamily.org/dox/group__Geometry__Module.html)
- *Building Low Latency Applications with C++* (in your `HFT/` folder): its latency-measurement and lock-free chapters pair with Week 3
