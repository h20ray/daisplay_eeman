import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/common/global_variable.dart';
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

class _RadioPageView extends StatelessWidget {
  const _RadioPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio'),
        centerTitle: true,
      ),
      body: BlocBuilder<RadioCubit, RadioState>(
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
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Album art
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: state.currentStation!.imagePath.isNotEmpty
                  ? Image.asset(
                      state.currentStation!.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultIcon(context),
                    )
                  : _buildDefaultIcon(context),
            ),
          ),
          SizedBox(height: 32.h),
          // Station info
          Text(
            state.currentStation!.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          if (state.currentStation!.artist != null &&
              state.currentStation!.artist!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              state.currentStation!.artist!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 48.h),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => context.read<RadioCubit>().stopRadio(),
                icon: const Icon(Icons.stop),
                iconSize: 32.sp,
              ),
              SizedBox(width: 16.w),
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => context.read<RadioCubit>().togglePlayPause(),
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 40.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
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

  void _playDefaultRadio(BuildContext context) {
    const defaultStation = RadioStation(
      id: 'default',
      title: 'Radio Tujuh Cahaya',
      url:
          'https://stream.zeno.fm/your-radio-stream-url', // Replace with actual URL
      imagePath: 'assets/icons/ic_radio_logo.png',
    );
    context.read<RadioCubit>().playRadio(defaultStation);
  }
}
