import 'package:flutter/material.dart';
import 'package:nubo/controller/validator_controller.dart';
import 'package:nubo/presentation/utils/generic_button/pill_button.dart';

class ValidatorMissionForm extends StatelessWidget {
  final ValidatorController controller;

  const ValidatorMissionForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final tokenData = controller.tokenData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.tokenId != null) ...[
          Text("Token: ${controller.tokenId}"),
          const SizedBox(height: 8),
          if (tokenData != null) ...[
            Text("Estado: ${tokenData['status']}"),
            Text("Misión: ${tokenData['missionId']}"),
            Text("Día: ${tokenData['periodKey']}"),
          ],
        ],

        const SizedBox(height: 20),

        CheckboxListTile(
          title: const Text(
            "Confirmo que he verificado que la misión fue realizada correctamente.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: controller.confirmed,
          onChanged: (v) => controller.setConfirmed(v ?? false),

          // 🔥 Personalización del checkbox
          controlAffinity: ListTileControlAffinity.leading,
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          activeColor: const Color(0xFF3C82C3), // color del fondo cuando está checked
          checkColor: Colors.white, // ✔ blanco
          side: const BorderSide(
            color: Colors.grey,
            width: 1.5,
          ),

          contentPadding: EdgeInsets.zero,
        ),

        const SizedBox(height: 20),

        PillButton(
          text: controller.isLoading ? "Validando..." : "Validar misión",
          onTap: (controller.tokenId == null ||
                  !controller.confirmed ||
                  controller.isLoading)
              ? null
              : () => controller.validate(context),

          // estilos
          bg: const Color(0xFF3C82C3),
          fg: Colors.white,
          elevation: 4,
          borderColor: Colors.transparent,
        )
      ],
    );
  }
}
