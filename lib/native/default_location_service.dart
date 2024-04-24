import 'package:location/location.dart' as location_api;
import 'package:passkey_demo_frontend/location_service.dart';

class DefaultLocationService implements LocationService {
  late location_api.Location location;
  location_api.LocationData? currentLocation;


  DefaultLocationService() {
    location = location_api.Location();
  }

  @override
  Location? getCachedCurrentLocation() {
    return mapCurrentLocation();
  }

  @override
  Future<Location?> requestCurrentLocation() async {
    bool serviceEnabled;
    location_api.PermissionStatus permissionGranted;
    location_api.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return getCachedCurrentLocation();
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == location_api.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != location_api.PermissionStatus.granted) {
        return getCachedCurrentLocation();
      }
    }

    locationData = await location.getLocation();
    currentLocation = locationData;
    return mapCurrentLocation();
  }

  Location? mapCurrentLocation() {
    if (currentLocation == null ||
        currentLocation!.latitude == null ||
        currentLocation!.longitude == null) {
      return null;
    }
    return Location(
        latitude: currentLocation!.latitude!,
        longitude: currentLocation!.longitude!);
  }
}
