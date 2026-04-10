
# Blueprint: Employee Attendance System

## Overview

This document outlines the plan for building a comprehensive employee management and attendance system using Flutter. The application will be professional, intuitive, and will leverage on-device capabilities for biometric authentication and local data storage.

## Features & Design Plan

### Core Features:
- **Employee Management:**
    - Add new employees with their name and a profile picture.
    - View a list of all employees.
    - View details for a single employee.
    - Delete employees.
- **Biometric Attendance:**
    - Use the phone's built-in fingerprint or face recognition (`local_auth`) to record attendance.
    - Clock-in and clock-out functionality.
- **Manual Attendance:**
    - Allow for manual clock-in/out as a fallback.
- **Local Storage:**
    - Use an `sqflite` local database to store all employee and attendance data persistently on the device.
- **State Management:**
    - Use the `provider` package for efficient and scalable state management.
- **Navigation:**
    - Use the `go_router` package for a declarative and robust routing solution.

### Design & UI/UX:
- **Theme:**
    - Implement a modern Material 3 design.
    - Use `ColorScheme.fromSeed` for a consistent and harmonious color palette.
    - Support both Light and Dark themes with a toggle switch.
- **Typography:**
    - Use the `google_fonts` package for professional and readable fonts (e.g., Roboto, Oswald).
- **Layout:**
    - Clean, card-based layouts for displaying employee information.
    - Intuitive navigation with a clear hierarchy.
    - Responsive design for various screen sizes.
- **Components:**
    - Use standard Material components like `Scaffold`, `AppBar`, `Card`, `ElevatedButton`, `ListView`, and `Icons`.

## Current Task: Initial Project Setup

The immediate next steps are to set up the foundational structure of the application.

1.  **Add Dependencies:** Add `provider`, `google_fonts`, and `go_router` to `pubspec.yaml`.
2.  **Create Theme:** Implement the `ThemeProvider` and define the light/dark themes in `lib/main.dart`.
3.  **Set Up Routing:** Configure `go_router` with initial routes for the home, employee list, and settings screens.
4.  **Create Placeholder Screens:** Create the basic widget files for the initial screens.
