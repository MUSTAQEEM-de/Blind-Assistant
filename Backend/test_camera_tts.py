import cv2
import pyttsx3

# Initialize TTS engine
engine = pyttsx3.init()

# Start camera
cap = cv2.VideoCapture(0)

if not cap.isOpened():
    print("❌ Camera not detected")
    engine.say("Camera not detected")
    engine.runAndWait()
else:
    print("✅ Camera opened successfully")
    engine.say("Camera opened successfully")
    engine.runAndWait()

# Release camera
cap.release()
cv2.destroyAllWindows()
