import 'dart:math';

class SafeLocation {
  final double latitude;
  final double longitude;
  const SafeLocation(this.latitude, this.longitude);
}

/// Client-side display protection. Production authorization must also be
/// enforced server-side so raw GPS is never returned to another member.
class LocationPrivacy {
  static SafeLocation obfuscate(double latitude, double longitude, {double radiusKm = 1.5}) {
    final r = Random('${latitude.toStringAsFixed(4)}:$longitude'.hashCode);
    final angle = r.nextDouble() * 2 * pi;
    final distance = radiusKm * (0.35 + r.nextDouble() * 0.65);
    final dLat = distance / 111.0 * cos(angle);
    final denominator = max(0.2, cos(latitude * pi / 180).abs());
    final dLon = distance / (111.0 * denominator) * sin(angle);
    double round3(double v) => (v * 1000).round() / 1000;
    return SafeLocation(round3(latitude + dLat), round3(longitude + dLon));
  }

  static String safeNearbyMessage() => 'Someone nearby liked you ❤️';
  static String safeCrossedPathsMessage() => 'You crossed paths in this area';
}
