// ignore: file_names
import 'package:flutter/material.dart';
import 'package:nubo/config/config.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_textfield.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';import 'package:nubo/presentation/utils/snackbar/snackbar.dart';
import 'package:nubo/presentation/utils/generic_button/pill_button.dart';

class ValidatorForm extends StatefulWidget {
  const ValidatorForm({super.key});

  @override
  State<ValidatorForm> createState() => _ValidatorFormState();
}

class _ValidatorFormState extends State<ValidatorForm> {
 final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  static const String _expectedCode = 'UCP2025';
  static const String _emptyMsg = 'No puede dejar este campo vacío';

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // === Nubes ===
          IgnorePointer(
            child: Stack(
              children: [
                Positioned(
                  left: -170,
                  bottom: -190,
                  child: _cloud(340, const Color(0xff6ecaf4)),
                ),
                Positioned(
                  left: 40,
                  right: 40,
                  bottom: -160,
                  child: _cloud(280, const Color(0xffb4e2ff)),
                ),
                Positioned(
                  right: -170,
                  bottom: -190,
                  child: _cloud(340, const Color(0xbb6ecaf4)),
                ),
              ],
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final bottomInset = MediaQuery.of(context).viewInsets.bottom;
              final bool keyboardOpen = bottomInset > 0;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 0, 24, bottomInset + 3),
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: height),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      padding: EdgeInsets.only(
                        top: keyboardOpen ? 24 : height * 0.18,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Título principal (sin flecha)
                            Text(
                              "Validar código",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontFamily: robotoBold,
                                    color: Colors.black87,
                                    fontSize: 28,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Ingresa tu código de validador para continuar.",
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                fontFamily: robotoRegular,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // === Form ===
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  UserField(
                                    controller: _codeController,
                                    icon: Icons.verified_outlined,
                                    hintText: "Ingresa tu código de validador",
                                    validador: (String? value) {
                                      final val = value?.trim() ?? '';
                                      if (val.isEmpty) return _emptyMsg;
                                      if (val != _expectedCode) {
                                        return 'Código incorrecto';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 24),

                                  // Botón de validar
                                  SizedBox(
                                    width: double.infinity,
                                    child: PillButton(
                                      text: "Validar",
                                      onTap: () {
                                        final isValid =
                                            _formKey.currentState!.validate();
                                        if (isValid) {
                                          SnackbarUtil.showSnack(
                                            context,
                                            message:
                                                '¡Bienvenido validador!',
                                            backgroundColor:
                                                Colors.green.shade600,
                                          );
                                          NavigationHelper.safePushReplacement(context, '/agent-val');
                                        } else {
                                          SnackbarUtil.showSnack(
                                            context,
                                            message:
                                                'El código ingresado no es válido',
                                            backgroundColor:
                                                Colors.red.shade600,
                                            duration:
                                                const Duration(seconds: 3),
                                          );
                                        }
                                      },
                                      bg: const Color(0xFF3C82C3),
                                      fg: Colors.white,
                                      elevation: 4,
                                      borderColor: Colors.transparent,
                                    ),
                                  ),

                                  const SizedBox(height: 36),

                                  const Text(
                                    "Nubo © 2025",
                                    style: TextStyle(
                                      fontFamily: robotoMedium,
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
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