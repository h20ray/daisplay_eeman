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

  // State management to prevent rapid toggling
  bool _isActionInProgress = false;
  DateTime? _lastStateChange;

  void _initialize() {
    // Check initial state when cubit is created
    _checkInitialState();

    _isPlayingSubscription = _radioUseCase.isPlayingStream.listen(
      (isPlaying) {
        if (isClosed) return;

        // Prevent rapid state changes
        final now = DateTime.now();
        if (_lastStateChange != null &&
            now.difference(_lastStateChange!).inMilliseconds < 500) {
          return;
        }
        _lastStateChange = now;

        if (state is RadioLoaded) {
          emit((state as RadioLoaded).copyWith(isPlaying: isPlaying));
        } else if (isPlaying) {
          // If we receive isPlaying=true but state is not RadioLoaded,
          // we need to get the current station and emit RadioLoaded
          _handlePlayingStateWithoutLoadedState();
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
    if (_isActionInProgress) {
      return;
    }

    try {
      if (isClosed) return;
      _isActionInProgress = true;
      emit(const RadioLoading());
      await _radioUseCase.playRadio(station);
      if (isClosed) return;
      // Don't emit state here - let the playback state stream handle it
      // This prevents race conditions between manual state and stream state
    } catch (e) {
      if (isClosed) return;
      emit(RadioError(e.toString()));
    } finally {
      _isActionInProgress = false;
    }
  }

  Future<void> pauseRadio() async {
    if (_isActionInProgress) return;

    try {
      if (isClosed) return;
      _isActionInProgress = true;
      await _radioUseCase.pauseRadio();
      if (isClosed) return;
      // Don't emit state here - let the playback state stream handle it
      // This prevents race conditions between manual state and stream state
    } catch (e) {
      if (isClosed) return;
      emit(RadioError('Failed to pause radio: $e'));
    } finally {
      _isActionInProgress = false;
    }
  }

  Future<void> stopRadio() async {
    if (_isActionInProgress) return;

    try {
      if (isClosed) return;
      _isActionInProgress = true;
      await _radioUseCase.stopRadio();
      if (isClosed) return;
      // Emit RadioLoaded with isPlaying: false to preserve volume information
      emit(
        RadioLoaded(
          currentStation: null,
          isPlaying: false,
          volume: _radioUseCase.volume,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(RadioError(e.toString()));
    } finally {
      _isActionInProgress = false;
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

  void _checkInitialState() {
    // Wait for volume to be initialized before emitting initial state
    _radioUseCase.volumeStream.take(1).listen((volume) {
      if (!isClosed) {
        // Emit with the actual system volume (even if it's 0)
        final currentStation = _radioUseCase.currentStation;
        emit(
          RadioLoaded(
            currentStation: currentStation,
            isPlaying: _radioUseCase.isPlaying,
            volume: volume,
          ),
        );
      }
    });
  }

  void _handlePlayingStateWithoutLoadedState() {
    // Get the current station from the repository and emit RadioLoaded
    _radioUseCase.currentStationStream.take(1).listen((station) {
      if (!isClosed) {
        emit(
          RadioLoaded(
            currentStation: station,
            isPlaying: true,
            volume: _radioUseCase.volume,
          ),
        );
      }
    });
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
