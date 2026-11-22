# 09 — Physical AI and NVIDIA Isaac: Robots That Learn

> **Weeks:** 3 (calendar Weeks 22–24 on Path A) · **Load:** ~16–18 h/week
> **Masterclass:** not covered. This phase fills its biggest gap: reinforcement learning, imitation learning, vision-language-action models, NVIDIA Isaac Sim, Isaac Lab and Isaac ROS, and agentic robotics in depth
> **Stack:** PyTorch · Gymnasium + MuJoCo · Isaac Lab 3.0 (Newton) · Isaac Sim 6.2 · LeRobot + SO-101 · SmolVLA / π0 / GR00T · LLM agents with tools · Whisper
> **Phase project:** 🏆 **Talk-to-Robot**: spoken instructions → an agent → your real rover and a learned arm policy
> **Map:** [../README.md](../README.md)

Everything so far has been *programmed*: you wrote the controller, the planner, the grasp. This phase is
about robots that *learn* skills that are too hard to write by hand. Week 1 is reinforcement learning:
thousands of simulated robots on your GPU learn to walk in minutes with Isaac Lab, and you learn to deploy
such a policy through ROS 2. Week 2 is imitation learning: you teach the real SO-101 arm a task by
demonstrating it, then train a policy that does it alone. Week 3 is foundation models: vision-language-action
models that take instructions in words, and LLM agents that plan with your robot's capabilities as tools.

You also get hands-on with NVIDIA's robotics stack: Isaac Lab for training, Isaac Sim for photorealistic
simulation and synthetic data, and Isaac ROS for GPU perception on the robot.

> **Your hardware, honestly:** Isaac Lab 3.0 trains on your laptop's RTX GPU without Isaac Sim, using the
> Newton physics engine (fewer parallel environments than a big GPU, but it works). **Isaac Sim 6.2 needs a
> 16 GB RTX GPU**, so the Isaac Sim day uses a cloud instance with an RTX-class GPU (L4, L40S or A10G; not
> A100/H100, which lack RT cores). VLA fine-tuning (☁️) also needs a cloud GPU. Budget roughly $30–80 of cloud
> time for the whole phase, and stop instances when you finish.

## Can I Start Here?

| | |
|---|---|
| **Week 1 Days 1–4, Week 2 Days 1–4** | Need only 00 and Python. They can run early as a weekend side-track ([Path E](../README.md#entry-paths)) |
| **Day 5 of Weeks 1 and 2, all of Week 3** | Need ROS 2 (02), ros2_control (05), and for the project your real robot (08) |
| **Week 2** | Needs the SO-101 arm (Tier 3 in [HARDWARE.md](../HARDWARE.md)); without it, use LeRobot's simulated environments |
| **PyTorch** | Day 1 is a refresher; your `AI_ML_LLM` track covers the deep version |

## After This Phase, You Can

- [ ] Explain MDPs, value functions, policy gradients and PPO, and train a policy from scratch
- [ ] Train a locomotion policy in Isaac Lab, with domain randomisation and a terrain curriculum
- [ ] Export a policy and run it at a fixed rate in a ROS 2 node driving joints through ros2_control
- [ ] Load your robot into Isaac Sim, connect it to ROS 2, and generate labelled synthetic images
- [ ] Explain behaviour cloning, covariate shift, action chunking (ACT) and diffusion policies
- [ ] Collect a demonstration dataset with LeRobot, train a policy, and evaluate it honestly on a real arm
- [ ] Explain what VLAs are, run one, and fine-tune one on your own data
- [ ] Build an LLM agent that uses robot capabilities as tools, with guardrails
- [ ] Write a basic safety case for a robot that uses learned components

## Software

Each lives in its **own** Python environment; never install them into the system Python that ROS uses.
- PyTorch with CUDA, Gymnasium, MuJoCo (SETUP.md Step 10)
- [Isaac Lab 3.0](https://isaac-sim.github.io/IsaacLab/) via its `uv`-based installer: Python 3.12, PyTorch 2.11 + CUDA 13; needs NVIDIA driver 580.88+ on Windows or 580.65.06+ on Linux; runs on Windows 11 or Ubuntu
- [LeRobot](https://github.com/huggingface/lerobot) for the SO-101
- Isaac Sim 6.2 on a cloud RTX instance (SETUP.md Step 14)

---

## Week 1 — Reinforcement Learning and Isaac Lab

### Day 1 — PyTorch for Robot Learning
- [ ] Tensors, autograd, `nn.Module`, a training loop, the GPU, datasets and loaders; MLPs and small CNNs
- [ ] Behaviour cloning as plain supervised learning
- [ ] **Code:** train a network to imitate your Phase 06 pure-pursuit controller from logged (state, action) pairs, then let it drive the 2D simulation; where does it fail?

### Day 2 — Reinforcement Learning Fundamentals
- [ ] MDPs, returns, value functions, Bellman equations; REINFORCE; actor-critic; PPO (clipped objective, GAE); SAC in one page
- [ ] Reward design and reward hacking; exploration; on-policy vs off-policy; the Gymnasium API
- [ ] **Code:** PPO on CartPole and Pendulum (from scratch, or reading CleanRL's single-file version line by line), then a MuJoCo Hopper

### Day 3 — Isaac Lab on Your GPU
- [ ] Installing Isaac Lab 3.0 (Newton backend, no Isaac Sim needed); manager-based vs direct task workflows
- [ ] Massively parallel simulation on the GPU; the observation, action, reward, termination and event managers; RSL-RL's PPO
- [ ] **Code:** train a quadruped (Unitree Go2 or ANYmal) to walk on flat ground; tune the number of environments for 6 GB of VRAM; watch the learned policy and the TensorBoard curves

### Day 4 — From Simulation to Reality
- [ ] Domain randomisation (mass, friction, motor strength, latency, sensor noise), terrain curricula, proprioceptive observations, teacher–student distillation
- [ ] Deployment: export to ONNX or TorchScript; a 50 Hz ROS 2 node that turns observations into joint targets through ros2_control
- [ ] **Code:** train on rough terrain with a curriculum, export the policy, and run it in a ROS 2 node controlling a simulated quadruped

### Day 5 — Isaac Sim ☁️
- [ ] USD basics (stages, prims, references, physics schemas); importing your robot's URDF
- [ ] The ROS 2 bridge (clock, TF, odometry, lidar, camera, velocity commands); running your Nav2 stack against Isaac Sim instead of Gazebo
- [ ] Replicator: domain-randomised synthetic images with automatic labels
- [ ] **Code:** on a cloud RTX instance, your robot in Isaac Sim driven by your own Nav2 configuration, plus 1,000 labelled images to retrain your Phase 07 detector

### 🔨 Saturday — WalkerBot
- [ ] A quadruped locomotion policy trained in Isaac Lab, flat ground then rough terrain, with videos
- [ ] Sim-to-sim transfer: deploy the exported policy in a *different* simulator (MuJoCo or Gazebo) through your ROS 2 policy node. The honest test of robustness: how much worse does it get, and why?

### 📄 Sunday
- [ ] Sutton & Barto, [*Reinforcement Learning: An Introduction*](http://incompleteideas.net/book/the-book-2nd.html) (free), chapters 1, 3 and 13
- [ ] OpenAI [Spinning Up](https://spinningup.openai.com/), the PPO page
- [ ] Rudin et al., "Learning to Walk in Minutes Using Massively Parallel Deep Reinforcement Learning" (CoRL 2021)

---

## Week 2 — Imitation Learning on a Real Arm (LeRobot + SO-101)

### Day 1 — Imitation Learning, Properly
- [ ] Behaviour cloning and covariate shift; DAgger; why multimodal demonstrations break a mean-squared-error policy
- [ ] Action chunking (ACT), diffusion policies, flow matching; how to design a dataset (variety and quality over volume); honest evaluation
- [ ] **Code:** run LeRobot's pretrained policies in its simulated environments and read the training code

### Day 2 — SO-101 Bring-up
- [ ] Assembly (if your kit is unassembled), motor IDs and baud rates, calibration of leader and follower
- [ ] Leader–follower teleoperation; wrist and third-person cameras; the LeRobot dataset format
- [ ] **Code:** teleoperate the arm, and record ten practice episodes

### Day 3 — A Data-Collection Campaign
- [ ] One task: "pick the cube and put it in the bowl", with varied positions, lighting and distractors
- [ ] At least 50 good episodes; review every episode and drop the bad ones; write a data card
- [ ] **Code:** the dataset, with its card and statistics

### Day 4 — Training and Honest Evaluation
- [ ] Training ACT (and optionally a diffusion policy) with LeRobot; fitting it into 6 GB of VRAM (batch size, image size) or using a cloud GPU
- [ ] Evaluation on the real arm: 20 trials, success rate, and a taxonomy of failures; iterate on the *data*
- [ ] **Code:** a trained ACT policy and its evaluation report

### Day 5 — ROS 2 Integration and Sim-to-Real for Manipulation
- [ ] The SO-101 in ROS 2: a `ros2_control` hardware interface for the Feetech STS3215 bus servos (your Phase 05 and 08 skills), MoveIt on the real arm
- [ ] NVIDIA's SO-101 sim-to-real course: train in Isaac Lab, deploy on the real arm
- [ ] **Code:** the learned policy wrapped as a ROS 2 action (`pick_cube`) that the rest of your system can call

### 🔨 Saturday — Learned Grasp
- [ ] The real SO-101 performs your pick-and-place task with a policy trained from *your* demonstrations
- [ ] At least 16 successes in 20 trials, with a video and a write-up of every failure type
- [ ] Callable as a ROS 2 action

### 📄 Sunday
- [ ] Zhao et al., "Learning Fine-Grained Bimanual Manipulation with Low-Cost Hardware" (the ACT paper, RSS 2023)
- [ ] Chi et al., "Diffusion Policy" (RSS 2023)
- [ ] NVIDIA's free [Physical AI learning path](https://docs.nvidia.com/learning/physical-ai/index.html): Isaac Sim, Isaac Lab, Isaac ROS, and the SO-101 sim-to-real course

---

## Week 3 — Foundation Models, VLAs, and Agentic Robotics

### Day 1 — The Robot Foundation-Model Landscape
- [ ] Vision-language models vs vision-language-action models; RT-2, OpenVLA, π0/π0.5 (open weights via `openpi`), SmolVLA, NVIDIA GR00T for humanoids; world models (NVIDIA Cosmos)
- [ ] How they are trained (large cross-robot datasets such as Open X-Embodiment), what they can do today, and what they cannot
- [ ] **Code:** run SmolVLA inference on frames from your SO-101 dataset and evaluate it zero-shot

### Day 2 — Fine-Tuning a VLA ☁️
- [ ] Fine-tune SmolVLA on your SO-101 dataset with LeRobot, on a cloud GPU
- [ ] Language-conditioned tasks: "pick the red cube" vs "pick the blue cube"
- [ ] **Code:** a fine-tuned VLA, compared against your ACT policy on the same 20 trials

### Day 3 — Agentic Robotics in Depth
- [ ] LLM agents with tools, where the tools are your robot's actions and services; MCP servers for ROS 2; NASA JPL's ROSA as a reference design
- [ ] Planning with LLMs: decomposition, verification, re-planning after failure; grounding in a scene description built from perception
- [ ] Safety: allow-lists, geofences, speed limits, human-in-the-loop confirmation, rate limits; local models (on a Jetson) vs cloud models
- [ ] **Code:** a tool server exposing `navigate`, `pick` (your learned policy), `describe_scene` and `report` to an agent

### Day 4 — Speech and Human-Robot Interaction
- [ ] Speech-to-text (Whisper), text-to-speech, wake words
- [ ] A vision-language model describing what the camera sees; the robot explaining what it is about to do; feedback with lights and sounds
- [ ] **Code:** a voice interface: "Robot, what do you see?" and "Go to the kitchen and bring the cube"

### Day 5 — Safe and Responsible Autonomy
- [ ] Safety standards in overview: ISO 13482 (personal care robots), ISO 10218 (industrial robots), ISO/TS 15066 (collaborative robots)
- [ ] Risk assessment, emergency stops, speed and separation monitoring; how learned policies fail and how to test for it; privacy for cameras in homes
- [ ] **Code:** a written safety case for Rover-1: hazards → mitigations → tests, with the tests implemented

### 🏆 Saturday + Sunday — Phase Project: Talk-to-Robot
See the brief below. Sunday reading this week:
- [ ] Brohan et al., "RT-2" (2023); Kim et al., "OpenVLA" (2024); Black et al., "π0" (2024); NVIDIA, "GR00T N1" (2025)

---

## 🏆 Phase Project — Talk-to-Robot

**What:** speak to your robot. An agent turns the request into a plan using your robot's capabilities as
tools: Rover-1 navigates with Nav2, the SO-101 picks with your learned policy (or MoveIt when the policy is
unsure), and the robot reports back by voice. Every action passes through the guardrails from your safety
case.

**Deliverables:**
- [ ] Voice in, voice out; the agent's plan visible in a log or on the dashboard
- [ ] At least three different multi-step requests completed on the real robot
- [ ] A refused unsafe request, and a recovered failure (object moved mid-task)
- [ ] The safety case, with its tests passing
- [ ] Demo video; the policy runners and agent graduate into `my_robot/src/<name>_ai`

**Skills used:** 09, 08 (real robot), 07 (perception), 05 (manipulation), 04 (Nav2), 02 (actions). **Evidence:** video, task success rates, safety tests.

---

## ✅ Gate

- [ ] Explain PPO's objective and why parallel simulation makes learned locomotion practical
- [ ] Train a policy in Isaac Lab and deploy it through a ROS 2 node, at least sim-to-sim
- [ ] Run your robot in Isaac Sim over ROS 2, and generate a labelled synthetic dataset
- [ ] Collect data, train an imitation policy, and report an honest success rate on real hardware
- [ ] Explain what a VLA is and how fine-tuning one differs from training ACT
- [ ] Demonstrate an agent refusing an unsafe request
- [ ] Talk-to-Robot works on the real robot

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md   <->   codes/Week_1/Saturday/
theory/Phase_Project.md     <->   codes/Phase_Project/TalkToRobot/
```

Datasets, checkpoints and training runs stay **out of git** (`.gitignore` blocks them); push datasets to the
Hugging Face Hub if you want to share them. Lessons are generated one day at a time; ask for **"P09·W1·D1"**.

## Resources

- [Isaac Lab documentation](https://isaac-sim.github.io/IsaacLab/) and the [Isaac Sim documentation](https://docs.isaacsim.omniverse.nvidia.com/latest/)
- NVIDIA's free [Physical AI learning path](https://docs.nvidia.com/learning/physical-ai/index.html)
- [LeRobot documentation](https://huggingface.co/docs/lerobot) and the Hugging Face Deep RL course (free)
- Sutton & Barto (free); OpenAI Spinning Up; [CleanRL](https://github.com/vwxyzjn/cleanrl)
- [openpi](https://github.com/Physical-Intelligence/openpi) (π0 open weights) and [Isaac GR00T](https://github.com/NVIDIA/Isaac-GR00T)
- [ROSA](https://github.com/nasa-jpl/rosa), NASA JPL's ROS agent
- Firoozi et al., "Foundation Models in Robotics: Applications, Challenges, and the Future" (survey, 2023)
- The Construct's Physical AI Robotics Masterclass, if you want a guided, mentored version of this phase later
