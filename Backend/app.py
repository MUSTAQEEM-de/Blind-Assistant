# app.py
import time
import numpy as np
import cv2
from flask import Flask, request, jsonify
from flask_cors import CORS
from ultralytics import YOLO

# Path to your model file present in folder (yolov8n.pt)
MODEL_PATH = "yolov8n.pt"

app = Flask(__name__)
CORS(app)

# Load YOLO model once (takes time at startup)
print("Loading YOLO model... (this may take 10-30s on CPU)")
model = YOLO(MODEL_PATH)
print("Model loaded.")

def detect_frame(frame, conf_thresh=0.35):
    """
    Run YOLO detection on a single BGR numpy frame (OpenCV format).
    Returns list of detections: {label, confidence, xyxy}
    """
    results = model(frame)[0]  # first result
    boxes = getattr(results, "boxes", None)
    if boxes is None:
        return []

    # Convert to numpy arrays (works whether tensors or already numpy)
    try:
        xyxy = boxes.xyxy.cpu().numpy()
        confs = boxes.conf.cpu().numpy()
        clss = boxes.cls.cpu().numpy()
    except Exception:
        # fallback
        xyxy = np.array(boxes.xyxy)
        confs = np.array(boxes.conf)
        clss = np.array(boxes.cls)

    detections = []
    for i in range(len(confs)):
        if confs[i] < conf_thresh:
            continue
        cls_idx = int(clss[i])
        # model.names is usually a dict mapping index -> name
        label = model.names.get(cls_idx, str(cls_idx)) if isinstance(model.names, dict) else model.names[cls_idx]
        detections.append({
            "label": str(label),
            "confidence": float(confs[i]),
            "xyxy": [float(x) for x in xyxy[i].tolist()]
        })
    return detections

def grab_frame_from_camera(camera_index=0, warmup=0.4):
    cap = cv2.VideoCapture(camera_index, cv2.CAP_DSHOW) if cv2.__version__.startswith('4') else cv2.VideoCapture(camera_index)
    if not cap.isOpened():
        return None, "Cannot open camera"
    # small warmup delay
    time.sleep(warmup)
    ret, frame = cap.read()
    cap.release()
    if not ret:
        return None, "Failed to read frame from camera"
    return frame, None

@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "model": MODEL_PATH})

@app.route("/detect", methods=["POST"])
def detect():
    """
    POST JSON:
    {
      "mode": "objects" | "person" | "currency"    # 'mode' is optional
    }
    Response:
    {
      "detections": [ {label, confidence, xyxy}, ... ]
    }
    """
    data = request.get_json(silent=True) or {}
    mode = data.get("mode", "objects")

    frame, err = grab_frame_from_camera()
    if err:
        return jsonify({"error": err}), 500

    detections = detect_frame(frame, conf_thresh=0.35)

    # simple filtering by mode
    if mode == "person":
        detections = [d for d in detections if d["label"].lower() == "person"]
    elif mode == "currency":
        # If you use a custom currency detection model, adjust keywords below.
        detections = [d for d in detections if any(k in d["label"].lower() for k in ("note", "coin", "rupee", "currency"))]

    return jsonify({"detections": detections})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
