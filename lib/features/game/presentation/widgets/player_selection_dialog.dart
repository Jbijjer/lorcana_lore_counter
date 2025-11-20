import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/player_history_service.dart';
import '../../domain/player.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/constants/player_icons.dart';
import '../../../../core/theme/app_theme.dart';
import 'player_edit_dialog.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';

/// Dialog simplifié pour sélectionner un joueur et retourner un objet Player complet
class PlayerSelectionDialog extends ConsumerStatefulWidget {
  const PlayerSelectionDialog({
    required this.title,
    required this.defaultColor,
    this.excludedPlayerName,
    super.key,
  });

  final String title;
  final Color defaultColor;
  final String? excludedPlayerName;

  @override
  ConsumerState<PlayerSelectionDialog> createState() =>
      _PlayerSelectionDialogState();
}

class _PlayerSelectionDialogState extends ConsumerState<PlayerSelectionDialog>
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
    final playerNames = ref.watch(playerNamesProvider);
    // Trier les noms par ordre alphabétique (insensible à la casse)
    final sortedPlayerNames = List<String>.from(playerNames)
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: widget.defaultColor,
        maxWidth: 450,
        maxHeight: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête
            DialogHeader(
              icon: Icons.person_search,
              title: widget.title,
              accentColor: widget.defaultColor,
              onClose: () => Navigator.of(context).pop(),
            ),

            const SizedBox(height: 20),

            // Liste des joueurs existants
            if (sortedPlayerNames.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Joueurs existants',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),

            if (sortedPlayerNames.isNotEmpty) const SizedBox(height: 12),

            // Liste scrollable (seulement les joueurs existants)
            if (sortedPlayerNames.isNotEmpty)
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Joueurs existants
                    ...sortedPlayerNames.map((name) => _buildPlayerNameTile(name)),
                  ],
                ),
              ),

            // Divider
            if (sortedPlayerNames.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ou',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),

            // Option "Nouveau joueur" (toujours visible)
            _buildNewPlayerTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerNameTile(String name) {
    final service = ref.read(playerHistoryServiceProvider);
    final iconAssetPath = service.getPlayerIcon(name);
    final isExcluded =
        widget.excludedPlayerName != null && name == widget.excludedPlayerName;

    return Opacity(
      opacity: isExcluded ? 0.4 : 1.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isExcluded
                ? null
                : () {
                    HapticUtils.light();
                    _handleSelectPlayer(name);
                  },
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.defaultColor.withValues(alpha: 0.05),
                        widget.defaultColor.withValues(alpha: 0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.defaultColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.defaultColor.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppTheme.pureBlack,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: iconAssetPath != null
                              ? Image.asset(
                                  iconAssetPath,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.person,
                                  color: widget.defaultColor,
                                  size: 24,
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      if (isExcluded)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.block,
                            color: Colors.red,
                            size: 20,
                          ),
                        )
                      else
                        Icon(
                          Icons.arrow_forward_ios,
                          color: widget.defaultColor,
                          size: 18,
                        ),
                    ],
                  ),
                ),
                // Effet shimmer sur tout le bouton
                if (!isExcluded)
                  Positioned.fill(
                    child: SimpleShimmerEffect(
                      animationValue: shimmerController.value,
                      borderRadius: 12,
                      alpha: 0.2,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewPlayerTile() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticUtils.light();
          _handleCreatePlayer();
        },
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.defaultColor.withValues(alpha: 0.15),
                    widget.defaultColor.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.defaultColor.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.defaultColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.defaultColor.withValues(alpha: 0.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_add,
                      color: widget.defaultColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Nouveau joueur',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: widget.defaultColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.add_circle,
                    color: widget.defaultColor,
                    size: 24,
                  ),
                ],
              ),
            ),
            // Effet shimmer sur tout le bouton
            Positioned.fill(
              child: SimpleShimmerEffect(
                animationValue: shimmerController.value,
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
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
    final random = math.Random();
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
    if (!mounted || !playerValidated) return;

    // MAINTENANT on crée le joueur dans la base de données
    await service.addOrUpdatePlayerName(selectedName);
    await service.updatePlayerColors(
        selectedName, selectedStartColor, selectedEndColor);
    await service.updatePlayerIcon(selectedName, selectedIcon);

    // Créer l'objet Player avec les valeurs finales
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
