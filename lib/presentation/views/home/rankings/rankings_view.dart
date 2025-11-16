import 'package:flutter/material.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import 'package:nubo/presentation/utils/rankings_widges/rankings_podium.dart';

class RankingsPage extends StatefulWidget {
  static const String routeName = 'rankings_page';
  const RankingsPage({super.key});

  @override
  State<RankingsPage> createState() => _RankingsPageState();
}
//TODO: REHACER
class _RankingsPageState extends State<RankingsPage> {
  int _periodIndex = 0; // 0: Hoy, 1: Semana, 2: Mes
  int _scopeIndex = 0;  // 0: San Isidro, 1: Lima, 2: Nacional

  // Mock data
  /*
  final _top3 = const [
    _RankUser(name: 'Lina',   points: 330, avatarUrl: null),
    _RankUser(name: 'Mauro',  points: 230, avatarUrl: null),
    _RankUser(name: 'Sofía',  points: 130, avatarUrl: null),
  ];
  */

  final _others = const [
    _RankUser(name: 'Ana García',   points: 98,  trend: 25),
    _RankUser(name: 'Ana García',   points: 60,  trend: 10),
    _RankUser(name: 'Ana García',   points: 54,  trend: -6),
    _RankUser(name: 'Ana García',   points: 25,  trend: 25),
    _RankUser(name: 'Ana García',   points: 25,  trend: 25),
  ];

  final _me = const _RankUser(name: 'Armando Blas (Tú)', points: 12, trend: 16);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final colors = _RankColors.of(context);
    //const crownSolid = 'assets/icons-svg/crown-solid-full.svg';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo con degradado sutil arriba
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFBFE6FF), Colors.white],
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),

            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: false,
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => NavigationHelper.safePop(context),
                  ),
                  centerTitle: true,
                  title: Text('Rankings',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      )),
                  actions: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.help_outline, color: Colors.black54),
                    ),
                  ],
                ),

                // Segmentos: Hoy / Semana / Mes
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: _SegmentedControl(
                      segments: const ['Hoy', 'Semana', 'Mes'],
                      selectedIndex: _periodIndex,
                      onChanged: (i) => setState(() => _periodIndex = i),
                    ),
                  ),
                ),

                // Podio Top-3
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: const PodiumStatic3DAnimated(
                      leftAvatar: AssetImage('assets/images/MESSI.jpg'),
                      centerAvatar: AssetImage('assets/images/MESSI.jpg'),
                      rightAvatar: AssetImage('assets/images/MESSI.jpg'),
                      coinsLeft: '230',
                      coinsCenter: '330',
                      coinsRight: '175',
                      duration: Duration(milliseconds: 3500),
                      curve: Curves.linear,
                    ),
                  ),
                ),

                // Tarjeta: Tu posición
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: _MyPositionCard(user: _me),
                  ),
                ),

                // Chips de ámbito
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: _ScopeChips(
                      labels: const ['San Isidro', 'Lima', 'Nacional'],
                      selected: _scopeIndex,
                      onSelected: (i) => setState(() => _scopeIndex = i),
                    ),
                  ),
                ),

                // Lista de posiciones
                SliverList.separated(
                  itemCount: _others.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _RankTile(
                      position: i + 4,
                      user: _others[i],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

/* =========================
 *  Helpers / Widgets
 * ========================= */

class _MyPositionCard extends StatelessWidget {
  final _RankUser user;
  const _MyPositionCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 22, backgroundColor: Color(0xFFE0F2FF)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tu posición • ${user.name}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 2),
                Text('5 kg reciclados • 30 🪙',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFE8F3FF),
            ),
            child: Text('#47',
                style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF3C82C3), fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _ScopeChips extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  const _ScopeChips({
    required this.labels, required this.selected, required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (i) {
        final enabled = i == selected;
        return Padding(
          padding: EdgeInsets.only(right: i == labels.length - 1 ? 0 : 8),
          child: ChoiceChip(
            label: Text(labels[i]),
            selected: enabled,
            onSelected: (_) => onSelected(i),
            selectedColor: const Color(0xFFEBF4FF),
            labelStyle: TextStyle(
              color: enabled ? const Color(0xFF3C82C3) : Colors.black87,
              fontWeight: enabled ? FontWeight.w700 : FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }),
    );
  }
}

class _RankTile extends StatelessWidget {
  final int position;
  final _RankUser user;
  const _RankTile({required this.position, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trendColor = (user.trend ?? 0) >= 0 ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    final trendIcon  = (user.trend ?? 0) >= 0 ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text('$position',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800, color: Colors.black54)),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(radius: 20, backgroundColor: Color(0xFFE0F2FF)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(user.name,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.black87)),
          ),
          const SizedBox(width: 8),
          _MetricPill(points: user.points),
          const SizedBox(width: 8),
          Row(
            children: [
              Icon(trendIcon, size: 16, color: trendColor),
              const SizedBox(width: 4),
              Text('${user.trend ?? 0}',
                  style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700, color: trendColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final int points;
  const _MetricPill({required this.points});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE6ECF5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco, size: 16, color: Color(0xFF10B981)),
          const SizedBox(width: 6),
          Text('$points',
              style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
        ],
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  const _SegmentedControl({
    required this.segments, required this.selectedIndex, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: List.generate(segments.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF3C82C3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Text(
                  segments[i],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/* ===== Modelito & colores ===== */

class _RankUser {
  final String name;
  final int points;
  final int? trend; // +/- variación
  final String? avatarUrl;
  // ignore: unused_element_parameter
  const _RankUser({required this.name, required this.points, this.trend, this.avatarUrl});
}
/*
class _RankColors {
  final Color first  = const Color(0xFFFFF176); // amarillo suave
  final Color second = const Color(0xFF64B5F6); // azul
  final Color third  = const Color(0xFFA5D6A7); // verde
  const _RankColors._();
  static _RankColors of(BuildContext _) => const _RankColors._();
}
*/