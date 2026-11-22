# setup/ — Lab Scripts

Three scripts that every phase relies on. The full lab build is in [`../SETUP.md`](../SETUP.md); this page
explains how code moves between Windows and WSL.

| Script | Direction | What it does |
|---|---|---|
| `sync_from_repo.sh` | repo → WSL | Copies `setup/`, `my_robot/` and every phase's `codes/` into `~/Robotics`, strips CRLF, restores `+x` |
| `sync_to_repo.sh` | WSL → repo | Copies the same trees back so you can commit; skips build output, bags, weights, videos and files over 20 MB |
| `check_lab.sh` | read-only | Verifies OS, ROS 2 Jazzy, Gazebo, GPU, toolchain and environment, then runs a live talker → subscriber test. Exit code = number of failures |

## Three locations, deliberately

| Location | Role |
|---|---|
| `Robotics/` on Windows (OneDrive, in git) | The version-controlled copy: theory, code, notes. What you commit and push |
| `~/Robotics/` inside WSL | Where code is **built and run**. Same relative paths as the repo, code trees only |
| `~/ros2_ws/` inside WSL | The colcon workspace: `build/`, `install/`, `log/`. Never committed, safe to delete |

Building on `/mnt/c/...` is several times slower, NTFS drops the executable bit and the symlinks that
`colcon build --symlink-install` creates, and OneDrive would try to upload every build artifact. So the
repo stays on Windows, and these scripts bridge it to WSL.

```text
02_ROS2_Core/codes/Week_5/Day_3/          (Windows repo, edited in Cursor)
        │  rpull  = sync_from_repo.sh
        ▼
~/Robotics/02_ROS2_Core/codes/Week_5/Day_3/   (WSL working copy)
        │  rb 02_ROS2_Core/codes/Week_5/Day_3
        ▼
~/ros2_ws/build + install                 (colcon output, sourced automatically by rb)
```

Both sync scripts use **newer file wins** (`rsync --update`): whichever side you edited most recently is kept,
and neither script ever deletes anything. Remove files from the repo yourself with `git rm`.

## First time (before the scripts exist inside WSL)

```bash
# In ~/.bashrc first (SETUP.md Step 6 has the full block). Keep the quotes: the path has spaces.
export ROBOTICS_REPO="/mnt/c/Users/<you>/<path-to>/SKILL/Robotics"

mkdir -p ~/Robotics ~/ros2_ws
cp -r "$ROBOTICS_REPO/setup" ~/Robotics/
sed -i 's/\r$//' ~/Robotics/setup/*.sh
bash ~/Robotics/setup/sync_from_repo.sh
bash ~/Robotics/setup/check_lab.sh
```

## Daily use

```bash
rpull                                      # repo -> WSL
rb 02_ROS2_Core/codes/Week_5/Day_3         # build that day's packages and source them
ros2 run ...                               # work, break things, fix them
rpush                                      # WSL -> repo, then commit from Windows
```

Prefer editing inside WSL? Open `~/Robotics` in Cursor through its WSL connection, and run `rpush` before
you commit. Either way works; just pick one side as "where I edit" per session.

## Why `rb` builds one folder at a time

Each day's folder can contain packages with the same names as another day's (Day 3's `turtle_tools` is a
newer version of Day 2's). Two things would break if everything were built together: colcon refuses duplicate
package names within one build, and CMake refuses to reuse a build directory that was configured for a
different source folder. So `rb`:

- passes `--base-paths` for just the folder you name
- gives that folder its own build directory, `~/ros2_ws/build/<folder_path_with_underscores>/`
- installs into the one shared `~/ros2_ws/install/`, so a later day can still use an earlier day's packages
  (if two days have a package with the same name, the one you built last is the one installed)

To clean one folder's build: `rm -rf ~/ros2_ws/build/<that_folder>`. To start completely fresh:
`rm -rf ~/ros2_ws/build ~/ros2_ws/install ~/ros2_ws/log`, then rebuild what you need.

Code you keep using across phases graduates into [`../my_robot/`](../my_robot/README.md), which is built as
one workspace: `rb my_robot`.
