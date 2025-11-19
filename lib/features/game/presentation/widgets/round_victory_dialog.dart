import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();

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
    final victoryColor = widget.isMatchComplete ? Colors.amber : Colors.green;

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
                    color: victoryColor.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Confettis en arrière-plan
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _confettiController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _ConfettiPainter(
                            animationValue: _confettiController.value,
                            color: victoryColor,
                          ),
                        );
                      },
                    ),
                  ),

                  // Contenu principal
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Titre "GAGNANT"
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                victoryColor.withValues(alpha: 0.2),
                                victoryColor.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: victoryColor.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [
                                  victoryColor,
                                  victoryColor.withValues(alpha: 0.7),
                                ],
                              ).createShader(bounds);
                            },
                            child: Text(
                              widget.isMatchComplete
                                  ? '🏆 VICTOIRE DU MATCH 🏆'
                                  : '🎯 GAGNANT 🎯',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Portrait du joueur
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Halo de lumière
                            Container(
                              width: 140,
                              height: 140,
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
                              width: 120,
                              height: 120,
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
                                  color: widget.winner.color,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.winner.color
                                        .withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: SvgPicture.asset(
                                  widget.winner.iconAssetPath,
                                  width: 120,
                                  height: 120,
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
                                    width: 135,
                                    height: 135,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: SweepGradient(
                                        colors: [
                                          Colors.transparent,
                                          victoryColor.withValues(alpha: 0.5),
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
                                color: widget.winner.color,
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
                              backgroundColor: victoryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 8,
                              shadowColor: victoryColor.withValues(alpha: 0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.isMatchComplete
                                      ? Icons.refresh
                                      : Icons.arrow_forward,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  widget.isMatchComplete
                                      ? 'Nouvelle Partie'
                                      : 'Manche Suivante',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
  }
}

/// Painter pour les confettis
class _ConfettiPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _ConfettiPainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final random = math.Random(42);

    // Dessiner des confettis
    for (int i = 0; i < 30; i++) {
      final offsetX = size.width * random.nextDouble();
      final startY = -50 - (random.nextDouble() * 100);
      final currentY = startY + (size.height + 100) * animationValue;

      if (currentY > size.height) continue;

      // Couleurs variées
      final colors = [
        color,
        Colors.amber,
        Colors.blue,
        Colors.pink,
        Colors.purple,
      ];
      paint.color = colors[i % colors.length].withValues(alpha: 0.7);

      // Rotation
      final rotation = (animationValue + (i * 0.1)) * math.pi * 4;

      canvas.save();
      canvas.translate(offsetX, currentY);
      canvas.rotate(rotation);

      // Dessiner un rectangle comme confetti
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: 6 + (random.nextDouble() * 4),
        height: 12 + (random.nextDouble() * 8),
      );
      canvas.drawRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}
