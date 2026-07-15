# Salon Loyalty System

A Flutter-based Salon Loyalty System application designed to manage salon services, bookings, and customer loyalty rewards. It includes role-based dashboards, booking scheduling with dynamic time-slot allocation, and a loyalty points system.

## Project Structure

This repository is structured as follows:

*   **[Code/](file:///Code)**: The core Flutter project codebase.
*   **[Diagrams/](file:///Diagrams)**: Architecture and UI design assets, including:
    *   Database/Schema Diagram
    *   Admin dashboard wireframe
    *   Barber dashboard wireframe
    *   Customer dashboard wireframe
*   **[AI Usage.txt](file:///AI%20Usage.txt)**: Statement of AI assistance and independent development contribution.

---

## Features

### 👤 Role-Based Portals

The application supports three distinct user roles with dedicated interfaces:

1.  **Customer Portal**:
    *   Register and log in securely.
    *   View real-time loyalty point balances.
    *   Book salon services with a dynamic time-slot picker (preventing overbooking).
    *   Apply loyalty points to redeem discounts on checkout.
    *   Cancel upcoming bookings or track service history.
2.  **Barber Portal**:
    *   View assigned bookings and schedules.
    *   Mark bookings as completed (automatically awarding loyalty points to the customer).
    *   Track work history and completed services.
3.  **Admin Portal**:
    *   Overview of all system bookings and user accounts.
    *   Assign specific barbers to customer bookings.
    *   Manage and audit complete booking logs.

### 💰 Loyalty Points Logic

*   Customers earn **10% of the net service price** as loyalty points upon completion of their salon service.
*   Every booking ensures at least **1 point** is rewarded.
*   Points are dynamically updated only when a barber marks a service as **done**. Cancelling completed bookings will deduct the credited points.
*   Points can be redeemed for discounts on future bookings.

---

## Getting Started

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable channel recommended)
*   Dart SDK
*   An Android/iOS Emulator or physical device set up for testing.

### Installation & Run

1.  Navigate into the `Code/` directory:
    ```bash
    cd Code
    ```
2.  Get the package dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the application:
    ```bash
    flutter run
    ```
