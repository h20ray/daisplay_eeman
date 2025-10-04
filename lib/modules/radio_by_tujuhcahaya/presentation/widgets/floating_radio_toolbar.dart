import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quran_app/common/extensions/text_theme_extension.dart';
import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/common/services/global_audio_manager.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/config/radio_config.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/cubit/radio_cubit.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/state/radio_state.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/pages/radio_page.dart';

class FloatingRadioToolbar extends StatefulWidget {
  const FloatingRadioToolbar({super.key});

  @override
  State<FloatingRadioToolbar> createState() => _FloatingRadioToolbarState();
}

class _FloatingRadioToolbarState extends State<FloatingRadioToolbar> {
  late final GlobalAudioManager _audioManager;
  late final RadioConfigService _radioConfigService;
  bool _isProcessingAction = false;
  DateTime? _lastActionTime;

  @override
  void initState() {
    super.initState();
    _audioManager = GlobalAudioManager();
    _radioConfigService = locator<RadioConfigService>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioCubit, RadioState>(
      builder: (context, state) {
        // Keep toolbar visible for Initial, Loading, and Loaded states to avoid blink
        if (state is! RadioLoaded &&
            state is! RadioInitial &&
            state is! RadioLoading) {
          return const SizedBox.shrink();
        }

        // Get current station info (toolbar uses static config; ignore metadata)
        RadioStation? currentStation;
        var isPlaying = false;
        final isLoading = state is RadioLoading;

        if (state is RadioLoaded) {
          currentStation = state.currentStation;
          isPlaying = state.isPlaying;
        }

        return Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 16.h + MediaQuery.of(context).padding.bottom,
          child: Material(
            elevation: 6,
            shadowColor:
                Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(28.r),
            child: InkWell(
              onTap: () => _navigateToRadioPage(context),
              borderRadius: BorderRadius.circular(28.r),
              child: Container(
                height: 144.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: StreamBuilder<bool>(
                    initialData: _audioManager.isJustAudioPlaying,
                    stream: _audioManager.justAudioPlayingStream,
                    builder: (context, snap) {
                      final isQuranPlaying = snap.data ?? false;
                      final effectiveIsPlaying = isPlaying && !isQuranPlaying;
                      return Row(
                        children: [
                          _buildAlbumArt(context, currentStation),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: _buildNowPlayingInfo(
                              context,
                              null,
                              effectiveIsPlaying,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          _buildPlayStopButton(
                            context,
                            effectiveIsPlaying,
                            isLoading,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumArt(BuildContext context, RadioStation? station) {
    return Container(
      width: 96.w,
      height: 96.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: (station?.imagePath.isNotEmpty ?? false)
            ? Image.asset(
                station!.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultIcon(context),
              )
            : _buildDefaultIcon(context),
      ),
    );
  }

  Widget _buildDefaultIcon(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Icon(
        Icons.radio,
        color: Theme.of(context).colorScheme.onPrimary,
        size: 48.sp,
      ),
    );
  }

  Widget _buildNowPlayingInfo(
    BuildContext context,
    RadioStation? _,
    bool isPlaying,
  ) {
    final config = _radioConfigService.currentConfig;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status indicator
        Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: isPlaying
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              isPlaying ? config.nowPlayingStatus : config.defaultStatus,
              style: context.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
                fontSize: 28.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        // Station title (static from config)
        Text(
          config.title,
          style: context.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 36.sp,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // No dynamic metadata line; keep UI static per config
      ],
    );
  }

  Widget _buildPlayStopButton(
    BuildContext context,
    bool isPlaying,
    bool isLoading,
  ) {
    final isDisabled = isLoading || _isProcessingAction;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : () => _handlePlayStop(context, isPlaying),
        borderRadius: BorderRadius.circular(40.r),
        child: Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: isDisabled
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(40.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isDisabled
              ? SizedBox(
                  width: 40.sp,
                  height: 40.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )
              : Icon(
                  isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 40.sp,
                ),
        ),
      ),
    );
  }

  Future<void> _handlePlayStop(BuildContext context, bool isPlaying) async {
    if (_isProcessingAction) {
      return;
    }

    // Debounce rapid clicks (prevent multiple actions within 1000ms)
    final now = DateTime.now();
    if (_lastActionTime != null &&
        now.difference(_lastActionTime!).inMilliseconds < 1000) {
      return;
    }
    _lastActionTime = now;

    setState(() {
      _isProcessingAction = true;
    });

    try {
      if (isPlaying) {
        // Stop radio and notify audio manager
        await context.read<RadioCubit>().stopRadio();
        _audioManager.isRadioPlaying = false;
      } else {
        // Start default radio if not playing
        await _startDefaultRadio(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingAction = false;
        });
      }
    }
  }

  Future<void> _startDefaultRadio(BuildContext context) async {
    final config = _radioConfigService.currentConfig;
    final defaultStation = RadioStation(
      id: 'default',
      title: config.title,
      url: config.streamingUrl,
      imagePath: config.imagePath,
    );

    // Notify audio manager that radio is starting
    _audioManager.isRadioPlaying = true;
    await context.read<RadioCubit>().playRadio(defaultStation);
  }

  void _navigateToRadioPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const RadioPage(),
      ),
    );
  }
}
