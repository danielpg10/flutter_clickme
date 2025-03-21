import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

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
  late AnimationController _waveController;
  late AnimationController _particleController;
  late AnimationController _nebulaController;
  final List<ParticleModel> particles = [];
  bool isLowPerformanceDevice = false;
  
  @override
  void initState() {
    super.initState();
    
    if (!kIsWeb) {
      isLowPerformanceDevice = Platform.isAndroid || Platform.isIOS;
    }
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: false);
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: false);
    
    _nebulaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat(reverse: false);
    
    final random = Random();
    final particleCount = isLowPerformanceDevice ? 30 : 60;
    
    for (int i = 0; i < particleCount; i++) {
      final isLarger = random.nextDouble() > 0.85;
      
      particles.add(
        ParticleModel(
          position: Offset(
            random.nextDouble() * 1000,
            random.nextDouble() * 1000,
          ),
          speed: Offset(
            (random.nextDouble() * 0.3 - 0.15) * (isLarger ? 0.7 : 1.0),
            (random.nextDouble() * 0.3 - 0.15) * (isLarger ? 0.7 : 1.0),
          ),
          radius: isLarger 
              ? random.nextDouble() * 2.5 + 1.5 
              : random.nextDouble() * 1.5 + 0.5,
          color: Colors.white.withOpacity(
            isLarger 
                ? random.nextDouble() * 0.2 + 0.15
                : random.nextDouble() * 0.3 + 0.1
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _particleController.dispose();
    _nebulaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0A0A1A),
          ),
        ),
        
        AnimatedBuilder(
          animation: _waveController,
          builder: (context, _) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(-0.5, -0.6),
                      radius: 1.0,
                      colors: const [
                        Color(0xFF3A0CA3),
                        Color(0xFF0A0A1A),
                      ],
                      stops: const [0.0, 0.7],
                    ),
                  ),
                ),
                
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.7,
                    child: CustomPaint(
                      painter: SubtleGradientPainter(
                        animation: _waveController.value,
                        isLowPerformance: isLowPerformanceDevice,
                      ),
                    ),
                  ),
                ),
                
                AnimatedBuilder(
                  animation: _nebulaController,
                  builder: (context, _) {
                    return Positioned.fill(
                      child: CustomPaint(
                        painter: NebulaPainter(
                          animation: _nebulaController.value,
                          isLowPerformance: isLowPerformanceDevice,
                        ),
                      ),
                    );
                  },
                ),
                
                AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, _) {
                    return Positioned.fill(
                      child: CustomPaint(
                        painter: ParticlePainter(
                          particles: particles,
                          animation: _particleController.value,
                          isLowPerformance: isLowPerformanceDevice,
                        ),
                      ),
                    );
                  },
                ),
              ],
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
  final Offset speed;
  final double radius;
  final Color color;

  ParticleModel({
    required this.position,
    required this.speed,
    required this.radius,
    required this.color,
  });

  void update(Size size) {
    position += speed;
    
    if (position.dx < 0) {
      position = Offset(size.width, position.dy);
    } else if (position.dx > size.width) {
      position = Offset(0, position.dy);
    }
    
    if (position.dy < 0) {
      position = Offset(position.dx, size.height);
    } else if (position.dy > size.height) {
      position = Offset(position.dx, 0);
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;
  final double animation;
  final bool isLowPerformance;

  ParticlePainter({
    required this.particles,
    required this.animation,
    required this.isLowPerformance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update(size);
      
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;
      
      if (particle.radius > 2 && !isLowPerformance) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, particle.radius * 0.5);
      }
      
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

class SubtleGradientPainter extends CustomPainter {
  final double animation;
  final bool isLowPerformance;
  
  SubtleGradientPainter({
    required this.animation,
    required this.isLowPerformance,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    final waveHeight = height * 0.05;
    final waveCount = isLowPerformance ? 3 : 5;
    
    for (int i = 0; i < waveCount; i++) {
      final phase = animation * 2 * pi + (i * pi / waveCount);
      final amplitude = waveHeight * (1 - i / waveCount);
      
      final path = Path();
      path.moveTo(0, height * (0.3 + 0.1 * i) + amplitude * sin(phase));
      
      for (double x = 0; x <= width; x += width / 100) {
        final y = height * (0.3 + 0.1 * i) + 
                 amplitude * sin(phase + (x / width) * 4 * pi);
        path.lineTo(x, y);
      }
      
      path.lineTo(width, height);
      path.lineTo(0, height);
      path.close();
      
      canvas.drawPath(
        path, 
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7B2CBF).withOpacity(0.1 - 0.02 * i),
              Color(0xFF240046).withOpacity(0),
            ],
          ).createShader(Rect.fromLTWH(0, height * (0.3 + 0.1 * i), width, height * 0.7))
          ..style = PaintingStyle.fill
      );
    }
    
    if (!isLowPerformance) {
      final starCount = 30;
      final random = Random(42);
      
      for (int i = 0; i < starCount; i++) {
        final x = random.nextDouble() * width;
        final y = random.nextDouble() * height * 0.7;
        final size = random.nextDouble() * 1.5 + 0.5;
        
        final starPhase = animation * 2 * pi + (i * 0.2);
        final opacity = 0.1 + 0.1 * sin(starPhase);
        
        final starPaint = Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(Offset(x, y), size, starPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(SubtleGradientPainter oldDelegate) => 
      oldDelegate.animation != animation;
}

class NebulaPainter extends CustomPainter {
  final double animation;
  final bool isLowPerformance;
  
  NebulaPainter({
    required this.animation,
    required this.isLowPerformance,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (isLowPerformance) return;
    
    final width = size.width;
    final height = size.height;
    final random = Random(42);
    
    final nebulaCount = 3;
    
    for (int i = 0; i < nebulaCount; i++) {
      final phase = animation * 2 * pi + (i * 2 * pi / nebulaCount);
      
      final centerX = width * (0.3 + 0.4 * sin(phase * 0.2));
      final centerY = height * (0.3 + 0.2 * cos(phase * 0.3));
      final radius = width * (0.15 + 0.05 * sin(phase * 0.5));
      
      final colors = [
        i == 0 
            ? Color(0xFF7B2CBF).withOpacity(0.03)
            : i == 1 
                ? Color(0xFF3A0CA3).withOpacity(0.03)
                : Color(0xFF5A189A).withOpacity(0.03),
        Colors.transparent,
      ];
      
      final nebulaPaint = Paint()
        ..shader = RadialGradient(
          colors: colors,
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromLTWH(
          centerX - radius, 
          centerY - radius, 
          radius * 2, 
          radius * 2
        ))
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.plus;
      
      canvas.drawCircle(Offset(centerX, centerY), radius, nebulaPaint);
      
      final smallNebulaCount = 5;
      
      for (int j = 0; j < smallNebulaCount; j++) {
        final smallPhase = phase + (j * 2 * pi / smallNebulaCount);
        final distance = radius * 0.7;
        
        final smallX = centerX + distance * cos(smallPhase);
        final smallY = centerY + distance * sin(smallPhase);
        final smallRadius = radius * (0.2 + 0.1 * sin(phase * 0.7 + j));
        
        final smallNebulaPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              colors[0].withOpacity(0.02),
              Colors.transparent,
            ],
            stops: const [0.0, 1.0],
          ).createShader(Rect.fromLTWH(
            smallX - smallRadius, 
            smallY - smallRadius, 
            smallRadius * 2, 
            smallRadius * 2
          ))
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.plus;
        
        canvas.drawCircle(Offset(smallX, smallY), smallRadius, smallNebulaPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(NebulaPainter oldDelegate) => 
      oldDelegate.animation != animation;
}