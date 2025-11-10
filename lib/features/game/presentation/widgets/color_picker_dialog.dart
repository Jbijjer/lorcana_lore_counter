import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Dialogue pour sélectionner les couleurs de fond d'un joueur
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    super.key,
    required this.currentColorStart,
    required this.currentColorEnd,
    required this.playerColor,
  });

  final Color currentColorStart;
  final Color currentColorEnd;
  final Color playerColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _selectedColorStart;
  late Color _selectedColorEnd;
  bool _useGradient = false;

  @override
  void initState() {
    super.initState();
    _selectedColorStart = widget.currentColorStart;
    _selectedColorEnd = widget.currentColorEnd;
    _useGradient = widget.currentColorStart != widget.currentColorEnd;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre
            Row(
              children: [
                Icon(
                  Icons.brush,
                  color: widget.playerColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Couleur de fond',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: widget.playerColor,
                          fontWeight: FontWeight.bold,
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

            // Aperçu du dégradé
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _selectedColorStart.withOpacity(0.15),
                    _selectedColorEnd.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.playerColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  'Aperçu',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: widget.playerColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Option dégradé
            SwitchListTile(
              title: const Text('Utiliser un dégradé'),
              value: _useGradient,
              activeColor: widget.playerColor,
              onChanged: (value) {
                HapticUtils.light();
                setState(() {
                  _useGradient = value;
                  if (!value) {
                    _selectedColorEnd = _selectedColorStart;
                  }
                });
              },
            ),

            const SizedBox(height: 16),

            // Sélection couleur 1
            Text(
              _useGradient ? 'Première couleur' : 'Couleur',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildColorGrid(
              selectedColor: _selectedColorStart,
              onColorSelected: (color) {
                HapticUtils.light();
                setState(() {
                  _selectedColorStart = color;
                  if (!_useGradient) {
                    _selectedColorEnd = color;
                  }
                });
              },
            ),

            // Sélection couleur 2 (si dégradé)
            if (_useGradient) ...[
              const SizedBox(height: 20),
              Text(
                'Deuxième couleur',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              _buildColorGrid(
                selectedColor: _selectedColorEnd,
                onColorSelected: (color) {
                  HapticUtils.light();
                  setState(() {
                    _selectedColorEnd = color;
                  });
                },
              ),
            ],

            const SizedBox(height: 20),

            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    HapticUtils.light();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    HapticUtils.medium();
                    Navigator.of(context).pop({
                      'start': _selectedColorStart,
                      'end': _selectedColorEnd,
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.playerColor,
                  ),
                  child: const Text('Confirmer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorGrid({
    required Color selectedColor,
    required ValueChanged<Color> onColorSelected,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: AppTheme.lorcanaColors.length,
      itemBuilder: (context, index) {
        final color = AppTheme.lorcanaColors[index];
        final colorName = AppTheme.lorcanaColorNames[index];
        final isSelected = color.value == selectedColor.value;

        return InkWell(
          onTap: () => onColorSelected(color),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? widget.playerColor : color,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: widget.playerColor,
                    size: 24,
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  colorName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
