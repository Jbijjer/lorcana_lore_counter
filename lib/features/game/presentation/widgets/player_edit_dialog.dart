import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/player_history_service.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/constants/player_icons.dart';
import 'color_picker_dialog.dart';

/// Dialogue pour éditer un joueur existant
class PlayerEditDialog extends ConsumerStatefulWidget {
  const PlayerEditDialog({
    super.key,
    required this.playerId,
    required this.playerName,
    required this.playerColor,
    required this.backgroundColorStart,
    required this.backgroundColorEnd,
    required this.iconCodePoint,
    required this.onPlayerUpdated,
  });

  final String playerId;
  final String playerName;
  final Color playerColor;
  final Color backgroundColorStart;
  final Color backgroundColorEnd;
  final int iconCodePoint;
  final Function({
    required String name,
    required Color backgroundColorStart,
    required Color backgroundColorEnd,
    required int iconCodePoint,
  }) onPlayerUpdated;

  @override
  ConsumerState<PlayerEditDialog> createState() => _PlayerEditDialogState();
}

class _PlayerEditDialogState extends ConsumerState<PlayerEditDialog> {
  late TextEditingController _nameController;
  late Color _backgroundColorStart;
  late Color _backgroundColorEnd;
  late int _selectedIconCodePoint;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.playerName);
    _backgroundColorStart = widget.backgroundColorStart;
    _backgroundColorEnd = widget.backgroundColorEnd;
    _selectedIconCodePoint = widget.iconCodePoint;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700, maxWidth: 550),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // En-tête
            Row(
              children: [
                Icon(
                  Icons.edit,
                  color: widget.playerColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Éditer le joueur',
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

            const SizedBox(height: 24),

            // Aperçu du joueur
            _buildPlayerPreview(),

            const SizedBox(height: 24),

            // Champ de saisie du nom
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom du joueur',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: widget.playerColor,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sélection de l'icône
            Text(
              'Portrait',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildIconSelector(),

            const SizedBox(height: 24),

            // Bouton pour changer les couleurs de fond
            OutlinedButton.icon(
              onPressed: _showColorPicker,
              icon: Icon(Icons.palette, color: widget.playerColor),
              label: const Text('Modifier les couleurs de fond'),
              style: OutlinedButton.styleFrom(
                foregroundColor: widget.playerColor,
                side: BorderSide(color: widget.playerColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            const SizedBox(height: 24),

            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _handleSave,
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.playerColor,
                  ),
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildPlayerPreview() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _backgroundColorStart.withValues(alpha: 0.6),
            _backgroundColorEnd.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar avec l'icône sélectionnée
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: widget.playerColor.withValues(alpha: 0.3),
                child: Icon(
                  IconData(_selectedIconCodePoint, fontFamily: 'MaterialIcons'),
                  color: widget.playerColor,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Nom du joueur
            Stack(
              children: [
                // Outline noir
                Text(
                  _nameController.text.isNotEmpty
                      ? _nameController.text
                      : 'Joueur',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = Colors.black,
                  ),
                ),
                // Texte blanc
                Text(
                  _nameController.text.isNotEmpty
                      ? _nameController.text
                      : 'Joueur',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSelector() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: PlayerIcons.availableIcons.length,
        itemBuilder: (context, index) {
          final playerIcon = PlayerIcons.availableIcons[index];
          final isSelected =
              playerIcon.iconData.codePoint == _selectedIconCodePoint;

          return Tooltip(
            message: playerIcon.label,
            child: InkWell(
              onTap: () {
                HapticUtils.light();
                setState(() {
                  _selectedIconCodePoint = playerIcon.iconData.codePoint;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? widget.playerColor.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? widget.playerColor
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Icon(
                  playerIcon.iconData,
                  color: isSelected ? widget.playerColor : Colors.grey.shade600,
                  size: 28,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showColorPicker() async {
    HapticUtils.light();
    final result = await showDialog<Map<String, Color>>(
      context: context,
      builder: (context) => ColorPickerDialog(
        currentColorStart: _backgroundColorStart,
        currentColorEnd: _backgroundColorEnd,
        playerColor: widget.playerColor,
      ),
    );

    if (result != null) {
      setState(() {
        _backgroundColorStart = result['start']!;
        _backgroundColorEnd = result['end']!;
      });
    }
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le nom ne peut pas être vide'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    HapticUtils.medium();

    print('💾 PlayerEditDialog._handleSave:');
    print('  playerId: ${widget.playerId}');
    print('  oldName: ${widget.playerName}');
    print('  newName: $name');

    // Mettre à jour le joueur par ID (permet le renommage)
    final service = ref.read(playerHistoryServiceProvider);
    await service.updatePlayerById(
      id: widget.playerId,
      oldName: widget.playerName,
      newName: name,
      backgroundColorStart: _backgroundColorStart,
      backgroundColorEnd: _backgroundColorEnd,
      iconCodePoint: _selectedIconCodePoint,
    );

    print('  ✅ updatePlayerById completed');

    // Callback avec les nouvelles données
    widget.onPlayerUpdated(
      name: name,
      backgroundColorStart: _backgroundColorStart,
      backgroundColorEnd: _backgroundColorEnd,
      iconCodePoint: _selectedIconCodePoint,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
