import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';

/// Dialog pour saisir les notes et couleurs de deck après une victoire
class VictoryNotesDialog extends StatefulWidget {
  const VictoryNotesDialog({
    required this.winnerName,
    required this.loserName,
    required this.winnerColor,
    this.previousPlayer1DeckColors = const [],
    this.previousPlayer2DeckColors = const [],
    this.isPlayer1Winner = true,
    super.key,
  });

  final String winnerName;
  final String loserName;
  final Color winnerColor;
  final List<String> previousPlayer1DeckColors;
  final List<String> previousPlayer2DeckColors;
  final bool isPlayer1Winner;

  @override
  State<VictoryNotesDialog> createState() => _VictoryNotesDialogState();
}

class _VictoryNotesDialogState extends State<VictoryNotesDialog>
    with TickerProviderStateMixin, DialogAnimationsMixin {
  late TextEditingController _noteController;
  late List<String> _player1DeckColors;
  late List<String> _player2DeckColors;

  // Couleurs de deck Lorcana
  static const List<LorcanaDeckColor> _lorcanaColors = [
    LorcanaDeckColor(name: 'Ambre', color: Color(0xFFFFC107)),
    LorcanaDeckColor(name: 'Améthyste', color: Color(0xFF9C27B0)),
    LorcanaDeckColor(name: 'Émeraude', color: Color(0xFF4CAF50)),
    LorcanaDeckColor(name: 'Rubis', color: Color(0xFFE53935)),
    LorcanaDeckColor(name: 'Saphir', color: Color(0xFF2196F3)),
    LorcanaDeckColor(name: 'Acier', color: Color(0xFF9E9E9E)),
  ];

  @override
  void initState() {
    super.initState();
    initDialogAnimations();
    _noteController = TextEditingController();

    // Utiliser les couleurs précédentes si disponibles, sinon liste vide
    _player1DeckColors = List.from(widget.previousPlayer1DeckColors);
    _player2DeckColors = List.from(widget.previousPlayer2DeckColors);
  }

  @override
  void dispose() {
    _noteController.dispose();
    disposeDialogAnimations();
    super.dispose();
  }

  void _toggleColor(bool isPlayer1, String colorName) {
    setState(() {
      final colors = isPlayer1 ? _player1DeckColors : _player2DeckColors;

      if (colors.contains(colorName)) {
        colors.remove(colorName);
      } else if (colors.length < 2) {
        colors.add(colorName);
      } else {
        // Remplacer la première couleur
        colors[0] = colors[1];
        colors[1] = colorName;
      }
    });
    HapticUtils.light();
  }

  @override
  Widget build(BuildContext context) {
    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: widget.winnerColor,
        maxWidth: 500,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Titre
              Text(
                'Informations de la partie',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.winnerColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Victoire de ${widget.winnerName}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Champ de note
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Note de la partie',
                  hintText: 'Ex: Bonne partie, deck aggro efficace...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 24),

              // Couleurs du deck gagnant
              _buildDeckColorSection(
                title: 'Couleurs du deck de ${widget.winnerName}',
                selectedColors: widget.isPlayer1Winner ? _player1DeckColors : _player2DeckColors,
                onColorToggle: (color) => _toggleColor(widget.isPlayer1Winner, color),
              ),

              const SizedBox(height: 20),

              // Couleurs du deck perdant
              _buildDeckColorSection(
                title: 'Couleurs du deck de ${widget.loserName}',
                selectedColors: widget.isPlayer1Winner ? _player2DeckColors : _player1DeckColors,
                onColorToggle: (color) => _toggleColor(!widget.isPlayer1Winner, color),
              ),

              const SizedBox(height: 24),

              // Bouton de validation
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    HapticUtils.light();
                    Navigator.of(context).pop({
                      'note': _noteController.text.trim().isEmpty
                          ? null
                          : _noteController.text.trim(),
                      'player1DeckColors': _player1DeckColors,
                      'player2DeckColors': _player2DeckColors,
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.winnerColor,
                    foregroundColor: AppTheme.pureWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeckColorSection({
    required String title,
    required List<String> selectedColors,
    required Function(String) onColorToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sélectionnez 2 couleurs',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _lorcanaColors.map((lorcanaColor) {
            final isSelected = selectedColors.contains(lorcanaColor.name);
            return _ColorChip(
              color: lorcanaColor,
              isSelected: isSelected,
              onTap: () => onColorToggle(lorcanaColor.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final LorcanaDeckColor color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.color : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color.color : Colors.grey[300]!,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              color.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LorcanaDeckColor {
  final String name;
  final Color color;

  const LorcanaDeckColor({
    required this.name,
    required this.color,
  });
}
