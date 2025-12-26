## 🔁 Chat & Dictionary Flow

# Chat Demo (Flutter)

A Flutter chat demo showcasing tabbed navigation, chat history, and a dictionary lookup on long-press.

## Project Structure
👉 [View detailed structure](structure.md)

## Requirements

- Flutter **3.29.2** (stable)
- Dart **3.7.2**

```
Flutter 3.29.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision c236373904 (10 months ago) • 2025-03-13 16:17:06 -0400
Engine • revision 18b71d647a
Tools • Dart 3.7.2 • DevTools 2.42.3
```

## Getting Started

```bash
flutter pub get
flutter run
```

## ✅ Core Features Implemented

- Bottom Navigation with 3 tabs
  - Home (functional)
  - Others & Settings (placeholders)
- Home Screen
  - Custom top tab switcher (Users / History)
  - AppBar hides on scroll down and reappears on scroll up
  - Scroll position preserved when switching tabs
- Users Tab
  - Displays locally added users
  - Floating “Add User” button (visible only on Users tab)
  - Snackbar confirmation on user add
  - Tapping a user opens the Chat screen
- Chat History Tab
  - Displays previous chat sessions
  - Shows user avatar, last message, and time
  - Preserves scroll state
- Chat Screen
  - Sender messages (local input)
  - Receiver messages fetched from open-source API
  - Message bubbles with avatar initials
  - Proper error handling and loading states

## ⭐ Bonus Feature Implemented

- Dictionary Word Meaning
  - Long-press on any word in a chat message
  - Fetches meaning using open-source Dictionary API
  - Displays result in a bottom sheet
  - Gracefully handles “no meaning found” cases

 
### 💬 Chat Message Flow

- User types a message and taps **Send**
- Message is added locally as **Sender message**
- UI updates immediately
- Receiver API is called  
  `GET https://dummyjson.com/comments?limit=10`
- API returns a random comment
- Response is parsed and added as **Receiver message**
- Chat auto-scrolls to the latest message

### Dictionary (Word Meaning) Flow

- User long-presses on any word in a chat message
- Selected word is cleaned (punctuation removed)
- Dictionary API is called  
  `GET https://api.dictionaryapi.dev/api/v2/entries/en/{word}`
- API response is parsed (word, part of speech, definition)
- Meaning is shown in a **bottom sheet**
- If no meaning is found, a graceful error message is shown

## 🧪 Testing

- Unit Tests
  - Dictionary repository
  - Dictionary cubit logic
- Integration Test
  - Complete chat flow
  - Message sending
  - Long-press word → dictionary bottom sheet validation

## 🏗 Architecture & Quality

- Feature-based folder structure
- Cubit (Bloc) for state management
- Proper separation of data, presentation, and logic
- Git discipline with meaningful commit history

## 📦 APK & Screen Recording

APK and screen recording are shared via Google Drive:
- https://drive.google.com/drive/folders/1yqBnM5dlynkWfhBOdi3YbMMvpVwvjm0C?usp=drive_link
