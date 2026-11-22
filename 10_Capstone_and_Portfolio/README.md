# 10 — Magnum Opus and Portfolio: Build Something That Makes People Say "Wow"

> **Where it sits:** Month 6 · Weeks 25–26
> **The plan (tick boxes there):** [Weeks 25–26](../README.md#week-25) · [✅ Definition of Done](../README.md#gate-10)
> **The brief:** [Month 6 Project: Magnum Opus ⭐⭐](../README.md#magnum-opus)
> **Map:** [../README.md](../README.md)

Six months ago you installed ROS 2. Now you pick one project that uses as much of what you built as
possible, make it work reliably on real hardware, and show it to the world. The Magnum Opus is not where you
learn new topics; it is where you prove the old ones compose.

Week 25 is building. Week 26 is making it reliable, then making it visible: documentation, video, write-up,
portfolio and a recorded talk.

## Can I Start Here?

Each option below lists the weeks it needs. If you are short of time, pick an option whose weeks you have
completed: a smaller project that works 18 times out of 20 beats an ambitious one that worked once.

## The Options

| Option | What the robot does | Needs |
|---|---|---|
| **A. Talk-to-Robot** (default) | Speak a request; an agent plans with your robot's capabilities as tools; Rover-1 navigates with Nav2, the SO-101 picks with your learned policy (MoveIt as fallback), and the robot reports back by voice | Weeks 21–24 |
| **B. Robot Café** | The SO-101 uses a depth camera to find a cup, picks it and places it on Rover-1, which delivers it to a table | Weeks 15, 19, 22 |
| **C. Tidy-Up Bot** | The mobile manipulator finds clutter (toys, cans) on the floor and drops it into a bin with a learned grasp | Weeks 13, 19, 22, 24 |
| **D. Tic-Tac-Toe Arm** | The arm reads the board with a camera, chooses a move with minimax, and places a piece or draws its symbol, playing a person | Weeks 15, 19 (24 for a learned grasp) |
| **E. Learned Quadruped** (ambitious) | A small 12-servo quadruped whose gait is trained in Isaac Lab and deployed on the real robot | Weeks 14, 21, 23 |
| **F. Shelf Returner** | A small warehouse robot docks under a miniature shelf, lifts it with a servo, and returns it home (full scale in simulation, small scale for real) | Weeks 13, 15, 22 |
| **G. Your own idea** | Anything that passes the [Novelty Scorecard](../README.md#project-philosophy) | — |

## This Folder

```text
theory/Week_25/Day_1.md       <->   codes/Week_25/Day_1/
theory/Projects/MagnumOpus.md <->   codes/Projects/MagnumOpus/   (or a package set in ../my_robot/)
```

Lessons are generated one day at a time: ask for **"M6W25D1"**, or **"M6 Magnum Opus"** for the project guide.
When the six months end, the [What To Learn Next](../README.md#learn-next) list at the end of the main README is
where the next roadmap begins.
