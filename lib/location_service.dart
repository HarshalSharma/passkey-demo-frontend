abstract class LocationService {
  Location? getCachedCurrentLocation();

  Future<Location?> requestCurrentLocation();
}

class Location {
  double latitude;
  double longitude;

  Location({required this.latitude, required this.longitude});
}
