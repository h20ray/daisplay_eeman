import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/data/repositories/radio_repository_impl.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/repositories/radio_repository.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/usecases/radio_usecase.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/cubit/radio_cubit.dart';

void setupRadioByTujuhCahayaLocator() {
  locator
    // * Repository
    ..registerLazySingleton<RadioRepository>(RadioRepositoryImpl.new)
    // * UseCase
    ..registerFactory(() => RadioUseCase(locator<RadioRepository>()))
    // * Cubit - Use factory instead of lazy singleton to ensure proper disposal
    ..registerFactory(() => RadioCubit(locator<RadioUseCase>()));
}
