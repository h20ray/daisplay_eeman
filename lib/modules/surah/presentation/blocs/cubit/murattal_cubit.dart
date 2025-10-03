import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/common/constants/constant.dart';
import 'package:quran_app/common/extensions/dialog_extension.dart';
import 'package:quran_app/common/extensions/text_theme_extension.dart';
import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/common/services/global_audio_manager.dart';
import 'package:quran_app/l10n/l10n.dart';
import 'package:quran_app/modules/surah_list/data/domain/surah_model.dart';

part '../state/murattal_state.dart';

class MurattalCubit extends Cubit<MurattalState> {
  MurattalCubit() : super(const MurattalInitial([]));

  final GlobalAudioManager _audioManager = locator<GlobalAudioManager>();
  AudioPlayer player = AudioPlayer();
  late List<AudioSource> audioSources;
  bool errorAlreadyShowed = false;

  void init(BuildContext context, Surah surah) {
    emit(MurattalLoading());

    // Register this player with the global audio manager
    _audioManager.registerJustAudioPlayer(player);

    final audioFileName = List.generate(surah.numberOfVerses ?? 1, (index) {
      final verseNumber = index + 1;
      return AudioSource.uri(
        Uri.parse(
          '$baseAudioUrl/${surah.number.toString().padLeft(3, '0')}${verseNumber.toString().padLeft(3, '0')}.mp3',
        ),
      );
    });

    // Add Bismillah audio if not surah 1
    if (surah.number != 1) {
      audioFileName.insert(
        0,
        AudioSource.uri(Uri.parse('$baseAudioUrl/001001.mp3')),
      );
    }

    audioSources = audioFileName;
    emit(MurattalLoaded(audioFileName, player, audioSources));

    // Catching errors during playback (e.g. lost network connection)
    player.playbackEventStream.listen(
      (event) {
        if (event.processingState == ProcessingState.completed) {
          emit(MurattalLoaded(audioFileName, player, audioSources));
        }
      },
      onError: (Object e) {
        onErrorAudioPlaying(context, e);
      },
    );
  }

  Future<void> onErrorAudioPlaying(BuildContext context, Object e) async {
    final internet = await checkInternetConnection();
    final l10n = context.l10n;
    if (!internet && !errorAlreadyShowed) {
      errorAlreadyShowed = true;

      context.showAppDialog(
        title: l10n.internetNeeded,
        content: Text(
          l10n.internetNeededDesc,
          style: context.bodyMedium,
        ),
      );
    }
    if (e is PlayerException) {
      debugPrint('Error code: ${e.code}');
      debugPrint('Error message: ${e.message}');
    } else {
      debugPrint('An error occurred: $e');
    }
  }

  Future<void> play(BuildContext context) async {
    try {
      // Stop all other just_audio players before starting this one
      await _audioManager.stopAllJustAudioPlayers();

      // Stop radio if it's playing to ensure clean audio session
      await _audioManager.stopRadioIfPlaying();

      // Add a delay to ensure audio session is completely released
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final internet = await checkInternetConnection();
      if (internet) {
        // Ensure player is in a valid state before setting audio sources
        if (player.processingState == ProcessingState.idle ||
            player.processingState == ProcessingState.completed) {
          await player.setAudioSources(
            audioSources,
            initialIndex: 0,
            initialPosition: Duration.zero,
          );
        }
      } else {
        throw PlayerException(0, 'Source error', 0);
      }

      emit(MurattalPlaying());
      await player.play();
    } on PlayerException catch (e) {
      if (e.message.toString() == 'Source error') {
        context.showAppDialog(
          title: context.l10n.internetNeeded,
          content: Text(
            context.l10n.internetNeededDesc,
            style: context.bodyMedium,
          ),
        );
      }
    }
  }

  Future<void> pause(BuildContext context) async {
    try {
      if (player.playing) {
        emit(MurattalPaused());
        await player.pause();
      } else {
        throw PlayerException(0, 'Source error', 0);
      }
    } on PlayerException catch (e) {
      if (e.message.toString() == 'Source error') {
        context.showAppDialog(
          title: context.l10n.internetNeeded,
          content: Text(
            context.l10n.internetNeededDesc,
            style: context.bodyMedium,
          ),
        );
      }
    }
  }

  void dispose() {
    // Unregister from global audio manager before disposing
    _audioManager.unregisterJustAudioPlayer(player);
    player
      ..stop()
      ..dispose();
  }
}
