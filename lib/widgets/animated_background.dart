import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  
  const AnimatedBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final List<ParticleModel> particles = [];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    
    final random = Random();
    
    for (int i = 0; i < 40; i++) {
      final isLarge = random.nextDouble() > 0.7;
      final colorOptions = [
        const Color(0xFFB026FF),
        const Color(0xFF7B2CBF),
        const Color(0xFF5A189A),
        const Color(0xFF3C096C),
        const Color(0xFF240046), 
      ];
      
      final selectedColor = colorOptions[random.nextInt(colorOptions.length)];
      
      particles.add(
        ParticleModel(
          position: Offset(
            random.nextDouble() * 1000,
            random.nextDouble() * 2000,
          ),
          speed: Offset(
            (random.nextDouble() * 0.8 - 0.4) * (isLarge ? 0.5 : 1.0),
            (random.nextDouble() * 0.8 - 0.4) * (isLarge ? 0.5 : 1.0),
          ),
          radius: isLarge ? random.nextDouble() * 15 + 10 : random.nextDouble() * 5 + 2,
          color: selectedColor.withOpacity(random.nextDouble() * 0.4 + 0.2),
          blur: random.nextDouble() * 5 + 2,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.5, 0.3),
              radius: 1.2,
              colors: [
                Color(0xFF8A2BE2),
                Color(0xFF111927),
              ],
              stops: [0.0, 0.7],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.8, 0.8),
              radius: 1.0,
              colors: [
                Color(0xFF111927),
                Color(0xFF111927),
              ],
              stops: [0.0, 0.5],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: ParticlePainter(particles, _controller.value),
              child: Container(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class ParticleModel {
  Offset position;
  Offset speed;
  final double radius;
  final Color color;
  final double blur;

  ParticleModel({
    required this.position,
    required this.speed,
    required this.radius,
    required this.color,
    required this.blur,
  });

  void update(Size size) {
    position += speed;
    
    if (position.dx < -radius || position.dx > size.width + radius) {
      speed = Offset(-speed.dx, speed.dy);
    }

    if (position.dy < -radius || position.dy > size.height + radius) {
      speed = Offset(speed.dx, -speed.dy);
    }

    if (position.dx < -radius * 2 || position.dx > size.width + radius * 2 ||
        position.dy < -radius * 2 || position.dy > size.height + radius * 2) {
      final random = Random();
      final side = random.nextInt(4);
      switch (side) {
        case 0:
          position = Offset(random.nextDouble() * size.width, -radius);
          break;
        case 1:
          position = Offset(size.width + radius, random.nextDouble() * size.height);
          break;
        case 2:
          position = Offset(random.nextDouble() * size.width, size.height + radius);
          break;
        case 3:
          position = Offset(-radius, random.nextDouble() * size.height);
          break;
      }
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;
  final double animation;

  ParticlePainter(this.particles, this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update(size);
      
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.blur);
      
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final distance = (particles[i].position - particles[j].position).distance;
        if (distance < 150) {
          final opacity = 1.0 - (distance / 150);
          final paint = Paint()
            ..color = Color.fromRGBO(255, 255, 255, opacity * 0.15)
            ..strokeWidth = 1.5;
          
          canvas.drawLine(particles[i].position, particles[j].position, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}