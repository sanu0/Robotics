# SETUP — Build Your Robotics Lab

> **This is Week 0, Day 1.** Every later week assumes it works.
> **Success:** `bash ~/Robotics/setup/check_lab.sh` exits 0, Gazebo renders on your NVIDIA GPU, and a C++
> talker reaches a Python listener.
> **Budget:** two or three evenings. Steps 10–14 are for later phases; each says when you need it.

---

## Contents

- [The Environments You Need](#the-environments-you-need)
- [Where Code Lives, and Why Not in OneDrive](#where-code-lives-and-why-not-in-onedrive)
- [Step 1 — A Dedicated WSL2 Ubuntu 24.04](#step-1--a-dedicated-wsl2-ubuntu-2404)
- [Step 2 — Put WSLg on the NVIDIA GPU](#step-2--put-wslg-on-the-nvidia-gpu)
- [Step 3 — Install ROS 2 Jazzy](#step-3--install-ros-2-jazzy)
- [Step 4 — Gazebo Harmonic](#step-4--gazebo-harmonic)
- [Step 5 — Smoke Tests](#step-5--smoke-tests)
- [Step 6 — Workspace, Sync Scripts and Shell Helpers](#step-6--workspace-sync-scripts-and-shell-helpers)
- [Step 7 — Editor](#step-7--editor)
- [Step 8 — Foxglove or Lichtblick on Windows](#step-8--foxglove-or-lichtblick-on-windows)
- [Step 9 — Packages by Phase](#step-9--packages-by-phase)
- [Step 10 — Later: Python ML Stack and Isaac Lab (Phases 07, 09)](#step-10--later-python-ml-stack-and-isaac-lab-phases-07-09)
- [Step 11 — Later: Docker and the NVIDIA Container Toolkit (Phase 07–08)](#step-11--later-docker-and-the-nvidia-container-toolkit-phase-0708)
- [Step 12 — Later: USB Devices into WSL (Phase 08)](#step-12--later-usb-devices-into-wsl-phase-08)
- [Step 13 — Later: Talking to a Real Robot over Wi-Fi (Phase 08)](#step-13--later-talking-to-a-real-robot-over-wi-fi-phase-08)
- [Step 14 — Later: Isaac Sim on a Cloud RTX GPU (Phase 09)](#step-14--later-isaac-sim-on-a-cloud-rtx-gpu-phase-09)
- [Verify Everything](#verify-everything)
- [Common Problems](#common-problems)

---

## The Environments You Need

| Environment | When | Role |
|---|---|---|
| **Windows 11 host** | Always | This repo (OneDrive), Cursor, git, Foxglove |
| **WSL2 `Ubuntu-24.04`** (dedicated to robotics) | Always | ROS 2 Jazzy, Gazebo, colcon, your code's working copy, CUDA via the Windows driver |
| **`~/ros2_ws`** inside WSL | Always | colcon's `build/`, `install/`, `log/`. Disposable |
| **Robot computer** (Raspberry Pi 5 or Jetson Orin Nano Super) | Phase 08+ | Ubuntu 24.04 (or JetPack 7.2) + ROS 2 Jazzy, on the robot |
| **Cloud RTX GPU instance** | Phase 09 (one or two days) | Isaac Sim 6.2 and VLA fine-tuning, which need more than your laptop's 6 GB of VRAM |

**Why ROS 2 Jazzy and Ubuntu 24.04**, not the newer Lyrical on 26.04: Isaac Sim 6.2 recommends Jazzy on
24.04, Isaac ROS 4.6 is built and tested for Jazzy, and JetPack 7.2 for Jetson is Ubuntu 24.04. Every NVIDIA
tool in this roadmap lines up on Jazzy, which is supported until May 2029. See
[State of the Robotics Stack](README.md#state-of-the-stack).

---

## Where Code Lives, and Why Not in OneDrive

Code lives in **three places on purpose**: the git-tracked repo under `Robotics/` on Windows, a working copy
at `~/Robotics` inside WSL where you build and run, and the colcon workspace at `~/ros2_ws`. The scripts in
[`setup/`](setup/README.md) move code between the first two.

Never build on `/mnt/c/...`. Through WSL's file bridge, builds are several times slower; NTFS drops the
executable bit and the symlinks `colcon build --symlink-install` creates; and OneDrive would try to upload
every build artifact.

**Pin the repo so OneDrive never swaps files for cloud placeholders** (a placeholder breaks git and breaks
WSL reading the scripts). In PowerShell, from the `SKILL` folder:

```powershell
attrib +P /s /d ".\Robotics\*"
# after you run `git init`, pin .git too (it is hidden, so it needs its own pass):
attrib +P /s /d ".\Robotics\.git\*"
```

Right-clicking the folder and choosing *Always keep on this device* does the same. Re-run after adding large
new folders. Once you have a git remote, push often: the remote is your real backup, not file sync.

---

## Step 1 — A Dedicated WSL2 Ubuntu 24.04

Your kernel lab already lives in a WSL distro. Robotics gets its own, so hundreds of ROS packages never sit
next to your kernel toolchain.

On this laptop that is not optional: the kernel lab's distro is named `Ubuntu` and runs **Ubuntu 26.04 LTS**
(checked in November 2026), and ROS 2 Jazzy has no packages for 26.04. The name `Ubuntu-24.04` is free, so:

```powershell
wsl -l -v                          # shows your existing "Ubuntu" (the kernel lab)
wsl --list --online                # confirm Ubuntu-24.04 is offered
wsl --install -d Ubuntu-24.04      # create it alongside; choose a username and password
wsl --update
wsl -d Ubuntu-24.04                # open it (the kernel lab stays the default distro)
```

Every command below runs inside `Ubuntu-24.04`. In Cursor or Windows Terminal, pick that distro explicitly;
`wsl` on its own still opens the kernel lab.

`%USERPROFILE%\.wslconfig` is **shared by all distros**, and the kernel lab already has one. Edit it rather
than creating a second; make sure it has at least:

```ini
[wsl2]
memory=20GB          # Gazebo + Nav2 + RViz want 12 GB+; leave Windows at least 8 GB
processors=12
swap=8GB
# networkingMode=mirrored    # turn on in Phase 08, when a real robot joins your network (Step 13)
```

Then `wsl --shutdown` from PowerShell and reopen the distro. Plan on **40 GB+ free** inside WSL.

---

## Step 2 — Put WSLg on the NVIDIA GPU

Your laptop has two GPUs: the Intel graphics in the Core Ultra and the RTX 1000 Ada. WSLg may render with
the Intel one, and Gazebo then runs slowly or crashes. Check, then fix:

```bash
sudo apt update && sudo apt install -y mesa-utils
glxinfo -B | grep -E "OpenGL renderer|OpenGL version"
# Want something like: OpenGL renderer string: D3D12 (NVIDIA RTX 1000 Ada Generation Laptop GPU)

# If it names Intel, or "llvmpipe" (software rendering):
echo 'export MESA_D3D12_DEFAULT_ADAPTER_NAME="NVIDIA"' >> ~/.bashrc
source ~/.bashrc
glxinfo -B | grep "OpenGL renderer"

nvidia-smi    # CUDA in WSL comes from the Windows driver
```

> **Never install a Linux NVIDIA driver inside WSL.** The Windows driver provides both graphics and CUDA to
> WSL. Keep the Windows driver current: Isaac Lab 3.0 needs 580.88 or newer (this laptop reported 621.14 in
> November 2026, which is fine).

---

## Step 3 — Install ROS 2 Jazzy

These commands follow the official page as of November 2026. If anything disagrees with
[docs.ros.org: Ubuntu (deb packages)](https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html),
the official page wins; the repository-setup step has changed more than once.

```bash
# Locale
sudo apt update && sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Repositories: enable universe, then install the ros2-apt-source package (it manages the key and source)
sudo apt install -y software-properties-common curl
sudo add-apt-repository -y universe
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

# ROS 2 Jazzy desktop + developer tools (colcon, rosdep, vcstool)
sudo apt update && sudo apt upgrade -y
sudo apt install -y ros-jazzy-desktop ros-dev-tools

# Build helpers used throughout Phase 01 onward
sudo apt install -y build-essential cmake ninja-build gdb ccache clangd rsync git

# rosdep
sudo rosdep init
rosdep update

# Every new shell gets Jazzy and colcon tab completion
echo 'source /opt/ros/jazzy/setup.bash' >> ~/.bashrc
echo 'source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash' >> ~/.bashrc
source ~/.bashrc
```

---

## Step 4 — Gazebo Harmonic

Jazzy pairs with Gazebo Harmonic (gz-sim 8), shipped as ROS vendor packages. One package installs Gazebo
and the ROS bridge:

```bash
sudo apt install -y ros-jazzy-ros-gz
gz sim --versions        # expect 8.x
gz sim shapes.sdf        # a window with shapes; press the play button
```

If the window is black, crashes, or crawls, see [Common Problems](#common-problems).

---

## Step 5 — Smoke Tests

Each command in its own terminal:

```bash
ros2 run demo_nodes_cpp talker          # terminal 1: a C++ publisher
ros2 run demo_nodes_py listener         # terminal 2: a Python subscriber. C++ → Python over DDS

ros2 run turtlesim turtlesim_node       # terminal 3
ros2 run turtlesim turtle_teleop_key    # terminal 4: drive with the arrow keys

rviz2                                   # opens RViz
ros2 doctor --report | head -40         # a health report
```

---

## Step 6 — Workspace, Sync Scripts and Shell Helpers

Add this block to `~/.bashrc`, with your own Windows path. **Keep the quotes**: the OneDrive path has spaces.

```bash
cat >> ~/.bashrc <<'EOF'

# ── Robotics lab ─────────────────────────────────────────────────
export ROBOTICS_REPO="/mnt/c/Users/<you>/<path-to>/SKILL/Robotics"   # Windows repo (git)
export ROBOTICS_HOME="$HOME/Robotics"                               # WSL working copy: build and run here
export ROS_DOMAIN_ID=42              # any number from 1 to 101; 0 is shared with every other ROS user on your network
export RCUTILS_COLORIZED_OUTPUT=1
export MESA_D3D12_DEFAULT_ADAPTER_NAME="NVIDIA"

# rb <path under ~/Robotics> [extra colcon args]: build just that folder's packages into ~/ros2_ws, then source them.
# Each folder gets its own build directory (two days may hold different versions of the same package, and CMake
# refuses to reuse a build directory for a different source folder); all folders share one install space.
rb() {
  local rel="${1:?usage: rb <path under ~/Robotics> [colcon args]}"
  shift
  rel="${rel%/}"
  ( cd "$HOME/ros2_ws" && colcon build --symlink-install --base-paths "$ROBOTICS_HOME/$rel" \
      --build-base "build/${rel//\//_}" "$@" ) \
    && source "$HOME/ros2_ws/install/setup.bash"
}
alias rpull='bash "$ROBOTICS_HOME/setup/sync_from_repo.sh"'    # repo -> WSL
alias rpush='bash "$ROBOTICS_HOME/setup/sync_to_repo.sh"'      # WSL -> repo
EOF
source ~/.bashrc
```

colcon defaults: compile commands for clangd, ccache for faster C++ rebuilds, optimised builds with debug
symbols.

```bash
mkdir -p ~/.colcon ~/ros2_ws
cat > ~/.colcon/defaults.yaml <<'EOF'
build:
  cmake-args:
    - -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    - -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
    - -DCMAKE_BUILD_TYPE=RelWithDebInfo
EOF
```

Bootstrap the working copy (first time only; after this, `rpull` does it):

```bash
mkdir -p ~/Robotics
cp -r "$ROBOTICS_REPO/setup" ~/Robotics/
sed -i 's/\r$//' ~/Robotics/setup/*.sh
bash ~/Robotics/setup/sync_from_repo.sh
bash ~/Robotics/setup/check_lab.sh
```

Daily rhythm: `rpull` → `rb <phase>/codes/Week_N/Day_N` → work → `rpush` → commit from Windows. Details in
[`setup/README.md`](setup/README.md).

---

## Step 7 — Editor

Two workable styles; pick one per session:

- **Edit on Windows, build in WSL** (the kernel-lab model): edit in this repo with Cursor, `rpull`, build
- **Edit inside WSL:** open `~/Robotics` in Cursor through its WSL connection, then `rpush` before committing

Extensions worth having: clangd (C++), Python, CMake, a ROS extension (for example *Robotics Developer
Environment*), and an XML/URDF helper. For clangd across all packages, merge the per-package compile
databases after a build:

```bash
cd ~/ros2_ws && jq -s 'add' build/*/compile_commands.json > build/compile_commands.json
```

(`sudo apt install -y jq` first.) Then point clangd at `~/ros2_ws/build`.

---

## Step 8 — Foxglove or Lichtblick on Windows

A visual debugger for live topics and recorded bags. Install **Foxglove** (needs a free account) or
**Lichtblick** (an open-source fork) on Windows, then in WSL:

```bash
sudo apt install -y ros-jazzy-foxglove-bridge
ros2 launch foxglove_bridge foxglove_bridge_launch.xml
```

Connect to `ws://localhost:8765`. WSL forwards localhost ports to Windows by default.

---

## Step 9 — Packages by Phase

Install as each phase needs them. Each phase README repeats its own line. Package names are correct for
Jazzy to the best of current knowledge; if `apt` cannot find one, try `apt search ros-jazzy-<keyword>`.

| Phase | Packages |
|---|---|
| 01 C++ | `libgtest-dev libgmock-dev libeigen3-dev clang-format clang-tidy valgrind` |
| 02 ROS 2 Core | `ros-jazzy-rmw-cyclonedds-cpp ros-jazzy-rmw-zenoh-cpp ros-jazzy-foxglove-bridge ros-jazzy-diagnostic-updater ros-jazzy-diagnostic-aggregator ros-jazzy-rqt-robot-monitor` |
| 03 Modeling & Sim | `ros-jazzy-xacro ros-jazzy-joint-state-publisher-gui ros-jazzy-ros2-control ros-jazzy-ros2-controllers ros-jazzy-gz-ros2-control ros-jazzy-teleop-twist-keyboard ros-jazzy-teleop-twist-joy ros-jazzy-twist-mux ros-jazzy-urdf-tutorial` |
| 04 Navigation | `ros-jazzy-navigation2 ros-jazzy-nav2-bringup ros-jazzy-slam-toolbox ros-jazzy-robot-localization` |
| 05 Manipulation | `ros-jazzy-moveit ros-jazzy-ur ros-jazzy-pick-ik ros-jazzy-apriltag-ros ros-jazzy-moveit-servo` |
| 06 Theory | `python3-numpy python3-scipy python3-matplotlib` + `pip install mujoco osqp` (in a venv) |
| 07 Perception | `ros-jazzy-vision-opencv ros-jazzy-image-pipeline ros-jazzy-image-transport-plugins ros-jazzy-perception-pcl ros-jazzy-depthimage-to-laserscan ros-jazzy-rtabmap-ros ros-jazzy-vision-msgs python3-open3d` |
| 08 Build Your Robot | `ros-jazzy-rosbridge-suite ros-jazzy-web-video-server ros-jazzy-usb-cam` |

---

## Step 10 — Later: Python ML Stack and Isaac Lab (Phases 07, 09)

ROS uses the system Python. Machine-learning tools each get their **own** environment, so neither can break
the other.

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh        # uv: fast Python environment manager
uv venv ~/venvs/ml --python 3.12
source ~/venvs/ml/bin/activate
uv pip install torch torchvision                        # CUDA wheels; check the PyTorch site for the current command
python -c "import torch; print(torch.cuda.is_available(), torch.cuda.get_device_name(0))"
```

- **Ultralytics YOLO (Phase 07):** `uv pip install ultralytics` in that environment
- **Isaac Lab 3.0 (Phase 09):** follow the [official installation](https://isaac-sim.github.io/IsaacLab/); its
  `uv`-based installer creates its own environment. The default Newton backend needs no Isaac Sim and runs on
  your RTX GPU (Windows 11 natively, or WSL/Ubuntu)
- **LeRobot (Phase 09):** its own environment, with the Python version its docs specify

To use a venv *with* ROS packages visible, create it with `--system-site-packages`.

---

## Step 11 — Later: Docker and the NVIDIA Container Toolkit (Phase 07–08)

Isaac ROS (Phase 07) and your robot's images (Phase 08) use Docker. Docker Engine installed inside WSL avoids
Docker Desktop's licensing terms for large companies:

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER          # log out of WSL and back in
docker run --rm hello-world
```

Then install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
following its apt instructions, run `sudo nvidia-ctk runtime configure --runtime=docker`, restart Docker, and
check GPU access with `docker run --rm --gpus all ubuntu nvidia-smi`.

---

## Step 12 — Later: USB Devices into WSL (Phase 08)

An ESP32, a lidar or the SO-101's servo board plug into Windows; `usbipd-win` passes them through to WSL.

```powershell
winget install usbipd                    # once
usbipd list                              # find the BUSID, e.g. 1-4
usbipd bind --busid 1-4                  # once per device, in an admin PowerShell
usbipd attach --wsl --busid 1-4          # each time you plug it in
```

Inside WSL the device appears as `/dev/ttyUSB0` or `/dev/ttyACM0`; add yourself to `dialout`
(`sudo usermod -aG dialout $USER`). Common USB-serial chips (CP210x, CH340, FTDI) work with WSL's kernel.
**USB webcams usually do not**: WSL's default kernel lacks the UVC video driver. Use simulated cameras on the
laptop, and real cameras on the robot computer.

> On a corporate laptop, `usbipd`, firewall rules and WSL networking changes may be restricted by IT policy.
> Plan B is cheap: a used mini PC or laptop running native Ubuntu 24.04 as a dedicated robotics machine, or
> developing on the robot computer over SSH.

---

## Step 13 — Later: Talking to a Real Robot over Wi-Fi (Phase 08)

WSL's default NAT networking blocks the multicast DDS uses for discovery, so the laptop and the robot cannot
see each other. Two fixes:

**A. Mirrored networking** (Windows 11 22H2+). In `.wslconfig` set `networkingMode=mirrored`, run
`wsl --shutdown`, then allow inbound traffic to WSL in an admin PowerShell:

```powershell
Set-NetFirewallHyperVVMSetting -Name '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}' -DefaultInboundAction Allow
```

Same `ROS_DOMAIN_ID` on both machines, then `ros2 run demo_nodes_cpp talker` on the robot and
`ros2 topic echo /chatter` on the laptop.

**B. Zenoh.** Use `rmw_zenoh_cpp` on both machines (`export RMW_IMPLEMENTATION=rmw_zenoh_cpp`), run the Zenoh
router on the robot (`ros2 run rmw_zenoh_cpp rmw_zenohd`), and point the laptop's session at the robot's
router (`tcp/<robot-ip>:7447`) through the Zenoh configuration file described in the
[rmw_zenoh README](https://github.com/ros2/rmw_zenoh). No multicast needed; very robust over Wi-Fi.

Either way: keep the clocks in sync (`chrony` on both machines), or TF will complain about the future.

---

## Step 14 — Later: Isaac Sim on a Cloud RTX GPU (Phase 09)

Isaac Sim 6.2 needs an RTX GPU with 16 GB of VRAM and 32 GB of RAM; your laptop has 6 GB of VRAM. For the one
or two days you need it:

1. Rent an instance with an **RTX-class GPU**: L4, L40S, A10G or RTX 6000 Ada. **Not A100 or H100**: they
   have no RT cores, and Isaac Sim does not support them. NVIDIA Brev, AWS, Azure and GCP all work
2. Ubuntu 24.04 with a current NVIDIA driver (Isaac Sim 6.2 was tested on 595.x)
3. Install Isaac Sim 6.2 following the [official workstation or container instructions](https://docs.isaacsim.omniverse.nvidia.com/latest/installation/index.html)
4. Stream the GUI to Windows with the Isaac Sim WebRTC streaming client, or run headless
5. Install ROS 2 Jazzy on the same instance for your external nodes (Nav2, your code)

Budget roughly $1–3 per hour, and **stop the instance when you finish**: idle GPUs cost the same as busy ones.

---

## Verify Everything

```bash
bash ~/Robotics/setup/check_lab.sh           # full check, including a live DDS test
bash ~/Robotics/setup/check_lab.sh --quick   # skip the live test
```

Exit code = number of failures. Warnings flag things later phases need; they never fail the run.

---

## Common Problems

**Gazebo window is black, flickers, or crashes on start.** Check Step 2 first (`glxinfo -B` must name
NVIDIA). Then try the older rendering engine: `gz sim -v4 shapes.sdf --render-engine ogre`. As a last resort
`export LIBGL_ALWAYS_SOFTWARE=1` works everywhere, but slowly; never leave it set.

**`ros2: command not found` in a new terminal.** `~/.bashrc` does not source `/opt/ros/jazzy/setup.bash`.

**`Package 'x' not found` after building.** You did not source the workspace: `source ~/ros2_ws/install/setup.bash`
(the `rb` helper does this for you).

**A Python node fails with `/usr/bin/env: 'python3\r'`.** The file has Windows line endings. `rpull` strips
them; `.gitattributes` keeps them out of git.

**Nodes cannot see each other.** Same `ROS_DOMAIN_ID` in both terminals? Same RMW? Is
`ROS_AUTOMATIC_DISCOVERY_RANGE` set to something restrictive? `ros2 daemon stop; ros2 daemon start` clears a
stale discovery cache.

**`rosdep update` fails or `apt update` shows key errors.** Re-run the repository step in Step 3 from the
official page; the ROS apt source package is updated when keys rotate.

**colcon builds the wrong Python or cannot find a module.** Deactivate any virtual environment before
`colcon build`; ROS packages build against the system Python.

**TF says "extrapolation into the future" between laptop and robot.** The clocks disagree. Install and enable
`chrony` on both machines.

**WSL uses all your RAM.** Lower `memory=` in `.wslconfig`, close RViz when you don't need it, and run Gazebo
headless (`-s`) for tests.
