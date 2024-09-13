```markdown
# Absence Manager <img src="https://img.shields.io/badge/made%20with-dart-blue.svg" alt="made with dart"> <img src="https://img.shields.io/badge/platform-android%20|%20iOS%20|%20macOS%20|%20web-green" alt="platform support">

The **Absence Manager** is an application designed to help clients manage and visualize employee absences efficiently. It follows **Domain-Driven Design (DDD)** for a modular architecture, **BLoC (Business Logic Component)** pattern for state management, and **GetIt** for dependency injection. The project is structured around best practices to ensure maintainability, scalability, and ease of testing. The app offers paginated lists, filtering capabilities, and an intuitive user experience for managing absences.

## Key Features

### Absence List
- View a comprehensive list of absences with employee names and other relevant details.

### Pagination
- Initially displays the first 10 absences.
- Supports infinite scrolling to load more absences as you reach the end of the list.

### Absence Count
- Displays the total number of absences in the system for tracking.

### Absence Card
Each absence entry includes:
- Employee name
- Type of absence (e.g., Vacation, Sickness)
- Absence period (start and end dates)
- Optional member note
- Absence status (Requested, Confirmed, or Rejected)
- Optional admittance note

### Filtering
- Filter absences by type (e.g., Vacation, Sickness).
- Filter absences by date using a date range picker.

### Loading State
- Displays a loading indicator while fetching the list of absences.

### Error Handling
- Shows an error message if the list of absences fails to load.

### Empty State
- Displays an empty state if no absences match the search criteria.

---

## Technical Overview

### Architecture

1. Domain-Driven Design (DDD) separates domain logic from framework-specific code, leading to a modular and maintainable architecture.
2. DDD principles in Flutter improve testability, scalability, and flexibility.

### State Management

Using [bloc](https://pub.dev/packages/flutter_bloc) for state management provides separation of concerns, flexibility, and reactive updates, ensuring a well-structured codebase.

### Dependency Injection

- **[GETIT](https://pub.dev/packages/get_it)** is used for dependency injection, simplifying singleton management and testing.
- Improves code organization and modularity.

### JSON Parsing

- [Freezed](https://pub.dev/packages/freezed) is used with [JSON Serializable](https://pub.dev/packages/json_serializable) for generating immutable data classes and handling serialization/deserialization.

### UI

1. [Flutter hooks](https://pub.dev/packages/flutter_hooks) enhance readability by removing the need for `StatefulWidget` and `setState`, reducing boilerplate code.
2. Promotes reusable, declarative components.

### Testing

- **[Mocktail](https://pub.dev/packages/mocktail)** provides a clean and expressive API for creating and verifying mock objects in unit tests.

### Key Packages

- **flutter_bloc**: Manages state transitions using the BLoC pattern.
- **get_it**: Provides dependency injection and service locator capabilities.
- **freezed**: Creates immutable data classes and handles union types.
- **flutter_hooks**: Simplifies state management with a more reactive approach.

---

## Platforms Tested

This application has been tested on the following platforms:

- **Android**
- **iOS**
- **macOS**
- **Web** (Modern browsers such as Chrome, Firefox, Safari, and Edge)

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
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```
```