# Utils

This folder contains **utility files** to centralize shared resources and helpers for the app.

## Files

### 1. `app_colors.dart`

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
