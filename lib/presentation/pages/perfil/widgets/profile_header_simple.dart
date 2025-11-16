import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:go_router/go_router.dart';

class ProfileHeaderSimple extends StatelessWidget {
  final UserProfile profile;
  
  const ProfileHeaderSimple({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(
      fontFamily: robotoBlack,
      fontSize: 28,
      height: 1.05,
      letterSpacing: -0.2,
      color: Colors.black,
    );

    return Column(
      children: [
        // Header con flecha y título
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Text(
                'Mi perfil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: robotoBold,
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 48), // Balance para centrar el título
          ],
        ),
        const SizedBox(height: 24),
        
        // Foto de perfil
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 56,
            backgroundImage: profile.user.avatar != null
                ? NetworkImage(profile.user.avatar!)
                : null,
            child: profile.user.avatar == null
                ? Text(
                    profile.user.username.isNotEmpty
                        ? profile.user.username.substring(0, 1).toUpperCase()
                        : 'U',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      fontFamily: robotoBold,
                    ),
                  )
                : null,
            backgroundColor: primaryLight,
          ),
        ),
        const SizedBox(height: 16),
        
        // Nombre completo
        Text(
          profile.user.username,
          style: nameStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

