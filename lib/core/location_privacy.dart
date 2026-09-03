import 'dart:math';

class SafeLocation {
  final double latitude;
  final double longitude;
  const SafeLocation(this.latitude, this.longitude);
}

/// Never expose raw GPS coordinates to discovery/map UI. Round and jitter them
/// into a privacy zone. Server-side enforcement must apply the same principle.
class LocationPrivacy {
  static SafeLocation obfuscate(double latitude, double longitude, {double radiusKm = 1.5}) {
    final r = Random('${latitude.toStringAsFixed(4)}:$longitude'.hashCode);
    final angle = r.nextDouble() * 2 * pi;
    final distance = radiusKm * (0.35 + r.nextDouble() * 0.65);
    final dLat = distance / 111.0 * cos(angle);
    final dLon = distance / (111.0 * cos(latitude * pi / 180).abs().clamp(0.2, 1.0)) * sin(angle);
    return SafeLocation((latitude + dLat).toStringAsFixed(3) as double, (longitude + dLon).toStringAsFixed(3) as double);
  }

  static String safeNearbyMessage() => 'Someone nearby liked you ❤️';
  static String safeCrossedPathsMessage() => 'You crossed paths in this area';
}
