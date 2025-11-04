# IA Tetris

A Tetris game developed in Flutter for Mac and Windows, inspired by the classic design with English interface.

## Features

- ✨ Modern interface with space gradient
- 🎮 Intuitive keyboard controls
- 📊 Scoring and level system
- 🔄 Piece rotation with collision detection
- 📱 Preview of next 3 pieces
- ⏸️ Pause system
- 🌟 Visual effects on active pieces
- 🎯 Custom application icon
- 🏆 High scores and records tracking with SQLite
- 📈 Game statistics and personal best tracking
- 🎖️ Records history with timestamps

## Controls

- **Arrow Keys ← →**: Move piece horizontally
- **Arrow Key ↓**: Accelerate descent (soft drop)
- **Arrow Key ↑ or Space**: Rotate piece
- **Enter**: Hard drop
- **P**: Pause/Resume game
- **R**: Restart game (anytime during play)
- **📊 Button**: View records and statistics

## Scoring System

- **Soft Drop**: +1 point per cell
- **Hard Drop**: +2 points per cell
- **Single line**: 40 × level
- **Two lines**: 100 × level
- **Three lines**: 300 × level
- **Tetris (4 lines)**: 1200 × level

## Requirements

- Flutter SDK 2.17.0 or higher
- Compatible Dart SDK
- macOS or Windows for execution
- SQLite support (included with Flutter)

## Installation and Execution

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd iatetris
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the project:**
   
   For Mac:
   ```bash
   flutter run -d macos
   ```
   
   For Windows:
   ```bash
   flutter run -d windows
   ```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── tetromino.dart       # Tetris piece definitions
│   ├── game_board.dart      # Board logic
│   ├── game_logic.dart      # Main game logic
│   └── game_record.dart     # Game record data model
├── services/                # Services
│   └── database_helper.dart # SQLite database management
├── screens/                 # Application screens
│   ├── game_screen.dart     # Main game screen
│   └── records_screen.dart  # Records and statistics screen
└── widgets/                 # Reusable widgets
    ├── game_board_widget.dart
    ├── next_piece_widget.dart
    └── game_info_widget.dart
```

## Build for Distribution

### macOS
```bash
flutter build macos
```

### Windows
```bash
flutter build windows
```

The executables will be available in:
- **macOS**: `build/macos/Build/Products/Release/`
- **Windows**: `build/windows/runner/Release/`

## Customization

The game can be easily customized through the following aspects:

- **Piece colors**: Modify in `lib/models/tetromino.dart`
- **Game speed**: Adjust `baseDropTime` in `lib/models/game_logic.dart`
- **Interface**: Customize widgets in `lib/widgets/`
- **Controls**: Modify mapping in `lib/screens/game_screen.dart`
- **Application icon**: Replace `icon.png` in the root directory and regenerate icons
- **Database**: SQLite database stores records in app's documents directory

### Updating the Application Icon

To update the application icon:

1. Replace the `icon.png` file in the project root with your new icon (512x512 recommended)
2. Add flutter_launcher_icons to dev_dependencies in pubspec.yaml
3. Add the flutter_icons configuration section
4. Run: `flutter packages pub run flutter_launcher_icons:main`

## Records and Statistics

The game automatically saves your performance data using SQLite:

### Tracked Data
- **Game Records**: Score, level reached, lines cleared, and game duration
- **Personal Best**: Highest score achieved
- **Statistics**: Total games played, average score, total lines cleared, and total play time
- **Timestamps**: When each game was played for historical tracking

### Records Screen
Access the records screen by clicking the 📊 button during gameplay to view:
- **Top 20 Records**: Ranked by score with medals for top 3
- **Game Statistics**: Comprehensive stats about your playing history
- **Recent Games**: When each record was achieved

### Database Location
- **macOS**: `~/Library/Application Support/com.example.iatetris/tetris_records.db`
- **Windows**: `%APPDATA%\com.example.iatetris\tetris_records.db`

## Technologies Used

- **Flutter**: Framework for cross-platform development
- **Dart**: Programming language
- **Material Design**: Interface design system

## Contributing

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by classic Tetris
- Design based on the provided reference image
- Flutter community for support and documentation