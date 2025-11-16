import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Podio estático 3D sin caras laterales: solo frente + tapa.
/// Las tapas son trapecios. El centro es isósceles; los lados
/// recortan sólo hacia el centro.
class PodiumStatic3D extends StatelessWidget {
  const PodiumStatic3D({
    super.key,
    this.height1 = 140,
    this.height2 = 100,
    this.height3 = 80,
    this.topDepth = 18,
    this.widthFactor = 0.78,
    this.leftAvatar,
    this.centerAvatar,
    this.rightAvatar,
    this.showCenterCrown = true,
    this.centerCrownAsset = 'assets/icons-svg/crown-solid-full.svg',
    this.coinsLeft = '0',
    this.coinsCenter = '0',
    this.coinsRight = '0',
    this.leftAvatarOpacity = 1.0,
    this.centerAvatarOpacity = 1.0,
    this.rightAvatarOpacity = 1.0,
    this.centerCrownOpacity = 1.0,
    this.fadeDuration = const Duration(milliseconds: 300),
  });

  final double height1, height2, height3, topDepth, widthFactor;
  final ImageProvider? leftAvatar, centerAvatar, rightAvatar;
  final bool showCenterCrown;
  final String centerCrownAsset;
  final String coinsLeft, coinsCenter, coinsRight;

  final double leftAvatarOpacity, centerAvatarOpacity, rightAvatarOpacity, centerCrownOpacity;
  final Duration fadeDuration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final total = c.maxWidth * widthFactor;   // usamos solo una fracción del ancho
        final barW  = total / 3;                  // siguen pegadas entre sí
        final sidePad = (c.maxWidth - total) / 2; // margen a los lados para “adelgazar”

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePad),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2º (izquierda)
              _BarWithAvatar(
                width: barW * 0.93,
                barHeight: height2,
                topDepth: topDepth,
                avatarImage: leftAvatar,
                avatarOpacity: leftAvatarOpacity,
                crownOpacity: 1.0,
                fadeDuration: fadeDuration,
                child: _Block3DNoSide(
                  width: barW * 0.93,
                  height: height2,
                  front: const Color(0xFF35B2FF),
                  top:   const Color(0xFF7ED3FF),
                  topDepth: topDepth,
                  topShape: _TopShape.inwardLeft,
                  frontLabelMain: '2',
                  frontLabelSuffix: 'do',
                  frontLabelMainStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    height: 1,
                    color: Colors.white,
                  ),
                  frontLabelSuffixStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1,
                    color: Colors.white,
                  ),
                  frontBadgeText: coinsLeft,
                  frontBadgeIconAsset: 'assets/logo/nubo_coin.png',
                  frontBadgeUseSvg: false,
                  frontBadgeGap: 2,
                  frontBadgeBgColor: Color(0xEEFFFFFF),
                  frontBadgePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),

              // 1º (centro)
              _BarWithAvatar(
                width: barW * 1.14,
                barHeight: height1,
                topDepth: topDepth,
                avatarImage: centerAvatar,
                // 👑 Corona para el 1º (opcional)
                crownAsset: showCenterCrown ? centerCrownAsset : null,
                crownRotationRad: 330 * math.pi / 180, // 315°
                crownScale: 0.46,
                crownDxFactor: -0.18,
                crownDyFactor: -0.35,
                avatarOpacity: centerAvatarOpacity,
                crownOpacity: centerCrownOpacity,
                fadeDuration: fadeDuration,
                child: _Block3DNoSide(
                  width: barW * 1.14,
                  height: height1,
                  front: const Color(0xFFFFD319),
                  top:   const Color(0xFFFFE372),
                  topDepth: topDepth,
                  topShape: _TopShape.iso,
                  frontLabelMain: '1',
                  frontLabelSuffix: 'ro',
                  frontLabelMainStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700, fontSize: 40, height: 1, color: Colors.white,
                  ),
                  frontLabelSuffixStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700, fontSize: 26, height: 1, color: Colors.white,
                  ),
                  frontBadgeText: coinsCenter,
                  frontBadgeIconAsset: 'assets/logo/nubo_coin.png',
                  frontBadgeUseSvg: false,
                  frontBadgeGap: 2,
                  frontBadgeBgColor: Color(0xEEFFFFFF),
                  frontBadgePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),

              // 3º (derecha)
              _BarWithAvatar(
                width: barW * 0.93,
                barHeight: height3,
                topDepth: topDepth,
                avatarImage: rightAvatar,
                avatarOpacity: rightAvatarOpacity,
                crownOpacity: 1.0,
                fadeDuration: fadeDuration,
                child: _Block3DNoSide(
                  width: barW * 0.93,
                  height: height3,
                  front: const Color(0xFF9BE170),
                  top:   const Color(0xFFC9F2AA),
                  topDepth: topDepth,
                  topShape: _TopShape.inwardRight,
                  frontLabelMain: '3',
                  frontLabelSuffix: 'ro',
                  frontLabelMainStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    height: 1,
                    color: Colors.white,
                  ),
                  frontLabelSuffixStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1,
                    color: Colors.white,
                  ),
                  frontBadgeText: coinsRight,
                  frontBadgeIconAsset: 'assets/logo/nubo_coin.png',
                  frontBadgeUseSvg: false,
                  frontBadgeGap: 2,
                  frontBadgeBgColor: Color(0xEEFFFFFF),
                  frontBadgePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum _TopShape { iso, inwardLeft, inwardRight }

/// Bloque sin cara lateral. Sólo frente y tapa (trapecios).
class _Block3DNoSide extends StatelessWidget {
  const _Block3DNoSide({
    required this.width,
    required this.height,
    required this.front,
    required this.top,
    required this.topDepth,
    required this.topShape,
    // ignore: unused_element_parameter
    this.frontLabel,
    // ignore: unused_element_parameter
    this.frontLabelStyle,
    // ignore: unused_element_parameter
    this.frontLabelPadding,
    this.frontLabelMain,
    this.frontLabelSuffix,
    this.frontLabelMainStyle,
    this.frontLabelSuffixStyle,

    this.frontBadgeText,            // p.ej. "330"
    this.frontBadgeIconAsset,       // p.ej. 'assets/coins/coin.svg' o .png
    this.frontBadgeUseSvg = true,   // true=SvgPicture.asset, false=Image.asset
    this.frontBadgeGap = 6,         // separación bajo el título
    this.frontBadgePadding,         // padding interno del badge
    this.frontBadgeBgColor,         // color de fondo del badge
    // ignore: unused_element_parameter
    this.frontBadgeTextStyle,       // estilo del número
    // ignore: unused_element_parameter
    this.frontBadgeRadius = 14,     // radio esquinas
    // ignore: unused_element_parameter
    this.frontBadgeIconSize,        // tamaño del icono dentro del badge
  });

  final double width;
  final double height;
  final Color front;
  final Color top;
  final double topDepth;
  final _TopShape topShape;

  final String? frontLabel;
  final TextStyle? frontLabelStyle;
  final EdgeInsets? frontLabelPadding;

  final String? frontLabelMain;
  final String? frontLabelSuffix;
  final TextStyle? frontLabelMainStyle;
  final TextStyle? frontLabelSuffixStyle;

  final String? frontBadgeText;
  final String? frontBadgeIconAsset;
  final bool frontBadgeUseSvg;
  final double frontBadgeGap;
  final EdgeInsets? frontBadgePadding;
  final Color? frontBadgeBgColor;
  final TextStyle? frontBadgeTextStyle;
  final double frontBadgeRadius;
  final double? frontBadgeIconSize;

  @override
  Widget build(BuildContext context) {
    final defaultMain = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: width * 0.36,
      height: 1.0,
      shadows: const [Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))],
    );
    final defaultSuffix = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: width * 0.18,
      height: 1.0,
      shadows: const [Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))],
    );

    Widget? labelChild;
    if (frontLabelMain != null && frontLabelSuffix != null) {
      labelChild = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(text: frontLabelMain!, style: frontLabelMainStyle ?? defaultMain),
            WidgetSpan(child: SizedBox(width: width * 0.01)),
            TextSpan(text: frontLabelSuffix!, style: frontLabelSuffixStyle ?? defaultSuffix),
          ],
        ),
      );
    } else if (frontLabel != null) {
      labelChild = Text(
        frontLabel!,
        textAlign: TextAlign.center,
        style: frontLabelStyle ??
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              shadows: [Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))],
            ),
      );
    }

    final double minForLabel = width * 0.22; // aprox alto necesario para el título
    final double minForBadge = width * 0.42; // aprox alto título + badge

    final bool canShowLabel = height >= minForLabel && (frontLabelMain != null || frontLabel != null);
    final bool canShowBadge = height >= minForBadge && frontBadgeText != null && frontBadgeIconAsset != null;

    return SizedBox(
      width: width,
      height: height + topDepth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Frente
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: width,
              height: height,
              color: front,
              child: (canShowLabel || canShowBadge)
                  ? Padding(
                padding: frontLabelPadding ?? const EdgeInsets.only(top: 6),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FittedBox(
                    fit: BoxFit.scaleDown, // 👈 evita overflow
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (canShowLabel) Align(alignment: Alignment.topCenter, child: labelChild!),
                        if (canShowBadge) ...[
                          SizedBox(height: frontBadgeGap),
                          _CoinsBadge(
                            text: frontBadgeText!,
                            iconAsset: frontBadgeIconAsset!,
                            useSvg: frontBadgeUseSvg,
                            padding: frontBadgePadding ??
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            bgColor: frontBadgeBgColor ?? Colors.white.withValues(alpha:0.85),
                            textStyle: frontBadgeTextStyle ??
                                GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.16,
                                  color: const Color(0xFF303030),
                                ),
                            radius: frontBadgeRadius,
                            iconSize: frontBadgeIconSize ?? width * 0.18,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )
                  : null,
            ),
          ),
          // Tapa (trapecio)
          Positioned(
            left: 0,
            bottom: height,
            child: ClipPath(
              clipper: _TopOnlyClipper(shape: topShape, depth: topDepth),
              child: Container(width: width, height: topDepth, color: top),
            ),
          ),
        ],
      ),
    );
  }
}

/// Crea la tapa como trapecio:
/// - iso: recorte simétrico a ambos lados
/// - inwardLeft: recorte en el lado IZQUIERDO (barra derecha)
/// - inwardRight: recorte en el lado DERECHO (barra izquierda)
class _TopOnlyClipper extends CustomClipper<Path> {
  _TopOnlyClipper({required this.shape, required this.depth});
  final _TopShape shape;
  final double depth;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height; // == depth
    final cut = w * 0.14;  // cuánto “entra” el recorte horizontal

    switch (shape) {
      case _TopShape.iso:
        return Path()
          ..moveTo(0, h)
          ..lineTo(cut, 0)
          ..lineTo(w - cut, 0)
          ..lineTo(w, h)
          ..close();

      case _TopShape.inwardLeft:
        return Path()
          ..moveTo(0, h)      // base izq
          ..lineTo(cut, 0)    // sube recortando sólo a la izq
          ..lineTo(w, 0)      // arriba der
          ..lineTo(w, h)      // baja der
          ..close();

      case _TopShape.inwardRight:
        return Path()
          ..moveTo(0, 0)          // arriba izq
          ..lineTo(w - cut, 0)    // arriba (recorte lado der)
          ..lineTo(w, h)          // base der
          ..lineTo(0, h)          // base izq
          ..close();
    }
  }

  @override
  bool shouldReclip(_TopOnlyClipper oldClipper) =>
      oldClipper.shape != shape || oldClipper.depth != depth;
}

/// Avatar redondo SIN borde blanco (solo imagen + sombra)
class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.diameter, required this.image});
  final double diameter;
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: image, fit: BoxFit.cover),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
    );
  }
}

/// Envuelve una barra y coloca un avatar arriba (y corona opcional) sin modificar la barra
class _BarWithAvatar extends StatelessWidget {
  const _BarWithAvatar({
    required this.width,
    required this.barHeight,
    required this.topDepth,
    required this.child,
    this.avatarImage,
    // ignore: unused_element_parameter
    this.avatarScale = 0.78,  // diámetro ≈ width * 0.9
    // ignore: unused_element_parameter
    this.overlapFactor = 0.1, // % del diámetro que “entra” sobre la tapa
    // 👑 Corona (opcional)
    this.crownAsset,
    this.crownRotationRad = 350* math.pi / 180, // 315°
    this.crownScale = 0.46,    // tamaño relativo al diámetro del avatar
    this.crownDxFactor = -0.18, // desplazamiento X relativo al ancho de la corona
    this.crownDyFactor = -0.35, // desplazamiento Y relativo al alto de la corona
    this.avatarOpacity = 1.0,
    this.crownOpacity = 1.0,
    this.fadeDuration = const Duration(milliseconds: 300),
  });

  final double width;
  final double barHeight;
  final double topDepth;
  final Widget child;
  final ImageProvider? avatarImage;
  final double avatarScale;
  final double overlapFactor;

  // 👑 Corona
  final String? crownAsset;
  final double crownRotationRad;
  final double crownScale;
  final double crownDxFactor;
  final double crownDyFactor;

  final double avatarOpacity;
  final double crownOpacity;
  final Duration fadeDuration;

  @override
  Widget build(BuildContext context) {
    final d = width * avatarScale;      // diámetro del avatar
    final overlap = d * overlapFactor;  // cuánto se solapa sobre la tapa
    final avatarBottom = barHeight + topDepth - overlap;

    // Medidas base de la corona (si está habilitada)
    final crownW = d * crownScale;
    final crownLeft  = (width - d) / 2 + crownW * crownDxFactor;
    final crownBottom = avatarBottom + d + crownW * crownDyFactor;

    return SizedBox(
      width: width,
      height: barHeight + topDepth + (d - overlap) + (crownAsset != null ? crownW * 0.15 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 0, bottom: 0, child: child),

          if (avatarImage != null)
            Positioned(
              left: (width - d) / 2,
              bottom: avatarBottom,
              child: AnimatedOpacity(
                opacity: avatarOpacity,
                duration: fadeDuration,
                curve: Curves.easeOut,
                child: _AvatarCircle(diameter: d, image: avatarImage!),
              ),
            ),

          if (crownAsset != null && avatarImage != null)
            Positioned(
              left: crownLeft,
              bottom: crownBottom,
              child: AnimatedOpacity(
                opacity: crownOpacity,
                duration: fadeDuration,
                curve: Curves.easeOut,
                child: Transform.rotate(
                  angle: crownRotationRad,
                  child: SvgPicture.asset(crownAsset!, width: crownW),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CoinsBadge extends StatelessWidget {
  const _CoinsBadge({
    required this.text,
    required this.iconAsset,
    required this.useSvg,
    required this.padding,
    required this.bgColor,
    required this.textStyle,
    required this.radius,
    required this.iconSize,
  });

  final String text;
  final String iconAsset;
  final bool useSvg;
  final EdgeInsets padding;
  final Color bgColor;
  final TextStyle textStyle;
  final double radius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: textStyle),
          const SizedBox(width: 4),
          useSvg
              ? SvgPicture.asset(iconAsset, width: iconSize, height: iconSize)
              : Image.asset(iconAsset, width: iconSize, height: iconSize),
        ],
      ),
    );
  }
}

class PodiumStatic3DAnimated extends StatefulWidget {
  const PodiumStatic3DAnimated({
    super.key,
    this.height1 = 140,
    this.height2 = 100,
    this.height3 = 80,
    this.topDepth = 18,
    this.widthFactor = 0.78,
    this.leftAvatar,
    this.centerAvatar,
    this.rightAvatar,
    this.showCenterCrown = true,
    this.centerCrownAsset = 'assets/icons-svg/crown-solid-full.svg',
    this.coinsLeft = '0',
    this.coinsCenter = '0',
    this.coinsRight = '0',
    this.duration = const Duration(milliseconds: 1600),
    this.curve = Curves.easeOutCubic,
  });

  final double height1, height2, height3, topDepth, widthFactor;
  final ImageProvider? leftAvatar, centerAvatar, rightAvatar;
  final bool showCenterCrown;
  final String centerCrownAsset;
  final String coinsLeft, coinsCenter, coinsRight;

  final Duration duration;
  final Curve curve;

  @override
  State<PodiumStatic3DAnimated> createState() => _PodiumStatic3DAnimatedState();
}

class _PodiumStatic3DAnimatedState extends State<PodiumStatic3DAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _aRight;  // 1º: derecha
  late final Animation<double> _aLeft;   // 2º: izquierda
  late final Animation<double> _aCenter; // 3º: centro (amarilla)

  static const _min = 1.0; // evita alturas 0 que pueden romper layouts/clip

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _aRight  = CurvedAnimation(parent: _ctrl, curve: const Interval(0.10, 0.70, curve: Curves.easeOutCubic));
    _aLeft   = CurvedAnimation(parent: _ctrl, curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic));
    _aCenter = CurvedAnimation(parent: _ctrl, curve: const Interval(0.60, 1.00, curve: Curves.easeOutCubic));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const done = 0.88; // umbral para "terminó"

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final hRight  = (widget.height3 * _aRight.value ).clamp(_min, double.infinity);
        final hLeft   = (widget.height2 * _aLeft.value  ).clamp(_min, double.infinity);
        final hCenter = (widget.height1 * _aCenter.value).clamp(_min, double.infinity);

        final leftOpacity   = _aLeft.value   >= done ? 1.0 : 0.0;
        final rightOpacity  = _aRight.value  >= done ? 1.0 : 0.0;
        final centerOpacity = _aCenter.value >= done ? 1.0 : 0.0;
        final crownOpacity  = (_aCenter.value >= done && widget.showCenterCrown) ? 1.0 : 0.0;

        return PodiumStatic3D(
          height1: hCenter,
          height2: hLeft,
          height3: hRight,
          topDepth: widget.topDepth,
          widthFactor: widget.widthFactor,
          leftAvatar: widget.leftAvatar,
          centerAvatar: widget.centerAvatar,
          rightAvatar: widget.rightAvatar,
          showCenterCrown: widget.showCenterCrown,
          centerCrownAsset: widget.centerCrownAsset,

          leftAvatarOpacity: leftOpacity,
          centerAvatarOpacity: centerOpacity,
          rightAvatarOpacity: rightOpacity,
          centerCrownOpacity: crownOpacity,

          coinsLeft: widget.coinsLeft,
          coinsCenter: widget.coinsCenter,
          coinsRight: widget.coinsRight,

          fadeDuration: const Duration(milliseconds: 280),
        );
      },
    );
  }
}
