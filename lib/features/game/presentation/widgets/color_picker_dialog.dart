import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';

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
    with TickerProviderStateMixin, DialogAnimationsMixin {
  List<Color> _selectedColors = [];
  late AnimationController _colorSelectController;

  @override
  void initState() {
    super.initState();
    initDialogAnimations();

    // Initialiser avec les couleurs actuelles
    if (widget.currentColorStart == widget.currentColorEnd) {
      // Une seule couleur
      _selectedColors = [widget.currentColorStart];
    } else {
      // Deux couleurs (dégradé)
      _selectedColors = [widget.currentColorStart, widget.currentColorEnd];
    }

    // Animation pour la sélection de couleur
    _colorSelectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _colorSelectController.dispose();
    disposeDialogAnimations();
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

  /// Retourne le titre du dialogue selon le nombre de couleurs sélectionnées
  String _getDialogTitle() {
    switch (_selectedColors.length) {
      case 0:
        return '1ère couleur du deck';
      case 1:
        return '2e couleur du deck';
      default:
        return '2e couleur du deck';
    }
  }

  Widget _buildPreview() {
    return AnimatedBuilder(
      animation: shimmerController,
      builder: (context, child) {
        return Stack(
          children: [
            if (_selectedColors.isEmpty)
              // Aucune couleur sélectionnée - montrer un aperçu aléatoire avec gradient animé
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment(
                      -1.0 + (shimmerController.value * 2),
                      -1.0,
                    ),
                    end: Alignment(
                      1.0 + (shimmerController.value * 2),
                      1.0,
                    ),
                    colors: [
                      AppTheme.lorcanaColors[0].withValues(alpha: 0.3),
                      AppTheme.lorcanaColors[1].withValues(alpha: 0.3),
                      AppTheme.lorcanaColors[2].withValues(alpha: 0.3),
                      AppTheme.lorcanaColors[3].withValues(alpha: 0.3),
                      AppTheme.lorcanaColors[4].withValues(alpha: 0.3),
                      AppTheme.lorcanaColors[5].withValues(alpha: 0.3),
                    ],
                  ),
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
                      color: AppTheme.pureWhite.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: widget.playerColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shuffle,
                          size: 24,
                          color: widget.playerColor,
                        ),
                        const SizedBox(width: 8),
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
                      color: AppTheme.pureBlack.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Fond uni',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.pureWhite,
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
                      color: AppTheme.pureBlack.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Dégradé',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.pureWhite,
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
                      -200 + (shimmerController.value * 400),
                      0,
                    ),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppTheme.transparentColor,
                            AppTheme.pureWhite.withValues(alpha: 0.3),
                            AppTheme.transparentColor,
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
    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: widget.playerColor,
        maxWidth: 600,
        maxHeight: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête avec titre dynamique selon la sélection
            DialogHeader(
              icon: Icons.palette,
              title: _getDialogTitle(),
              accentColor: widget.playerColor,
              onClose: () => Navigator.of(context).pop(),
            ),

            const SizedBox(height: 16),

            // Aperçu avec shimmer
            _buildPreview(),

            const SizedBox(height: 16),

            // Info sur la sélection
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.playerColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.playerColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: widget.playerColor.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cochez 0, 1 ou 2 couleurs (${_selectedColors.length}/2)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: widget.playerColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
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
                              ? AppTheme.pureWhite
                              : AppTheme.pureBlack.withValues(alpha: 0.2),
                          width: isSelected ? 4 : 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.pureWhite.withValues(alpha: 0.6),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: AppTheme.pureBlack.withValues(alpha: 0.1),
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
                                      color: AppTheme.pureWhite,
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.playerColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      HapticUtils.light();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.close,
                          size: 18,
                          color: widget.playerColor.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Annuler',
                          style: TextStyle(
                            color: widget.playerColor.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildConfirmButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSparkles(Color color) {
    return AnimatedBuilder(
      animation: shimmerController,
      builder: (context, child) {
        return CustomPaint(
          painter: ContrastSparklesPainter(
            animationValue: shimmerController.value,
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
          backgroundColor: AppTheme.transparentColor,
          shadowColor: AppTheme.transparentColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: AppTheme.pureWhite),
            SizedBox(width: 8),
            Text(
              'Confirmer',
              style: TextStyle(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
