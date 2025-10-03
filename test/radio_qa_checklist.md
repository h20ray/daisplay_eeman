# Radio Feature QA Checklist

## Pre-Test Setup
- [ ] Clean install the app
- [ ] Ensure stable internet connection
- [ ] Test on both Android and iOS devices
- [ ] Test on different network conditions (WiFi, 4G, 3G)

## Basic Functionality
- [ ] Radio page loads without crashes
- [ ] Auto-play starts after 500ms delay
- [ ] Play/pause button toggles correctly
- [ ] Volume slider responds to user input
- [ ] Station information displays correctly
- [ ] Album art loads and displays properly

## Background Playback
- [ ] Radio continues playing when app goes to background
- [ ] Notification controls appear in system notification
- [ ] Play/pause works from notification
- [ ] Radio stops when notification is dismissed
- [ ] Radio resumes when app comes to foreground

## Network Conditions
- [ ] Radio handles network interruptions gracefully
- [ ] Radio reconnects when network is restored
- [ ] Error message displays when stream is unavailable
- [ ] "Try Again" button works correctly
- [ ] No crashes during network loss

## App Lifecycle
- [ ] Radio state persists across app backgrounding
- [ ] Radio state syncs correctly when app resumes
- [ ] No duplicate audio streams
- [ ] Memory usage remains stable after 10+ minutes
- [ ] Hot reload doesn't cause audio issues

## Audio Conflicts
- [ ] Radio stops when other audio starts (Quran recitation)
- [ ] Other audio stops when radio starts
- [ ] No overlapping audio streams
- [ ] Volume controls work independently

## Performance
- [ ] App doesn't freeze during radio operations
- [ ] UI remains responsive during playback
- [ ] Battery usage is reasonable
- [ ] CPU usage stays low during playback
- [ ] No memory leaks after extended use

## Error Handling
- [ ] Invalid stream URLs show appropriate error
- [ ] Network timeouts are handled gracefully
- [ ] App doesn't crash on audio errors
- [ ] Error recovery works correctly
- [ ] User feedback is clear and helpful

## Device-Specific Tests
### Android
- [ ] Works on Android API 21+ (Android 5.0+)
- [ ] Notification controls work on all Android versions
- [ ] Background playback works with battery optimization
- [ ] Works with different audio output devices (speaker, headphones, Bluetooth)

### iOS
- [ ] Works on iOS 12+
- [ ] Background audio works with iOS restrictions
- [ ] Notification controls work on all iOS versions
- [ ] Works with different audio output devices

## Edge Cases
- [ ] Rapid play/pause button tapping doesn't cause issues
- [ ] Volume slider rapid changes don't cause problems
- [ ] App handles phone calls during radio playback
- [ ] Radio works with other apps using audio
- [ ] Works with system volume changes

## Accessibility
- [ ] Radio controls are accessible via screen readers
- [ ] Button sizes meet accessibility guidelines
- [ ] Color contrast is sufficient
- [ ] Voice commands work (if supported)

## Regression Tests
- [ ] All existing features still work
- [ ] No new crashes introduced
- [ ] Performance hasn't degraded
- [ ] UI/UX remains consistent

## Sign-off
- [ ] All critical issues resolved
- [ ] Performance meets requirements
- [ ] User experience is smooth
- [ ] Ready for production release

## Notes
- Test duration: Minimum 30 minutes continuous playback
- Test frequency: Multiple sessions per day
- Document any issues found with reproduction steps
- Test on both debug and release builds
