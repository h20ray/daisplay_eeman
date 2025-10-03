import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/common/widgets/expanded_box.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/config/radio_config.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/cubit/radio_cubit.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/state/radio_state.dart';

class RadioPage extends StatelessWidget {
  const RadioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<RadioCubit>(),
      child: const _RadioPageView(),
    );
  }
}

class _RadioPageView extends StatefulWidget {
  const _RadioPageView();

  @override
  State<_RadioPageView> createState() => _RadioPageViewState();
}

class _RadioPageViewState extends State<_RadioPageView>
    with WidgetsBindingObserver {
  bool _hasAutoPlayed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Auto-play after a short delay (like source)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_hasAutoPlayed) {
        _hasAutoPlayed = true;
        _playDefaultRadio(context);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final radioCubit = context.read<RadioCubit>();

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // App is going to background - radio should continue playing
        // The radio_player plugin should handle background playback
        break;
      case AppLifecycleState.resumed:
        // App is coming back to foreground
        // Refresh the radio state to ensure UI is in sync
        if (radioCubit.state is RadioLoaded) {
          // Trigger a state refresh to ensure UI reflects actual playback state
          final currentState = radioCubit.state as RadioLoaded;
          if (currentState.currentStation != null) {
            radioCubit.playRadio(currentState.currentStation!);
          }
        }
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., phone call, notification panel)
        break;
      case AppLifecycleState.hidden:
        // App is hidden but still running
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(context),
          BlocBuilder<RadioCubit, RadioState>(
            builder: (context, state) {
              if (state is RadioInitial) {
                return _buildInitialState(context);
              } else if (state is RadioLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RadioLoaded) {
                return _buildLoadedState(context, state);
              } else if (state is RadioError) {
                return _buildErrorState(context, state);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.radio,
            size: 64.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 16.h),
          Text(
            'Select a radio station to start listening',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => _playDefaultRadio(context),
            child: const Text('Play Default Radio'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, RadioLoaded state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.08;
    final albumArtSize = screenWidth - padding * 2;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          children: [
            // Flexible spacing (like source ExpandedBox)
            const ExpandedBox(flex: 2, minHeight: 20),
            // Album art with animated switching and metadata support (like source)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _buildAlbumArtWithMetadata(
                context,
                key: ValueKey(state.currentStation!.id),
                size: albumArtSize,
                imagePath: state.currentStation!.imagePath,
                metadataArtwork: state.artwork,
              ),
            ),
            // Flexible spacing (like source ExpandedBox)
            const ExpandedBox(flex: 4),
            // Station info with metadata and faded text box (like source)
            _buildStationInfoWithFadeAndMetadata(context, state),
            // Flexible spacing (like source ExpandedBox)
            const ExpandedBox(),
            // Single play/pause button (like source)
            _buildSingleControlButton(
              context,
              isPlaying: state.isPlaying,
              onPressed: () => context.read<RadioCubit>().togglePlayPause(),
            ),
            // Flexible spacing (like source ExpandedBox)
            const ExpandedBox(),
            // Volume slider (like source)
            _buildVolumeSlider(context),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, RadioError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error: ${state.message}',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.read<RadioCubit>().stopRadio(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArtWithMetadata(
    BuildContext context, {
    required Key key,
    required double size,
    required String imagePath,
    String? metadataArtwork,
  }) {
    return Container(
      key: key,
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(2, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: _buildAlbumArtContent(context, imagePath, metadataArtwork),
      ),
    );
  }

  Widget _buildAlbumArtContent(
    BuildContext context,
    String imagePath,
    String? metadataArtwork,
  ) {
    // Priority: metadata artwork > station image > default icon
    if (metadataArtwork != null && metadataArtwork.isNotEmpty) {
      return Image.network(
        metadataArtwork,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildAlbumArtContent(context, imagePath, null),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingArtwork(context);
        },
      );
    } else if (imagePath.isNotEmpty) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildDefaultIcon(context),
      );
    } else {
      return _buildDefaultIcon(context);
    }
  }

  Widget _buildLoadingArtwork(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildStationInfoWithFadeAndMetadata(
    BuildContext context,
    RadioLoaded state,
  ) {
    return _buildFadedBox(
      context,
      height: 65.h,
      alignment: AlignmentDirectional.centerEnd,
      gradientWidth: 20.w,
      child: _buildStationInfoWithMetadata(context, state),
    );
  }

  Widget _buildFadedBox(
    BuildContext context, {
    required double height,
    required AlignmentGeometry alignment,
    required double gradientWidth,
    required Widget child,
  }) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          child,
          Align(
            alignment: alignment,
            child: Container(
              width: gradientWidth,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface.withValues(alpha: 0),
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationInfoWithMetadata(
    BuildContext context,
    RadioLoaded state,
  ) {
    final station = state.currentStation!;
    final metadata = state.metadata;

    // Use metadata from radio stream if available, otherwise fallback to station data
    final artist = (metadata != null && metadata.isNotEmpty)
        ? metadata[0].trim()
        : station.artist;
    final track = (metadata != null && metadata.length > 1)
        ? metadata[1].trim()
        : station.track;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Artist/Station title (larger, bold)
        TextScroll(
          artist ?? station.title,
          intervalSpaces: 7,
          velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
          delayBefore: const Duration(seconds: 1),
          pauseBetween: const Duration(seconds: 2),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        if (track != null && track.isNotEmpty) ...[
          SizedBox(height: 8.h),
          // Track info (smaller, lighter)
          TextScroll(
            track,
            intervalSpaces: 10,
            velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
            delayBefore: const Duration(seconds: 1),
            pauseBetween: const Duration(seconds: 2),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildSingleControlButton(
    BuildContext context, {
    required bool isPlaying,
    required VoidCallback onPressed,
  }) {
    return ClipOval(
      child: Material(
        color: Theme.of(context).colorScheme.primary,
        child: InkWell(
          onTap: onPressed,
          splashColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          splashFactory: InkRipple.splashFactory,
          child: SizedBox(
            width: 70.w,
            height: 70.w,
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 38.sp,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeSlider(BuildContext context) {
    return BlocBuilder<RadioCubit, RadioState>(
      builder: (context, state) {
        var volume = 0.5; // Default volume

        if (state is RadioLoaded) {
          volume = state.volume / 100; // Convert from 0-100 to 0-1
        }

        final volumePercent = (volume * 100).round();

        return Slider(
          value: volume,
          divisions: 100,
          label: '$volumePercent%',
          onChanged: (value) async {
            // Update the UI state (this will be used by the radio system)
            if (context.mounted) {
              await context.read<RadioCubit>().setVolume(value * 100);
            }
          },
        );
      },
    );
  }

  Widget _buildDefaultIcon(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      child: Icon(
        Icons.radio,
        color: Theme.of(context).colorScheme.primary,
        size: 64.sp,
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.2),
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Container(),
    );
  }

  void _playDefaultRadio(BuildContext context) {
    const defaultStation = RadioStation(
      id: 'default',
      title: RadioConfigValues.title,
      url: RadioConfigValues.streamingUrl,
      imagePath: RadioConfigValues.imagePath,
    );
    context.read<RadioCubit>().playRadio(defaultStation);
  }
}
