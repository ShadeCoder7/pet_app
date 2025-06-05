# Hope & Paws – Animal Adoption Mobile App 🐾

Welcome to **Hope & Paws**! This cross-platform mobile application is designed to accelerate and simplify responsible animal adoption, providing a unified and accessible digital solution for shelters, foster homes, volunteers, and individuals interested in giving a home to abandoned animals in Spain.  
With more than 280,000 animals abandoned every year (Fundación Affinity, 2023), our mission is to make a real difference through technology.

---

## 🚀 Project Overview

**Hope & Paws** centralizes all adoption processes, animal profiles, requests, and incident reports in a single mobile platform.  
The app allows standard users, foster homes, shelters, and administrators to work in a coordinated way, updating animal statuses in real time and facilitating transparent communication between all actors.  
It was fully developed as a final project for the Advanced Technician in Multiplatform Application Development (2º DAM).

**Demo & Task Board:**  
See all tasks, issues, and development progress on the [GitHub Projects Kanban board](https://github.com/users/ShadeCoder7/projects/2/views/1).

---

## 📱 Key Features

1. **User Authentication**
   - Secure registration and login via **Firebase Authentication**
   - Persistent session and protected routes
2. **Animal Profiles Management**
   - Create and manage detailed animal profiles (name, age, breed, status, photos, location, description)
   - Filter, search, and view animal listings with up-to-date availability
3. **Adoption Requests**
   - Authenticated users can send adoption requests and track their status
   - Prevents duplicate requests; admins/shelters can approve or reject
4. **Incident & Sighting Reports**
   - Report abandoned animals or app issues directly from the app
   - Attach location and optional images
5. **User Roles**
   - Standard users, foster homes, shelters, and admin (only standard user fully available in MVP)
   - Future versions: advanced management for other roles
6. **Favorites**
   - Mark and review favorite animals (feature under development)
7. **User-Friendly, Accessible Interface**
   - Responsive design, consistent color palette, accessible typography, clear navigation
   - Designed for mobile devices (Android emulator; iOS planned)

---

## 🛠️ Technologies Used

- **Frontend:** Flutter (Dart)
- **Backend:** ASP.NET Core (C#)
- **Database:** PostgreSQL (Docker), managed via Entity Framework Core
- **Authentication:** Firebase Authentication (email & password)
- **Image Hosting:** imgbb (external URLs for animal photos)
- **Dev Tools:** Visual Studio Code, Android Studio, Postman, Git & GitHub, pgAdmin 4, Docker

---

## 🏗️ System Architecture

The architecture is modular and scalable, separating all core responsibilities:

- **Frontend:**  
  Flutter mobile app, handles all UI, navigation, user actions, API calls (HTTP/REST, JWT Bearer).
- **Backend:**  
  ASP.NET Core API, with a clean separation of Models, DTOs, Interfaces, Services, and Controllers.  
  Security through JWT validation from Firebase.
- **Database:**  
  PostgreSQL, fully normalized and deployed in Docker.  
  Uses UUID for all entities, with advanced constraints, triggers and automatic timestamp updates.
- **Image Storage:**  
  Animal images are hosted externally (imgbb), with only the direct URLs stored in the database.
- **DevOps:**  
  Docker Compose orchestrates the DB and admin tools.  
  Sensitive config managed with `.env` files (excluded from repo).

---

## 📂 Project Structure

```bash
├── backend/
│   ├── Controllers/
│   ├── Data/
│   ├── Dtos/
│   ├── Interfaces/
│   ├── Properties/
│   ├── Services/
│   ├── Program.cs
│   └── README.md
├── frontend/
│   ├── assets/
│   ├── lib/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── services/
│   │   ├── utils/
│   │   ├── widgets/
│   │   ├── app.dart
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── README.md
├── sql/
│   └── README.md
└── README.md
```

_Note: Each main component (`backend`, `frontend`, `sql`) contains its own `README.md` with specific setup and usage instructions. For an overview of the entire project, see this main `README.md`._

---

## 📝 Good Practices & Git Workflow

- **Version control:** Git + GitHub, using feature/fix/chore branches and pull requests (GitFlow).
- **Commits:** Follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for semantic and readable history.
- **Documentation:** Code and API are well documented for maintainability and scalability.

---

## 🔒 Privacy & Data Protection

- All sensitive credentials and environment variables are stored in `.env` files (excluded from version control).
- User passwords are managed exclusively by Firebase Authentication; no password is ever stored in the project’s backend or database.
- The app is a prototype and is not available on Google Play or App Store; for local testing only.

---

## 🧪 Testing

- **Backend:**
  - Unit, integration, and endpoint testing performed using Postman and automated scripts.
- **Frontend:**
  - Manual testing on Android Studio emulator; onboarding for new users included.
- **Test Data:**
  - Includes several test users, animal profiles, and example adoption requests.

---

## 📚 Documentation & Screenshots

See `/docs` and Project Wiki for:

- Detailed database schema
- ER & use case diagrams
- Wireframes and UI mockups (created with Excalidraw)
- User manual and Postman collection
- Screenshots of all main app screens

---

## 🙋 Author & Contact

**Author:** Eric Moya Carmona  
**Degree:** Advanced Technician in Multiplatform Application Development (2º DAM)  
**Contact:** [ericmoyacarmona7@gmail.com](mailto:ericmoyacarmona7@gmail.com)  
**GitHub:** [ShadeCoder7](https://github.com/ShadeCoder7)

> _“This project was created as part of my final year at CESUR, combining all my self-taught knowledge in Flutter, Dart, C#, and modern backend development.  
> My goal was not only to learn but to create something that could make a real difference for animal welfare.”_

---

### ⭐ If you like this project, please leave a star or open an issue for feedback!
