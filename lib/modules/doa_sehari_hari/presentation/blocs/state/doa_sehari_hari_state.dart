import 'package:equatable/equatable.dart';
import 'package:quran_app/modules/doa_sehari_hari/data/domain/doa_daily.dart';

abstract class DoaSehariHariState extends Equatable {
  const DoaSehariHariState();

  @override
  List<Object?> get props => [];
}

class DoaSehariHariInitial extends DoaSehariHariState {}

class DoaSehariHariLoading extends DoaSehariHariState {}

class DoaSehariHariError extends DoaSehariHariState {
  const DoaSehariHariError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class DoaSehariHariLoaded extends DoaSehariHariState {
  const DoaSehariHariLoaded(this.doaDaily);
  final List<DoaDaily> doaDaily;

  @override
  List<Object> get props => [doaDaily];
}
