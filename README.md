# Bandari Connect Hub — Laravel Edition

A professional, fully responsive educational community platform for **Bandari Maritime College**, rebuilt on **Laravel 13** with **Eloquent**, **Blade** and **Bootstrap 5**.

This is a modernised migration of the original plain-PHP application. Key upgrade: **subjects are now first-class, per-course entities** managed by administrators (previously subjects were inconsistent free text).

## Features

- **Authentication** — register, login (by username *or* email), password reset, roles (student / admin / super-admin), account suspension.
- **Social Feed** — posts, likes, threaded comments, image uploads, "Everyone / My Course" scoping, trending & course filters.
- **Course Groups** — auto-grouped, course-scoped feed with a classmate leaderboard.
- **Study Materials** — upload/download files, filtered by **course → subject** (dependent dropdowns).
- **Subjects per Course** — admins define the subject catalogue for each course; this drives every material/quiz/library dropdown.
- **E-Library** — curated, verified external resources, filterable by course & subject.
- **Quizzes & Leaderboards** — timed multiple-choice quizzes, per-course leaderboards, points & global ranking.
- **Profiles** — avatars, bio, social links, activity stats, password change.
- **Admin Panel** — dashboard, course CRUD, **subject manager**, quiz bank, library links, user management (suspend/promote/demote/delete).
- **Gamification** — points for posting (+2), commenting (+1), uploading materials (+5), correct quiz answers (+2 each).

## Tech Stack

- Laravel 13 · PHP 8.3+
- SQLite (dev) / MySQL (production) — migrations are database-agnostic
- Blade templating + Bootstrap 5.3 + Bootstrap Icons (via CDN, no build step required)

## Getting Started

```bash
# 1. Install dependencies
composer install

# 2. Environment
cp .env.example .env
php artisan key:generate

# 3. Database (SQLite is default and needs no server)
php artisan migrate:fresh --seed

# 4. Storage symlink (for uploaded files)
php artisan storage:link

# 5. Run
php artisan serve
```

Then open http://127.0.0.1:8000.

### Seeded accounts

| Role | Username | Password |
|------|----------|----------|
| Super Admin | `admin` | `Admin@1234` |
| Student (Port Management) | `jbahari` | `Student@1234` |
| Student (Maritime Logistics) | `aneema` | `Student@1234` |

The seeders create the 7 maritime courses, a starter set of subjects per course (editable by admins), demo posts, quiz questions and library links.

## Managing Subjects (the headline feature)

1. Log in as an admin and open **Subjects** in the sidebar.
2. Pick a course on the left.
3. Add / edit / activate / deactivate / delete subjects for that course.
4. These subjects instantly populate the course→subject dropdowns used when uploading materials, adding quiz questions and library links.

> Subjects with existing materials can't be deleted (deactivate them instead) to preserve data integrity.

## Testing

```bash
php artisan test
```

`tests/Feature/CoreFlowTest.php` covers auth guarding, posting, material upload with per-course subject validation, admin subject management and quiz scoring.

## Switching to MySQL

Edit `.env`, set the `mysql` block (see comments in `.env.example`), create the database, then run `php artisan migrate:fresh --seed`.
