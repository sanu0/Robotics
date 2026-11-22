# 09 — Physical AI and NVIDIA Isaac: Robots That Learn

> **Where it sits:** Month 6 · Weeks 23–24
> **The plan (tick boxes there):** [Week 23](../README.md#week-23) · [Week 24](../README.md#week-24) · [✅ Phase 09 gate](../README.md#gate-09)
> **Projects:** 🔨 WalkerBot (Week 23) · 🔨 Learned Grasp (Week 24) · feeds the 🎖 [Magnum Opus](../README.md#magnum-opus)
> **Stack:** PyTorch · Gymnasium + MuJoCo · Isaac Lab 3.0 (Newton) · Isaac Sim 6.2 · LeRobot + SO-101 · SmolVLA / π0 / GR00T · LLM agents with tools · Whisper
> **Map:** [../README.md](../README.md)

Everything before this was *programmed*: you wrote the controller, the planner, the grasp. This phase is
about robots that *learn* skills too hard to write by hand. Week 23 is reinforcement learning: thousands of
simulated robots on your GPU learn to walk with Isaac Lab, and you deploy such a policy through ROS 2; Isaac
Sim runs your own robot for photorealistic simulation and synthetic data. Week 24 is imitation learning and
foundation models: you teach the real SO-101 a task by demonstrating it, train a policy that does it alone,
run vision-language-action models, and put an LLM agent with guardrails in front of your robot.

> **Your hardware, honestly:** Isaac Lab 3.0 trains on your laptop's RTX GPU without Isaac Sim, using the
> Newton physics engine (fewer parallel environments than a big GPU, but it works). **Isaac Sim 6.2 needs a
> 16 GB RTX GPU**, so the Isaac Sim day uses a cloud instance with an RTX-class GPU (L4, L40S or A10G; not
> A100/H100, which lack RT cores). VLA fine-tuning (☁️) also needs a cloud GPU. Budget roughly $30–80 of
> cloud time, and stop instances when you finish.

## Can I Start Here?

| | |
|---|---|
| **Week 23 Days 1–3, Week 24 Days 1–3** | Need only Week 0, Python and a GPU (plus the SO-101 for Week 24). They can run early as weekend side quests ([Path E](../README.md#entry-paths)) |
| **Week 23 Days 4–5, Week 24 Days 4–5** | Need ROS 2 (Month 2), ros2_control (Week 14), and for the agent your robot (Weeks 21–22) |
| **No SO-101?** | Use LeRobot's simulated environments and Isaac Lab's SO-101 tasks; the method is the same |
| **PyTorch** | Week 23 Day 1 is a refresher; your `AI_ML_LLM` track covers the deep version |

## What You Will Be Able To Do

- Explain MDPs, value functions, policy gradients and PPO, and train a policy from scratch
- Train a locomotion policy in Isaac Lab, with domain randomisation and a terrain curriculum
- Export a policy and run it at a fixed rate in a ROS 2 node driving joints through ros2_control
- Load your robot into Isaac Sim, connect it to ROS 2, and generate labelled synthetic images
- Explain behaviour cloning, covariate shift, action chunking (ACT) and diffusion policies
- Collect a demonstration dataset with LeRobot, train a policy, and evaluate it honestly on a real arm
- Explain what VLAs are and run one (and fine-tune one, with a cloud GPU)
- Build an LLM agent that uses robot capabilities as tools, with guardrails and a safety case

## Software

Each lives in its **own** Python environment; never install them into the system Python that ROS uses.
- PyTorch with CUDA, Gymnasium, MuJoCo (SETUP.md Step 10)
- [Isaac Lab 3.0](https://isaac-sim.github.io/IsaacLab/) via its `uv`-based installer: Python 3.12, PyTorch 2.11 + CUDA 13; NVIDIA driver 580.88+ on Windows or 580.65.06+ on Linux; runs on Windows 11 or Ubuntu
- [LeRobot](https://github.com/huggingface/lerobot) for the SO-101
- Isaac Sim 6.2 on a cloud RTX instance (SETUP.md Step 14)

## This Folder

```text
theory/Week_23/Day_1.md       <->   codes/Week_23/Day_1/
theory/Week_24/Saturday.md    <->   codes/Week_24/Saturday/
```

Datasets, checkpoints and training runs stay **out of git** (`.gitignore` blocks them); push datasets to the
Hugging Face Hub if you want to share them. Policy runners and the agent graduate into
[`../my_robot/`](../my_robot/README.md) as `<name>_ai`. Lessons are generated one day at a time: ask for **"M6W23D1"**.

## Resources

- [Isaac Lab documentation](https://isaac-sim.github.io/IsaacLab/) and the [Isaac Sim documentation](https://docs.isaacsim.omniverse.nvidia.com/latest/)
- NVIDIA's free [Physical AI learning path](https://docs.nvidia.com/learning/physical-ai/index.html)
- [LeRobot documentation](https://huggingface.co/docs/lerobot) and the Hugging Face Deep RL course (free)
- Sutton & Barto (free); OpenAI Spinning Up; [CleanRL](https://github.com/vwxyzjn/cleanrl)
- [openpi](https://github.com/Physical-Intelligence/openpi) (π0 open weights) and [Isaac GR00T](https://github.com/NVIDIA/Isaac-GR00T)
- [ROSA](https://github.com/nasa-jpl/rosa), NASA JPL's ROS agent
- Firoozi et al., "Foundation Models in Robotics: Applications, Challenges, and the Future" (survey, 2023)
