import 'package:quran_app/modules/doa_sehari_hari/data/domain/doa_daily.dart';
import 'package:quran_app/modules/doa_sehari_hari/domain/doa_sehari_hari_repository.dart';

typedef DoaSehariHariUseCase = Future<List<DoaDaily>> Function();

DoaSehariHariUseCase createDoaSehariHariUseCase(
  DoaSehariHariRepository repository,
) {
  return () => repository();
}
