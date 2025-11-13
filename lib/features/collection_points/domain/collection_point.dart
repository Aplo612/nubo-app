enum MissionState { activo, inactivo }         // para chips Activo/Libre del mock
enum RewardType { libre, puntos, descuento }   // ajusta a tu negocio

class CollectionPoint {
  final String id;
  final String name;
  final String organization;
  final String district;
  final double lat;
  final double lng;
  final MissionState state;
  final RewardType rewardType;
  final List<String> materials;
  final String schedule; // "08:00–18:00"
  final double distanceKm;

  const CollectionPoint({
    required this.id,
    required this.name,
    required this.organization,
    required this.district,
    required this.lat,
    required this.lng,
    required this.state,
    required this.rewardType,
    required this.materials,
    required this.schedule,
    required this.distanceKm,
  });
}

class CollectionPointFilter {
  final String? organization;
  final MissionState? state;      // null = todos
  final RewardType? rewardType;
  final String? district;

  const CollectionPointFilter({this.organization, this.state, this.rewardType, this.district});
  CollectionPointFilter copyWith({
    String? organization,
    MissionState? state,
    RewardType? rewardType,
    String? district,
  }) => CollectionPointFilter(
    organization: organization ?? this.organization,
    state: state ?? this.state,
    rewardType: rewardType ?? this.rewardType,
    district: district ?? this.district,
  );
}
