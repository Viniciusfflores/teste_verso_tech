import 'package:flutter/material.dart';

class PokedexCard extends StatelessWidget {
  final Widget child;

  final double chamfer;

  final double borderWidth;

  final Color borderColor;
  final Color backgroundColor;

  final double dotsTop;
  final double dotsLeft;
  final double dotSize;
  final double dotsGap;

  const PokedexCard({
    super.key,
    required this.child,
    this.chamfer = 18,
    this.borderWidth = 4,
    this.borderColor = const Color(0xFF8A8A8A),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.dotsTop = 10,
    this.dotsLeft = 12,
    this.dotSize = 10,
    this.dotsGap = 18,
  });

  @override
  Widget build(BuildContext context) {
    final clipper = _PokedexChamferClipper(chamfer: chamfer);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _PokedexFillPainter(
              chamfer: chamfer,
              color: backgroundColor,
            ),
          ),
        ),

        Positioned.fill(
          child: ClipPath(
            clipper: clipper,
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),

        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _PokedexBorderPainter(
                chamfer: chamfer,
                borderWidth: borderWidth,
                color: borderColor,
              ),
            ),
          ),
        ),

        Positioned(
          top: dotsTop,
          left: dotsLeft,
          child: _Dot(size: dotSize, color: const Color(0xFF3CB54A)),
        ),
        Positioned(
          top: dotsTop,
          left: dotsLeft + dotsGap,
          child: _Dot(size: dotSize, color: const Color(0xFF3CB54A)),
        ),
        Positioned(
          top: dotsTop,
          left: dotsLeft + dotsGap * 2,
          child: _Dot(size: dotSize, color: Colors.yellow),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;

  const _Dot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 1),
            color: Colors.black26,
          ),
        ],
      ),
    );
  }
}

Path _pokedexChamferTRBLPath(Rect rect, double chamfer) {
  final l = rect.left, t = rect.top, r = rect.right, b = rect.bottom;

  final c = chamfer.clamp(0.0, rect.shortestSide / 2);

  return Path()
    ..moveTo(l, t)
    ..lineTo(r - c, t)      // topo vai até antes do canto TR
    ..lineTo(r, t + c)      // chanfro TR
    ..lineTo(r, b)          // desce tudo
    ..lineTo(l + c, b)      // vai no bottom até antes do BL
    ..lineTo(l, b - c)      // chanfro BL
    ..lineTo(l, t)
    ..close();
}

class _PokedexChamferClipper extends CustomClipper<Path> {
  final double chamfer;

  _PokedexChamferClipper({required this.chamfer});

  @override
  Path getClip(Size size) {
    return _pokedexChamferTRBLPath(Offset.zero & size, chamfer);
  }

  @override
  bool shouldReclip(covariant _PokedexChamferClipper oldClipper) {
    return oldClipper.chamfer != chamfer;
  }
}

class _PokedexFillPainter extends CustomPainter {
  final double chamfer;
  final Color color;

  _PokedexFillPainter({required this.chamfer, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = _pokedexChamferTRBLPath(rect, chamfer);

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PokedexFillPainter oldDelegate) {
    return oldDelegate.chamfer != chamfer || oldDelegate.color != color;
  }
}

class _PokedexBorderPainter extends CustomPainter {
  final double chamfer;
  final double borderWidth;
  final Color color;

  _PokedexBorderPainter({
    required this.chamfer,
    required this.borderWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = _pokedexChamferTRBLPath(rect, chamfer);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = color
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PokedexBorderPainter oldDelegate) {
    return oldDelegate.chamfer != chamfer ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.color != color;
  }
}
