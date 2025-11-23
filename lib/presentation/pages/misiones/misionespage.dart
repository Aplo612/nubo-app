import 'package:flutter/material.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import 'package:nubo/presentation/utils/snackbar/snackbar.dart';
import 'package:qr_flutter/qr_flutter.dart';

// 👇 Ajusta esta ruta a donde tengas mision_controller.dart
import 'package:nubo/controller/mision_controller.dart';

class MissionsPage extends StatefulWidget {
  static const String name = 'missions_page';
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

enum MissionStatus { available, inProgress, completed }
enum QrStage { none, readyToStart, generating, qrShown, validated, nextSteps, done }

class Mission {
  final String id;
  String title;
  String subtitle;
  int reward;

  MissionStatus status;
  QrStage qrStage;
  String? qrPayload;

  Mission({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.reward,
    this.status = MissionStatus.available,
    this.qrStage = QrStage.none,
    this.qrPayload,
  });
}


class _MissionsPageState extends State<MissionsPage> {
  final _missionController = MissionController();

  /// Estado local de misiones por id, para conservar qrStage, etc.
  final Map<String, Mission> _missionsById = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFBFEAFC),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Misiones', style: TextStyle(fontWeight: FontWeight.w800)),
            SizedBox(width: 6),
            Icon(Icons.help_outline_rounded, size: 18),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => NavigationHelper.safePop(context),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _missionController.availableMissionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data ?? [];

          // Sincroniza el estado local _missionsById con los docs del usuario.
          final visibleMissions = _syncMissionsWithSnapshot(docs);

          if (visibleMissions.isEmpty) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: const [
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'No tienes misiones disponibles por ahora.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _SpecialRewardCard(
                title: '¡Realiza tu Eco Quiz!',
                subtitle:
                    'Aprende sobre el reciclaje y gana puntos mientras lo haces.',
                reward: 100,
                onAccept: () {},
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: const [
                  _Chip(label: 'Reciclaje', icon: Icons.eco_rounded, selected: true),
                  _Chip(label: 'Empresas', icon: Icons.bolt_rounded),
                  _Chip(label: 'Prendas', icon: Icons.checkroom_rounded),
                ],
              ),
              const SizedBox(height: 12),
              for (final mission in visibleMissions)
                _MissionCard(
                  mission: mission,
                  onPrimary: () => _onPrimary(mission),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Sincroniza los docs de Firestore con el estado local de misiones.
  List<Mission> _syncMissionsWithSnapshot(List<Map<String, dynamic>> docs) {
    final seenIds = <String>{};

    for (final m in docs) {
      final id = (m['id'] ?? '') as String;
      if (id.isEmpty) continue;
      seenIds.add(id);

      final existing = _missionsById[id];

    // ========= AQUÍ APLICAMOS FALLBACKS =========
    final backendTitle   = (m['title'] as String? ?? '').trim();
    final backendSubtitle = (m['subtitle'] as String? ?? '').trim();

    // Si vienen vacíos de Firestore, usamos textos del frontend
    final title    = backendTitle.isEmpty   ? _fallbackTitle(id)    : backendTitle;
    final subtitle = backendSubtitle.isEmpty ? _fallbackSubtitle(id) : backendSubtitle;
    // ===========================================
      final reward = _parseCoins(m['coinsReward']);
      final statusStr = (m['status'] ?? 'available') as String;
      final status = _statusFromString(statusStr);

      if (existing == null) {
        _missionsById[id] = Mission(
          id: id,
          title: title,
          subtitle: subtitle,
          reward: reward,
          status: status,
        );
      } else {
        existing.title = title;        // 👈 se refresca desde Firestore
        existing.subtitle = subtitle;
        existing.reward = reward;
        existing.status = status;
      }
    }

    // Limpia misiones locales que ya no vienen de Firestore
    _missionsById.removeWhere((key, value) => !seenIds.contains(key));

    final list = _missionsById.values.toList();
    list.sort((a, b) => a.title.compareTo(b.title));
    return list;
  }

  int _parseCoins(dynamic raw) {
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw) ?? 0;
    return 0;
  }

  MissionStatus _statusFromString(String? value) {
    switch (value) {
      case 'in_progress':
        return MissionStatus.inProgress;
      case 'completed':
        return MissionStatus.completed;
      case 'available':
      default:
        return MissionStatus.available;
    }
  }

  String _buildTodayPeriodKey() {
  final now = DateTime.now();
  final y = now.year.toString().padLeft(4, '0');
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
  }


  // ====== Fallbacks de frontend por id de misión ======

  String _fallbackTitle(String id) {
    switch (id) {
      // Ajusta estos ids a los que realmente usas en Firestore
      case 'recycle_plastic_v1':
        return 'Recicla objetos sólidos';
      case 'family_recycle_v1':
        return 'Reciclaje en la familia';
      default:
        return 'Misión';
    }
  }

  String _fallbackSubtitle(String id) {
    switch (id) {
      case 'recycle_plastic_v1':
        return 'plásticos, latas, papel, bolsa, cartón, vidrios, cable';
      case 'family_recycle_v1':
        return 'Logra que un miembro de tu familia recicle contigo y súbanlo juntos';
      default:
        return '';
    }
  }

  // Ahora trabajamos con la misión directamente, no con índices
  void _onPrimary(Mission mission) {
    if (mission.status == MissionStatus.available) {
      _showAcceptSheet(mission);
      return;
    }
    if (mission.status == MissionStatus.inProgress) {
      _openQrFlow(mission); // salta directo a la etapa actual
      return;
    }
    // completed: sin acción
  }

  // --------- Aceptar → inProgress + confirmación ----------
  Future<void> _showAcceptSheet(Mission mission) async {
    final m = mission;

    final accepted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _StepsSheet(
        mission: m,
        primary: _PillButton.green('Aceptar', onPressed: () {
          Navigator.of(sheetCtx).pop(true);
        }),
      ),
    );

    if (accepted == true && context.mounted) {
      final cont = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogCtx) => _ConfirmDialog(missionTitle: m.title),
      );
      if (cont == true) {
        // 1) Actualizamos el estado local → botón cambia a "Seguir"
        setState(() {
          mission.status = MissionStatus.inProgress;
          mission.qrStage = QrStage.readyToStart;
        });

        // 2) Persistimos en Firestore (missions_state.status = "in_progress")
        await _missionController.updateMissionStatus(
          mission.id,
          'in_progress',
        );
      }
    }
  }

  // --------- Flujo QR (Fig.1 → Fig.6) ----------
  Future<void> _openQrFlow(Mission mission) async {
    final m = mission;

    // Si ya está validado/siguiente/done o completado, saltar
    if (m.qrStage == QrStage.validated ||
        m.qrStage == QrStage.nextSteps ||
        m.qrStage == QrStage.done ||
        m.status == MissionStatus.completed) {
      await _openStage(m);
      return;
    }

    // Si no inició o listo para iniciar, abrir Fig.1
    if (m.qrStage == QrStage.none || m.qrStage == QrStage.readyToStart) {
      await _openStage(m);
      return;
    }

    // Otros estados intermedios
    await _openStage(m);
  }

  Future<void> _openStage(Mission mission) async {
    final m = mission;

    switch (m.qrStage) {
      case QrStage.none:
      case QrStage.readyToStart:
        // Figura 1: Generar QR / Ver en mapa
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetCtx) => _StepsSheet(
            mission: m,
            primary: _PillButton.green('Generar QR', onPressed: () {
              NavigationHelper.safePop(context); // cerrar Fig.1
              _startGenerate(m);
            }),
            secondary: _PillButton.blue('Ver en Mapa', onPressed: () {
              SnackbarUtil.showSnack(context, message: 'Próximamente');
            }),
          ),
        );
        break;

      case QrStage.generating:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetCtx) => _SimpleSheet(
            mission: m,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child:
                  Text('Su QR se está generando.', textAlign: TextAlign.center),
            ),
          ),
        );
        break;

      case QrStage.qrShown:
        final code = m.qrPayload;
        if (code == null) {
          // No hay código QR: volver al estado listo para iniciar
          setState(() => m.qrStage = QrStage.readyToStart);
          return;
        }

        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetCtx) {
            return StreamBuilder<Map<String, dynamic>?>(
              stream: _missionController.watchQrToken(code),
              builder: (context, snapshot) {
                final data = snapshot.data;
                final tokenStatus =
                    (data?['status'] ?? 'pending_validation') as String;

                // Si el backend/agent cambió el token a "validated"
                if (tokenStatus == 'validated') {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    setState(() {
                      m.qrStage = QrStage.validated;
                    });
                    // Cerrar este sheet si sigue abierto
                    if (Navigator.of(sheetCtx).canPop()) {
                      Navigator.of(sheetCtx).pop();
                    }
                    // Abrir la siguiente etapa (QR Validado)
                    _openStage(m);
                  });
                }

                final titleExtra =
                    tokenStatus == 'validated' ? 'QR Validado' : null;

                return _QrSheet(
                  mission: m,
                  titleExtra: titleExtra,
                  validated: tokenStatus == 'validated',
                );
              },
            );
          },
        );
        break;


      case QrStage.validated:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetCtx) =>
              _QrSheet(titleExtra: 'QR Validado', mission: m, validated: true),
        );
        break;

      case QrStage.nextSteps:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetCtx) => _SimpleSheet(
            mission: m,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 8),
                Center(
                  child: Text('Ahora',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
                SizedBox(height: 8),
                _Bullet('Completa la misión en el punto de acopio.'),
                _Bullet('Espera que valide nuestro agente.'),
                _Bullet('¡Gana tu canje!'),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
        break;

      case QrStage.done:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetCtx) => _DoneSheet(
            mission: m,
            onRedeem: () {
              NavigationHelper.safePop(sheetCtx);
              setState(() {
                mission.status = MissionStatus.completed;
              });
              // TODO: opcional -> actualizar missions_state.{status = 'completed'}
            },
          ),
        );
        break;
    }
  }

  // --------- Generación real de QR (sin simulación automática) ----------
  Future<void> _startGenerate(Mission mission) async {
    final m = mission;

    // Si ya está validado / siguiente / done o completado, no regenerar
    if (m.qrStage == QrStage.validated ||
        m.qrStage == QrStage.nextSteps ||
        m.qrStage == QrStage.done ||
        m.status == MissionStatus.completed) {
      SnackbarUtil.showSnack(
        context,
        message: 'El QR ya fue validado o la misión fue completada.',
      );
      await _openStage(m);
      return;
    }

    setState(() {
      m.qrStage = QrStage.generating;
      m.qrPayload = null;
    });

    try {
      final periodKey = _buildTodayPeriodKey();

      // Genera token en Firestore y enlaza en missions_state
      final code = await _missionController.generateAndAttachQr(
        missionId: m.id,
        periodKey: periodKey,
        // ttl: const Duration(minutes: 10), // si luego quieres expiración
      );

      if (!mounted) return;

      setState(() {
        m.qrPayload = code;       // este code será el payload del QR
        m.qrStage = QrStage.qrShown;
      });

      // Mostrar hoja con el QR (estado 'qrShown')
      await _openStage(m);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        m.qrStage = QrStage.readyToStart;
        m.qrPayload = null;
      });
      SnackbarUtil.showSnack(
        context,
        message: 'No se pudo generar el QR. Inténtalo de nuevo.',
      );
    }
  }
}

/// ======================= Widgets de soporte =======================

class _MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onPrimary;
  const _MissionCard({required this.mission, required this.onPrimary});

  @override
  Widget build(BuildContext context) {
    final isFollowing = mission.status == MissionStatus.inProgress;
    final isCompleted = mission.status == MissionStatus.completed;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: _card(),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFD2F3D0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.backpack_rounded, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mission.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                      mission.subtitle,
                      style:
                          TextStyle(color: Colors.black.withValues(alpha: .7)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('${mission.reward} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16)),
                        const Icon(Icons.monetization_on_outlined, size: 20),
                        const Spacer(),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: isCompleted
                                ? Colors.grey
                                : (isFollowing
                                    ? const Color(0xFF12A1BC) // Seguir
                                    : const Color(0xFF31B14F)), // Aceptar
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                          onPressed: isCompleted ? null : onPrimary,
                          child: Text(isCompleted
                              ? 'Completada'
                              : (isFollowing ? 'Seguir' : 'Aceptar')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isFollowing)
            const Positioned(
              right: 0,
              top: 0,
              child: Icon(Icons.info_outline, color: Colors.black45),
            ),
        ],
      ),
    );
  }
}

class _SpecialRewardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int reward;
  final VoidCallback onAccept;
  const _SpecialRewardCard({
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _card(borderColor: const Color(0xFFF4A41C)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF4A41C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Text(
              'RECOMPENSA ESPECIAL',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt_rounded, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                            color: Colors.black.withValues(alpha: .72)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('$reward ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16)),
                          const Icon(Icons.monetization_on_outlined, size: 20),
                          const Spacer(),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF31B14F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                            ),
                            onPressed: onAccept,
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  const _Chip({required this.label, required this.icon, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFFF4A41C) : Colors.black12;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFF6E6) : Colors.white,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (!selected)
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: selected ? const Color(0xFFF4A41C) : null),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? const Color(0xFFF4A41C) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============ Hojas modal ============

class _StepsSheet extends StatelessWidget {
  final Mission mission;
  final Widget primary;
  final Widget? secondary;

  const _StepsSheet({
    required this.mission,
    required this.primary,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHeader(onClose: () => NavigationHelper.safePop(context)),
          const SizedBox(height: 4),
          Text(mission.title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                    color: Color(0xFFD2F3D0), shape: BoxShape.circle),
                child: const Icon(Icons.backpack_rounded, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mission.subtitle,
                  style: TextStyle(
                      color: Colors.black.withValues(alpha: .72)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _Bullet('Recolecta uno de los materiales descritos.'),
          const _Bullet('Junta hasta 3 latas o botellas plásticas.'),
          const _Bullet('Toma una foto del material reciclado.'),
          const _Bullet('Espere hasta que se confirme la misión.'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: primary),
              if (secondary != null) const SizedBox(width: 12),
              if (secondary != null) Expanded(child: secondary!),
            ],
          ),
        ],
      ),
    );
  }
}

class _SimpleSheet extends StatelessWidget {
  final Mission mission;
  final Widget child;
  const _SimpleSheet({required this.mission, required this.child});

  @override
  Widget build(BuildContext context) {
    return _ModalScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHeader(onClose: () => NavigationHelper.safePop(context)),
          const SizedBox(height: 4),
          Text(
            mission.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                    color: Color(0xFFD2F3D0), shape: BoxShape.circle),
                child: const Icon(Icons.backpack_rounded, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mission.subtitle,
                  style: TextStyle(
                      color: Colors.black.withValues(alpha: .72)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _QrSheet extends StatelessWidget {
  final Mission mission;
  final String? titleExtra; // "QR Validado"
  final bool validated;
  const _QrSheet({
    required this.mission,
    this.titleExtra,
    this.validated = false,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHeader(onClose: () => NavigationHelper.safePop(context)),
          const SizedBox(height: 4),
          Text(
            mission.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          if (titleExtra != null)
            Text(
              titleExtra!,
              style: const TextStyle(
                  color: Color(0xFF1F9D4E), fontWeight: FontWeight.w700),
            ),
          const SizedBox(height: 12),
          QrImageView(
            data: mission.qrPayload ?? 'QR',
            version: QrVersions.auto,
            size: 180,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _DoneSheet extends StatelessWidget {
  final Mission mission;
  final VoidCallback onRedeem;
  const _DoneSheet({required this.mission, required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    return _ModalScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHeader(onClose: () => NavigationHelper.safePop(context)),
          const SizedBox(height: 4),
          Text(
            mission.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          const Text(
            '¡Misión completada!',
            style: TextStyle(
              color: Color(0xFFE0881C),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            'assets/logo/nubo_ok.png',
            height: 140,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          _PillButton.orange('Canjear', onPressed: onRedeem),
        ],
      ),
    );
  }
}

/// ============ Diálogo de confirmación ============
class _ConfirmDialog extends StatelessWidget {
  final String missionTitle;
  const _ConfirmDialog({required this.missionTitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¡Genial!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            Text(
              'Tu misión $missionTitle está dentro de tus misiones pendientes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withValues(alpha: 0.85)),
            ),
            const SizedBox(height: 18),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF4BAF2E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continuar',
                  style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============ Building blocks UI ============

class _ModalScaffold extends StatelessWidget {
  final Widget child;
  const _ModalScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => NavigationHelper.safePop(context),
          child: Container(color: Colors.black.withValues(alpha: .5)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .15),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final VoidCallback onClose;
  const _SheetHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: onClose,
        ),
        const Spacer(),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  const _PillButton(this.text, this.color, this.onPressed);

  factory _PillButton.green(String t, {required VoidCallback onPressed}) =>
      _PillButton(t, const Color(0xFF31B14F), onPressed);

  factory _PillButton.blue(String t, {required VoidCallback onPressed}) =>
      _PillButton(t, const Color(0xFF12A1BC), onPressed);

  factory _PillButton.orange(String t, {required VoidCallback onPressed}) =>
      _PillButton(t, const Color(0xFFF4A41C), onPressed);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

BoxDecoration _card({Color? borderColor}) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor ?? Colors.transparent, width: 1.2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
