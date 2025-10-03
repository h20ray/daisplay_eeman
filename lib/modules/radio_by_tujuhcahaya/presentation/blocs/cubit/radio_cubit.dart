import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:quran_app/common/services/global_audio_manager.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/usecases/radio_usecase.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/state/radio_state.dart';

class RadioCubit extends Cubit<RadioState> {
  RadioCubit(this._radioUseCase) : super(const RadioInitial()) {
    _initialize();
  }

  final RadioUseCase _radioUseCase;
  final GlobalAudioManager _audioManager = GlobalAudioManager();
  StreamSubscription<bool>? _isPlayingSubscription;
  StreamSubscription<RadioStation>? _currentStationSubscription;
  StreamSubscription<double>? _volumeSubscription;
  StreamSubscription<bool>? _justAudioPlayingSubscription;

  void _initialize() {
    _isPlayingSubscription = _radioUseCase.isPlayingStream.listen(
      (isPlaying) {
        if (isClosed) return;
        if (state is RadioLoaded) {
          emit((state as RadioLoaded).copyWith(isPlaying: isPlaying));
        }
      },
      onError: (Object error) {
        if (isClosed) return;
        emit(RadioError('Playback state error: $error'));
      },
    );

    _currentStationSubscription = _radioUseCase.currentStationStream.listen(
      (station) {
        if (isClosed) return;
        if (state is RadioLoaded) {
          emit((state as RadioLoaded).copyWith(currentStation: station));
        } else {
          emit(
            RadioLoaded(
              currentStation: station,
              isPlaying: _radioUseCase.isPlaying,
              volume: _radioUseCase.volume,
            ),
          );
        }
      },
      onError: (Object error) {
        if (isClosed) return;
        emit(RadioError('Station state error: $error'));
      },
    );

    _volumeSubscription = _radioUseCase.volumeStream.listen(
      (volume) {
        if (isClosed) return;
        if (state is RadioLoaded) {
          emit((state as RadioLoaded).copyWith(volume: volume));
        }
      },
      onError: (Object error) {
        if (isClosed) return;
        emit(RadioError('Volume state error: $error'));
      },
    );

    // Listen for just_audio playing state to stop radio when just_audio starts
    _justAudioPlayingSubscription = _audioManager.justAudioPlayingStream.listen(
      (isJustAudioPlaying) {
        if (isClosed) return;
        if (isJustAudioPlaying &&
            state is RadioLoaded &&
            (state as RadioLoaded).isPlaying) {
          // Stop radio when just_audio starts playing
          stopRadio();
        }
      },
      onError: (Object error) {
        if (isClosed) return;
        emit(RadioError('Audio manager error: $error'));
      },
    );
  }

  Future<void> playRadio(RadioStation station) async {
    try {
      if (isClosed) return;
      emit(const RadioLoading());
      await _radioUseCase.playRadio(station);
      if (isClosed) return;
      emit(
        RadioLoaded(
          currentStation: station,
          isPlaying: true,
          volume: _radioUseCase.volume,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(RadioError(e.toString()));
    }
  }

  Future<void> pauseRadio() async {
    try {
      await _radioUseCase.pauseRadio();
      if (isClosed) return;
      if (state is RadioLoaded) {
        emit((state as RadioLoaded).copyWith(isPlaying: false));
      }
    } catch (e) {
      if (isClosed) return;
      emit(RadioError('Failed to pause radio: $e'));
    }
  }

  Future<void> stopRadio() async {
    try {
      await _radioUseCase.stopRadio();
      if (isClosed) return;
      emit(const RadioInitial());
    } catch (e) {
      if (isClosed) return;
      emit(RadioError(e.toString()));
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _radioUseCase.setVolume(volume);
      if (state is RadioLoaded) {
        emit((state as RadioLoaded).copyWith(volume: volume));
      }
    } catch (e) {
      emit(RadioError(e.toString()));
    }
  }

  Future<void> togglePlayPause() async {
    if (state is RadioLoaded) {
      final currentState = state as RadioLoaded;
      if (currentState.isPlaying) {
        await pauseRadio();
      } else {
        if (currentState.currentStation != null) {
          await playRadio(currentState.currentStation!);
        }
      }
    }
  }

  @override
  Future<void> close() {
    _isPlayingSubscription?.cancel();
    _currentStationSubscription?.cancel();
    _volumeSubscription?.cancel();
    _justAudioPlayingSubscription?.cancel();

    // Clean up any ongoing operations
    _isPlayingSubscription = null;
    _currentStationSubscription = null;
    _volumeSubscription = null;
    _justAudioPlayingSubscription = null;

    return super.close();
  }
}
