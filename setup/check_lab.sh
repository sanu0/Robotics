#!/usr/bin/env bash
# check_lab.sh — verify the whole robotics lab in one command.
#
# Exit code = number of FAILED checks, so 0 means the lab is ready. WARN lines never fail the
# run; they flag things a later phase will need.
#
# Usage:
#   bash ~/Robotics/setup/check_lab.sh           # everything, including a live DDS test (~15 s)
#   bash ~/Robotics/setup/check_lab.sh --quick   # skip the live test
#
# Read-only: it installs nothing and changes nothing.

set -uo pipefail

QUICK=0
[[ "${1:-}" == "--quick" ]] && QUICK=1

if [[ -t 1 ]]; then
  G=$'\e[32m'; Y=$'\e[33m'; R=$'\e[31m'; B=$'\e[1m'; N=$'\e[0m'
else
  G=""; Y=""; R=""; B=""; N=""
fi

FAILS=0
WARNS=0
pass()    { printf '  %sPASS%s  %s\n' "$G" "$N" "$1"; }
warn()    { printf '  %sWARN%s  %s\n' "$Y" "$N" "$1"; WARNS=$((WARNS + 1)); }
fail()    { printf '  %sFAIL%s  %s\n' "$R" "$N" "$1"; FAILS=$((FAILS + 1)); }
hint()    { printf '        -> %s\n' "$1"; }
section() { printf '\n%s%s%s\n' "$B" "$1" "$N"; }
have()    { command -v "$1" > /dev/null 2>&1; }

# version_ge A B: true when dotted version A >= B
version_ge() { [[ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" == "$2" ]]; }

# ───────────────────────────────────────────────────────────────────
section "1. Platform"
IN_WSL=0
if grep -qi microsoft /proc/version 2> /dev/null; then
  IN_WSL=1
  pass "Running inside WSL2"
else
  pass "Running on native Linux"
fi

if [[ -r /etc/os-release ]]; then
  OS_CODENAME=$(. /etc/os-release && echo "${VERSION_CODENAME:-}")
  OS_PRETTY=$(. /etc/os-release && echo "${PRETTY_NAME:-unknown}")
  if [[ "$OS_CODENAME" == "noble" ]]; then
    pass "$OS_PRETTY (noble): the Tier 1 platform for ROS 2 Jazzy"
  else
    fail "OS is $OS_PRETTY; this roadmap needs Ubuntu 24.04 (noble)"
    hint "SETUP.md Step 1: create a dedicated Ubuntu-24.04 WSL distro"
  fi
fi

mem_gb=$(awk '/MemTotal/ {printf "%d", $2/1024/1024}' /proc/meminfo)
if (( mem_gb >= 12 )); then
  pass "Memory visible to Linux: ${mem_gb} GB"
else
  warn "Only ${mem_gb} GB RAM visible; Gazebo + Nav2 + RViz want 12 GB or more"
  hint "Raise memory= in %USERPROFILE%\\.wslconfig (SETUP.md Step 1)"
fi

disk_gb=$(df -BG --output=avail "$HOME" | tail -n1 | tr -dc '0-9')
if (( disk_gb >= 40 )); then
  pass "Free disk in \$HOME: ${disk_gb} GB"
else
  warn "Only ${disk_gb} GB free in \$HOME; plan on 40 GB+ for ROS, simulators, bags and datasets"
fi

# ───────────────────────────────────────────────────────────────────
section "2. Repo and working copy"
ROBOTICS_HOME="${ROBOTICS_HOME:-$HOME/Robotics}"
if [[ -n "${ROBOTICS_REPO:-}" && -d "${ROBOTICS_REPO}" ]]; then
  pass "ROBOTICS_REPO points at the Windows repo"
elif [[ -n "${ROBOTICS_REPO:-}" ]]; then
  fail "ROBOTICS_REPO is set but does not exist: ${ROBOTICS_REPO}"
  hint "Fix the path in ~/.bashrc and keep the quotes; the OneDrive path has spaces"
else
  fail "ROBOTICS_REPO is not set"
  hint "SETUP.md Step 6"
fi

case "$ROBOTICS_HOME" in
  /mnt/*)
    fail "ROBOTICS_HOME is on the Windows drive ($ROBOTICS_HOME): builds there are slow and break symlinks"
    hint "Use \$HOME/Robotics"
    ;;
  *)
    if [[ -d "$ROBOTICS_HOME/setup" ]]; then
      pass "Working copy at $ROBOTICS_HOME"
    else
      fail "No working copy at $ROBOTICS_HOME"
      hint "bash \"\$ROBOTICS_REPO/setup/sync_from_repo.sh\" (SETUP.md Step 6)"
    fi
    ;;
esac

if [[ -d "$HOME/ros2_ws" ]]; then
  pass "Build workspace ~/ros2_ws exists"
else
  warn "No ~/ros2_ws yet"
  hint "mkdir -p ~/ros2_ws"
fi

# ───────────────────────────────────────────────────────────────────
section "3. ROS 2 Jazzy"
if [[ -f /opt/ros/jazzy/setup.bash ]]; then
  pass "/opt/ros/jazzy is installed"
  # ROS setup scripts read unset variables, so relax -u while sourcing.
  set +u
  # shellcheck disable=SC1091
  source /opt/ros/jazzy/setup.bash
  set -u
  if [[ "${ROS_DISTRO:-}" == "jazzy" ]]; then
    pass "ROS_DISTRO=jazzy after sourcing"
  else
    fail "ROS_DISTRO is '${ROS_DISTRO:-unset}' after sourcing /opt/ros/jazzy/setup.bash"
  fi
else
  fail "ROS 2 Jazzy is not installed (/opt/ros/jazzy missing)"
  hint "SETUP.md Step 3"
fi

if grep -qs 'source /opt/ros/jazzy/setup.bash' "$HOME/.bashrc"; then
  pass "~/.bashrc sources Jazzy"
else
  warn "~/.bashrc does not source /opt/ros/jazzy/setup.bash; new terminals will say 'ros2: command not found'"
fi

if have ros2; then
  pass "ros2 CLI on PATH"
else
  fail "ros2 CLI not found"
fi

for tool in colcon rosdep vcs; do
  if have "$tool"; then
    pass "$tool installed"
  else
    fail "$tool missing"
    hint "sudo apt install ros-dev-tools"
  fi
done

if compgen -G "/etc/ros/rosdep/sources.list.d/*.list" > /dev/null; then
  pass "rosdep initialised"
else
  fail "rosdep not initialised"
  hint "sudo rosdep init && rosdep update"
fi
if [[ -d "$HOME/.ros/rosdep/sources.cache" ]]; then
  pass "rosdep database downloaded"
else
  warn "rosdep database not downloaded yet"
  hint "rosdep update"
fi

if have ros2; then
  for pkg in demo_nodes_cpp demo_nodes_py turtlesim rviz2; do
    if ros2 pkg prefix "$pkg" > /dev/null 2>&1; then
      pass "package $pkg"
    else
      fail "package $pkg missing"
      hint "sudo apt install ros-jazzy-desktop"
    fi
  done
fi

# ───────────────────────────────────────────────────────────────────
section "4. Gazebo Harmonic"
if have gz; then
  gzv=$(gz sim --versions 2> /dev/null | head -n1 | tr -d '[:space:]')
  if [[ "$gzv" == 8.* ]]; then
    pass "gz sim $gzv (Harmonic)"
  elif [[ -n "$gzv" ]]; then
    warn "gz sim $gzv; ROS 2 Jazzy pairs with Gazebo Harmonic (8.x)"
  else
    fail "gz is installed but 'gz sim --versions' printed nothing"
  fi
else
  fail "Gazebo not found"
  hint "sudo apt install ros-jazzy-ros-gz"
fi

if have ros2 && ros2 pkg prefix ros_gz_bridge > /dev/null 2>&1; then
  pass "ros_gz bridge installed"
else
  fail "ros_gz_bridge missing"
  hint "sudo apt install ros-jazzy-ros-gz"
fi

# ───────────────────────────────────────────────────────────────────
section "5. Graphics and GPU"
if have nvidia-smi; then
  gpu=$(nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader 2> /dev/null | head -n1)
  if [[ -n "$gpu" ]]; then
    pass "NVIDIA GPU visible: $gpu"
  else
    warn "nvidia-smi exists but returned nothing"
  fi
else
  warn "nvidia-smi not found; CUDA work in Weeks 19 and 23 needs the GPU visible in Linux"
  if (( IN_WSL == 1 )); then
    hint "In WSL it comes from the Windows driver (/usr/lib/wsl/lib). Never install a Linux NVIDIA driver inside WSL"
  fi
fi

if have glxinfo; then
  if [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
    renderer=$(glxinfo -B 2> /dev/null | sed -n 's/^OpenGL renderer string: //p')
    case "$renderer" in
      *NVIDIA*)
        pass "OpenGL renderer: $renderer"
        ;;
      *llvmpipe* | *softpipe*)
        fail "OpenGL is software-rendered ($renderer); Gazebo will crawl"
        hint "SETUP.md Step 2"
        ;;
      "")
        warn "Could not read the OpenGL renderer string"
        ;;
      *)
        warn "OpenGL renderer is not the NVIDIA GPU: $renderer"
        hint "export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA (SETUP.md Step 2)"
        ;;
    esac
  else
    warn "No DISPLAY: GUI apps (RViz, Gazebo) cannot open from this shell"
  fi
else
  warn "glxinfo not installed, so the GPU renderer cannot be checked"
  hint "sudo apt install mesa-utils"
fi

# ───────────────────────────────────────────────────────────────────
section "6. Build toolchain"
if have g++; then
  gv=$(g++ -dumpfullversion 2> /dev/null || g++ -dumpversion)
  if version_ge "$gv" 13; then
    pass "g++ $gv (C++20 ready)"
  else
    warn "g++ $gv; Weeks 1-3 assume GCC 13 or newer"
  fi
else
  fail "g++ missing"
  hint "sudo apt install build-essential"
fi

if have cmake; then
  cv=$(cmake --version | head -n1 | awk '{print $3}')
  if version_ge "$cv" 3.22; then
    pass "cmake $cv"
  else
    warn "cmake $cv is old"
  fi
else
  fail "cmake missing"
  hint "sudo apt install cmake"
fi

if have python3; then
  pv=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
  if [[ "$pv" == 3.12.* ]]; then
    pass "python3 $pv"
  else
    warn "python3 $pv; ROS 2 Jazzy on Ubuntu 24.04 uses Python 3.12"
  fi
else
  fail "python3 missing"
fi

for tool in git rsync; do
  if have "$tool"; then
    pass "$tool installed"
  else
    fail "$tool missing"
    hint "sudo apt install $tool"
  fi
done

if have ccache; then
  pass "ccache installed"
else
  warn "ccache not installed; C++ rebuilds will be slower"
  hint "sudo apt install ccache"
fi

# ───────────────────────────────────────────────────────────────────
section "7. Environment"
if [[ -n "${ROS_DOMAIN_ID:-}" ]]; then
  pass "ROS_DOMAIN_ID=$ROS_DOMAIN_ID"
else
  warn "ROS_DOMAIN_ID is unset, so it defaults to 0, shared with every other ROS user on your network"
  hint "export ROS_DOMAIN_ID=42 in ~/.bashrc (SETUP.md Step 6)"
fi
printf '        RMW in use: %s\n' "${RMW_IMPLEMENTATION:-rmw_fastrtps_cpp (default)}"

if (( IN_WSL == 1 )); then
  if [[ -n "${MESA_D3D12_DEFAULT_ADAPTER_NAME:-}" ]]; then
    pass "MESA_D3D12_DEFAULT_ADAPTER_NAME=$MESA_D3D12_DEFAULT_ADAPTER_NAME"
  else
    warn "MESA_D3D12_DEFAULT_ADAPTER_NAME is unset; WSLg may render on the Intel iGPU"
    hint "SETUP.md Step 2"
  fi
fi

if grep -qs '^rb()' "$HOME/.bashrc"; then
  pass "rb build helper defined in ~/.bashrc"
else
  warn "rb build helper not found in ~/.bashrc"
  hint "SETUP.md Step 6"
fi

# ───────────────────────────────────────────────────────────────────
if (( QUICK == 0 )) && have ros2; then
  section "8. Live test: a C++ talker reaches a Python subscriber over DDS"
  talker_prefix=$(ros2 pkg prefix demo_nodes_cpp 2> /dev/null || true)
  if [[ -x "$talker_prefix/lib/demo_nodes_cpp/talker" ]]; then
    # Run the executable directly (not via `ros2 run`) so the PID we kill is the talker itself.
    "$talker_prefix/lib/demo_nodes_cpp/talker" > /dev/null 2>&1 &
    talker_pid=$!
    trap 'kill "$talker_pid" 2> /dev/null' EXIT
    msg=$(timeout 15 ros2 topic echo --once /chatter std_msgs/msg/String 2> /dev/null \
            | sed -n 's/^data: //p' | head -n1)
    kill "$talker_pid" 2> /dev/null
    wait "$talker_pid" 2> /dev/null
    trap - EXIT
    if [[ -n "$msg" ]]; then
      pass "Received: $msg"
    else
      fail "No message on /chatter within 15 s"
      hint "Check ROS_DOMAIN_ID and ROS_AUTOMATIC_DISCOVERY_RANGE, then run 'ros2 doctor --report'"
    fi
  else
    fail "demo_nodes_cpp talker not found"
    hint "sudo apt install ros-jazzy-desktop"
  fi
fi

# ───────────────────────────────────────────────────────────────────
section "Summary"
if (( FAILS == 0 )); then
  printf '  %sLab ready.%s %d warning(s); warnings are for later phases.\n' "$G" "$N" "$WARNS"
else
  printf '  %s%d check(s) failed%s, %d warning(s). Fix the FAILs from the top; later ones often disappear.\n' \
    "$R" "$FAILS" "$N" "$WARNS"
fi
exit "$FAILS"
