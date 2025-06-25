# ⏰ Tick Clock - Chat App

A simple, real-time chat application built with **Flutter** and **Firebase**, supporting push notifications, user authentication, and a smooth, modern UI.

[Download for Android](https://drive.google.com/file/d/1X53C5jfdAiUASWiD6YCPBPRS20UAQOW4/view?usp=drive_link)**

---

## 📱 Frontend - Flutter

The mobile app is built using:

- **Flutter** (Dart)
- **Firebase Authentication** (Email/Password login)
- **Cloud Firestore** (Chat messages, user data)
- **Firebase Cloud Messaging (FCM)** (Push notifications)
- **GoRouter** (Navigation management)
- **Provider** (State management for themes)
- **Custom Animations** (Page transitions)
- **Local Storage** (SharedPreferences for settings)
- **Material Design UI**

---

## 🛠️ Backend - Node.js FCM Server

A minimal Node.js server acts as a relay to send FCM notifications securely.

**Tech Stack:**

- **Node.js**
- **Express.js**
- **Google Auth Library** (for secure access to FCM HTTP v1 API)
- **dotenv** (for managing private keys and secrets)
- **Deployed on Render**

**Purpose:**

✅ Keeps FCM server keys hidden from the mobile app  
✅ Allows sending custom notification payloads  
✅ Easy integration with Flutter via HTTP POST request  

---

## ☁️ Firebase Services Used

- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Cloud Messaging (HTTP v1)**
- **Firebase Console** (Project & Credentials management)

---

## 🚀 Deployment

- **Frontend:** Built with Flutter, APK distributed via Google Drive  
- **Backend:** Node.js server deployed to **Render.com**, accessible via HTTPS  

---

## 🔒 Security Notes

- FCM notifications are triggered from the backend server to avoid exposing sensitive keys in the mobile app.  
- Service Account keys are securely stored as environment variables on Render.  

---

## 💡 Optional Improvements

- Convert Node.js server to **Firebase Cloud Functions** for a fully serverless setup  
- Add message encryption  
- Integrate image and file sharing features  

---

## 📸 Screenshots & Demo

*Coming Soon...*

---
