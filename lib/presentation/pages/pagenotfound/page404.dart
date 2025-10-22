import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import 'package:nubo/config/config.dart';

class NotFoundPage extends StatelessWidget {
  static const String name = "404";
  const NotFoundPage({
    super.key,
    this.mascotAsset = 'assets/logo/nubo_blanco.png',
    this.title = 'Página no encontrada',
    this.subtitle = 'No se encontró la página que solicitaste',
  });

  final String mascotAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: buttonprimary, // azul Nubo
      body: SafeArea(
        child: Stack(
          children: [
            // Contenido centrado
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Silueta blanca
                    Image.asset(
                      mascotAsset,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    // Título
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: robotoBold,
                        fontSize: 32,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtítulo
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: robotoMedium,
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: background,
                  foregroundColor: buttonprimary,
                  elevation: 8,
                  shadowColor: Colors.black26,
                  minimumSize: const Size.fromHeight(58),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Regresar',
                  style: TextStyle(
                    fontFamily: robotoBold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
