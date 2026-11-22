# 01 — Modern C++ for Robotics

> **Weeks:** 3 (calendar Weeks 1–3 on Path A) · **Load:** ~2–2.5 h weekdays · 4 h Saturday · 1.5 h Sunday
> **Masterclass:** Phase 1, "C++ for robotics, then advanced modern C++"
> **Toolchain:** GCC 13 with C++20 · CMake 3.28 · GoogleTest · Eigen 3.4, all from Ubuntu 24.04's apt
> **Phase project:** 🏆 **MiniROS**, a tiny publish/subscribe robot middleware you write yourself
> **Map:** [../README.md](../README.md)

Nav2, MoveIt 2, ros2_control, Gazebo and most of Isaac ROS are written in C++. Python gets a robot moving
quickly; C++ is what you need to write a Nav2 planner plugin, a ros2_control hardware interface that talks
to motors hundreds of times a second, or a perception node that does not drop frames.

This phase gets you there in three weeks by leaning on what you already know. You read and write C every
week on the kernel track and you are learning Rust, so each new idea appears next to its C and Rust
equivalent: RAII next to `Drop`, `unique_ptr` next to `Box`, references next to borrows (and the checks
C++ does not do for you).

It ends with something unusual: you build a miniature ROS 2 core (typed topics, callbacks, executors,
zero-copy hand-off) **before** you learn ROS 2 properly. When you meet `rclcpp` in Phase 02, its design
will read like a list of decisions you already had to make yourself.

## Can I Start Here?

| | |
|---|---|
| **Must have** | 00 Launchpad (the lab, `g++`, `cmake`) |
| **Nice to have** | Nothing: this phase needs no ROS |
| **Run in parallel with** | 02's Python track ([Path C](../README.md#entry-paths)): ROS on Mon/Wed/Fri, C++ on Tue/Thu |
| **If you postpone it** | Phase 02's ⚙️ blocks, Phase 03's Gazebo plugin day, Phase 04's plugin days and all of Phase 05 Week 1 wait for you. Log them in the [Catch-up Ledger](../README.md#catch-up-ledger) |

## After This Phase, You Can

- [ ] Write, build and debug multi-file C++20 programs with CMake, warnings as errors and sanitizers on
- [ ] Design classes with RAII and correct copy/move behaviour, and map each idea to Rust ownership
- [ ] Use smart pointers deliberately, and explain why ROS 2 hands you `SharedPtr` and `UniquePtr` everywhere
- [ ] Use STL containers and algorithms fluently, including `priority_queue` for planners
- [ ] Write lambdas, callbacks, templates and C++20 concepts, the vocabulary of every ROS 2 API
- [ ] Write thread-safe code that is clean under ThreadSanitizer, and measure a control loop's jitter
- [ ] Use Eigen for rotations, quaternions and rigid transforms
- [ ] Test with GoogleTest and keep code tidy with clang-format and clang-tidy

## Software

```bash
sudo apt install -y build-essential cmake ninja-build gdb clangd clang-format clang-tidy \
  libgtest-dev libgmock-dev libeigen3-dev ccache valgrind
```

No hardware.

---

## Week 1 — The Core Language, the C/Rust Programmer's Way

### Day 1 — Toolchain, Build, and the Safety Net
- [ ] Compile vs link; headers vs sources; the one-definition rule; `#pragma once`
- [ ] Flags you always use: `-std=c++20 -Wall -Wextra -Wpedantic -Werror`, plus `-fsanitize=address,undefined` in debug builds, from today rather than "later"
- [ ] A minimal CMake project: `add_executable`, `target_compile_features(cxx_std_20)`, `target_compile_options`, build types, out-of-source builds with Ninja
- [ ] Editor setup: clangd + `compile_commands.json` (`CMAKE_EXPORT_COMPILE_COMMANDS=ON`) so completion and errors work in Cursor
- [ ] `gdb` in ten minutes: breakpoints, `bt`, `p`, stepping
- [ ] **Code:** `wheel_distance`, which converts encoder ticks into distance for a given wheel radius and ticks per revolution; then break it with an out-of-bounds read and watch AddressSanitizer catch it

### Day 2 — Types, References, `const`, and Vocabulary Types
- [ ] Values vs references vs pointers; `const` everywhere it fits; `constexpr`; `auto` and when it hides too much
- [ ] References vs Rust borrows: what C++ does *not* check (a dangling reference compiles)
- [ ] `enum class`, structured bindings, `std::optional`, `std::variant` + `std::visit`, `std::string_view`, `std::span`
- [ ] Integer traps robots hit: signed/unsigned comparisons, encoder counters wrapping around at `uint32_t` max
- [ ] **Code:** parse one sensor-log line (`t, left_ticks, right_ticks, imu_yaw`) into a struct, with `std::optional` for missing fields and `std::variant` for "reading or error"

### Day 3 — Classes and RAII
- [ ] Constructors (member-initialiser lists, `explicit`, delegating), destructors, class invariants
- [ ] RAII: C++'s answer to Rust's `Drop` and to the kernel's `goto err_*` ladders
- [ ] Rule of zero, three and five; `= default` and `= delete`
- [ ] Operator overloading done sensibly (`*`, `==`, `<<`); `[[nodiscard]]`
- [ ] **Code:** a `Pose2D` (x, y, θ) with `compose()`, `inverse()` and `operator*`, normalising θ into (−π, π]. This is your first transform algebra

### Day 4 — Inheritance, Polymorphism, and Plugin-Shaped Interfaces
- [ ] Virtual functions, abstract base classes, `override`, `final`, virtual destructors (and the leak when you forget one)
- [ ] vtables: the same mechanism as a C struct of function pointers and the kernel's `#[vtable]`
- [ ] Composition vs inheritance; interfaces as contracts
- [ ] Why it matters: a Nav2 planner *is* a subclass of `nav2_core::GlobalPlanner`, loaded at run time by `pluginlib`
- [ ] **Code:** a `Sensor` interface with `Lidar`, `Imu` and `WheelEncoder` implementations, polled through `std::vector<std::unique_ptr<Sensor>>`

### Day 5 — Memory, Ownership, and Move Semantics
- [ ] Stack vs heap; why raw `new`/`delete` is a smell in modern C++
- [ ] `std::unique_ptr` (≈ `Box`), `std::shared_ptr` (≈ `Arc`), `std::weak_ptr` (≈ `Weak`), `make_unique`/`make_shared`
- [ ] Move semantics: lvalues and rvalues, `std::move` (which moves nothing by itself), move constructors, copy elision
- [ ] Why ROS 2 is full of `Node::SharedPtr`, and why publishing a `std::unique_ptr<Msg>` can be zero-copy
- [ ] **Code:** an ownership drill: create a use-after-free, a double free and a leak on purpose, and read what AddressSanitizer and LeakSanitizer say about each

### 🔨 Saturday — OdomCalc
- [ ] A command-line tool that reads a CSV of encoder ticks (plus optional IMU yaw) and integrates a differential-drive robot's pose over time
- [ ] Classes `Robot`, `Pose2D`, `OdometryIntegrator`; RAII file handling; `std::optional` for missing IMU readings
- [ ] Write the trajectory as CSV and plot it with a ten-line Python script
- [ ] Generate a log for a 1 m square. Does the robot come back to the start? By how much does it miss, and why?
- [ ] CMake with warnings as errors, sanitizers on in Debug

### 📄 Sunday
- [ ] *A Tour of C++* (Stroustrup, 3rd ed.), chapters 1–6, skimming what you know from C
- [ ] [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines): section R (resource management) and C.20–C.22 (rule of zero/five)
- [ ] [learncpp.com](https://www.learncpp.com/) on move semantics, if Day 5 felt shaky

---

## Week 2 — The Standard Library, Lambdas, and Templates

### Day 1 — Containers and Complexity
- [ ] `vector`, `array`, `deque`, `map`/`unordered_map`, `set`, `priority_queue`: when each one wins
- [ ] Big-O for the operations planners and maps use; why a `vector` beats a linked list on real hardware
- [ ] Iterator invalidation: the bug class Rust's borrow checker forbids and C++ lets you write
- [ ] **Code:** an `OccupancyGrid` class backed by `std::vector<int8_t>` with world↔cell conversion, the same layout as `nav_msgs/OccupancyGrid`

### Day 2 — Algorithms, Iterators, and Ranges
- [ ] `<algorithm>`: `sort`, `find_if`, `count_if`, `transform`, `accumulate`, `minmax_element`, erase–remove
- [ ] C++20 ranges and views (`filter`, `transform`, `take`), and how close they feel to Rust iterators
- [ ] **Code:** clean a fake `LaserScan`: drop NaN, infinite and out-of-range readings, then find the closest obstacle in the front, left and right sectors

### Day 3 — Lambdas, `std::function`, and Callbacks
- [ ] Lambda syntax, captures by value and by reference, `[this]`, `mutable`, generic lambdas
- [ ] `std::function` vs templates for callbacks; what type erasure costs
- [ ] Callbacks *are* ROS 2: `create_subscription<Msg>("scan", qos, [this](Msg::ConstSharedPtr m) { ... })`
- [ ] Dangling captures: the classic callback bug
- [ ] **Code:** a tiny in-process event bus, `subscribe(topic, callback)` and `publish(topic, value)`. It is the seed of MiniROS

### Day 4 — Templates and Concepts
- [ ] Function and class templates, argument deduction, `if constexpr`
- [ ] Type traits; C++20 concepts as the nearest thing to Rust trait bounds
- [ ] Why `create_publisher<MsgT>()` is a template, and how to read a template error message without panic
- [ ] **Code:** a generic `RingBuffer<T, N>` that never allocates after construction, and a typed `Topic<T>`

### Day 5 — Errors: Exceptions, Error Codes, and `std::expected`
- [ ] Exceptions done right: RAII makes them safe; `noexcept`; what happens when one escapes a destructor or a thread
- [ ] Where ROS 2 throws (parameter declaration, invalid QoS, failed transform lookups) and where it returns codes
- [ ] `std::expected` (C++23, available in GCC 13 with `-std=c++23`): Rust's `Result`, in C++
- [ ] Real-time rule preview: no exceptions and no allocation inside a control loop
- [ ] **Code:** a robot-config loader (`key = value` files) that reports errors with `std::expected`, then a version with exceptions; compare the call sites

### 🔨 Saturday — GridPlanner
- [ ] Load a map in the PGM + YAML format Nav2's `map_server` uses (draw one in any paint program)
- [ ] Implement Dijkstra and A* (4- and 8-connected; Manhattan, Euclidean and octile heuristics) with `std::priority_queue`
- [ ] Draw the path back onto the map as an image; print nodes expanded and time taken
- [ ] Compare A* and Dijkstra on three maps, and keep this code: it becomes a real Nav2 planner plugin in Phase 04
- [ ] 🌶️ Inflate obstacles by the robot's radius before planning: your first costmap

### 📄 Sunday
- [ ] Red Blob Games: [Introduction to A*](https://www.redblobgames.com/pathfinding/a-star/introduction.html) and [Implementation of A*](https://www.redblobgames.com/pathfinding/a-star/implementation.html)
- [ ] *Effective Modern C++* (Meyers), Items 1–6 (type deduction, `auto`) and 31–34 (lambdas)

---

## Week 3 — Concurrency, Real Builds, Testing, and Eigen

### Day 1 — Threads and Synchronisation
- [ ] `std::thread`, `std::jthread` with stop tokens, `std::mutex`, `lock_guard`, `scoped_lock`, `unique_lock`, `condition_variable`
- [ ] Data races, deadlocks and lock ordering; ThreadSanitizer (`-fsanitize=thread`)
- [ ] Why ROS 2 has executors and callback groups (Phase 02 Week 3)
- [ ] **Code:** three "sensor" threads at 10, 50 and 100 Hz feed a fusion thread through a thread-safe queue; run it under TSan, break it, fix it

### Day 2 — Atomics, Clocks, and Control-Loop Timing
- [ ] `std::atomic` and memory orders on one page (you know the Rust version from the kernel track)
- [ ] `std::chrono`: `steady_clock` vs `system_clock`, a preview of ROS time vs wall time vs sim time
- [ ] Fixed-rate loops with `sleep_until`; measuring jitter (min, mean, p99, max)
- [ ] Real-time basics: no allocation, locks or I/O in the hot loop; thread priorities; what PREEMPT_RT (in mainline Linux since 6.12) changes
- [ ] **Code:** a 1 kHz loop that records its own jitter histogram, run idle and under load; save both results (your low-latency C++ book's chapter on measurement is the deep version)

### Day 3 — CMake for Real
- [ ] Targets and usage requirements: `PUBLIC`, `PRIVATE`, `INTERFACE`; libraries vs executables
- [ ] `find_package`, `FetchContent`, `install()` and `export()`; generator expressions, just enough
- [ ] How ROS 2's `ament_cmake` is ordinary CMake plus conventions (preview)
- [ ] **Code:** restructure OdomCalc and GridPlanner into a `robotcore` library, two apps and a `tests/` folder

### Day 4 — Testing and Code Quality
- [ ] GoogleTest: `TEST`, fixtures, parameterised tests; GMock in one example
- [ ] Coverage with `gcov`/`lcov`; `clang-format`; `clang-tidy` checks that catch real bugs
- [ ] ROS 2's linters (`ament_lint_auto`: cpplint, uncrustify, cppcheck), as a preview
- [ ] **Code:** tests for `Pose2D` (compose with inverse gives identity; angles wrap) and for A* (optimal on hand-made maps; fails cleanly when there is no path)

### Day 5 — Eigen: The Linear Algebra Under Every Robot
- [ ] `Vector3d`, `Matrix3d`, block operations, solving `Ax = b`
- [ ] Rotations four ways (`Matrix3d`, `AngleAxisd`, `Quaterniond`, Euler angles) and the conversions between them
- [ ] `Isometry3d` for rigid transforms; composing camera → base → map
- [ ] Traps: aliasing (`a = a * b`), fixed-size alignment, and the quaternion order trap: Eigen's constructor takes `(w, x, y, z)`, ROS messages store `(x, y, z, w)`
- [ ] **Code:** move a small point cloud from a camera frame into the map frame through two transforms, and check against values computed by hand

### 🏆 Saturday + Sunday — Phase Project: MiniROS
See the brief below. Sunday reading shrinks to one item this week:
- [ ] ROS 2 docs: [About Executors](https://docs.ros.org/en/jazzy/Concepts/Intermediate/About-Executors.html). Read it *after* MiniROS and list the decisions you made the same way

---

## 🏆 Phase Project — MiniROS: A Tiny Robot Middleware in C++

**What:** a small library with typed topics, publishers, subscriptions with callbacks, timers, nodes, a
single-threaded and a multi-threaded executor, keep-last-N queues, and zero-copy hand-off of
`std::unique_ptr` messages between nodes in the same process.

**Why it is worth a weekend:** you will spend six months inside ROS 2. Building its core once, badly and
then better, turns `rclcpp`'s design from a list of rules into trade-offs you understand: why callbacks run
on executors, why queues have depths, why some messages arrive as `SharedPtr` and others as `UniquePtr`.

**Deliverables:**
- [ ] `Topic<T>`, `Publisher<T>`, `Subscription<T>`, `Timer`, `Node`, `Executor` (single- and multi-threaded)
- [ ] Keep-last-N history per subscription, with a counter of dropped messages
- [ ] Zero-copy path: publishing a `std::unique_ptr<T>` to one subscriber moves the pointer; with several subscribers it falls back to shared ownership
- [ ] A demo wiring a fake 10 Hz lidar node, a 100 Hz IMU node, a fusion node and a logger node in one process
- [ ] Benchmarks: publish → callback latency (p50, p99) for 1 KB and 1 MB messages, copy vs zero-copy
- [ ] A GoogleTest suite, clean under ASan and TSan
- [ ] A README with an architecture diagram, your numbers, and a section called **"Decisions I expect ROS 2 made differently"**, which you check in Phase 02 Week 3

**Skills used:** every day of this phase. **Evidence:** benchmark table and sanitizer-clean test run.

---

## ✅ Gate

- [ ] A class hierarchy with smart pointers that is leak-free under LeakSanitizer
- [ ] Explain move semantics and RAII, and map each to its Rust equivalent, without notes
- [ ] A lambda-based callback API and a template container written from scratch
- [ ] Multithreaded code that is TSan-clean, and a measured jitter figure for a 1 kHz loop
- [ ] A CMake project with a library, two apps and GoogleTest tests
- [ ] Points transformed between frames with Eigen, and the quaternion-order trap explained
- [ ] MiniROS benchmarks in the journal

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md   <->   codes/Week_1/Saturday/
theory/Phase_Project.md     <->   codes/Phase_Project/MiniROS/
```

Lessons are generated one day at a time; ask for **"P01·W1·D1"**. See
[How the Daily Notes Work](../README.md#daily-notes).

## Resources

- *A Tour of C++*, 3rd ed. (Stroustrup): the fastest complete overview of modern C++
- *Effective Modern C++* (Meyers): still the best book on move semantics, smart pointers and lambdas
- *C++ Concurrency in Action*, 2nd ed. (Williams): chapters 2–5 for Week 3
- [cppreference.com](https://en.cppreference.com/) and [learncpp.com](https://www.learncpp.com/) (free)
- [Eigen documentation: Geometry module](https://eigen.tuxfamily.org/dox/group__Geometry__Module.html)
- *Building Low Latency Applications with C++* (in your `HFT/` folder): the latency-measurement and lock-free chapters pair with Week 3
