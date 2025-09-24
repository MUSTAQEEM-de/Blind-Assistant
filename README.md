# Blind Assistant 👁️‍🗨️

An AI-powered assistive system for **visually impaired people**.  
It uses a **camera + AI (YOLO)** for object/currency/person detection, **Vosk** for voice commands, and **Text-to-Speech** to guide the user.  
The mobile app (Flutter) connects with a Python backend (Flask API).

---

## ✨ Features
- Detects **objects, people, and obstacles**  
- Recognizes **Indian currency notes and coins**  
- Fully **voice-controlled** (no dropdowns needed)  
- Speaks out results using **Text-to-Speech**  
- Flutter app for a clean mobile interface  

---

## 📂 Project Structure
Blind Assistant/
│
├── Backend/ # Flask + YOLO + Vosk + TTS
├── Frontend/ # Entire Flutter project
├── docs/ # Screenshots, diagrams, demo
├── .gitignore
├── LICENSE
└── README.md
---

## ⚡ How to Run

### Backend (Python + Flask)
```bash
cd Backend
python -m venv venv
venv\Scripts\activate   # On Windows
source venv/bin/activate  # On Mac/Linux

pip install -r requirements.txt
python app.py
Backend runs at: http://127.0.0.1:5000

Frontend (Flutter)
bash
Copy code
cd Frontend
flutter pub get
flutter run
📸 Demo
Add screenshots or a short demo video here.

🚀 Tech Stack
Python (Flask, YOLO, Vosk, Pyttsx3, OpenCV)

Flutter (Dart)

📌 Future Plans
Add outdoor navigation with GPS

Multi-language voice commands

Support for edge devices (e.g., Raspberry Pi)