import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../domain/player.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';

/// Dialog de victoire de manche avec portrait du joueur
class RoundVictoryDialog extends StatefulWidget {
  const RoundVictoryDialog({
    required this.winner,
    required this.isMatchComplete,
    required this.winnerWins,
    required this.loserWins,
    required this.loserName,
    super.key,
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
    with TickerProviderStateMixin, DialogAnimationsMixin {
  late AnimationController _confettiController;

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
    initDialogAnimations();

    // Sélection aléatoire d'une couleur
    final random = math.Random();
    final colorKeys = _colorMap.keys.toList();
    _victoryImageName = colorKeys[random.nextInt(colorKeys.length)];
    _victoryColor = _colorMap[_victoryImageName]!;

    // Animation des confettis
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Incrémenter le compteur de cycles à chaque répétition
    _confettiController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _confettiCycleCount++;
        });
      }
    });

    HapticUtils.success();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    disposeDialogAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: _victoryColor,
        maxWidth: 400,
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
                              color: widget.winner.color.withValues(alpha: 0.4),
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
                              color: _victoryColor.withValues(alpha: 0.3),
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
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Nom du gagnant
                  Text(
                    widget.winner.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.winner.name}: ${widget.winnerWins}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                            ),
                            Text(
                              '${widget.loserName}: ${widget.loserWins}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bouton principal avec effet shimmer
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Le bouton
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

                        // Effet shimmer sur le bouton
                        Positioned.fill(
                          child: SimpleShimmerEffect(
                            animationValue: shimmerController.value,
                            borderRadius: 16,
                          ),
                        ),
                      ],
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

    // Dessiner des têtes de Mickey multicolores
    for (int i = 0; i < 25; i++) {
      // Seed unique pour chaque confetti basée sur le cycle et l'index
      // Utilisation d'une variation forte pour créer des patterns vraiment différents
      final confettiRandom = math.Random(42 + cycleCount * 1234 + i * 789 + (cycleCount * i * 37));

      final offsetX = size.width * confettiRandom.nextDouble();

      // Délai de départ pour chaque confetti (0.0 à 0.4 de l'animation)
      final startDelay = confettiRandom.nextDouble() * 0.4;

      // Temps effectif d'animation pour ce confetti
      final effectiveAnimation = (animationValue - startDelay).clamp(0.0, 1.0);

      // Position de départ
      final startY = -50 - (confettiRandom.nextDouble() * 200);

      // Vitesse différente pour chaque confetti (entre 1.1x et 1.6x)
      final speedFactor = 1.1 + (confettiRandom.nextDouble() * 0.5);
      // Distance totale augmentée pour garantir que tous les confettis sortent de l'écran
      final currentY = startY + (size.height + 700) * effectiveAnimation * speedFactor;

      // Calculer l'opacité avec fade in au départ et fade out à la fin
      double opacity = 0.8;

      // Fade in au début de l'animation de ce confetti
      if (effectiveAnimation < 0.1) {
        opacity = 0.8 * (effectiveAnimation / 0.1);
      }

      // Fade out seulement une fois en dehors de l'écran visible
      final fadeStart = size.height + 100;
      if (currentY > fadeStart) {
        final fadeEnd = size.height + 400;
        final fadeProgress = (currentY - fadeStart) / (fadeEnd - fadeStart);
        opacity *= (1.0 - fadeProgress.clamp(0.0, 1.0));
      }

      // Skip seulement si complètement transparent ou très loin en dehors
      if (opacity <= 0.0 || currentY > size.height + 500) continue;

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
      final mickeySize = 12 + (confettiRandom.nextDouble() * 8);
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
