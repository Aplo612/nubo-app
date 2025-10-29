import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nubo/config/config.dart';

class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({
    super.key,
    required this.name,
    required this.streak,
    this.onTap,
  });

  final String name;
  final int streak;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontFamily: robotoBlack,
      fontSize: 28,
      height: 1.05,
      letterSpacing: -0.2,
      color: Colors.black, // Título negro
    );

    final subtitleStyle = TextStyle(
      fontFamily: robotoLight,
      fontSize: 16,
      height: 1.25,
      color: gray400, // gris claro
    );

    final streakNumberStyle = TextStyle(
      fontFamily: robotoBold,
      fontSize: 28, // aumentado
      height: 1.0,
      color: warningActive, // naranja del tema
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hola, $name', style: titleStyle),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '¡Hoy es un gran dia\npara reciclar!',
                          style: subtitleStyle,
                        ),
                      ),
                      const SizedBox(width: 0),
                      SvgPicture.asset(
                        streakSvg,
                        width: 24,
                        height: 29,
                        colorFilter: const ColorFilter.mode(
                          Colors.orange,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 0),
                      Text('$streak', style: streakNumberStyle),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 0),
            // --- Mascota ---
            Image.asset(
              'assets/logo/nubo_sin_fondo.png',
              width: 170, // un poco más grande
              fit: BoxFit.contain,
              semanticLabel: 'Mascota Nubo saludando',
            ),
          ],
        ),
      ),
    );
  }
}