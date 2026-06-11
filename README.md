# Khedemni — Job Search Application

A full-stack mobile application for job searching and offer management, built with Flutter and a Node.js/Express REST API backed by PostgreSQL.

---

## Features

- **Authentication** — Register, login, JWT-based session management
- **Job Offers** — Browse, post, edit, and delete job listings
- **User Profiles** — View and manage applicant/employer profiles
- **Onboarding** — Guided onboarding flow for new users

> **Note:** The following features are currently under development:
> - Image upload (Multer integration in progress)
> - In-app messaging
> - Email-based password recovery (requires Gmail SMTP configuration in `.env`)

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter (Dart) |
| Backend | Node.js, Express.js |
| Database | PostgreSQL + Sequelize ORM |
| Auth | JWT, bcryptjs |
| Email | Nodemailer (Gmail SMTP) |
| File Upload | Multer |

---

## Project Structure

```
khedemni/
├── khedemni-backend/        # Node.js/Express REST API
│   ├── config/              # Database configuration
│   ├── controllers/         # Route logic (auth, offers)
│   ├── middleware/          # JWT auth, validation
│   ├── migrations/          # SQL schema migrations
│   ├── models/              # Sequelize models (User, Offer)
│   ├── routes/              # API routes
│   ├── services/            # Email service
│   └── server.js            # Entry point
│
└── lib/                     # Flutter frontend
    ├── account/             # Auth screens (login, register, reset)
    ├── pages/               # Offer detail, user detail, edit
    ├── screens/             # Main screens
    ├── services/            # API service (HTTP client)
    └── main.dart            # Entry point
```

---

## Getting Started

### Prerequisites

- Node.js v18+
- Flutter SDK
- PostgreSQL

### Backend Setup

```bash
cd khedemni-backend
npm install
cp .env.example .env   # Fill in your credentials
node server.js
```

### Frontend Setup

```bash
flutter pub get
flutter run
```

---

## Environment Variables

Create a `.env` file in `khedemni-backend/` based on `.env.example`:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=khedemni
DB_USER=your_db_user
DB_PASSWORD=your_db_password

JWT_SECRET=your_jwt_secret

EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your_email@gmail.com
EMAIL_PASSWORD=your_app_password
EMAIL_FROM=your_email@gmail.com
```

---

## API Endpoints

| Method | Route | Description |
|--------|-------|-------------|
| POST | `/api/auth/register` | Register a new user |
| POST | `/api/auth/login` | Login and get JWT |
| POST | `/api/auth/forgot-password` | Send OTP via email |
| POST | `/api/auth/reset-password` | Reset password |
| GET | `/api/offers` | Get all job offers |
| POST | `/api/offers` | Create a new offer |
| PUT | `/api/offers/:id` | Update an offer |
| DELETE | `/api/offers/:id` | Delete an offer |

---

## Author

BOUZELBOUDJEN Mohamed Abdelwahab — Full-stack development
M2 Computer Science, University of Algiers 1

---

## License

This project is for academic purposes — M2 Computer Science, University of Algiers 1.