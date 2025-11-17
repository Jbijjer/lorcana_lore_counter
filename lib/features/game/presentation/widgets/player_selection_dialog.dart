import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/player_history_service.dart';
import '../../domain/player.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/constants/player_icons.dart';
import 'player_edit_dialog.dart';

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
  @override
  void dispose() {
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
              if (isExcluded)
                const Icon(
                  Icons.block,
                  color: Colors.red,
                  size: 20,
                ),
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
        _handleCreatePlayer();
      },
    );
  }

  Future<void> _handleSelectPlayer(String name) async {
    final service = ref.read(playerHistoryServiceProvider);

    // Mettre à jour l'historique et attendre que la sauvegarde soit terminée
    await service.addOrUpdatePlayerName(name);

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

    // Retourner le joueur
    if (mounted) {
      Navigator.of(context).pop(player);
    }
  }

  Future<void> _handleCreatePlayer() async {
    HapticUtils.medium();

    final service = ref.read(playerHistoryServiceProvider);

    // Générer un nom aléatoire Disney
    final randomName = service.generateRandomDisneyName();

    // Créer d'abord le joueur avec des valeurs aléatoires
    await service.addOrUpdatePlayerName(randomName);

    // Récupérer les valeurs aléatoires qui viennent d'être assignées
    final (randomStartColor, randomEndColor) = service.getPlayerColors(randomName);
    final randomIcon = service.getPlayerIcon(randomName);

    if (!mounted) return;

    // Ouvrir le dialog de personnalisation avec les valeurs aléatoires
    Color? selectedStartColor = randomStartColor ?? widget.defaultColor;
    Color? selectedEndColor = randomEndColor ?? widget.defaultColor;
    String? selectedIcon = randomIcon ?? PlayerIcons.defaultIcon;

    await showDialog(
      context: context,
      builder: (context) => PlayerEditDialog(
        playerId: service.getPlayerByName(randomName)?.id ?? '',
        playerName: randomName,
        playerColor: widget.defaultColor,
        backgroundColorStart: selectedStartColor,
        backgroundColorEnd: selectedEndColor,
        iconAssetPath: selectedIcon,
        onPlayerUpdated: ({
          required String name,
          required Color backgroundColorStart,
          required Color backgroundColorEnd,
          required String iconAssetPath,
        }) {
          selectedStartColor = backgroundColorStart;
          selectedEndColor = backgroundColorEnd;
          selectedIcon = iconAssetPath;
        },
      ),
    );

    // Si l'utilisateur a fermé le dialog sans valider, on ne crée pas le joueur
    if (!mounted) return;

    // Mettre à jour avec les valeurs personnalisées (si l'utilisateur a modifié)
    await service.updatePlayerColors(randomName, selectedStartColor!, selectedEndColor!);
    await service.updatePlayerIcon(randomName, selectedIcon!);

    // Créer l'objet Player avec les valeurs finales
    final player = Player.create(
      name: randomName,
      color: widget.defaultColor,
      backgroundColorStart: selectedStartColor!,
      backgroundColorEnd: selectedEndColor!,
      iconAssetPath: selectedIcon!,
    );

    if (!mounted) return;

    // Retourner le joueur
    Navigator.of(context).pop(player);
  }
}
