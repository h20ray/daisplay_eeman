# Radio Configuration

This module provides a simple radio streaming feature with easy configuration.

## Configuration

To configure your radio settings, edit the file:
`lib/modules/radio_by_tujuhcahaya/config/radio_config.dart`

### Available Settings

1. **streamingUrl** - Your radio stream URL
   ```dart
   static const String streamingUrl = 'https://your-radio-stream-url.com/stream';
   ```

2. **title** - Radio station title (appears in floating toolbar)
   ```dart
   static const String title = 'Your Radio Station Name';
   ```

3. **name** - Radio station name (for display purposes)
   ```dart
   static const String name = 'Your Radio Station';
   ```

4. **nowPlayingStatus** - Text shown when radio is playing
   ```dart
   static const String nowPlayingStatus = 'Now Playing';
   ```

5. **defaultStatus** - Text shown when radio is not playing
   ```dart
   static const String defaultStatus = 'Radio';
   ```

6. **imagePath** - Path to your radio logo/icon
   ```dart
   static const String imagePath = 'assets/icons/your_radio_logo.png';
   ```

## How to Update

1. Open `lib/modules/radio_by_tujuhcahaya/config/radio_config.dart`
2. Edit the values you want to change
3. Save the file
4. Restart the app

## Features

- **Floating Toolbar**: Shows current radio status with Material Design 3 styling
- **Audio Conflict Management**: Automatically stops other audio when radio plays
- **Easy Configuration**: Simple file-based configuration
- **Theme Support**: Works with both light and dark themes

## Usage

The floating toolbar will appear when:
- Radio is loaded and playing
- Radio is in initial state (allows starting)

Users can:
- Tap the toolbar to open the full radio page
- Tap the play/stop button to control playback
- See real-time status updates
