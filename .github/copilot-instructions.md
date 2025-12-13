# Copilot Instructions for ungdungluyentap_suckhoe

## Project Overview
**ungdungluyentap_suckhoe** is a Flutter health & nutrition management application. The app focuses on helping users manage their health through nutrition tracking and workout planning.

## Current Status
- **Frontend**: Implemented with bottom navigation (Food Handbook + Nutrition Tracking screens)
- **Models**: Complete data models for nutrition management
- **Widgets**: Reusable UI components for displaying nutrition data

## Subsystems Priority (Phân hệ)
1. **Subsystem 2: Nutrition Management (Quản lý Dinh dưỡng)** - IN PROGRESS
   - Food Handbook Screen (Sổ tay Dinh dưỡng) - DONE
   - Nutrition Tracking Screen (Quản lý Dinh dưỡng) - DONE
   - Database integration - TODO
   - Meal adding/editing functionality - TODO

2. **Subsystem 1: Workout Management (Quản lý Luyện tập)** - TODO
   - Exercise routines and tracking
   - Workout scheduling

## Architecture & Key Patterns

### Current File Structure
```
lib/
  main.dart                              # Entry point with navigation
  models/
    thuc_pham.dart                      # Food model
    mon_an.dart                         # Single meal item
    bufa_an.dart                        # Meal (Breakfast/Lunch/Dinner)
    nhat_ky_dinh_duong.dart             # Daily nutrition log
  screens/
    food_handbook_screen.dart           # Searchable food database UI
    nutrition_tracking_screen.dart      # Daily nutrition tracking UI
  services/
    food_image_service.dart             # Food image URL mapping (Wikimedia)
  widgets/
    thuc_pham_card.dart                 # Food card component
    dinh_duong_display.dart             # Nutrition stats display
    calo_progress_bar.dart              # Calorie progress indicator
```

### Flutter Project Setup
- **Flutter SDK**: Dart 3.10.0+
- **Minimal Dependencies**: flutter, cupertino_icons, flutter_lints
- **Platforms**: Android, iOS, Web, Linux, macOS, Windows
- **Theme**: Material 3, Deep Purple primary color

## Frontend Implementation Details

### Main Navigation (main.dart)
- Uses `BottomNavigationBar` with 2 tabs:
  - Tab 0: Food Handbook Screen
  - Tab 1: Nutrition Tracking Screen

### Food Handbook Screen (food_handbook_screen.dart)
- **Features**:
  - Search bar for finding foods
  - Category filter chips (All, Staple, Meat, Fish, Vegetable, Fruit, Dessert, Dairy)
  - ListView of food items with `ThucPhamCard` widgets showing thumbnail images
  - Bottom sheet detail view
- **Data**: Contains 9 sample foods with Wikipedia image URLs
- **Images**: Loaded from Wikimedia Commons public images
- **TODO**: Replace with SQLite/database queries

### Nutrition Tracking Screen (nutrition_tracking_screen.dart)
- **Features**:
  - Daily calorie progress bar (using `CaloProgressBar`)
  - Nutrition summary display (using `DinhDuongDisplay`)
  - Expandable meal list showing foods per meal with images
  - FAB for adding new meals
- **Data**: Creates sample daily log with breakfast items
- **TODO**: Integrate with actual daily data from database

### Key Widgets

#### ThucPhamCard (thuc_pham_card.dart)
- Displays food item with thumbnail image, name, category, calories, protein
- Supports image loading from URL with loading spinner
- Error handling for broken image links with fallback icon
- Accepts `onTap` callback for detail view
- Responsive layout
- **Image Loading**: Uses `Image.network()` with:
  - `loadingBuilder` - Shows circular progress while loading
  - `errorBuilder` - Shows fallback icon if image fails
  - `fit: BoxFit.cover` - Fills container proportionally

#### DinhDuongDisplay (dinh_duong_display.dart)
- Shows total daily calories in highlighted container
- Displays macro breakdown (Protein, Carbs, Fat) in colored boxes
- Responsive grid layout

#### CaloProgressBar (calo_progress_bar.dart)
- Linear progress indicator for calorie goal tracking
- Color changes: Red (<50%), Orange (50-80%), Green (80-100%), Blue (>100%)
- Shows current/target calories and percentage

## Code Conventions

### Widget Organization
- Use `const` constructors where possible
- Stateless widgets for purely presentational components (ThucPhamCard, DinhDuongDisplay)
- Stateful widgets for screens with local state (FoodHandbookScreen, NutritionTrackingScreen)
- Avoid deep nesting - extract complex widgets

### Material Design Implementation
- Material 3 with `ColorScheme.fromSeed()`
- Primary color: `Colors.deepPurple`
- Secondary colors: Blue, Orange, Red for different nutrients
- Use `Cards` for grouped content, `ExpansionTile` for collapsible sections

### Data Models
- Models in `lib/models/` with `toJson()` and `fromJson()` methods
- Named parameters with `required` for mandatory fields
- Helper methods for calculations (e.g., `ThucPham.tinhDinhDuong()`, `BufaAn.getTongDinhDuong()`)

### State Management (Current)
- No external packages (Provider, Riverpod) yet
- Use `setState()` for local screen state
- Pass data via constructor parameters
- TODO: Consider Provider for cross-screen state sharing when adding/editing meals

## Development Workflows

### Running the App
```bash
flutter run
```
Defaults to Windows/Web. Use `-d windows` or `-d web` explicitly.

### Building
```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release

# Web
flutter build web
```

### Testing
```bash
flutter test
flutter test --coverage
```

### Common Fixes
- **"Unused import"**: Remove unused imports (analyzer hints are correct)
- **"toList() unnecessary"**: Flutter 3.0+ supports spreads directly - remove `.toList()`
- **"Parameter could be super parameter"**: Use `super.key` in constructors for Dart 3+

## Next Steps for Nutrition Feature

### Immediate (High Priority)
1. **Database Setup**
   - Add `sqflite` package for local SQLite storage
   - Create schema for Foods, Meals, DailyLogs
   - Migrate hardcoded data to database

2. **Add Meal Dialog**
   - Create `AddMealDialog` widget
   - Implement food search + weight input
   - Save to database

3. **Edit/Delete Functionality**
   - Add edit meal screen
   - Delete meal with confirmation

### Medium Priority
4. **Data Persistence**
   - Load today's data on app start
   - Implement date picker for viewing past days
   - Backup/export functionality

5. **UI Polish**
   - Add food images
   - Implement macronutrient pie chart visualization
   - Daily/weekly progress charts

### Testing
- Widget tests for card components
- Unit tests for nutrition calculations
- Integration tests for meal add/edit flows

## Git Workflow
- **Current Branch**: `ThinhDev`
- **Commit Style**: `feat: add meal editing`, `fix: calorie calculation bug`
- Push nutrition features to this branch

## Performance Tips
- Use `ListView.builder` for large food lists (already implemented)
- Lazy-load images with error handling
- Cache nutrition calculations
- Use `const` constructors (linter will warn if not)

## External Resources
- Flutter docs: https://docs.flutter.dev
- Dart API: https://api.dart.dev
- Material Design 3: https://m3.material.io
- SQLite in Flutter: https://pub.dev/packages/sqflite

---

**Last Updated**: December 2025  
**Current Focus**: Food Handbook & Nutrition Tracking UI (COMPLETE), Next: Database Integration
