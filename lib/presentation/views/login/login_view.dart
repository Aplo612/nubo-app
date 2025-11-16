import 'package:flutter/material.dart';
import 'package:nubo/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nubo/presentation/utils/generic_button/pill_button.dart';
import 'package:nubo/presentation/utils/generic_button/social_button.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({super.key});

  // Paleta
  static const _blue = Color(0xFF5DB7E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Degradado superior
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFBFE6FF), Colors.white],
                ),
              ),
            ),
          ),

          // “Nubes” inferiores (3 círculos)
          // izquierda
          Positioned(
            left: -170,
            bottom: -190,
            child: _cloud(340, Color(0xff6ecaf4)),
          ),
          // centro
          Positioned(
            left: 40,
            right: 40,
            bottom: -160,
            child: _cloud(280, Color(0xffb4e2ff)),
          ),
          // derecha
          Positioned(
            right: -170,
            bottom: -190,
            child: _cloud(340, Color(0xbb6ecaf4)),
          ),

          // Contenido
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo con tinte
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(_blue, BlendMode.srcIn),
                        child: Image.asset(
                          "assets/logo/nubo_logo_login.png",
                          height: 120,
                        ),
                      ),
                      const SizedBox(height: 6),

                      const SizedBox(height: 28),

                      PillButton(
                        text: 'Ingresar',
                        onTap: () => context.pushNamed('login_form_page'),
                      ),
                      const SizedBox(height: 14),
                      PillButton(
                        text: 'Registrarse',
                        onTap: () => context.pushNamed('register_form_page'),
                        // si quieres un estilo levemente más claro:
                        bg: Colors.white,
                        fg: const Color(0xFF4A4A4A),
                      ),

                      const SizedBox(height: 18),
                      // separador sutil
                      Opacity(
                        opacity: .5,
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Botones sociales
                      Row(
                        children: [
                          Expanded(
                            child: SocialButton(
                              iconWidget: SvgPicture.asset(
                                googleSvg,
                                width: 22,
                                height: 22,
                              ),
                              label: 'Google',
                              onTap: () {/* TODO: Google sign-in */},
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SocialButton(
                              iconWidget: SvgPicture.asset(
                                facebookSvg,
                                width: 22,
                                height: 22,
                              ),
                              label: 'Facebook',
                              onTap: () {/* TODO: Facebook sign-in */},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _cloud(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
    );
  }
}
