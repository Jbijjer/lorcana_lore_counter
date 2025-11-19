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

  // Compteur de cycles pour varier la disposition des confettis
  int _confettiCycleCount = 0;

  // Couleur et image de victoire aléatoires
  late String _victoryImageName;
  late Color _victoryColor;

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

    // Sélection aléatoire d'une couleur
    final random = math.Random();
    final colorKeys = _colorMap.keys.toList();
    _victoryImageName = colorKeys[random.nextInt(colorKeys.length)];
    _victoryColor = _colorMap[_victoryImageName]!;

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

    // Animation shimmer pour l'effet rotatif autour du portrait
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Animation des confettis
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Incrémenter le compteur de cycles à chaque répétition
    _confettiController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _confettiCycleCount++;
        });
      }
    });

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
                        // Image de victoire
                        SizedBox(
                          height: 160,
                          child: Image.asset(
                            'assets/images/victoire_$_victoryImageName.png',
                            fit: BoxFit.contain,
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
                              cycleCount: _confettiCycleCount,
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
  final int cycleCount;

  _ConfettiPainter({
    required this.animationValue,
    required this.color,
    required this.cycleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Utiliser une seed différente à chaque cycle pour varier la disposition
    final random = math.Random(42 + cycleCount);

    // Dessiner des têtes de Mickey multicolores
    for (int i = 0; i < 25; i++) {
      final offsetX = size.width * random.nextDouble();
      final startY = -50 - (random.nextDouble() * 150);

      // Vitesse différente pour chaque confetti (entre 0.7x et 1.4x)
      final speedFactor = 0.7 + (random.nextDouble() * 0.7);
      final currentY = startY + (size.height + 300) * animationValue * speedFactor;

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
