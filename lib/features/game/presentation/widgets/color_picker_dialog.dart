import 'dart:math';
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
  List<Color> _selectedColors = [];

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
  }

  Widget _buildPreview() {
    if (_selectedColors.isEmpty) {
      // Aucune couleur sélectionnée - montrer un aperçu aléatoire
      return Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.playerColor.withOpacity(0.3),
            width: 2,
          ),
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
      );
    } else if (_selectedColors.length == 1) {
      // Une seule couleur - fond uni
      return Container(
        height: 100,
        decoration: BoxDecoration(
          color: _selectedColors[0].withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.playerColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            'Fond uni',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: widget.playerColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      );
    } else {
      // Deux couleurs - dégradé
      return Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _selectedColors[0].withOpacity(0.6),
              _selectedColors[1].withOpacity(0.4),
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
            'Dégradé',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: widget.playerColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      );
    }
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

            // Aperçu
            _buildPreview(),

            const SizedBox(height: 16),

            // Info sur la sélection
            Text(
              'Cochez 0, 1 ou 2 couleurs (${_selectedColors.length}/2)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.center,
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.white : color.withOpacity(0.3),
                          width: isSelected ? 4 : 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),

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

                    // Gérer les cas
                    Color startColor;
                    Color endColor;

                    if (_selectedColors.isEmpty) {
                      // Couleur aléatoire
                      final random = Random();
                      final randomColor = AppTheme.lorcanaColors[random.nextInt(AppTheme.lorcanaColors.length)];
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
}
