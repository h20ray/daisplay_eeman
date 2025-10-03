import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/usecases/radio_usecase.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/cubit/radio_cubit.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/state/radio_state.dart';

class MockRadioUseCase extends Mock implements RadioUseCase {}

const testStation = RadioStation(
  id: 'test',
  title: 'Test Radio',
  url: 'https://test.com/stream',
  imagePath: 'assets/test.png',
);

void main() {
  setUpAll(() {
    registerFallbackValue(testStation);
  });

  group('RadioCubit', () {
    late RadioCubit radioCubit;
    late MockRadioUseCase mockRadioUseCase;

    setUp(() {
      mockRadioUseCase = MockRadioUseCase();

      // Mock the streams
      when(() => mockRadioUseCase.isPlayingStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => mockRadioUseCase.currentStationStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => mockRadioUseCase.volumeStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => mockRadioUseCase.volume).thenReturn(50);
      when(() => mockRadioUseCase.isPlaying).thenReturn(false);

      radioCubit = RadioCubit(mockRadioUseCase);
    });

    tearDown(() {
      radioCubit.close();
    });

    test('initial state is RadioInitial', () {
      expect(radioCubit.state, equals(const RadioInitial()));
    });

    group('playRadio', () {
      blocTest<RadioCubit, RadioState>(
        'emits [RadioLoading, RadioLoaded] when playRadio succeeds',
        build: () {
          when(() => mockRadioUseCase.playRadio(any()))
              .thenAnswer((_) async {});
          when(() => mockRadioUseCase.volume).thenReturn(50);
          return radioCubit;
        },
        act: (cubit) => cubit.playRadio(testStation),
        expect: () => [
          const RadioLoading(),
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: true,
            volume: 50,
          ),
        ],
        verify: (_) {
          verify(() => mockRadioUseCase.playRadio(testStation)).called(1);
        },
      );

      blocTest<RadioCubit, RadioState>(
        'emits [RadioLoading, RadioError] when playRadio fails',
        build: () {
          when(() => mockRadioUseCase.playRadio(any()))
              .thenThrow(Exception('Network error'));
          return radioCubit;
        },
        act: (cubit) => cubit.playRadio(testStation),
        expect: () => [
          const RadioLoading(),
          const RadioError('Exception: Network error'),
        ],
      );
    });

    group('pauseRadio', () {
      blocTest<RadioCubit, RadioState>(
        'emits RadioLoaded with isPlaying false when pauseRadio succeeds',
        build: () {
          when(() => mockRadioUseCase.pauseRadio()).thenAnswer((_) async {});
          return radioCubit;
        },
        seed: () => const RadioLoaded(
          currentStation: testStation,
          isPlaying: true,
          volume: 50,
        ),
        act: (cubit) => cubit.pauseRadio(),
        expect: () => [
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: false,
            volume: 50,
          ),
        ],
        verify: (_) {
          verify(() => mockRadioUseCase.pauseRadio()).called(1);
        },
      );

      blocTest<RadioCubit, RadioState>(
        'emits RadioError when pauseRadio fails',
        build: () {
          when(() => mockRadioUseCase.pauseRadio())
              .thenThrow(Exception('Pause failed'));
          return radioCubit;
        },
        seed: () => const RadioLoaded(
          currentStation: testStation,
          isPlaying: true,
          volume: 50,
        ),
        act: (cubit) => cubit.pauseRadio(),
        expect: () => [
          const RadioError('Failed to pause radio: Exception: Pause failed'),
        ],
      );
    });

    group('stopRadio', () {
      blocTest<RadioCubit, RadioState>(
        'emits RadioInitial when stopRadio succeeds',
        build: () {
          when(() => mockRadioUseCase.stopRadio()).thenAnswer((_) async {});
          return radioCubit;
        },
        seed: () => const RadioLoaded(
          currentStation: testStation,
          isPlaying: true,
          volume: 50,
        ),
        act: (cubit) => cubit.stopRadio(),
        expect: () => [const RadioInitial()],
        verify: (_) {
          verify(() => mockRadioUseCase.stopRadio()).called(1);
        },
      );

      blocTest<RadioCubit, RadioState>(
        'emits RadioError when stopRadio fails',
        build: () {
          when(() => mockRadioUseCase.stopRadio())
              .thenThrow(Exception('Stop failed'));
          return radioCubit;
        },
        seed: () => const RadioLoaded(
          currentStation: testStation,
          isPlaying: true,
          volume: 50,
        ),
        act: (cubit) => cubit.stopRadio(),
        expect: () => [
          const RadioError('Exception: Stop failed'),
        ],
      );
    });

    group('setVolume', () {
      blocTest<RadioCubit, RadioState>(
        'emits RadioLoaded with new volume when setVolume succeeds',
        build: () {
          when(() => mockRadioUseCase.setVolume(any()))
              .thenAnswer((_) async {});
          return radioCubit;
        },
        seed: () => const RadioLoaded(
          currentStation: testStation,
          isPlaying: true,
          volume: 50,
        ),
        act: (cubit) => cubit.setVolume(75.0),
        expect: () => [
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: true,
            volume: 75.0,
          ),
        ],
        verify: (_) {
          verify(() => mockRadioUseCase.setVolume(75.0)).called(1);
        },
      );

      blocTest<RadioCubit, RadioState>(
        'emits RadioError when setVolume fails',
        build: () {
          when(() => mockRadioUseCase.setVolume(any()))
              .thenThrow(Exception('Volume failed'));
          return radioCubit;
        },
        seed: () => const RadioLoaded(
          currentStation: testStation,
          isPlaying: true,
          volume: 50,
        ),
        act: (cubit) => cubit.setVolume(75.0),
        expect: () => [
          const RadioError('Exception: Volume failed'),
        ],
      );
    });

    group('togglePlayPause', () {
      blocTest<RadioCubit, RadioState>(
        'calls pauseRadio when currently playing',
        build: () {
          when(() => mockRadioUseCase.pauseRadio()).thenAnswer((_) async {});
          return radioCubit;
        },
        seed: () => const RadioLoaded(
          currentStation: testStation,
          isPlaying: true,
          volume: 50,
        ),
        act: (cubit) => cubit.togglePlayPause(),
        expect: () => [
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: false,
            volume: 50,
          ),
        ],
        verify: (_) {
          verify(() => mockRadioUseCase.pauseRadio()).called(1);
        },
      );

      blocTest<RadioCubit, RadioState>(
        'calls playRadio when currently paused',
        build: () {
          when(() => mockRadioUseCase.playRadio(any()))
              .thenAnswer((_) async {});
          when(() => mockRadioUseCase.volume).thenReturn(50);
          return radioCubit;
        },
        seed: () => const RadioLoaded(
          currentStation: testStation,
          isPlaying: false,
          volume: 50,
        ),
        act: (cubit) => cubit.togglePlayPause(),
        expect: () => [
          const RadioLoading(),
          const RadioLoaded(
            currentStation: testStation,
            isPlaying: true,
            volume: 50,
          ),
        ],
        verify: (_) {
          verify(() => mockRadioUseCase.playRadio(testStation)).called(1);
        },
      );
    });
  });
}
