import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
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
  bool _isClosed = false;

  void _initialize() {
    _isPlayingSubscription = _radioUseCase.isPlayingStream.listen((isPlaying) {
      if (!_isClosed && state is RadioLoaded) {
        emit((state as RadioLoaded).copyWith(isPlaying: isPlaying));
      }
    });

    _currentStationSubscription =
        _radioUseCase.currentStationStream.listen((station) {
      if (!_isClosed) {
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
      }
    });

    _volumeSubscription = _radioUseCase.volumeStream.listen((volume) {
      if (!_isClosed && state is RadioLoaded) {
        emit((state as RadioLoaded).copyWith(volume: volume));
      }
    });

    // Listen for just_audio playing state to stop radio when just_audio starts
    _justAudioPlayingSubscription =
        _audioManager.justAudioPlayingStream.listen((isJustAudioPlaying) {
      if (!_isClosed) {
        if (isJustAudioPlaying &&
            state is RadioLoaded &&
            (state as RadioLoaded).isPlaying) {
          // Stop radio when just_audio starts playing
          _stopRadioInternal();
        } else if (!isJustAudioPlaying &&
            _radioUseCase.wasPlayingBeforeJustAudio) {
          // If just_audio stops and radio was playing before, restart it
          _radioUseCase.restartIfWasPlaying();
        }
      }
    });
  }

  Future<void> playRadio(RadioStation station) async {
    if (_isClosed) return;

    try {
      emit(const RadioLoading());
      await _radioUseCase.playRadio(station);
      if (!_isClosed) {
        emit(
          RadioLoaded(
            currentStation: station,
            isPlaying: true,
            volume: _radioUseCase.volume,
          ),
        );
      }
    } catch (e) {
      if (!_isClosed) {
        emit(RadioError(e.toString()));
      }
    }
  }

  Future<void> pauseRadio() async {
    if (_isClosed) return;

    try {
      await _radioUseCase.pauseRadio();
      if (!_isClosed && state is RadioLoaded) {
        emit((state as RadioLoaded).copyWith(isPlaying: false));
      }
    } catch (e) {
      if (!_isClosed) {
        emit(RadioError(e.toString()));
      }
    }
  }

  Future<void> stopRadio() async {
    if (_isClosed) return;

    try {
      await _radioUseCase.stopRadio();
      if (!_isClosed) {
        emit(const RadioInitial());
      }
    } catch (e) {
      if (!_isClosed) {
        emit(RadioError(e.toString()));
      }
    }
  }

  Future<void> _stopRadioInternal() async {
    if (_isClosed) return;

    try {
      await _radioUseCase.stopRadio();
      if (!_isClosed) {
        emit(const RadioInitial());
      }
    } catch (e) {
      // Don't emit error for internal stops to avoid UI disruption
      debugPrint('Error stopping radio internally: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    if (_isClosed) return;

    try {
      await _radioUseCase.setVolume(volume);
      if (!_isClosed && state is RadioLoaded) {
        emit((state as RadioLoaded).copyWith(volume: volume));
      }
    } catch (e) {
      if (!_isClosed) {
        emit(RadioError(e.toString()));
      }
    }
  }

  Future<void> togglePlayPause() async {
    if (_isClosed) return;

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
    _isClosed = true;
    _isPlayingSubscription?.cancel();
    _currentStationSubscription?.cancel();
    _volumeSubscription?.cancel();
    _justAudioPlayingSubscription?.cancel();
    return super.close();
  }
}
