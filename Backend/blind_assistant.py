import cv2
import pyttsx3
from vosk import Model, KaldiRecognizer
import pyaudio
from ultralytics import YOLO
import json
import os

# Load YOLO model
yolo_model = YOLO("yolov8n.pt")

# Load TTS engine
engine = pyttsx3.init()

def speak(text):
    engine.say(text)
    engine.runAndWait()

# Load VOSK model
vosk_path = os.path.join("models", "vosk-model-small-en-us-0.15")
if not os.path.exists(vosk_path):
    print("Vosk model not found!")
    exit()

model = Model(vosk_path)
recognizer = KaldiRecognizer(model, 16000)

# Setup mic
mic = pyaudio.PyAudio()
stream = mic.open(rate=16000, channels=1, format=pyaudio.paInt16, input=True, frames_per_buffer=4096)
stream.start_stream()

def detect_objects():
    cap = cv2.VideoCapture(0)
    ret, frame = cap.read()
    if not ret:
        return []
    results = yolo_model(frame)
    detected = []
    for box in results[0].boxes.cls:
        cls_id = int(box)
        detected.append(results[0].names[cls_id])
    cap.release()
    return detected

print("Listening... say 'what's in front of me'")

while True:
    data = stream.read(4096, exception_on_overflow=False)
    if recognizer.AcceptWaveform(data):
        result = json.loads(recognizer.Result())
        command = result.get("text", "").lower()

        if "what's in front of me" in command:
            objects = detect_objects()
            if objects:
                speak("I see " + ", ".join(objects))
            else:
                speak("I cannot detect anything.")
