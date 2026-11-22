# 07 — Perception and Vision: Cameras, Detection, 3D, SLAM, Isaac ROS

> **Where it sits:** Month 5 · Week 19
> **The plan (tick boxes there):** [Week 19](../README.md#week-19) · [✅ Phase 07 gate](../README.md#gate-07)
> **Projects:** 🔨 TagNav + Detect (Week 19) · 🏆 [SeeAndServe](../README.md#m5-project-b) (Month 5 Project B, Buffer Week 20)
> **Stack:** OpenCV · `image_pipeline` · AprilTag · PCL/Open3D · Ultralytics YOLO + TensorRT · open-vocabulary detectors · RTAB-Map · Isaac ROS (NITROS, cuVSLAM, nvblox)
> **Map:** [../README.md](../README.md)

Until now your robot has mostly seen the world as lidar ranges and fiducial tags. Real tasks need more: find
*the red mug*, work out where it is in 3D, and grasp it. This week covers the perception stack end to end:
the pinhole model and calibration, OpenCV, fiducials and hand-eye calibration, deep-learning detectors
accelerated on your GPU, point clouds and 3D object pose, visual SLAM, and NVIDIA's Isaac ROS.

It is one dense week, and the depth comes from Buffer Week 20, where SeeAndServe closes the loop with
manipulation: a calibrated camera finds a cup, the arm picks it, and a mobile robot delivers it.

## Can I Start Here?

| | |
|---|---|
| **Must have** | Weeks 5–7 (topics, launch, composition) and Weeks 9–10 (simulated cameras and depth cameras) |
| **Needs Week 15 for** | Day 4's pick, and SeeAndServe (picking with MoveIt) |
| **GPU** | YOLO with TensorRT runs on your RTX laptop. Isaac ROS officially wants an 8 GB GPU on x86; your 6 GB card is best-effort, and a Jetson in Week 22 is the real target |
| **Real cameras in WSL** | WSL's default kernel lacks USB webcam drivers. Use simulated cameras and recorded bags here; real cameras run on the robot computer in Week 22 |

## What You Will Be Able To Do

- Explain the pinhole camera model, intrinsics, distortion and extrinsics, and calibrate a camera
- Build OpenCV pipelines in ROS 2 with `cv_bridge` and `image_transport`
- Estimate poses from AprilTags/ArUco markers with `solvePnP`, and use them for localization and docking
- Explain hand-eye calibration and measure its error
- Train, export and accelerate a YOLO detector with TensorRT, and publish `vision_msgs` detections
- Use segmentation and open-vocabulary detection where they fit
- Process point clouds: filtering, plane segmentation, clustering, pose estimation, ICP
- Run a visual SLAM system and explain Isaac ROS's NITROS zero-copy GPU pipeline

## Software

```bash
sudo apt install -y ros-jazzy-vision-opencv ros-jazzy-image-pipeline ros-jazzy-image-transport-plugins \
  ros-jazzy-apriltag-ros ros-jazzy-perception-pcl ros-jazzy-depthimage-to-laserscan \
  ros-jazzy-rtabmap-ros ros-jazzy-vision-msgs python3-open3d
```

Ultralytics and PyTorch go in a separate virtual environment (SETUP.md Step 10). Isaac ROS runs in its own
Docker-based development environment (SETUP.md Step 11). No hardware required.

## This Folder

```text
theory/Week_19/Day_1.md            <->   codes/Week_19/Day_1/
theory/Week_19/Saturday.md         <->   codes/Week_19/Saturday/
theory/Projects/SeeAndServe.md     <->   codes/Projects/SeeAndServe/
```

Lessons are generated one day at a time: ask for **"M5W19D1"**. The perception package graduates into
[`../my_robot/`](../my_robot/README.md) as `<name>_perception`.

## Resources

- Szeliski, *Computer Vision: Algorithms and Applications*, 2nd ed. (free online)
- [OpenCV tutorials](https://docs.opencv.org/4.x/d9/df8/tutorial_root.html) and the [image_pipeline docs](https://docs.ros.org/en/jazzy/p/image_pipeline/)
- [Ultralytics documentation](https://docs.ultralytics.com/) (training, export, TensorRT)
- [Isaac ROS documentation](https://nvidia-isaac-ros.github.io/) (release 4.6)
- [Open3D tutorials](https://www.open3d.org/docs/release/) and the PCL tutorials
- Hartley & Zisserman, *Multiple View Geometry in Computer Vision*: the reference, not a first read
