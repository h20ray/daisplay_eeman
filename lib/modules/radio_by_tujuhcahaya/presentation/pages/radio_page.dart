/*
 * Radio Page - Material Design 3 Expressive
 * Modern, accessible radio player interface following M3 guidelines
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/widgets/base_page.dart';
import 'package:quran_app/common/widgets/custom_app_bar.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/config/radio_config.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/cubit/radio_cubit.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/state/radio_state.dart';

class RadioPage extends StatelessWidget {
  const RadioPage({super.key});
  static const routeName = '/radio';

  @override
  Widget build(BuildContext context) {
    return BasePage.noPadding(
      appBar: const CustomAppBar(
        title: RadioConfigValues.title,
      ),
      child: BlocBuilder<RadioCubit, RadioState>(
        builder: (context, state) {
          return _RadioPlayerContent(state: state);
        },
      ),
    );
  }
}

class _RadioPlayerContent extends StatelessWidget {
  const _RadioPlayerContent({required this.state});

  final RadioState state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            const Spacer(flex: 2),
            _RadioArtwork(state: state),
            const Spacer(flex: 3),
            _RadioInfo(state: state),
            const Spacer(flex: 2),
            _VolumeControl(state: state),
            const Spacer(),
            _PlaybackControls(state: state),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _RadioArtwork extends StatelessWidget {
  const _RadioArtwork({required this.state});

  final RadioState state;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.7;

    var imagePath = RadioConfigValues.imagePath;
    if (state is RadioLoaded &&
        ((state as RadioLoaded).currentStation?.imagePath.isNotEmpty ??
            false)) {
      imagePath = (state as RadioLoaded).currentStation!.imagePath;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
            ),
            child: Icon(
              Icons.radio,
              size: size * 0.4,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioInfo extends StatelessWidget {
  const _RadioInfo({required this.state});

  final RadioState state;

  @override
  Widget build(BuildContext context) {
    var title = RadioConfigValues.title;
    const subtitle = RadioConfigValues.radioStreamingSubtitle;
    var isPlaying = false;

    if (state is RadioLoaded) {
      final loadedState = state as RadioLoaded;
      title = loadedState.currentStation?.title ?? RadioConfigValues.title;
      isPlaying = loadedState.isPlaying;
    }

    return Column(
      children: [
        // Status indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isPlaying
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPlaying)
                _LiveIndicator()
              else
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                isPlaying ? RadioConfigValues.liveStatusText : RadioConfigValues.stoppedStatusText,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isPlaying
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Station title
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Subtitle
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _VolumeControl extends StatelessWidget {
  const _VolumeControl({required this.state});

  final RadioState state;

  void _increaseVolume(BuildContext context, double currentVolume) {
    final newVolume = (currentVolume + 5).clamp(0, 100).toDouble();
    context.read<RadioCubit>().setVolume(newVolume);
  }

  void _decreaseVolume(BuildContext context, double currentVolume) {
    final newVolume = (currentVolume - 5).clamp(0, 100).toDouble();
    context.read<RadioCubit>().setVolume(newVolume);
  }

  @override
  Widget build(BuildContext context) {
    double volume = 0; // Default to 0, will be updated from state
    if (state is RadioLoaded) {
      volume = (state as RadioLoaded).volume;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Volume Down Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _decreaseVolume(context, volume),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.volume_down_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Text(
              RadioConfigValues.volumeLabelText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            // Volume Up Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _increaseVolume(context, volume),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: volume,
            max: 100,
            divisions: 100,
            label: '${volume.round()}%',
            onChanged: (newVolume) {
              context.read<RadioCubit>().setVolume(newVolume);
            },
          ),
        ),
      ],
    );
  }
}

class _PlaybackControls extends StatefulWidget {
  const _PlaybackControls({required this.state});

  final RadioState state;

  @override
  State<_PlaybackControls> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<_PlaybackControls> {
  DateTime? _lastActionTime;

  @override
  Widget build(BuildContext context) {
    // Get the current state from BlocBuilder instead of widget parameter
    return BlocBuilder<RadioCubit, RadioState>(
      builder: (context, currentState) {
        var isPlaying = false;
        final isLoading = currentState is RadioLoading;

        if (currentState is RadioLoaded) {
          isPlaying = currentState.isPlaying;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Single play/stop button
            _ControlButton(
              icon: isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
              onPressed: !isLoading ? () => _handlePlayStop(isPlaying) : null,
              isActive: true,
              isLoading: isLoading,
            ),
          ],
        );
      },
    );
  }

  void _handlePlayStop(bool isPlaying) {
    // Debounce rapid clicks (prevent multiple actions within 1000ms)
    final now = DateTime.now();
    if (_lastActionTime != null &&
        now.difference(_lastActionTime!).inMilliseconds < 1000) {
      return;
    }
    _lastActionTime = now;

    if (isPlaying) {
      context.read<RadioCubit>().stopRadio();
    } else {
      const defaultStation = RadioStation(
        id: 'default',
        title: RadioConfigValues.title,
        url: RadioConfigValues.streamingUrl,
        imagePath: RadioConfigValues.imagePath,
      );
      context.read<RadioCubit>().playRadio(defaultStation);
    }
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.isActive,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isActive;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final size = isActive ? 72.0 : 56.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(size / 2),
            border: isActive
                ? null
                : Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                  ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )
              : Icon(
                  icon,
                  size: isActive ? 32 : 24,
                  color: isActive
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
        ),
      ),
    );
  }
}

class _LiveIndicator extends StatefulWidget {
  @override
  _LiveIndicatorState createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<_LiveIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Create animation controller with 1.5 second duration
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create scale animation (breathing effect)
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ),);

    // Create opacity animation (blinking effect)
    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ),);

    // Start the animation and repeat it
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
