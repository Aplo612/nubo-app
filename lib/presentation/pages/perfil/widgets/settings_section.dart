import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';

class SettingsSection extends StatelessWidget {
  final VoidCallback onLogout;
  const SettingsSection({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuración',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              fontFamily: robotoMedium,
            ),
          ),
          const SizedBox(height: 8),
          _SettingTile(icon: '🔔', title: 'Notificaciones', onTap: () {}),
          _SettingTile(icon: '🛡️', title: 'Privacidad', onTap: () {}),
          _SettingTile(icon: '❓', title: 'Ayuda y Soporte', onTap: () {}),
          _SettingTile(icon: '📄', title: 'Términos y Condiciones', onTap: () {}),
          const SizedBox(height: 8),
          _LogoutButton(onTap: onLogout),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  const _SettingTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: robotoBold,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: gray400),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: errorLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: errorColor),
            const SizedBox(width: 8),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: errorColor,
                fontWeight: FontWeight.w800,
                fontFamily: robotoBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

