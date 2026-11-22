# 06 — How Robots Really Work: Math, Kinematics, Control, Estimation, Planning

> **Weeks:** 3 (calendar Weeks 14–16 on Path A) · **Load:** ~16–18 h/week
> **Masterclass:** Phase 3 "Understand How Robots Really Work" and its **Cyber World Lab** project
> **Tools:** C++ with Eigen (or Python with NumPy) · MuJoCo for control experiments · your Gazebo robot · Nav2 as the baseline
> **Phase project:** 🏆 **NavFromScratch**, your own complete navigation stack, benchmarked against Nav2
> **Map:** [../README.md](../README.md)

For two months you have used tools that work: Nav2 plans, AMCL localizes, MoveIt solves inverse kinematics,
`diff_drive_controller` turns velocities into wheel speeds. This phase opens every one of those boxes. You
derive the math and implement it yourself: forward and inverse kinematics, PID and LQR controllers, Kalman
and particle filters, A*, Hybrid-A* and RRT*. Then you check your versions against the tools you already
trust.

This is the phase that separates someone who can configure a robot from someone who can fix one when it
misbehaves. When AMCL loses the robot, you will know why. When the arm's IK flips its elbow, you will know
why. And when no package does what you need, you can write it.

**Language:** implement in C++/Eigen where you can, because the result can become a Nav2 or MoveIt plugin.
Python/NumPy is fine for first versions and plots.

## Can I Start Here?

| | |
|---|---|
| **Weeks 1–2 (math, kinematics, control)** | Need only 00 and Python, or 01 Week 3 Day 5 (Eigen) for C++. You can do them any time, even first ([Path F](../README.md#entry-paths)) |
| **Week 3 (estimation, planning)** | Exercises run on your Gazebo robot (03) and plug into Nav2 (04) |
| **Phase project** | Needs 03 and 04, to compare against Nav2 |

## After This Phase, You Can

- [ ] Use least squares, SVD and eigen-decomposition on robotics problems
- [ ] Work fluently with rotation matrices, quaternions, axis-angle and SE(3), including exp/log maps
- [ ] Derive kinematics for differential-drive, Ackermann and mecanum robots
- [ ] Compute forward kinematics (DH and product of exponentials), Jacobians and numerical IK for any arm
- [ ] Write the equations of motion for simple systems and simulate them
- [ ] Design and tune PID, LQR and simple MPC controllers, and track paths with pure pursuit
- [ ] Implement Bayes, Kalman (KF, EKF, UKF) and particle filters, and check their consistency
- [ ] Implement A*, Hybrid-A*, D* Lite, PRM, RRT and RRT*, and explain when each fits
- [ ] Size motors and gearboxes for a robot from first principles

## Software

```bash
sudo apt install -y libeigen3-dev python3-numpy python3-scipy python3-matplotlib
pip install --user mujoco osqp    # or inside a venv created with --system-site-packages
```

No hardware.

---

## Week 1 — The Math and Kinematics of Motion 🧮

### Day 1 — Linear Algebra That Robots Actually Use
- [ ] Linear maps, rank, null space; eigen-decomposition; the SVD and why it appears in IK, calibration and registration
- [ ] Least squares three ways: normal equations, QR, pseudo-inverse; RANSAC for outliers
- [ ] **Code:** fit lines to lidar points with least squares + RANSAC; align two scans with SVD (the Kabsch algorithm, the core step of ICP)

### Day 2 — Rotations and Rigid Transforms
- [ ] SO(2), SO(3): rotation matrices, Euler angles and gimbal lock, axis-angle, unit quaternions (composition, interpolation, double cover)
- [ ] SE(3) homogeneous transforms; twists; Lie groups intuitively: exponential and logarithm maps
- [ ] **Code:** your own `SE3` class (compose, inverse, exp, log) in Eigen, tested against tf2

### Day 3 — Mobile Robot Kinematics
- [ ] Differential drive: forward and inverse kinematics, odometry integration, instantaneous centre of rotation
- [ ] Nonholonomic constraints; the unicycle model; Ackermann (car-like) steering; omnidirectional robots (mecanum, omni wheels) and swerve drives
- [ ] Motion models with noise: the bridge to Week 3
- [ ] **Code:** simulate differential, Ackermann and mecanum robots following the same path; write a mecanum inverse-kinematics node

### Day 4 — Arm Forward Kinematics
- [ ] Denavit–Hartenberg parameters (standard and modified); product of exponentials (*Modern Robotics*)
- [ ] FK for the SO-101 and the UR3e; workspace plots
- [ ] **Code:** an FK library for any serial arm (DH and PoE), verified against MoveIt's TF output

### Day 5 — Velocity Kinematics and Inverse Kinematics
- [ ] The Jacobian (geometric and analytic), singularities, manipulability
- [ ] Analytic IK (2-link planar; why UR arms have closed-form solutions); numerical IK (Newton–Raphson, damped least squares, Levenberg–Marquardt); redundancy and the null space
- [ ] IK in practice: KDL, TRAC-IK, pick_ik, and GPU-accelerated solvers (cuRobo/cuMotion)
- [ ] **Code:** a damped-least-squares IK solver; drive the simulated arm's end effector around a circle with it

### 🔨 Saturday — KinLab
- [ ] Your kinematics library: FK, IK and Jacobians for any DH/PoE arm, C++/Eigen with a small Python binding (pybind11)
- [ ] Visualised in RViz by publishing `joint_states`
- [ ] Benchmarked against KDL for speed and accuracy; randomised tests (FK(IK(pose)) ≈ pose)

### 📄 Sunday
- [ ] Lynch & Park, [*Modern Robotics*](http://hades.mech.northwestern.edu/index.php/Modern_Robotics) (free PDF and videos), chapters 2–6
- [ ] Solà, Deray & Atchuthan, "A micro Lie theory for state estimation in robotics" (2018), sections 1–3

---

## Week 2 — Dynamics and Control 🧮

### Day 1 — Dynamics
- [ ] Newton–Euler and Lagrangian formulations; mass matrix, Coriolis and gravity terms
- [ ] The pendulum and the cart-pole: deriving their equations of motion
- [ ] Simulating ODEs: Euler vs RK4, and checking energy
- [ ] **Code:** simulate a pendulum and a cart-pole with RK4, then the same in MuJoCo; compare

### Day 2 — PID Control, Properly
- [ ] What P, I and D each do; integral windup and anti-windup; derivative filtering; feed-forward
- [ ] Tuning: step-response metrics, manual tuning, Ziegler–Nichols; cascaded loops (position → velocity → current); discretisation
- [ ] **Code:** a PID wheel-speed controller on a simulated DC motor with saturation and encoder quantisation. This exact code runs on your ESP32 in Phase 08

### Day 3 — State-Space Control and LQR
- [ ] Linearisation, controllability, pole placement; LQR and the Riccati equation; observers
- [ ] **Code:** balance the cart-pole with LQR in MuJoCo, then push it and watch it recover (the masterclass's "controller that keeps it balanced")

### Day 4 — Trajectories and Path Tracking
- [ ] Trajectory generation: cubic and quintic polynomials, trapezoidal and S-curve velocity profiles
- [ ] Mobile-robot path tracking: pure pursuit, Stanley, and model predictive control (receding horizon with constraints, solved as a QP with OSQP)
- [ ] **Code:** pure pursuit and an MPC tracker for your differential-drive robot on the same path; compare tracking error and smoothness

### Day 5 — Motors, Gears and Actuators (the bridge to hardware)
- [ ] DC motor model (torque constant, back-EMF, resistance), gear ratios, encoders (quadrature, counts per revolution)
- [ ] Servos, steppers, BLDC motors and field-oriented control, intuitively; quasi-direct-drive actuators and why legged robots use them
- [ ] **Code:** a motor-sizing calculator: from robot mass, wheel radius, acceleration and slope to torque, speed and current. **Choose your Phase 08 motors with it**

### 🔨 Saturday — Balance & Track
- [ ] An LQR-balanced cart-pole in MuJoCo with disturbance rejection, with plots
- [ ] Your MPC or pure-pursuit tracker driving your Gazebo robot through `ros2_control`
- [ ] The motor-sizing result for Rover-1, written up in the journal

### 📄 Sunday
- [ ] Brian Douglas, *Control Systems Lectures* and MATLAB Tech Talks on PID, LQR and MPC (YouTube)
- [ ] Steve Brunton, *Control Bootcamp* (YouTube), the LQR episodes
- [ ] Åström & Murray, [*Feedback Systems*](https://fbswiki.org/) (free), chapters 1, 6 and 7

---

## Week 3 — State Estimation and Planning 🧮

### Day 1 — Probability and the Bayes Filter
- [ ] Random variables, Gaussians, covariance, Bayes' rule, the Markov assumption; motion and measurement models
- [ ] The histogram (grid) filter
- [ ] **Code:** grid localization in 1D, then 2D, with a plotted belief

### Day 2 — Kalman Filters
- [ ] The Kalman filter, intuitively and in equations; the EKF (Jacobians); the UKF (sigma points)
- [ ] Tuning Q and R; checking consistency (NEES); what "the filter is overconfident" looks like
- [ ] **Code:** an EKF fusing wheel odometry, IMU yaw and landmark observations for your robot; compare it with `robot_localization` on the same bag

### Day 3 — Particle Filters
- [ ] Monte Carlo localization; motion and likelihood-field measurement models; low-variance resampling
- [ ] AMCL's refinements (adaptive sample count with KLD); particle deprivation; the kidnapped-robot problem
- [ ] **Code:** MCL from scratch on your Gazebo map, with particles shown in RViz as a `PoseArray`

### Day 4 — Search-Based Planning
- [ ] Graphs, BFS, Dijkstra, A*; admissible and consistent heuristics; weighted A*
- [ ] D* Lite for replanning; Hybrid-A* for car-like robots; state-lattice planners; costmaps and inflation as planner input
- [ ] **Code:** upgrade your A* plugin from Phase 04 to Hybrid-A* or D* Lite

### Day 5 — Sampling-Based and Optimisation-Based Planning
- [ ] Configuration space; PRM; RRT, RRT-Connect, RRT*; potential fields and their local minima
- [ ] Trajectory optimisation in one lesson (CHOMP, TrajOpt); OMPL as the library MoveIt uses
- [ ] **Code:** RRT* in 2D with obstacles and in the arm's joint space; visualise the tree growing

### 🏆 Saturday + Sunday — Phase Project: NavFromScratch
See the brief below. Sunday reading this week:
- [ ] Thrun, Burgard & Fox, *Probabilistic Robotics*, chapters 2–4 and 8

---

## 🏆 Phase Project — NavFromScratch (the Cyber World Lab, on your robot)

**What:** the masterclass asks you to write navigation algorithms from scratch for a real ROSbot XL. You do
the same for your own robot: a complete navigation stack where **every algorithm is yours**:

- an **EKF** fusing wheel odometry and IMU (`odom → base_link`)
- an **MCL** particle filter on the map (`map → odom`)
- an **A\*/Hybrid-A\*** global planner, packaged as a Nav2 planner plugin
- a **pure-pursuit or MPC** controller, packaged as a Nav2 controller plugin where possible

Then benchmark it against stock Nav2 (AMCL + Smac + MPPI) on the same 20 goals in the same world.

**Deliverables:**
- [ ] All four components running together on your Gazebo robot from one launch file
- [ ] A benchmark table: success rate, time, path length, CPU, and localization error against Gazebo ground truth
- [ ] Plots: estimated vs true trajectory, particle cloud snapshots, tracking error
- [ ] A write-up: where your stack wins, where it loses, and why
- [ ] The algorithms graduate into `my_robot/src/<name>_algorithms`

**Skills used:** 06 (all), 04 (Nav2 plugins and baseline), 03 (robot, world), 01 (C++/Eigen). **Evidence:** the benchmark table and plots.

---

## ✅ Gate

- [ ] Derive differential-drive kinematics and the odometry update on paper
- [ ] Explain quaternions, the double cover, and the exp/log maps of SO(3)
- [ ] Write FK and damped-least-squares IK for a 6-joint arm, and explain singularities
- [ ] Tune a PID loop with anti-windup and explain each term; balance a cart-pole with LQR
- [ ] Write the EKF prediction and update equations from memory and implement them
- [ ] Explain why a particle filter can recover from a kidnapping and a Kalman filter cannot
- [ ] Implement A* and RRT*, and say when you would choose each
- [ ] NavFromScratch's benchmark is in the journal

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md   <->   codes/Week_1/Saturday/
theory/Phase_Project.md     <->   codes/Phase_Project/NavFromScratch/
```

Lessons are generated one day at a time; ask for **"P06·W1·D1"**.

## Resources

- Lynch & Park, *Modern Robotics* (free PDF, videos, and a Coursera specialisation)
- Thrun, Burgard & Fox, *Probabilistic Robotics*: the classic for estimation and SLAM
- Roger Labbe, [*Kalman and Bayesian Filters in Python*](https://github.com/rlabbe/Kalman-and-Bayesian-Filters-in-Python) (free Jupyter book)
- Steven LaValle, [*Planning Algorithms*](http://lavalle.pl/planning/) (free online), chapters 5–6
- Cyrill Stachniss's lectures on YouTube: Kalman filters, particle filters, SLAM
- Russ Tedrake, [*Underactuated Robotics*](https://underactuated.mit.edu/) (free online), for dynamics and control beyond this phase
- Siegwart, Nourbakhsh & Scaramuzza, *Introduction to Autonomous Mobile Robots*, for locomotion and kinematics
