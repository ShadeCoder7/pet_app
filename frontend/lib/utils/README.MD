# Utils

This folder contains **utility files** to centralize shared resources and helpers for the app.

## Files

### 1. `fade_route.dart`

- **Purpose:**  
  Provides a helper function to create a smooth *fade transition* between screens when using navigation.
- **How to use:**  
  Import the function and use it with your `Navigator` when you want a fade effect.
  ```
  import '../utils/fade_route.dart';
  ```

  // Example usage:
  Navigator.of(context).pushReplacement(createFadeRoute(const NextScreen()));

- **Benefit:**
  Ensures all transitions look consistent and visually pleasing across the app.

### 2. `app_colors.dart`

- **Purpose:**  
  Defines the main color palette used throughout the app as static constants.
- **How to use:**  
  Import AppColors and reference the color you need for styling widgets.
  ```
  import '../utils/app_colors.dart';
  // Example usage:
  color: AppColors.deepGreen
  ```

- **Benefit:**
  Centralizes color definitions for easy updates and ensures a coherent visual identity.

> ℹ️ **Any new utility/helper file used globally in the app should be placed here and documented in this README.**
