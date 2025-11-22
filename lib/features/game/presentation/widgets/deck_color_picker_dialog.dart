import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';

/// Représente une couleur de deck Lorcana
class LorcanaDeckColor {
  final String name;
  final Color color;

  const LorcanaDeckColor({
    required this.name,
    required this.color,
  });
}

/// Couleurs de deck Lorcana disponibles
const List<LorcanaDeckColor> lorcanaColors = [
  LorcanaDeckColor(name: 'Ambre', color: Color(0xFFFFC107)),
  LorcanaDeckColor(name: 'Améthyste', color: Color(0xFF9C27B0)),
  LorcanaDeckColor(name: 'Émeraude', color: Color(0xFF4CAF50)),
  LorcanaDeckColor(name: 'Rubis', color: Color(0xFFE53935)),
  LorcanaDeckColor(name: 'Saphir', color: Color(0xFF2196F3)),
  LorcanaDeckColor(name: 'Acier', color: Color(0xFF9E9E9E)),
];

/// Dialogue stylé pour sélectionner une couleur de deck Lorcana
class DeckColorPickerDialog extends StatefulWidget {
  const DeckColorPickerDialog({
    required this.accentColor,
    required this.selectedColors,
    super.key,
  });

  /// Couleur d'accent pour le style du dialogue
  final Color accentColor;

  /// Couleurs déjà sélectionnées (pour afficher les checkmarks)
  final List<String> selectedColors;

  @override
  State<DeckColorPickerDialog> createState() => _DeckColorPickerDialogState();
}

class _DeckColorPickerDialogState extends State<DeckColorPickerDialog>
    with TickerProviderStateMixin, DialogAnimationsMixin {

  @override
  void initState() {
    super.initState();
    initDialogAnimations();
  }

  @override
  void dispose() {
    disposeDialogAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: widget.accentColor,
        maxWidth: 350,
        maxHeight: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête
            DialogHeader(
              icon: Icons.palette,
              title: 'Couleur du deck',
              accentColor: widget.accentColor,
              onClose: () => Navigator.of(context).pop(),
            ),

            const SizedBox(height: 16),

            // Grille de couleurs
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                itemCount: lorcanaColors.length,
                itemBuilder: (context, index) {
                  final lorcanaColor = lorcanaColors[index];
                  final isSelected = widget.selectedColors.contains(lorcanaColor.name);

                  return _buildColorItem(lorcanaColor, isSelected);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Bouton annuler
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.3),
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
                    vertical: 12,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.close,
                      size: 18,
                      color: widget.accentColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Annuler',
                      style: TextStyle(
                        color: widget.accentColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorItem(LorcanaDeckColor lorcanaColor, bool isSelected) {
    return InkWell(
      onTap: () {
        HapticUtils.light();
        Navigator.of(context).pop(lorcanaColor.name);
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: lorcanaColor.color,
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
        child: Stack(
          children: [
            // Checkmark si sélectionné
            if (isSelected)
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
                    color: lorcanaColor.color,
                  ),
                ),
              ),
            // Nom de la couleur
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.pureBlack.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    lorcanaColor.name,
                    style: const TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Sparkles si sélectionné
            if (isSelected)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildColorSparkles(lorcanaColor.color),
                ),
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
}
