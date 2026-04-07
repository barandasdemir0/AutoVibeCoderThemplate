# 📚 Resources — YOLO CV
| Kaynak | Link |
|--------|------|
| Ultralytics YOLO | https://docs.ultralytics.com |
| Roboflow Universe | https://universe.roboflow.com |
| OpenCV | https://docs.opencv.org |
| CVAT | https://www.cvat.ai |
| Papers with Code - Detection | https://paperswithcode.com/task/object-detection |

## CLI Cheatsheet
```bash
pip install ultralytics
yolo detect train data=data.yaml model=yolov8n.pt epochs=100 imgsz=640
yolo detect val data=data.yaml model=best.pt
yolo detect predict model=best.pt source=images/ conf=0.5 save=True
yolo export model=best.pt format=onnx
```
