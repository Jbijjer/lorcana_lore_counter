import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/player_history_service.dart';
import '../../domain/player.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/constants/player_icons.dart';

/// Dialog simplifié pour sélectionner un joueur et retourner un objet Player complet
class PlayerSelectionDialog extends ConsumerStatefulWidget {
  const PlayerSelectionDialog({
    super.key,
    required this.title,
    required this.defaultColor,
    this.excludedPlayerName,
  });

  final String title;
  final Color defaultColor;
  final String? excludedPlayerName;

  @override
  ConsumerState<PlayerSelectionDialog> createState() => _PlayerSelectionDialogState();
}

class _PlayerSelectionDialogState extends ConsumerState<PlayerSelectionDialog> {
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
                  color: widget.defaultColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: widget.defaultColor,
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
                      color: widget.defaultColor,
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
                onSubmitted: (value) => _handleCreatePlayer(value),
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
                    onPressed: () => _handleCreatePlayer(_controller.text),
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.defaultColor,
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
    final service = ref.read(playerHistoryServiceProvider);
    final iconAssetPath = service.getPlayerIcon(name);
    final isExcluded = widget.excludedPlayerName != null && name == widget.excludedPlayerName;

    return Opacity(
      opacity: isExcluded ? 0.4 : 1.0,
      child: InkWell(
        onTap: isExcluded ? null : () {
          HapticUtils.light();
          _handleSelectPlayer(name);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: widget.defaultColor.withOpacity(0.2),
                child: iconAssetPath != null
                    ? ClipOval(
                        child: Image.asset(
                          iconAssetPath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: widget.defaultColor,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              if (isExcluded) ...[
                const Icon(
                  Icons.block,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Déjà sélectionné',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewPlayerTile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.defaultColor.withOpacity(0.2),
        child: Icon(
          Icons.add,
          color: widget.defaultColor,
        ),
      ),
      title: Text(
        'Nouveau joueur',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: widget.defaultColor,
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
    final service = ref.read(playerHistoryServiceProvider);

    // Récupérer les couleurs sauvegardées
    final (savedStartColor, savedEndColor) = service.getPlayerColors(name);
    final iconAssetPath = service.getPlayerIcon(name);

    // Créer l'objet Player
    final player = Player.create(
      name: name,
      color: widget.defaultColor,
      backgroundColorStart: savedStartColor ?? widget.defaultColor,
      backgroundColorEnd: savedEndColor ?? widget.defaultColor,
      iconAssetPath: iconAssetPath ?? PlayerIcons.defaultIcon,
    );

    // Mettre à jour l'historique
    service.addOrUpdatePlayerName(name);

    // Retourner le joueur
    Navigator.of(context).pop(player);
  }

  void _handleCreatePlayer(String name) {
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

    final service = ref.read(playerHistoryServiceProvider);

    // Créer l'objet Player avec des valeurs par défaut
    final player = Player.create(
      name: name.trim(),
      color: widget.defaultColor,
      backgroundColorStart: widget.defaultColor,
      backgroundColorEnd: widget.defaultColor,
      iconAssetPath: PlayerIcons.defaultIcon,
    );

    // Ajouter à l'historique
    service.addOrUpdatePlayerName(name.trim());

    // Retourner le joueur
    Navigator.of(context).pop(player);
  }
}
