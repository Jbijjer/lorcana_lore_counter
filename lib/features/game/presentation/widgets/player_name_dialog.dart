import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/player_history_service.dart';
import '../../../../core/utils/haptic_utils.dart';
import 'player_edit_dialog.dart';

/// Dialogue pour sélectionner ou créer un nom de joueur
class PlayerNameDialog extends ConsumerStatefulWidget {
  const PlayerNameDialog({
    super.key,
    required this.currentName,
    required this.playerColor,
    required this.backgroundColorStart,
    required this.backgroundColorEnd,
    required this.onBackgroundColorsChanged,
    this.onIconChanged,
  });

  final String currentName;
  final Color playerColor;
  final Color backgroundColorStart;
  final Color backgroundColorEnd;
  final Function(Color start, Color end) onBackgroundColorsChanged;
  final Function(int iconCodePoint)? onIconChanged;

  @override
  ConsumerState<PlayerNameDialog> createState() => _PlayerNameDialogState();
}

class _PlayerNameDialogState extends ConsumerState<PlayerNameDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _showTextField = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerNames = ref.watch(playerNamesProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: widget.playerColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Choisir un joueur',
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

            // Afficher soit la liste, soit le champ de texte
            if (_showTextField) ...[
              // Champ de saisie pour nouveau joueur
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Nom du joueur',
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
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                ),
                onSubmitted: (value) => _handleSave(value),
              ),

              const SizedBox(height: 12),

              // Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      HapticUtils.light();
                      setState(() {
                        _showTextField = false;
                        _controller.clear();
                      });
                    },
                    child: const Text('Retour'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => _handleSave(_controller.text),
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.playerColor,
                    ),
                    child: const Text('Confirmer'),
                  ),
                ],
              ),
            ] else ...[
              // Liste des joueurs existants
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Joueurs existants
                    ...playerNames.map((name) => _buildPlayerNameTile(name)),

                    // Divider
                    if (playerNames.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(),
                      ),

                    // Option "Nouveau joueur"
                    _buildNewPlayerTile(),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerNameTile(String name) {
    final isCurrentPlayer = name == widget.currentName;
    final service = ref.read(playerHistoryServiceProvider);
    final iconCodePoint = service.getPlayerIcon(name);

    return InkWell(
      onTap: () {
        HapticUtils.light();
        _handleSelectPlayer(name);
      },
      onLongPress: () {
        HapticUtils.medium();
        _showEditDialog(name);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isCurrentPlayer
                  ? widget.playerColor.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              child: Icon(
                iconCodePoint != null
                    ? IconData(iconCodePoint, fontFamily: 'MaterialIcons')
                    : Icons.person,
                color: isCurrentPlayer ? widget.playerColor : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: isCurrentPlayer ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentPlayer ? widget.playerColor : null,
                ),
              ),
            ),
            if (isCurrentPlayer)
              Icon(Icons.check_circle, color: widget.playerColor)
            else
              Icon(Icons.edit, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPlayerTile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.playerColor.withValues(alpha: 0.2),
        child: Icon(
          Icons.add,
          color: widget.playerColor,
        ),
      ),
      title: Text(
        'Nouveau joueur',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: widget.playerColor,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () {
        HapticUtils.light();
        setState(() {
          _showTextField = true;
        });
      },
    );
  }

  void _handleSelectPlayer(String name) {
    // Mettre à jour l'historique
    ref.read(playerHistoryServiceProvider).addOrUpdatePlayerName(name);
    // Retourner le nom sélectionné
    Navigator.of(context).pop(name);
  }

  void _handleSave(String name) {
    if (name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le nom ne peut pas être vide'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    HapticUtils.medium();
    // Ajouter à l'historique
    ref.read(playerHistoryServiceProvider).addOrUpdatePlayerName(name.trim());
    // Retourner le nom
    Navigator.of(context).pop(name.trim());
  }

  Future<void> _showEditDialog(String oldName) async {
    final service = ref.read(playerHistoryServiceProvider);
    final player = service.getPlayerByName(oldName);

    if (player == null) return;

    final (startColor, endColor) = service.getPlayerColors(oldName);
    final iconCodePoint = service.getPlayerIcon(oldName);

    await showDialog(
      context: context,
      builder: (context) => PlayerEditDialog(
        playerId: player.id!,
        playerName: oldName,
        playerColor: widget.playerColor,
        backgroundColorStart: startColor ?? widget.backgroundColorStart,
        backgroundColorEnd: endColor ?? widget.backgroundColorEnd,
        iconCodePoint: iconCodePoint ?? 0xe491, // Icons.person par défaut
        onPlayerUpdated: ({
          required String name,
          required Color backgroundColorStart,
          required Color backgroundColorEnd,
          required int iconCodePoint,
        }) {
          // Mettre à jour les couleurs et l'icône du joueur actuel si c'est le même
          if (name == widget.currentName || oldName == widget.currentName) {
            widget.onBackgroundColorsChanged(
              backgroundColorStart,
              backgroundColorEnd,
            );
            widget.onIconChanged?.call(iconCodePoint);
          }
          // Rafraîchir l'interface
          setState(() {});
        },
      ),
    );
  }
}
