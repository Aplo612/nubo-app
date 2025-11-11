import 'package:flutter/material.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';

class CollectionPointsSection extends StatelessWidget {
  const CollectionPointsSection({
    super.key,
    required this.onSeeAll,
    this.onOpenMap,
  });

  final VoidCallback onSeeAll;
  final VoidCallback? onOpenMap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                Icon(Icons.location_on, color: color.primary),
                const SizedBox(width: 8),
                Text('Puntos de acopio', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton(
                  onPressed: onSeeAll,
                  child: const Text('Ver todo'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Subtítulo sutil
            Text(
              'Encuentra los más cercanos a tu ubicación',
              style: text.bodySmall?.copyWith(color: color.onSurface.withOpacity(0.65)),
            ),
            const SizedBox(height: 12),

            // Lista horizontal de puntos
            SizedBox(
              height: 128,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _PointCard(
                    name: 'EcoPunto Ate',
                    distanceKm: 1.2,
                    schedule: '08:00–18:00',
                    materials: ['PET', 'Vidrio'],
                  ),
                  _PointCard(
                    name: 'Centro Recicla Salamanca',
                    distanceKm: 2.5,
                    schedule: '09:00–17:00',
                    materials: ['Papel', 'Cartón', 'Plástico'],
                  ),
                  _PointCard(
                    name: 'Punto La Molina',
                    distanceKm: 3.0,
                    schedule: '10:00–19:00',
                    materials: ['Metal', 'Vidrio'],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // CTA inferior
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpenMap ?? () {},
                icon: const Icon(Icons.map),
                label: const Text('Ver en mapa'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  const _PointCard({
    required this.name,
    required this.distanceKm,
    required this.schedule,
    required this.materials,
  });

  final String name;
  final double distanceKm;
  final String schedule;
  final List<String> materials;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título + distancia
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 6),
              _ChipSmall(label: '${distanceKm.toStringAsFixed(1)} km'),
            ],
          ),
          const SizedBox(height: 6),

          // Materiales aceptados
          Wrap(
            spacing: 6,
            runSpacing: -4,
            children: materials.take(3).map((m) => _ChipTiny(label: m)).toList(),
          ),
          const Spacer(),

          // Horario + CTA
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: color.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(color: color.onSurface.withOpacity(0.7)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Cómo llegar',
                onPressed: () {
                  // Navegación genérica a detalle/lista
                  NavigationHelper.safePush(context, '/collection-points');
                },
                icon: const Icon(Icons.directions),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipSmall extends StatelessWidget {
  const _ChipSmall({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.primary.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ChipTiny extends StatelessWidget {
  const _ChipTiny({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.secondaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color.onSecondaryContainer.withOpacity(0.9),
            ),
      ),
    );
  }
}
