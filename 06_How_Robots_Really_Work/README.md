# 06 — How Robots Really Work: Math, Kinematics, Control, Estimation, Planning

> **Where it sits:** Month 5 · Weeks 17–18
> **The plan (tick boxes there):** [Week 17](../README.md#week-17) · [Week 18](../README.md#week-18) · [✅ Phase 06 gate](../README.md#gate-06)
> **Projects:** 🔨 KinLab (Week 17) · 🔨 Filters From Scratch v0.1 (Week 18) · 🏆 [NavFromScratch](../README.md#m5-project-a) (Month 5 Project A, Buffer Week 20)
> **Tools:** C++ with Eigen (or Python with NumPy for first versions) · MuJoCo for control experiments · your Gazebo robot · Nav2 as the baseline
> **Map:** [../README.md](../README.md)

For three months you have used tools that work: Nav2 plans, AMCL localizes, MoveIt solves inverse kinematics,
`diff_drive_controller` turns velocities into wheel speeds. This phase opens every one of those boxes. You
derive the math and implement it yourself (forward and inverse kinematics, PID and LQR, Kalman and particle
filters, A*, Hybrid-A* and RRT*), then check your versions against the tools you already trust.

This is the phase that separates someone who can configure a robot from someone who can fix one. When AMCL
loses the robot, you will know why. When the arm's IK flips its elbow, you will know why. And when no package
does what you need, you can write it.

Implement in C++/Eigen where you can, because the result can become a Nav2 or MoveIt plugin. Python and NumPy
are fine for first versions and plots.

## Can I Start Here?

| | |
|---|---|
| **Week 17 (math, kinematics, control)** | Needs only Week 0 and Python, or Week 3 Day 5 (Eigen) for C++. You can do it any time, even first ([Path F](../README.md#entry-paths)) |
| **Week 18 (estimation, planning)** | Exercises run on your Gazebo robot (Weeks 9–10) and plug into Nav2 (Weeks 11, 13) |
| **NavFromScratch** | Needs Weeks 9–13 and NavBench (Month 3 Project B), to compare against Nav2 |

## What You Will Be Able To Do

- Use least squares, the SVD and eigen-decomposition on robotics problems
- Work fluently with rotation matrices, quaternions, axis-angle and SE(3), including exp/log maps
- Derive kinematics for differential-drive, Ackermann and mecanum robots
- Compute forward kinematics (DH and product of exponentials), Jacobians and numerical IK for any arm
- Write equations of motion for simple systems and simulate them
- Design and tune PID and LQR controllers, and track paths with pure pursuit and MPC
- Implement Bayes, Kalman (KF, EKF, UKF) and particle filters, and check their consistency
- Implement A*, Hybrid-A*, PRM, RRT and RRT*, and explain when each fits

## Software

```bash
sudo apt install -y libeigen3-dev python3-numpy python3-scipy python3-matplotlib
pip install mujoco osqp    # inside a venv created with --system-site-packages
```

No hardware.

## This Folder

```text
theory/Week_17/Day_1.md              <->   codes/Week_17/Day_1/
theory/Week_18/Saturday.md           <->   codes/Week_18/Saturday/
theory/Projects/NavFromScratch.md    <->   codes/Projects/NavFromScratch/
```

Lessons are generated one day at a time: ask for **"M5W17D1"**. The algorithms graduate into
[`../my_robot/`](../my_robot/README.md) as `<name>_algorithms`.

## Resources

- Lynch & Park, *Modern Robotics* (free PDF, videos, and a Coursera specialisation)
- Thrun, Burgard & Fox, *Probabilistic Robotics*: the classic for estimation and SLAM
- Roger Labbe, [*Kalman and Bayesian Filters in Python*](https://github.com/rlabbe/Kalman-and-Bayesian-Filters-in-Python) (free Jupyter book)
- Steven LaValle, [*Planning Algorithms*](http://lavalle.pl/planning/) (free online), chapters 5–6
- Cyrill Stachniss's lectures on YouTube: Kalman filters, particle filters, SLAM
- Brian Douglas (MATLAB Tech Talks) and Steve Brunton (*Control Bootcamp*) on YouTube, for control intuition
- Russ Tedrake, [*Underactuated Robotics*](https://underactuated.mit.edu/) (free online), for dynamics beyond this phase
