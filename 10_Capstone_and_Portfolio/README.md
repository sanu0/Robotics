# 10 — Capstone and Portfolio: Build Something That Makes People Say "Wow"

> **Weeks:** 2 (calendar Weeks 25–26 on Path A) · **Load:** ~18–20 h/week (it is demo season)
> **Masterclass:** Phase 5, "Final Project and Certification": its five project options are all here, plus more ambitious ones
> **Deliverable:** ⭐⭐ one signature project, a portfolio, a demo video, a write-up and a recorded talk
> **Map:** [../README.md](../README.md)

Six months ago you installed ROS 2. Now you pick one project that uses as much of what you built as
possible, make it work reliably on real hardware, and show it to the world. The capstone is not where you
learn new topics; it is where you prove the old ones compose.

Week 1 is building. Week 2 is making it reliable, then making it visible: documentation, video, write-up,
portfolio, and a talk.

## Can I Start Here?

Each option below lists the phases it needs. If you are short of time, pick an option whose phases you have
completed; a smaller project that works 18 times out of 20 beats an ambitious one that worked once.

---

## Capstone Options

### The masterclass's five final projects, on your own hardware

| Option | What the robot does | Needs |
|---|---|---|
| **1. Robot Café** | The SO-101 uses a depth camera to find a cup, picks it and places it on Rover-1, which delivers it to a table | 05, 07, 08 |
| **2. Tic-Tac-Toe Arm** | The arm reads the board with a camera, chooses a move with minimax, and places a piece or draws its symbol, playing against a person | 05, 07 (09 for a learned grasp) |
| **3. Hand-Eye Calibration Studio** | A reusable web app + Docker image that calibrates any camera to any MoveIt arm and reports accuracy | 05, 07, 08 Week 3 |
| **4. Tidy-Up Bot** | A mobile manipulator finds clutter (toys, cans) on the floor and drops it into a bin, using a learned grasp | 04, 07, 08, 09 |
| **5. Shelf Returner** | A small warehouse robot docks under a miniature shelf, lifts it with a servo, and returns it to its home spot (full scale in Isaac Sim or Gazebo, small scale for real) | 04, 05, 08 |

### More ambitious

| Option | What the robot does | Needs |
|---|---|---|
| **6. Learned Quadruped** | Build or buy a small 12-servo quadruped, train its gait in Isaac Lab, and deploy the policy on the real robot | 05, 08, 09 |
| **7. Talk-to-Robot, Production Edition** | Harden Phase 09's project into something a guest can use unsupervised, with a safety case and a week of logs | 08, 09 |
| **8. Your own idea** | Anything that passes the [Novelty Scorecard](../README.md#project-philosophy) | — |

---

## Week 1 — Build

### Day 1 — Choose, Scope, Design
- [ ] Pick an option; write a one-page design document: goal, success metric (for example "≥ 18/20 successful deliveries"), architecture diagram, risks, test plan
- [ ] List what you reuse from earlier phases and `my_robot/`, and what is new
- [ ] A day-by-day plan for the two weeks, with the riskiest piece first

### Day 2 — Integration First
- [ ] A walking skeleton: every component present and wired end to end, even if each one is crude
- [ ] One launch command; a bag of the first full run

### Day 3 — Build Sprint
- [ ] Replace the riskiest crude component with the real one; test on hardware
- [ ] Journal: what broke, and the numbers

### Day 4 — Build Sprint
- [ ] The next component; first full runs on real hardware
- [ ] Start an evaluation log: every run, success or failure, with a reason

### Day 5 — Build Sprint
- [ ] Feature-complete. From here on, no new features, only reliability

### 🔨 Saturday — First Full Demo Run
- [ ] Run the whole task ten times in a row; record every run
- [ ] A failure list ordered by frequency: next week's work

### 📄 Sunday
- [ ] Rest. Look at your journal from Week 0, and notice how far you have come

---

## Week 2 — Polish and Ship

### Day 1 — Reliability
- [ ] Fix the top three failure causes; re-run 20 trials; record the success rate

### Day 2 — Documentation
- [ ] README: what it does, why it matters, architecture diagram, a one-command quick start with Docker, results table, known limitations
- [ ] Clean up `my_robot/`: every package has a README and tests

### Day 3 — Demo Video and Write-up
- [ ] A 2–3 minute video: the problem, the robot doing it, one interesting technical moment, the numbers
- [ ] A technical write-up or blog post on the hardest problem you solved

### Day 4 — Portfolio
- [ ] GitHub: pin your six best repositories (suggested: MiniROS, NavFromScratch, Rover-1/`my_robot`, Learned Grasp, the capstone, and one of your choice); a profile README linking demos
- [ ] Résumé bullets with numbers; a LinkedIn post with the video
- [ ] 🌶️ Contribute one small fix or doc improvement upstream (Nav2, MoveIt, ros2_control, LeRobot)

### Day 5 — The Talk and the Retrospective
- [ ] A 15-minute talk on your capstone; record it; answer questions from a friend, colleague or mentor
- [ ] A six-month retrospective in the journal: what worked, what you would do differently, what you want to master next
- [ ] Choose your next path (see [Beyond Six Months](../README.md#beyond))

### 🎉 Saturday — Demo Day
- [ ] Show the robot to people. Live.

### 📄 Sunday
- [ ] Celebrate. You can build robots now.

---

## ⭐⭐ Definition of Done

- [ ] Works on real hardware, with a measured success rate over at least 20 trials
- [ ] One command brings up the whole system (Docker)
- [ ] Tests pass, and CI is configured
- [ ] README, architecture diagram, bill of materials (if hardware changed), safety notes
- [ ] Demo video and technical write-up published
- [ ] Recorded talk
- [ ] The README states which phases' skills appear where (the cumulative rule)

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Capstone.md          <->   codes/Capstone/      (or a package set in ../my_robot/)
```

Lessons are generated one day at a time; ask for **"P10·W1·D1"**.
