import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/presentation/utils/card_custom/card_custom.dart';

class PersonalInfoSection extends StatelessWidget {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String city;
  final String birthDate;

  const PersonalInfoSection({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.city,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    return CardCustom(
      enableShadow: false,
      padding: const EdgeInsets.all(16),
      spacing: 12,
      children: [
        _InfoRow(label: 'Nombre Completo', value: fullName),
        _InfoRow(label: 'Número de Teléfono', value: phoneNumber),
        _InfoRow(label: 'Email', value: email),
        _InfoRow(label: 'Ciudad', value: city),
        _InfoRow(label: 'Fecha de Nacimiento', value: birthDate),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: robotoMedium,
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: gray50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: robotoRegular,
                fontSize: 14,
                color: gray600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

