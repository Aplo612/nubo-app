import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nubo/config/constants/enviroments.dart';

import 'package:nubo/controller/validator_controller.dart';
import 'package:nubo/presentation/utils/generic_button/pill_button.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import 'package:nubo/presentation/utils/snackbar/snackbar.dart';
import 'package:nubo/presentation/views/validator/validator_widget.dart';
import 'package:nubo/services/mission_validation_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgentValidateMissionPage extends StatefulWidget {
  static const String name = 'agent_page';
  const AgentValidateMissionPage({super.key});

  @override
  State<AgentValidateMissionPage> createState() =>
      _AgentValidateMissionPageState();
}

class _AgentValidateMissionPageState
    extends State<AgentValidateMissionPage> {
  late ValidatorController controller;

  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    controller = ValidatorController(
      service: MissionValidationService(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
      ),
      db: FirebaseFirestore.instance,
    );
  }

  void _openScanner() async {
    setState(() => _isScanning = true);

    await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: SizedBox(
            height: 400,
            child: MobileScanner(
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final value = barcodes.first.rawValue;
                  if (value != null) {
                    Navigator.pop(context);
                    setState(() => _isScanning = false);

                    controller.setTokenId(value);

                    try {
                      await controller.loadToken();
                    } catch (e) {
                      if (context.mounted) {
                        SnackbarUtil.showSnack(
                          context,
                          message: "Error: $e",
                        );
                      }
                    }
                  }
                }
              },
            ),
          ),
        );
      },
    );

    setState(() => _isScanning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () =>
              NavigationHelper.safePushReplacement(context, '/home'),
        ),
        title: const Text(
          'Validar misiones',
          style: TextStyle(
            fontFamily: robotoBold,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón para escanear QR
                 Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.maxWidth * 0.5; // 50% del ancho
                      return Column(
                        children: [
                          SizedBox(
                            height: size,
                            child: Image.asset(
                              nuboSinFondo,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                PillButton(
                  text: _isScanning ? "Escaneando..." : "Escanear QR",
                  onTap: _isScanning ? null : _openScanner,
                  bg: const Color(0xFF3C82C3),
                  fg: Colors.white,
                  elevation: 4,
                  borderColor: Colors.transparent,
                ),
               
                const SizedBox(height: 10),

                // Form del validador
                ValidatorMissionForm(controller: controller),
              ],
            );
          },
        ),
      ),
    );
  }
}
