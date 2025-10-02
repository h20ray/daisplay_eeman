import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/common/widgets/app_loading.dart';
import 'package:quran_app/common/widgets/spacing.dart';
import 'package:quran_app/modules/doa_sehari_hari/doa_sehari_hari.dart';
import 'package:quran_app/modules/doa_sehari_hari/presentation/widgets/doa_sehari_hari_view.dart';

class DoaSehariHariPage extends StatelessWidget {
  const DoaSehariHariPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<DoaSehariHariCubit>()..loadDoaDaily(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Doa Harian',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<DoaSehariHariCubit, DoaSehariHariState>(
          builder: (context, state) {
            if (state is DoaSehariHariLoading) {
              return const Center(child: AppLoading());
            }

            if (state is DoaSehariHariError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const EemanSpacing.vertical16(),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const EemanSpacing.vertical16(),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<DoaSehariHariCubit>().loadDoaDaily(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is DoaSehariHariLoaded) {
              return DoaSehariHariView(doaDaily: state.doaDaily);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
