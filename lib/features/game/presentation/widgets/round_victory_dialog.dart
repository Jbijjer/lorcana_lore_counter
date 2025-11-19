import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../domain/player.dart';

/// Dialog de victoire de manche avec portrait du joueur
class RoundVictoryDialog extends StatefulWidget {
  const RoundVictoryDialog({
    super.key,
    required this.winner,
    required this.isMatchComplete,
    required this.winnerWins,
    required this.loserWins,
    required this.loserName,
  });

  final Player winner;
  final bool isMatchComplete;
  final int winnerWins;
  final int loserWins;
  final String loserName;

  @override
  State<RoundVictoryDialog> createState() => _RoundVictoryDialogState();
}

class _RoundVictoryDialogState extends State<RoundVictoryDialog>
    with TickerProviderStateMixin {
  late AnimationController _dialogAnimationController;
  late AnimationController _shimmerController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  // Couleur et image de victoire aléatoires
  late String _victoryImageName;
  late Color _victoryColor;
  late int _sparklesSeed;

  // Map des couleurs disponibles
  static const Map<String, Color> _colorMap = {
    'bleu': Colors.blue,
    'gris': Colors.grey,
    'jaune': Colors.amber,
    'mauve': Colors.purple,
    'rouge': Colors.red,
    'vert': Colors.green,
  };

  @override
  void initState() {
    super.initState();

    // Sélection aléatoire d'une couleur et d'une seed pour les sparkles
    final random = math.Random();
    final colorKeys = _colorMap.keys.toList();
    _victoryImageName = colorKeys[random.nextInt(colorKeys.length)];
    _victoryColor = _colorMap[_victoryImageName]!;
    _sparklesSeed = random.nextInt(1000000);

    // Animation d'entrée du dialog
    _dialogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.elasticOut,
    );

    _rotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeIn,
    );

    // Animation shimmer
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Animation des confettis
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _dialogAnimationController.forward();
    HapticUtils.success();
  }

  @override
  void dispose() {
    _dialogAnimationController.dispose();
    _shimmerController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _victoryColor.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Contenu principal
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image de victoire avec sparkles
                        SizedBox(
                          height: 160,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Image de victoire
                              Image.asset(
                                'assets/images/victoire_$_victoryImageName.png',
                                fit: BoxFit.contain,
                              ),

                              // Sparkles animés
                              AnimatedBuilder(
                                animation: _shimmerController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    size: const Size(400, 160),
                                    painter: _SparklesPainter(
                                      animationValue: _shimmerController.value,
                                      color: _victoryColor,
                                      seed: _sparklesSeed,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Portrait du joueur
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Halo de lumière
                            Container(
                              width: 168,
                              height: 168,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.winner.color
                                        .withValues(alpha: 0.4),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),

                            // Portrait avec gradient
                            Container(
                              width: 144,
                              height: 144,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    widget.winner.backgroundColorStart,
                                    widget.winner.backgroundColorEnd,
                                  ],
                                ),
                                border: Border.all(
                                  color: _victoryColor,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _victoryColor
                                        .withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  widget.winner.iconAssetPath,
                                  width: 144,
                                  height: 144,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // Effet shimmer autour du portrait
                            AnimatedBuilder(
                              animation: _shimmerController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _shimmerController.value * 2 * math.pi,
                                  child: Container(
                                    width: 162,
                                    height: 162,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: SweepGradient(
                                        colors: [
                                          Colors.transparent,
                                          _victoryColor.withValues(alpha: 0.5),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.5, 1.0],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Nom du gagnant
                        Text(
                          widget.winner.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _victoryColor,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Score du match
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.isMatchComplete
                                    ? 'Score Final'
                                    : 'Score du Match',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${widget.winner.name}: ${widget.winnerWins}  -  ${widget.loserName}: ${widget.loserWins}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Bouton principal
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              HapticUtils.light();
                              Navigator.of(context).pop();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: _victoryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 8,
                              shadowColor: _victoryColor.withValues(alpha: 0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.isMatchComplete
                                      ? Icons.refresh
                                      : Icons.arrow_forward,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    widget.isMatchComplete
                                        ? 'Nouvelle Partie'
                                        : 'Manche Suivante',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Confettis au premier plan
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _confettiController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: _ConfettiPainter(
                              animationValue: _confettiController.value,
                              color: _victoryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Painter pour les têtes de Mickey qui tombent
class _ConfettiPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _ConfettiPainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final random = math.Random(42);

    // Dessiner des têtes de Mickey multicolores
    for (int i = 0; i < 25; i++) {
      final offsetX = size.width * random.nextDouble();
      final startY = -50 - (random.nextDouble() * 150);
      final currentY = startY + (size.height + 300) * animationValue;

      // Calculer l'opacité avec fade out progressif vers le bas
      double opacity = 0.8;
      final fadeStart = size.height * 0.85 - 30;
      if (currentY > fadeStart) {
        // Commencer le fade out 30 pixels plus haut
        final fadeEnd = size.height + 80;
        final fadeProgress = (currentY - fadeStart) / (fadeEnd - fadeStart);
        opacity = 0.8 * (1.0 - fadeProgress.clamp(0.0, 1.0));
      }

      // Skip seulement si complètement transparent ou trop loin
      if (opacity <= 0.0 || currentY > size.height + 150) continue;

      // Couleurs multicolores variées
      final colors = [
        color,
        Colors.amber,
        Colors.blue,
        Colors.pink,
        Colors.purple,
        Colors.red,
        Colors.orange,
        Colors.cyan,
        Colors.teal,
        Colors.lime,
      ];
      paint.color = colors[i % colors.length].withValues(alpha: opacity);

      // Rotation légère
      final rotation = (animationValue + (i * 0.1)) * math.pi * 2;

      // Taille de la tête de Mickey
      final mickeySize = 12 + (random.nextDouble() * 8);
      final headRadius = mickeySize / 2;
      final earRadius = headRadius * 0.6;

      canvas.save();
      canvas.translate(offsetX, currentY);
      canvas.rotate(rotation);

      // Dessiner la tête de Mickey (3 cercles)
      // Oreille gauche
      canvas.drawCircle(
        Offset(-headRadius * 0.6, -headRadius * 0.6),
        earRadius,
        paint,
      );

      // Oreille droite
      canvas.drawCircle(
        Offset(headRadius * 0.6, -headRadius * 0.6),
        earRadius,
        paint,
      );

      // Tête principale
      canvas.drawCircle(
        Offset.zero,
        headRadius,
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}

/// Painter pour les sparkles brillants sur l'image de victoire
class _SparklesPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final int seed;

  _SparklesPainter({
    required this.animationValue,
    required this.color,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Dessiner 3 sparkles à des positions aléatoires
    for (int i = 0; i < 3; i++) {
      // Générer une durée aléatoire unique pour ce sparkle (entre 1.5 et 3.0 secondes normalisées)
      final durationRandom = math.Random(seed + i * 999983);
      final normalizedDuration = 1.5 + durationRandom.nextDouble() * 1.5; // Entre 1.5 et 3.0

      // Calculer le temps ajusté pour cette durée personnalisée
      final adjustedTime = animationValue * (2.0 / normalizedDuration) + (i * 0.33);

      // Calculer le numéro du cycle pour changer la position à chaque cycle
      // Utiliser des nombres premiers grands pour éviter la périodicité
      final cycleNumber = adjustedTime.floor();

      // Animation cyclique pour chaque sparkle avec un décalage et une durée aléatoire
      final sparklePhase = adjustedTime % 1.0;

      // Générer une nouvelle position pour chaque cycle avec un seed vraiment unique
      // Les grands nombres premiers évitent la répétition du pattern
      final random = math.Random(seed + i * 999983 + cycleNumber * 104729);
      final x = size.width * (0.25 + random.nextDouble() * 0.5);
      final y = size.height * (0.25 + random.nextDouble() * 0.5);

      // Fade in/out en triangle
      double opacity;
      if (sparklePhase < 0.5) {
        opacity = sparklePhase * 2; // Fade in
      } else {
        opacity = (1.0 - sparklePhase) * 2; // Fade out
      }
      opacity = opacity.clamp(0.0, 1.0);

      // Taille du sparkle qui varie avec l'opacité
      final sparkleSize = 3.5 + (opacity * 2.5);

      // Mélanger la couleur de victoire avec du blanc pour une teinte colorée
      final sparkleColor = Color.lerp(Colors.white, color, 0.4)!;
      paint.color = sparkleColor.withValues(alpha: opacity * 0.95);

      // Dessiner une petite étoile à 4 branches
      canvas.save();
      canvas.translate(x, y);

      // Centre de l'étoile
      canvas.drawCircle(const Offset(0, 0), sparkleSize, paint);

      // Rayons de l'étoile
      final rayLength = sparkleSize * 1.6;
      paint.strokeWidth = 1.8;
      paint.style = PaintingStyle.stroke;

      // 4 rayons (horizontal, vertical, 2 diagonaux)
      canvas.drawLine(Offset(-rayLength, 0), Offset(rayLength, 0), paint);
      canvas.drawLine(Offset(0, -rayLength), Offset(0, rayLength), paint);
      canvas.drawLine(Offset(-rayLength * 0.7, -rayLength * 0.7),
                     Offset(rayLength * 0.7, rayLength * 0.7), paint);
      canvas.drawLine(Offset(rayLength * 0.7, -rayLength * 0.7),
                     Offset(-rayLength * 0.7, rayLength * 0.7), paint);

      canvas.restore();
      paint.style = PaintingStyle.fill;
    }
  }

  @override
  bool shouldRepaint(_SparklesPainter oldDelegate) => true;
}
