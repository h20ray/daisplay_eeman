import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/common/services/global_audio_manager.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/config/radio_config.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/data/repositories/radio_repository_impl.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:radio_player/radio_player.dart';

class MockGlobalAudioManager extends Mock implements GlobalAudioManager {}

class MockRadioConfigService extends Mock implements RadioConfigService {}

class MockRadioPlayer extends Mock {
  static final StreamController<PlaybackState> _playbackStateController =
      StreamController<PlaybackState>.broadcast();
  static final StreamController<List<String>> _metadataController =
      StreamController<List<String>>.broadcast();

  static Stream<PlaybackState> get playbackStateStream =>
      _playbackStateController.stream;
  static Stream<List<String>> get metadataStream => _metadataController.stream;

  static Future<void> setStation({
    required String title,
    required String url,
    String? logoAssetPath,
  }) async {
    // Mock implementation
  }

  static Future<void> play() async {
    _playbackStateController.add(PlaybackState.playing);
  }

  static Future<void> pause() async {
    _playbackStateController.add(PlaybackState.paused);
  }

  static Future<void> reset() async {
    _playbackStateController.add(PlaybackState.unknown);
  }

  static void dispose() {
    _playbackStateController.close();
    _metadataController.close();
  }
}

void main() {
  group('RadioRepositoryImpl', () {
    late RadioRepositoryImpl repository;
    late MockGlobalAudioManager mockAudioManager;
    late MockRadioConfigService mockConfigService;

    const testStation = RadioStation(
      id: 'test',
      title: 'Test Radio',
      url: 'https://test.com/stream',
      imagePath: 'assets/test.png',
    );

    const testConfig = RadioConfig(
      streamingUrl: 'https://test.com/stream',
      title: 'Test Radio',
      name: 'Test Radio',
      nowPlayingStatus: 'Now Playing',
      defaultStatus: 'Radio',
      imagePath: 'assets/test.png',
      notificationTitle: 'Test Radio',
      notificationSubtitle: 'Now Playing',
      showMetadataInNotification: false,
    );

    setUp(() {
      mockAudioManager = MockGlobalAudioManager();
      mockConfigService = MockRadioConfigService();

      when(() => mockConfigService.currentConfig).thenReturn(testConfig);
      when(() => mockAudioManager.stopAllJustAudioPlayers())
          .thenAnswer((_) async {});
      when(() => mockAudioManager.unregisterStopRadioCallback())
          .thenReturn(null);

      repository = RadioRepositoryImpl();
    });

    tearDown(() {
      repository.dispose();
      MockRadioPlayer.dispose();
    });

    test('initial state is correct', () {
      expect(repository.currentStation, isNull);
      expect(repository.isPlaying, isFalse);
      expect(repository.volume, equals(50));
    });

    group('playRadio', () {
      test('successfully plays radio station', () async {
        await repository.playRadio(testStation);

        expect(repository.currentStation, equals(testStation));
        verify(() => mockAudioManager.stopAllJustAudioPlayers()).called(1);
      });

      test('emits current station to stream', () async {
        final stationStream = repository.currentStationStream;
        final stationCompleter = Completer<RadioStation>();

        stationStream.listen((station) {
          if (!stationCompleter.isCompleted) {
            stationCompleter.complete(station);
          }
        });

        await repository.playRadio(testStation);

        final emittedStation = await stationCompleter.future.timeout(
          const Duration(seconds: 1),
        );
        expect(emittedStation, equals(testStation));
      });

      test('handles playRadio errors gracefully', () async {
        when(() => mockAudioManager.stopAllJustAudioPlayers())
            .thenThrow(Exception('Audio manager error'));

        expect(
          () => repository.playRadio(testStation),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('pauseRadio', () {
      test('successfully pauses radio', () async {
        await repository.pauseRadio();
        // Should not throw any exceptions
      });

      test('handles pauseRadio errors gracefully', () async {
        // Mock RadioPlayer.pause to throw
        expect(
          () => repository.pauseRadio(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('stopRadio', () {
      test('successfully stops radio and clears state', () async {
        // First play a station
        await repository.playRadio(testStation);
        expect(repository.currentStation, equals(testStation));

        // Then stop
        await repository.stopRadio();
        expect(repository.currentStation, isNull);
        verify(() => mockAudioManager.isRadioPlaying = false).called(1);
      });

      test('handles stopRadio errors gracefully', () async {
        // Mock RadioPlayer.reset to throw
        expect(
          () => repository.stopRadio(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('setVolume', () {
      test('successfully sets volume', () async {
        await repository.setVolume(75);
        expect(repository.volume, equals(75));
      });

      test('emits volume to stream', () async {
        final volumeStream = repository.volumeStream;
        final volumeCompleter = Completer<double>();

        volumeStream.listen((volume) {
          if (volume == 75 && !volumeCompleter.isCompleted) {
            volumeCompleter.complete(volume);
          }
        });

        await repository.setVolume(75);

        final emittedVolume = await volumeCompleter.future.timeout(
          const Duration(seconds: 1),
        );
        expect(emittedVolume, equals(75));
      });
    });

    group('streams', () {
      test('isPlayingStream emits correct values', () async {
        final playingStream = repository.isPlayingStream;
        final playingCompleter = Completer<bool>();

        playingStream.listen((isPlaying) {
          if (isPlaying && !playingCompleter.isCompleted) {
            playingCompleter.complete(isPlaying);
          }
        });

        // Simulate playback state change
        MockRadioPlayer._playbackStateController.add(PlaybackState.playing);

        final emittedPlaying = await playingCompleter.future.timeout(
          const Duration(seconds: 1),
        );
        expect(emittedPlaying, isTrue);
      });

      test('volumeStream emits correct values', () async {
        final volumeStream = repository.volumeStream;
        final volumeCompleter = Completer<double>();

        volumeStream.listen((volume) {
          if (volume == 80.0 && !volumeCompleter.isCompleted) {
            volumeCompleter.complete(volume);
          }
        });

        await repository.setVolume(80.0);

        final emittedVolume = await volumeCompleter.future.timeout(
          const Duration(seconds: 1),
        );
        expect(emittedVolume, equals(80));
      });
    });

    group('dispose', () {
      test('properly disposes all resources', () {
        expect(() => repository.dispose(), returnsNormally);

        // Verify that streams are closed
        expect(repository.isPlayingStream.isBroadcast, isTrue);
        expect(repository.currentStationStream.isBroadcast, isTrue);
        expect(repository.volumeStream.isBroadcast, isTrue);
      });
    });
  });
}
