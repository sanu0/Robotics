# 07 — Perception and Vision: Cameras, 3D, Deep Learning, VSLAM, Isaac ROS

> **Weeks:** 2 (calendar Weeks 17–18 on Path A) · **Load:** ~16–18 h/week
> **Masterclass:** goes well beyond its "object detection" module; covers the skills behind its **camera calibration** and **vision-based café delivery** final projects
> **Stack:** OpenCV · `image_pipeline` · AprilTag · PCL/Open3D · Ultralytics YOLO + TensorRT · open-vocabulary detectors · RTAB-Map · Isaac ROS (NITROS, cuVSLAM, nvblox)
> **Phase project:** 🏆 **SeeAndServe**: hand-eye calibration, then a vision-guided pick handed to a delivery robot
> **Map:** [../README.md](../README.md)

Until now your robot has mostly seen the world as lidar ranges and fiducial tags. Real tasks need more: find
*the red mug*, work out where it is in 3D, and grasp it. This phase covers the full perception stack. Week 1
is cameras and 2D vision: the pinhole model, calibration, classical OpenCV, fiducials, and deep-learning
detectors running on your GPU. Week 2 is 3D: depth, point clouds, segmentation, object pose, visual SLAM,
and NVIDIA's GPU-accelerated Isaac ROS.

It ends by closing the loop with Phase 05: a calibrated camera finds a cup, the arm picks it, and a mobile
robot delivers it. That is the masterclass's café final project, built in your simulation.

## Can I Start Here?

| | |
|---|---|
| **Must have** | 02 (topics, launch, composition) and 03 (simulated cameras and depth cameras) |
| **Needs 05 for** | Week 2 Day 2 and the phase project (picking with MoveIt) |
| **GPU** | YOLO with TensorRT runs on your RTX laptop. Isaac ROS officially wants an 8 GB GPU on x86; your 6 GB card is best-effort, and the Jetson in Phase 08 is the real target |
| **Real cameras in WSL** | The default WSL kernel lacks USB webcam (UVC) drivers. Use simulated cameras and recorded bags here; real cameras run on the robot computer in Phase 08 |

## After This Phase, You Can

- [ ] Explain the pinhole camera model, intrinsics, distortion and extrinsics, and calibrate a camera
- [ ] Build OpenCV pipelines in ROS 2 with `cv_bridge` and `image_transport`
- [ ] Estimate poses from AprilTags/ArUco markers with `solvePnP`, and use them for localization and docking
- [ ] Train, export and accelerate a YOLO detector with TensorRT, and publish `vision_msgs` detections
- [ ] Use segmentation and open-vocabulary detection ("find the red mug") where they fit
- [ ] Process point clouds: filtering, plane segmentation, clustering, pose estimation, ICP
- [ ] Run and compare visual and lidar SLAM systems
- [ ] Explain Isaac ROS's NITROS zero-copy GPU pipeline and run an Isaac ROS package
- [ ] Calibrate a camera to an arm (hand-eye) and report the error

## Software

```bash
sudo apt install -y ros-jazzy-vision-opencv ros-jazzy-image-pipeline ros-jazzy-image-transport-plugins \
  ros-jazzy-apriltag-ros ros-jazzy-perception-pcl ros-jazzy-depthimage-to-laserscan \
  ros-jazzy-rtabmap-ros ros-jazzy-vision-msgs python3-open3d
```

Ultralytics and PyTorch go in a separate virtual environment (see SETUP.md Step 10). Isaac ROS runs in its
own Docker-based development environment. No hardware is required; a depth camera (see
[HARDWARE.md](../HARDWARE.md)) makes Week 2 more fun if you have one on the robot computer.

---

## Week 1 — Cameras and 2D Vision

### Day 1 — Camera Models and Calibration
- [ ] The pinhole model; the intrinsic matrix K; lens distortion; extrinsics; projection and back-projection
- [ ] `sensor_msgs/CameraInfo`; the `camera_calibration` tool with a checkerboard; rectification with `image_proc`
- [ ] Stereo in one lesson: disparity → depth
- [ ] **Code:** calibrate a simulated camera with a checkerboard in Gazebo, compare your intrinsics with the true values, then project 3D points into the image and check they land in the right pixels

### Day 2 — OpenCV in ROS 2
- [ ] `cv_bridge`, `image_transport` (raw vs compressed), colour spaces, thresholds, morphology, contours, edges, Hough lines
- [ ] Perspective transforms (bird's-eye view)
- [ ] **Code:** rebuild CityBot's lane follower properly, with a bird's-eye view and curve fitting

### Day 3 — Fiducials and Pose Estimation
- [ ] AprilTag and ArUco detection; `solvePnP`; the tag pose in the camera frame → TF
- [ ] Uses: docking, object pose, calibration targets, landmarks for localization
- [ ] **Code:** AprilTags on the walls of your simulated flat, fed as landmark observations into your Phase 06 EKF

### Day 4 — Deep-Learning Detection on Your GPU
- [ ] How modern detectors work, at the level a robot builder needs; Ultralytics YOLO; datasets and labelling
- [ ] Training on a small custom dataset (auto-labelled from simulation, or real photos); exporting to ONNX; building a TensorRT engine for your RTX GPU
- [ ] `vision_msgs/Detection2DArray`; a detection node; FPS and latency on CPU vs GPU
- [ ] **Code:** detect cups and boxes in Gazebo camera images, publish detections, and measure frame rate

### Day 5 — Segmentation and Foundation Models
- [ ] Semantic vs instance segmentation; Segment Anything (promptable masks); open-vocabulary detection (Grounding DINO, OWLv2, YOLO-World); CLIP
- [ ] Classical vs learned perception: accuracy, latency and failure modes on a robot
- [ ] **Code:** "find the red mug": open-vocabulary detection → a 2D box, ready to lift into 3D tomorrow

### 🔨 Saturday — TagNav + Detect
- [ ] The robot localizes with AprilTags around the flat while it navigates
- [ ] It detects objects as it drives and drops them on the map as labelled markers: a semantic object map
- [ ] Query it: "where did you last see a cup?"

### 📄 Sunday
- [ ] Szeliski, [*Computer Vision: Algorithms and Applications*](https://szeliski.org/Book/) (2nd ed., free), chapter 2 (image formation) and the calibration chapter
- [ ] Cyrill Stachniss, photogrammetry lectures on the camera model (YouTube)

---

## Week 2 — 3D Perception, SLAM, and GPU Acceleration

### Day 1 — Depth and Point Clouds
- [ ] Depth sensing: stereo, time-of-flight, structured light; strengths and failure cases
- [ ] Depth image → point cloud; `sensor_msgs/PointCloud2`; PCL and Open3D basics: voxel grid, pass-through, outlier removal, normals
- [ ] **Code:** a point cloud from the simulated depth camera, filtered in a C++ PCL node

### Day 2 — 3D Segmentation and Object Pose
- [ ] RANSAC plane segmentation (the table), Euclidean clustering, centroids and oriented bounding boxes (PCA), ICP registration; 6D pose estimation (FoundationPose, conceptually)
- [ ] From an object cluster to a grasp pose
- [ ] **Code:** table-top segmentation → object poses as TF frames → a MoveIt pick (closing the loop with Phase 05)

### Day 3 — Visual and Lidar SLAM
- [ ] Visual odometry: features, the essential matrix, PnP, bundle adjustment intuitively; visual-inertial odometry
- [ ] VSLAM systems (ORB-SLAM3, RTAB-Map); 3D lidar SLAM and odometry (KISS-ICP, FAST-LIO2 and LIO-SAM, conceptually)
- [ ] **Code:** RTAB-Map with your robot's simulated RGB-D camera; compare its map with slam_toolbox's

### Day 4 — GPU-Accelerated Perception with Isaac ROS
- [ ] NITROS: type adaptation and negotiation that keep images on the GPU between nodes
- [ ] cuVSLAM (visual SLAM), nvblox (3D reconstruction and a costmap for Nav2), DNN inference with TensorRT/Triton, FoundationPose
- [ ] Platform reality: Isaac ROS 4.6 targets Jazzy on Jetson (JetPack 7.2) and on x86 with an Ampere-or-newer GPU
- [ ] **Code:** run one Isaac ROS package (AprilTag or cuVSLAM on a recorded bag) in its Docker environment on your laptop. If 6 GB of VRAM is not enough, note it and run it on the Jetson in Phase 08

### Day 5 — Perception Engineering
- [ ] Synchronisation (`message_filters` approximate time), latency and throughput budgets, zero-copy composition, compressed transport over Wi-Fi
- [ ] Datasets: collection, labelling tools (CVAT, Label Studio), synthetic data from simulation, evaluation (precision/recall, mAP, pose error)
- [ ] **Code:** a composed perception pipeline with timing instrumentation at every stage, and an auto-labelled dataset recorded from simulation

### 🏆 Saturday + Sunday — Phase Project: SeeAndServe
See the brief below. Sunday reading this week:
- [ ] Campos et al., "ORB-SLAM3" (2021), or Vizzo et al., "KISS-ICP" (2023), a short and readable paper

---

## 🏆 Phase Project — SeeAndServe: Calibrate, See, Pick, Deliver

**What:** two of the masterclass's final projects combined, in your simulation:

1. **Hand-eye calibration:** calibrate a depth camera to the arm (eye-to-hand) using a calibration board
   moved by the arm, and report the calibration error in millimetres
2. **Vision-based café delivery:** the camera finds a cup (YOLO or open-vocabulary detection plus depth),
   computes a grasp, the arm picks it with MoveIt and places it on a mobile robot's tray, and the mobile
   robot delivers it to a table with Nav2

**Deliverables:**
- [ ] Calibration procedure and error report
- [ ] Perception → grasp → pick → hand-over → delivery, started from one launch command
- [ ] Success rate over 20 runs, with cup positions varied
- [ ] Latency budget of the perception pipeline (stage by stage)
- [ ] Demo video; the perception package graduates into `my_robot/src/<name>_perception`

**Skills used:** 07, 05 (MoveIt, MTC), 04 (Nav2), 03 (sim sensors), 02 (composition). **Evidence:** calibration error, success rate, latency table.

---

## ✅ Gate

- [ ] Explain the pinhole model and calibrate a camera, reporting reprojection error
- [ ] Build an OpenCV pipeline in ROS 2 that runs at camera rate
- [ ] Train, export and run a detector with TensorRT, and report FPS
- [ ] Segment a table-top scene and produce object poses as TF frames
- [ ] Run a VSLAM system and explain what makes it lose tracking
- [ ] Explain how NITROS avoids CPU copies between nodes
- [ ] SeeAndServe succeeds in at least 16 of 20 runs

## This Folder

```text
theory/Week_1/Day_1.md      <->   codes/Week_1/Day_1/
theory/Week_1/Saturday.md   <->   codes/Week_1/Saturday/
theory/Phase_Project.md     <->   codes/Phase_Project/SeeAndServe/
```

Lessons are generated one day at a time; ask for **"P07·W1·D1"**.

## Resources

- Szeliski, *Computer Vision: Algorithms and Applications*, 2nd ed. (free online)
- [OpenCV tutorials](https://docs.opencv.org/4.x/d9/df8/tutorial_root.html) and the [image_pipeline docs](https://docs.ros.org/en/jazzy/p/image_pipeline/)
- [Ultralytics documentation](https://docs.ultralytics.com/) (training, export, TensorRT)
- [Isaac ROS documentation](https://nvidia-isaac-ros.github.io/) (release 4.6)
- [Open3D tutorials](https://www.open3d.org/docs/release/) and the PCL tutorials
- Hartley & Zisserman, *Multiple View Geometry in Computer Vision*: the reference, not a first read
