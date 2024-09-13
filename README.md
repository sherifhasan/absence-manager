# Absence Manager <img src="https://img.shields.io/badge/made%20with-dart-blue.svg" alt="made with dart">


The **Absence Manager** is an application designed to help clients manage and visualize employee absences efficiently. It follows **Domain-Driven Design (DDD)** to ensure a clear separation of concerns, **BLoC (Business Logic Component)** pattern for state management, and **GetIt** for dependency injection.

This project is structured around best practices to ensure maintainability, scalability, and ease of testing. With a focus on responsiveness, the app provides paginated lists, filtering capabilities, and an intuitive user experience to manage absences.

## Key Features

### Absence List
- View a comprehensive list of absences that displays employee names and other relevant details.

### Pagination
- Initially displays the first 10 absences.
- Supports infinite scrolling to load more absences as you reach the end of the list.

### Absence Count
- Displays the total number of absences in the system for easy tracking.

### Absence card
Each absence entry includes:
- Employee name
- Type of absence (e.g., Vacation, Sickness)
- Absence period (start and end dates)
- Member note (optional, if available)
- Absence status (Requested, Confirmed, or Rejected)
- Admitter note (optional, if available)

### Filtering
- Filter absences by type (e.g., Vacation, Sickness).
- Filter absences by date using a date range picker for precise results.

### Loading State
- Displays a loading indicator while the list of absences is being retrieved.

### Error Handling
- Shows an error message if the list of absences fails to load.

### Empty State
- Displays an empty state if no absences match the current search criteria.
---

## Technical Overview

### Architecture

1. Domain driven design helps separate domain logic from framework-specific code,
   leading to a modular and maintainable Flutter app architecture.
2. Applying DDD principles in Flutter improves testability, scalability, and flexibility of the
   application.

### State management

Using [bloc](https://pub.dev/packages/flutter_bloc) as a state management solution allows us to
benefit from BLoC in our Flutter app as it offers the benefits of separation of concerns,
flexibility,
and reactive updates for a well-structured and efficient codebase.

### Dependency injection

1. Using [GETIT](https://pub.dev/packages/get_it) in Flutter simplifies dependency injection,
   singleton management, and testing,
2. Improving code organization and modularity.

### JSON parsing

Using the [Freezed](https://pub.dev/packages/freezed) package
with [JSON Serializable](https://pub.dev/packages/json_serializable) package in Flutter simplifies
JSON parsing by generating immutable data classes and automatic serialization/deserialization.
It provides type safety, reducing runtime exceptions and improving code quality.

### UI

1. Using the [Flutter hooks](https://pub.dev/packages/flutter_hooks) enhances code readability by
   removing the need for StatefulWidget and setState,
2. Reducing boilerplate code and making the logic more declarative.
3. Flutter Hooks promotes reusability of hooks-based components, allowing for easier composition and
   sharing of logic across different parts of the app.

### Testing

Unit testing using [Mocktail](https://pub.dev/packages/mocktail) providing a clean and expressive API for creating and verifying mock objects, reducing test setup and improving test readability

### Key Packages

- **flutter_bloc**: Manages state transitions using the BLoC pattern.
- **get_it**: Provides dependency injection and service locator capabilities.
- **freezed**: Used for creating immutable data classes and handling union types for various app states (e.g., loading, success, error).
- **flutter_hooks**: Simplifies state management by introducing a reactive way to handle widget state.

---

## How to Run the Project

### Prerequisites

- Flutter SDK: Ensure you have [Flutter installed](https://flutter.dev/docs/get-started/install) on your machine.
- GetIt: [GetIt package](https://pub.dev/packages/get_it) installed.
- Bloc: [flutter_bloc package](https://pub.dev/packages/flutter_bloc) installed.

### Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/sherifhasan/absence_manager.git
   cd absence_manager
