import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/modules/doa_sehari_hari/domain/doa_sehari_hari_usecase.dart';
import 'package:quran_app/modules/doa_sehari_hari/presentation/blocs/state/doa_sehari_hari_state.dart';

class DoaSehariHariCubit extends Cubit<DoaSehariHariState> {
  DoaSehariHariCubit(this._doaSehariHariUseCase)
      : super(DoaSehariHariInitial());
  final DoaSehariHariUseCase _doaSehariHariUseCase;

  Future<void> loadDoaDaily() async {
    emit(DoaSehariHariLoading());

    try {
      final doaDaily = await _doaSehariHariUseCase();
      emit(DoaSehariHariLoaded(doaDaily));
    } catch (e) {
      emit(DoaSehariHariError('Error loading daily prayers: $e'));
    }
  }
}
