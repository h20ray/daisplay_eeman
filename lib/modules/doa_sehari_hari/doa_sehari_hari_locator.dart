import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/modules/doa_sehari_hari/data/repositories/doa_sehari_hari_repository_impl.dart';
import 'package:quran_app/modules/doa_sehari_hari/domain/doa_sehari_hari_repository.dart';
import 'package:quran_app/modules/doa_sehari_hari/domain/doa_sehari_hari_usecase.dart';
import 'package:quran_app/modules/doa_sehari_hari/presentation/blocs/cubit/doa_sehari_hari_cubit.dart';

void setupDoaSehariHariLocator() {
  // Check if already registered to avoid conflicts
  if (!locator.isRegistered<DoaSehariHariRepository>()) {
    locator.registerLazySingleton<DoaSehariHariRepository>(
      createDoaSehariHariRepository,
    );
  }

  if (!locator.isRegistered<DoaSehariHariUseCase>()) {
    locator.registerLazySingleton<DoaSehariHariUseCase>(
      () => createDoaSehariHariUseCase(
        locator<DoaSehariHariRepository>(),
      ),
    );
  }

  if (!locator.isRegistered<DoaSehariHariCubit>()) {
    locator.registerFactory<DoaSehariHariCubit>(
      () => DoaSehariHariCubit(locator<DoaSehariHariUseCase>()),
    );
  }
}
