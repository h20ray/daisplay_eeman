// ignore_for_file: one_member_abstracts

import 'package:geocoding/geocoding.dart' show Location;
import 'package:quran_app/common/domain/pray.dart';

abstract class HomeRepository {
  Future<List<Pray>> getTiming(DateTime date, Location location);
  Future<Location> getLocation();
  Future<String> getCity(Location location);
}
