import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Options de réinitialisation disponibles
enum ResetOption {
  cancel,
  scores,
  round,
}

/// Dialog de confirmation pour réinitialiser la partie
class ResetConfirmationDialog extends StatefulWidget {
  const ResetConfirmationDialog({super.key});

  @override
  State<ResetConfirmationDialog> createState() =>
      _ResetConfirmationDialogState();
}

class _ResetConfirmationDialogState extends State<ResetConfirmationDialog>
    with TickerProviderStateMixin {
  late AnimationController _dialogAnimationController;
  late AnimationController _shimmerController;
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
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeIn,
    );

    // Animation shimmer pour les cartes
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _dialogAnimationController.forward();
  }

  @override
  void dispose() {
    _dialogAnimationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleSelection(ResetOption option) {
    HapticUtils.light();
    Navigator.of(context).pop(option);
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

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
                    color: errorColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // En-tête avec effet
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.restart_alt,
                          color: errorColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                errorColor,
                                errorColor.withValues(alpha: 0.6),
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            'Réinitialiser',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _handleSelection(ResetOption.cancel),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Question
                  Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Que voulez-vous réinitialiser ?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Options
                  _ResetOptionCard(
                    icon: Icons.refresh,
                    title: 'Réinitialiser Partie',
                    description: 'Remet les scores à 0 (garde les victoires)',
                    color: Colors.blue,
                    onTap: () => _handleSelection(ResetOption.scores),
                    shimmerController: _shimmerController,
                  ),
                  const SizedBox(height: 12),
                  _ResetOptionCard(
                    icon: Icons.replay_circle_filled,
                    title: 'Réinitialiser Round',
                    description: 'Remet tout à zéro (scores et victoires)',
                    color: Colors.orange,
                    onTap: () => _handleSelection(ResetOption.round),
                    shimmerController: _shimmerController,
                  ),

                  const SizedBox(height: 16),

                  // Bouton Annuler
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _handleSelection(ResetOption.cancel),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
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

/// Carte d'option de réinitialisation
class _ResetOptionCard extends StatefulWidget {
  const _ResetOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    required this.shimmerController,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final AnimationController shimmerController;

  @override
  State<_ResetOptionCard> createState() => _ResetOptionCardState();
}

class _ResetOptionCardState extends State<_ResetOptionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.color.withValues(alpha: _isHovered ? 0.15 : 0.08),
                  widget.color.withValues(alpha: _isHovered ? 0.08 : 0.04),
                ],
              ),
              border: Border.all(
                color: widget.color.withValues(alpha: _isHovered ? 0.6 : 0.3),
                width: _isHovered ? 3 : 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.2),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: widget.color,
                      size: 18,
                    ),
                  ],
                ),
                // Effet shimmer
                if (_isHovered)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: widget.shimmerController,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Transform.translate(
                            offset: Offset(
                              -200 + (widget.shimmerController.value * 400),
                              0,
                            ),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.4),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                // Particules scintillantes
                if (_isHovered)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: widget.shimmerController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _ResetSparklesPainter(
                            animationValue: widget.shimmerController.value,
                            color: widget.color,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Painter pour les particules scintillantes
class _ResetSparklesPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _ResetSparklesPainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Dessiner quelques étoiles scintillantes
    final random = math.Random(42); // Seed fixe pour cohérence
    for (int i = 0; i < 4; i++) {
      final x = size.width * random.nextDouble();
      final y = size.height * random.nextDouble();
      final sparklePhase = (animationValue + (i * 0.25)) % 1.0;
      final opacity = (math.sin(sparklePhase * math.pi * 2) + 1) / 2;

      paint.color = color.withValues(alpha: opacity * 0.7);

      // Dessiner une petite étoile
      canvas.drawCircle(Offset(x, y), 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(_ResetSparklesPainter oldDelegate) => true;
}
