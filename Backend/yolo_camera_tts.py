# yolo_camera_tts.py
import time
import numpy as np
import cv2
import pyttsx3
from ultralytics import YOLO

# --- config ---
MODEL_PATH = "yolov8n.pt"   # you already downloaded this
COOLDOWN_SEC = 2.5          # don't repeat same label for this many seconds
CAM_INDEX = 1               # default webcam index
# ---------------

print("Loading model... (this may take a second)")
model = YOLO(MODEL_PATH)
engine = pyttsx3.init()
cap = cv2.VideoCapture(CAM_INDEX)

if not cap.isOpened():
    print("❌ Camera not detected. Quit.")
    engine.say("Camera not detected")
    engine.runAndWait()
    raise SystemExit

last_spoken = {}  # label -> last spoken timestamp
print("Press 'q' in the window to quit.")

try:
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # Run YOLO on the current frame (returns a Results object list; take [0])
        res = model(frame)[0]

        labels = []
        # If any boxes detected, extract their class ids
        if hasattr(res, "boxes") and len(res.boxes) > 0:
            # res.boxes.cls is a tensor -> convert to numpy ints
            cls_ids = res.boxes.cls.cpu().numpy().astype(int)
            for cid in cls_ids:
                labels.append(model.names[int(cid)])  # model.names maps id->label

        # keep unique labels in detection order
        unique_labels = list(dict.fromkeys(labels))

        now = time.time()
        for lbl in unique_labels:
            last = last_spoken.get(lbl, 0)
            if now - last > COOLDOWN_SEC:
                print("Detected:", lbl)
                engine.say(lbl)
                engine.runAndWait()
                last_spoken[lbl] = now

        # draw annotated frame and show
        annotated = res.plot()          # annotated numpy image
        cv2.imshow("YOLOv8 Live", annotated)

        if cv2.waitKey(1) & 0xFF == ord("q"):
            break
finally:
    cap.release()
    cv2.destroyAllWindows()
