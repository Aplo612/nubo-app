import '../domain/collection_point.dart';

abstract class ICollectionPointsRepo {
  Future<List<CollectionPoint>> fetch({CollectionPointFilter? filter});
}

class CollectionPointsRepoMock implements ICollectionPointsRepo {
  static final _data = <CollectionPoint>[
    CollectionPoint(
      id: '1',
      name: 'EcoPunto Ate',
      organization: 'Municipalidad',
      district: 'Ate',
      lat: -12.05, lng: -76.93,
      state: MissionState.activo,
      rewardType: RewardType.puntos,
      materials: ['PET', 'Vidrio'],
      schedule: '08:00–18:00',
      distanceKm: 1.2,
    ),
    CollectionPoint(
      id: '2',
      name: 'Centro Recicla Salamanca',
      organization: 'ONG',
      district: 'Ate',
      lat: -12.07, lng: -76.95,
      state: MissionState.activo,
      rewardType: RewardType.libre,
      materials: ['Papel', 'Cartón', 'Plástico'],
      schedule: '09:00–17:00',
      distanceKm: 2.5,
    ),
    CollectionPoint(
      id: '3',
      name: 'Punto La Molina',
      organization: 'Privado',
      district: 'La Molina',
      lat: -12.08, lng: -76.94,
      state: MissionState.inactivo,
      rewardType: RewardType.descuento,
      materials: ['Metal', 'Vidrio'],
      schedule: '10:00–19:00',
      distanceKm: 3.0,
    ),
  ];

  @override
  Future<List<CollectionPoint>> fetch({CollectionPointFilter? filter}) async {
    await Future.delayed(const Duration(milliseconds: 250)); // simula red
    var list = _data;

    if (filter?.state != null) {
      list = list.where((e) => e.state == filter!.state).toList();
    }
    if (filter?.rewardType != null) {
      list = list.where((e) => e.rewardType == filter!.rewardType).toList();
    }
    if ((filter?.district ?? '').isNotEmpty) {
      list = list.where((e) => e.district.toLowerCase() == filter!.district!.toLowerCase()).toList();
    }
    if ((filter?.organization ?? '').isNotEmpty) {
      list = list.where((e) => e.organization.toLowerCase().contains(filter!.organization!.toLowerCase())).toList();
    }
    return list;
  }
}
