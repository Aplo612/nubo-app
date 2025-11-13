import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MissionsPage extends StatefulWidget {
  static const String name = 'missions_page';
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

enum MissionStatus { available, inProgress, completed }
enum QrStage { none, readyToStart, generating, qrShown, validated, nextSteps, done }

class Mission {
  final String title;
  final String subtitle;
  final int reward;

  MissionStatus status;
  QrStage qrStage;
  String? qrPayload; // FRONTEND SIMULADO

  Mission({
    required this.title,
    required this.subtitle,
    required this.reward,
    this.status = MissionStatus.available,
    this.qrStage = QrStage.none,
    this.qrPayload,
  });
}

class _MissionsPageState extends State<MissionsPage> {
  final missions = <Mission>[
    Mission(
      title: 'Recicla objetos sólidos',
      subtitle: 'plásticos, latas, papel, bolsa, cartón, vidrios, cable',
      reward: 80,
    ),
    Mission(
      title: 'Reciclaje en la familia',
      subtitle: 'Logra que un miembro de tu familia recicle contigo y súbanlo juntos',
      reward: 80,
    ),
  ];

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
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _SpecialRewardCard(
            title: '¡Realiza tu Eco Quiz!',
            subtitle: 'Aprende sobre el reciclaje y gana puntos mientras lo haces.',
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
          for (int i = 0; i < missions.length; i++)
            _MissionCard(
              mission: missions[i],
              onPrimary: () => _onPrimary(i),
            ),
        ],
      ),
    );
  }

  void _onPrimary(int index) {
    final m = missions[index];

    if (m.status == MissionStatus.available) {
      _showAcceptSheet(index);
      return;
    }
    if (m.status == MissionStatus.inProgress) {
      _openQrFlow(index); // salta directo a la etapa actual
      return;
    }
    // completed: sin acción
  }

  // --------- Aceptar → inProgress + confirmación ----------
  Future<void> _showAcceptSheet(int index) async {
    final m = missions[index];
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

    if (accepted == true) {
      final cont = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogCtx) => _ConfirmDialog(missionTitle: m.title),
      );
      if (cont == true) {
        setState(() {
          missions[index].status = MissionStatus.inProgress;
          missions[index].qrStage = QrStage.readyToStart;
        });
      }
    }
  }

  // --------- Flujo QR (Fig.1 → Fig.6) ----------
  Future<void> _openQrFlow(int index) async {
    final m = missions[index];

    // Si ya está validado/siguiente/done o completado, saltar
    if (m.qrStage == QrStage.validated ||
        m.qrStage == QrStage.nextSteps ||
        m.qrStage == QrStage.done ||
        m.status == MissionStatus.completed) {
      await _openStage(index);
      return;
    }

    // Si no inició o listo para iniciar, abrir Fig.1
    if (m.qrStage == QrStage.none || m.qrStage == QrStage.readyToStart) {
      await _openStage(index);
      return;
    }

    // Otros estados intermedios
    await _openStage(index);
  }

  Future<void> _openStage(int index) async {
    final m = missions[index];

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
              Navigator.of(sheetCtx).pop(); // cerrar Fig.1
              _startGenerate(index);
            }),
            secondary: _PillButton.blue('Ver en Mapa', onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente')),
              );
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
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetCtx) => _QrSheet(titleExtra: null, mission: m),
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
              Navigator.of(sheetCtx).pop();
              setState(() {
                missions[index].status = MissionStatus.completed;
              });
            },
          ),
        );
        break;
    }
  }

  // --------- Simulaciones de transición ----------
  void _startGenerate(int index) {
    final m = missions[index];

    if (m.qrStage == QrStage.validated ||
        m.qrStage == QrStage.nextSteps ||
        m.qrStage == QrStage.done ||
        m.status == MissionStatus.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El QR ya fue validado o canjeado.')),
      );
      _openStage(index);
      return;
    }

    setState(() {
      m.qrStage = QrStage.generating;
      m.qrPayload = _fakeQrPayload(m); // TODO backend real
    });

    // 1.5 s → mostrar QR
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => m.qrStage = QrStage.qrShown);
      _openStage(index);

      // 2 s → validar
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (!mounted) return;
        setState(() => m.qrStage = QrStage.validated);
        _openStage(index);

        // 1.5 s → “Ahora…”
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (!mounted) return;
          setState(() => m.qrStage = QrStage.nextSteps);
          _openStage(index);

          // 1.5 s → “¡Misión completada!”
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (!mounted) return;
            setState(() => m.qrStage = QrStage.done);
            _openStage(index);
          });
        });
      });
    });
  }

  String _fakeQrPayload(Mission m) {
    final rnd = Random().nextInt(999999).toString().padLeft(6, '0');
    return 'MISION:${m.title}|R:${m.reward}|TS:${DateTime.now().millisecondsSinceEpoch}|N:$rnd';
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
                    Text(mission.subtitle,
                        style: TextStyle(color: Colors.black.withOpacity(.7))),
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
                      Text(subtitle,
                          style:
                              TextStyle(color: Colors.black.withOpacity(.72))),
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
              color: Colors.black.withOpacity(.04),
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
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      selected ? const Color(0xFFF4A41C) : Colors.black87)),
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
          _SheetHeader(onClose: () => Navigator.pop(context)),
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
                child: Text(mission.subtitle,
                    style: TextStyle(color: Colors.black.withOpacity(.72))),
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
          _SheetHeader(onClose: () => Navigator.pop(context)),
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
                child: Text(mission.subtitle,
                    style: TextStyle(color: Colors.black.withOpacity(.72))),
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
          _SheetHeader(onClose: () => Navigator.pop(context)),
          const SizedBox(height: 4),
          Text(mission.title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
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
          _SheetHeader(onClose: () => Navigator.pop(context)),
          const SizedBox(height: 4),
          Text(mission.title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          const Text(
            '¡Misión completada!',
            style: TextStyle(
              color: Color(0xFFE0881C),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          // Tu imagen (ruta final):
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
              style: TextStyle(color: Colors.black.withOpacity(.85)),
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
              child:
                  const Text('Continuar', style: TextStyle(fontWeight: FontWeight.w800)),
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
          onTap: () => Navigator.pop(context),
          child: Container(color: Colors.black.withOpacity(.5)),
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
                  color: Colors.black.withOpacity(.15),
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
  const _PillButton(this.text, this.color, this.onPressed, {super.key});

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
          color: Colors.black.withOpacity(.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
