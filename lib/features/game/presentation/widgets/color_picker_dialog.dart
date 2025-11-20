import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Dialogue pour sélectionner les couleurs de fond d'un joueur
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    required this.currentColorStart,
    required this.currentColorEnd,
    required this.playerColor,
    super.key,
  });

  final Color currentColorStart;
  final Color currentColorEnd;
  final Color playerColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog>
    with TickerProviderStateMixin {
  List<Color> _selectedColors = [];
  late AnimationController _dialogAnimationController;
  late AnimationController _shimmerController;
  late AnimationController _colorSelectController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialiser avec les couleurs actuelles
    if (widget.currentColorStart == widget.currentColorEnd) {
      // Une seule couleur
      _selectedColors = [widget.currentColorStart];
    } else {
      // Deux couleurs (dégradé)
      _selectedColors = [widget.currentColorStart, widget.currentColorEnd];
    }

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

    // Animation shimmer pour l'aperçu
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Animation pour la sélection de couleur
    _colorSelectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _dialogAnimationController.forward();
  }

  @override
  void dispose() {
    _dialogAnimationController.dispose();
    _shimmerController.dispose();
    _colorSelectController.dispose();
    super.dispose();
  }

  void _toggleColor(Color color) {
    setState(() {
      if (_selectedColors.contains(color)) {
        // Décocher la couleur
        _selectedColors.remove(color);
      } else {
        // Cocher la couleur
        if (_selectedColors.length >= 2) {
          // Décocher la première couleur pour respecter la limite de 2
          _selectedColors.removeAt(0);
        }
        _selectedColors.add(color);
      }
    });
    // Animation de bounce lors de la sélection
    _colorSelectController.forward(from: 0.0);
  }

  Widget _buildPreview() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Stack(
          children: [
            if (_selectedColors.isEmpty)
              // Aucune couleur sélectionnée - montrer un aperçu aléatoire
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.playerColor.withValues(alpha: 0.5),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.playerColor.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shuffle,
                        size: 32,
                        color: widget.playerColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Couleur aléatoire',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: widget.playerColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_selectedColors.length == 1)
              // Une seule couleur - fond uni
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: _selectedColors[0],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.playerColor.withValues(alpha: 0.5),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.playerColor.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Fond uni',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              )
            else
              // Deux couleurs - dégradé
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _selectedColors,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.playerColor.withValues(alpha: 0.5),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.playerColor.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Dégradé',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            // Effet shimmer
            if (_selectedColors.isNotEmpty)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Transform.translate(
                    offset: Offset(
                      -200 + (_shimmerController.value * 400),
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
                            Colors.white.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
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
              constraints: const BoxConstraints(maxHeight: 600),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.playerColor.withValues(alpha: 0.3),
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
                          color: widget.playerColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.palette,
                          color: widget.playerColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                widget.playerColor,
                                widget.playerColor.withValues(alpha: 0.6),
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            'Couleur de fond',
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Aperçu avec shimmer
                  _buildPreview(),

                  const SizedBox(height: 16),

                  // Info sur la sélection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Cochez 0, 1 ou 2 couleurs (${_selectedColors.length}/2)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Grille de couleurs avec rectangles
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: AppTheme.lorcanaColors.length,
                      itemBuilder: (context, index) {
                        final color = AppTheme.lorcanaColors[index];
                        final isSelected = _selectedColors.contains(color);

                        return InkWell(
                          onTap: () {
                            HapticUtils.light();
                            _toggleColor(color);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black.withValues(alpha: 0.2),
                                width: isSelected ? 4 : 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.white.withValues(alpha: 0.6),
                                        blurRadius: 12,
                                        spreadRadius: 3,
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: isSelected
                                ? Stack(
                                    children: [
                                      // Checkmark
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 16,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                      // Particules scintillantes
                                      Positioned.fill(
                                        child: _buildColorSparkles(color),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Boutons d'action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          HapticUtils.light();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildConfirmButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorSparkles(Color color) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return CustomPaint(
          painter: _ColorSparklesPainter(
            animationValue: _shimmerController.value,
            baseColor: color,
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            widget.playerColor,
            widget.playerColor.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.playerColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticUtils.medium();

          // Gérer les cas
          Color startColor;
          Color endColor;

          if (_selectedColors.isEmpty) {
            // Couleur aléatoire
            final random = math.Random();
            final randomColor = AppTheme
                .lorcanaColors[random.nextInt(AppTheme.lorcanaColors.length)];
            startColor = randomColor;
            endColor = randomColor;
          } else if (_selectedColors.length == 1) {
            // Fond uni
            startColor = _selectedColors[0];
            endColor = _selectedColors[0];
          } else {
            // Dégradé
            startColor = _selectedColors[0];
            endColor = _selectedColors[1];
          }

          Navigator.of(context).pop({
            'start': startColor,
            'end': endColor,
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Confirmer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter pour les particules scintillantes sur les couleurs sélectionnées
class _ColorSparklesPainter extends CustomPainter {
  final double animationValue;
  final Color baseColor;

  _ColorSparklesPainter({
    required this.animationValue,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculer une couleur contrastante pour les particules
    final brightness = baseColor.computeLuminance();
    final sparkleColor = brightness > 0.5 ? Colors.black : Colors.white;

    final paint = Paint()
      ..color = sparkleColor.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Dessiner quelques étoiles scintillantes
    final random = math.Random(42); // Seed fixe pour cohérence
    for (int i = 0; i < 3; i++) {
      final x = size.width * random.nextDouble();
      final y = size.height * random.nextDouble();
      final sparklePhase = (animationValue + (i * 0.3)) % 1.0;
      final opacity = (math.sin(sparklePhase * math.pi * 2) + 1) / 2;

      paint.color = sparkleColor.withValues(alpha: opacity * 0.8);

      // Dessiner une petite étoile
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(_ColorSparklesPainter oldDelegate) => true;
}
