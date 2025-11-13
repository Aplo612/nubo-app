import 'package:flutter/material.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import '../../../features/collection_points/data/collection_points_repo.dart';
import '../../../features/collection_points/domain/collection_point.dart';

class CollectionPointsPage extends StatefulWidget {
  const CollectionPointsPage({super.key});

  @override
  State<CollectionPointsPage> createState() => _CollectionPointsPageState();
}

class _CollectionPointsPageState extends State<CollectionPointsPage> {
  final _repo = CollectionPointsRepoMock();
  CollectionPointFilter _filter = const CollectionPointFilter();
  bool _onlyNearby = true; // “Puntos cercanos” del wireframe
  MissionState? _chipState; // null/todos, activo, inactivo

  Future<List<CollectionPoint>> _load() => _repo.fetch(
        filter: _filter.copyWith(state: _chipState),
      );

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de acopio')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Preview de mapa
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: color.surfaceVariant.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.outlineVariant.withOpacity(0.5)),
                ),
                alignment: Alignment.center,
                child: Text('Map preview', style: text.bodyMedium),
              ),
              const SizedBox(height: 8),

              // Botón Filtrar
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final result = await NavigationHelper.safePush<CollectionPointFilter>(
                      context,
                      '/collection-points/filter',
                      extra: _filter, // <-- NO 'arguments', usa 'extra'
                    );

                    if (result is CollectionPointFilter) {
                      setState(() => _filter = result);
                    }
                  },
                  child: const Text('Filtrar'),
                ),
              ),
              const SizedBox(height: 12),

              // Encabezado “Puntos cercanos” + chips Activo/Libre
              Row(
                children: [
                  Text('Puntos cercanos', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  FilterChip(
                    selected: _chipState == MissionState.activo,
                    label: const Text('Activo'),
                    onSelected: (_) => setState(() => _chipState = _chipState == MissionState.activo ? null : MissionState.activo),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    selected: _chipState == MissionState.inactivo,
                    label: const Text('Libre'), // según tu wireframe “Libre” = inactivo o sin restricción
                    onSelected: (_) => setState(() => _chipState = _chipState == MissionState.inactivo ? null : MissionState.inactivo),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Lista
              Expanded(
                child: FutureBuilder<List<CollectionPoint>>(
                  future: _load(),
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = (_onlyNearby)
                        ? (snap.data ?? []).where((e) => e.distanceKm <= 3.5).toList()
                        : (snap.data ?? []);

                    if (data.isEmpty) {
                      return _EmptyResults(text: text);
                    }
                    return ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => _PointTile(point: data[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointTile extends StatelessWidget {
  const _PointTile({required this.point});
  final CollectionPoint point;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.outlineVariant.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          // icono/estado
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, color: color.primary),
          ),
          const SizedBox(width: 12),
          // info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(point.name, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('${point.district} • ${point.schedule}', style: text.bodySmall?.copyWith(color: color.onSurface.withOpacity(0.7))),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6, runSpacing: -4,
                  children: point.materials.take(3).map((m) => _chipTiny(context, m)).toList(),
                )
              ],
            ),
          ),
          const SizedBox(width: 8),
          // derecha: distancia + switch visual del wireframe
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${point.distanceKm.toStringAsFixed(1)} km', style: text.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              _statePill(context, point.state),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statePill(BuildContext context, MissionState state) {
    final color = Theme.of(context).colorScheme;
    final isActive = state == MissionState.activo;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.15) : color.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(isActive ? 'Activo' : 'Libre',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isActive ? Colors.green.shade700 : color.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          )),
    );
  }

  Widget _chipTiny(BuildContext context, String label) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.secondaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.text});
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.search_off, size: 56),
        const SizedBox(height: 8),
        Text('No se encontraron puntos de acopio.', style: text.bodyMedium),
      ]),
    );
  }
}
