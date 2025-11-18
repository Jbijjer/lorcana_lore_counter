import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/player_history_service.dart';
import '../../domain/player.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/constants/player_icons.dart';
import '../../../../core/theme/app_theme.dart';
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
    // Trier les noms par ordre alphabétique (insensible à la casse)
    final sortedPlayerNames = List<String>.from(playerNames)
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

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
                  ...sortedPlayerNames.map((name) => _buildPlayerNameTile(name)),

                  // Divider
                  if (sortedPlayerNames.isNotEmpty)
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

    // Générer des valeurs aléatoires SANS créer le joueur
    final random = Random();
    final randomColorIndex = random.nextInt(AppTheme.lorcanaColors.length);
    final randomColor = AppTheme.lorcanaColors[randomColorIndex];
    final randomIconIndex = random.nextInt(PlayerIcons.availableIcons.length);
    final randomIcon = PlayerIcons.availableIcons[randomIconIndex].assetPath;

    if (!mounted) return;

    // Ouvrir le dialog de personnalisation avec les valeurs aléatoires
    Color selectedStartColor = randomColor;
    Color selectedEndColor = randomColor;
    String selectedIcon = randomIcon;
    String selectedName = randomName;
    bool playerValidated = false;

    await showDialog(
      context: context,
      builder: (context) => PlayerEditDialog(
        playerId: '', // ID vide car le joueur n'existe pas encore
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
          selectedName = name;
          selectedStartColor = backgroundColorStart;
          selectedEndColor = backgroundColorEnd;
          selectedIcon = iconAssetPath;
          playerValidated = true;
        },
      ),
    );

    // Si l'utilisateur a annulé, on ne fait rien
    // (Le joueur n'est créé que si l'utilisateur a validé dans PlayerEditDialog)
    if (!mounted || !playerValidated) return;

    // Créer l'objet Player avec les valeurs finales
    // (Le joueur a déjà été créé dans PlayerEditDialog._handleSave())
    final player = Player.create(
      name: selectedName,
      color: widget.defaultColor,
      backgroundColorStart: selectedStartColor,
      backgroundColorEnd: selectedEndColor,
      iconAssetPath: selectedIcon,
    );

    if (!mounted) return;

    // Retourner le joueur
    Navigator.of(context).pop(player);
  }
}
