import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quran_app/common/domain/pray.dart';
import 'package:quran_app/modules/home/domain/home_usecase.dart';
import 'package:quran_app/modules/home/presentation/blocs/state/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeUseCase) : super(HomeInitial());
  final HomeUseCase _homeUseCase;

  Future<void> init(DateTime date) async {
    emit(HomeLoading());

    try {
      // Get location first as other operations depend on it
      final location = await _homeUseCase.getLocation();

      // Run independent operations in parallel
      final results = await Future.wait([
        _homeUseCase.getCity(location),
        getTiming(date, location),
        getTiming(date.add(const Duration(days: 1)), location),
      ]);

      final city = results[0] as String;
      final timing = results[1] as List<Pray>;
      final tomorrowTiming = results[2] as List<Pray>;

      timing.isEmpty
          ? emit(const HomeError('No Prayer Time Fetched'))
          : emit(
              HomeLoaded(
                currentLocation: location,
                currentLocationInCity: city,
                todayTiming: timing,
                tomorrowTiming: tomorrowTiming,
              ),
            );
    } catch (e) {
      emit(HomeError('Error loading data: $e'));
    }
  }

  Future<List<Pray>> getTiming(DateTime date, Location location) async {
    final res = await _homeUseCase.getTiming(date, location);
    return res;
  }
}
