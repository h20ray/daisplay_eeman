import 'package:flutter/services.dart';
import 'package:quran_app/modules/doa_sehari_hari/data/domain/doa_daily.dart';
import 'package:quran_app/modules/doa_sehari_hari/domain/doa_sehari_hari_repository.dart';

DoaSehariHariRepository createDoaSehariHariRepository() {
  return () async {
    final doaResponse = await rootBundle.loadString('assets/sources/doa.json');
    final doaData = doaDailyFromJson(doaResponse);
    return doaData;
  };
}
