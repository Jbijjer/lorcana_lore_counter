import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/player_history_service.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/constants/player_icons.dart';
import '../../../../core/theme/app_theme.dart';
import 'player_edit_dialog.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';

/// Dialogue pour sélectionner ou créer un nom de joueur
class PlayerNameDialog extends ConsumerStatefulWidget {
  const PlayerNameDialog({
    required this.currentName,
    required this.playerColor,
    required this.backgroundColorStart,
    required this.backgroundColorEnd,
    required this.onBackgroundColorsChanged,
    this.onIconChanged,
    this.onNameChanged,
    this.excludedPlayerName,
    super.key,
  });

  final String currentName;
  final Color playerColor;
  final Color backgroundColorStart;
  final Color backgroundColorEnd;
  final Function(Color start, Color end) onBackgroundColorsChanged;
  final Function(String iconAssetPath)? onIconChanged;
  final Function(String newName)? onNameChanged;
  final String? excludedPlayerName;

  @override
  ConsumerState<PlayerNameDialog> createState() => _PlayerNameDialogState();
}

class _PlayerNameDialogState extends ConsumerState<PlayerNameDialog>
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
        accentColor: widget.playerColor,
        maxWidth: 450,
        maxHeight: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête
            DialogHeader(
              icon: Icons.person_search,
              title: 'Choisir un joueur',
              accentColor: widget.playerColor,
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Joueurs existants',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    'Maintenez pour éditer',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
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
                        color: Theme.of(context).colorScheme.outlineVariant,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ou',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.outlineVariant,
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
    final isCurrentPlayer = name == widget.currentName;
    final isExcluded =
        widget.excludedPlayerName != null && name == widget.excludedPlayerName;
    final service = ref.read(playerHistoryServiceProvider);
    final iconAssetPath = service.getPlayerIcon(name);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
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
          onLongPress: isExcluded
              ? null
              : () {
                  HapticUtils.medium();
                  _showEditDialog(name);
                },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isExcluded
                    ? [
                        colorScheme.surfaceContainerHighest,
                        colorScheme.surfaceContainer,
                      ]
                    : isCurrentPlayer
                        ? [
                            widget.playerColor.withValues(alpha: 0.15),
                            widget.playerColor.withValues(alpha: 0.08),
                          ]
                        : [
                            widget.playerColor.withValues(alpha: 0.05),
                            widget.playerColor.withValues(alpha: 0.02),
                          ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isExcluded
                    ? colorScheme.outlineVariant
                    : isCurrentPlayer
                        ? widget.playerColor.withValues(alpha: 0.4)
                        : widget.playerColor.withValues(alpha: 0.2),
                width: isCurrentPlayer ? 2 : 1,
              ),
              boxShadow: isCurrentPlayer
                  ? [
                      BoxShadow(
                        color: widget.playerColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isExcluded
                        ? colorScheme.surfaceContainerHighest
                        : isCurrentPlayer
                            ? widget.playerColor.withValues(alpha: 0.2)
                            : widget.playerColor.withValues(alpha: 0.1),
                    border: Border.all(
                      color: isExcluded
                          ? colorScheme.outlineVariant
                          : colorScheme.outline,
                      width: isCurrentPlayer ? 3 : 2,
                    ),
                    boxShadow: isCurrentPlayer
                        ? [
                            BoxShadow(
                              color: widget.playerColor.withValues(alpha: 0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipOval(
                    child: iconAssetPath != null
                        ? ColorFiltered(
                            colorFilter: isExcluded
                                ? const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.saturation,
                                  )
                                : const ColorFilter.mode(
                                    Colors.transparent,
                                    BlendMode.multiply,
                                  ),
                            child: Image.asset(
                              iconAssetPath,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            color: isExcluded
                                ? colorScheme.onSurfaceVariant
                                : widget.playerColor,
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight:
                          isCurrentPlayer ? FontWeight.bold : FontWeight.w600,
                      fontSize: 16,
                      color: isExcluded
                          ? colorScheme.onSurfaceVariant
                          : isCurrentPlayer
                              ? widget.playerColor
                              : colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isExcluded)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.block,
                      color: colorScheme.onErrorContainer,
                      size: 20,
                    ),
                  )
                else if (isCurrentPlayer)
                  Icon(
                    Icons.check_circle,
                    color: widget.playerColor,
                    size: 24,
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: widget.playerColor,
                    size: 18,
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
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.playerColor.withValues(alpha: 0.15),
                widget.playerColor.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.playerColor.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.playerColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.playerColor.withValues(alpha: 0.2),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_add,
                  color: widget.playerColor,
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
                    color: widget.playerColor,
                  ),
                ),
              ),
              Icon(
                Icons.add_circle,
                color: widget.playerColor,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSelectPlayer(String name) async {
    // Mettre à jour l'historique et attendre que la sauvegarde soit terminée
    await ref.read(playerHistoryServiceProvider).addOrUpdatePlayerName(name);
    // Retourner le nom sélectionné
    if (mounted) {
      Navigator.of(context).pop(name);
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

    // Variables pour stocker les valeurs finales
    String? finalName;
    Color? finalStartColor;
    Color? finalEndColor;
    String? finalIcon;

    // Ouvrir le dialog d'édition avec les valeurs aléatoires
    await showDialog(
      context: context,
      builder: (context) => PlayerEditDialog(
        playerId: '', // ID vide car le joueur n'existe pas encore
        playerName: randomName,
        playerColor: widget.playerColor,
        backgroundColorStart: randomColor,
        backgroundColorEnd: randomColor,
        iconAssetPath: randomIcon,
        onPlayerUpdated: ({
          required String name,
          required Color backgroundColorStart,
          required Color backgroundColorEnd,
          required String iconAssetPath,
        }) {
          // Stocker les valeurs finales
          finalName = name;
          finalStartColor = backgroundColorStart;
          finalEndColor = backgroundColorEnd;
          finalIcon = iconAssetPath;
        },
      ),
    );

    // Si l'utilisateur a annulé, ne rien faire
    if (!mounted || finalName == null) return;

    // MAINTENANT on crée le joueur dans la base de données
    await service.addOrUpdatePlayerName(finalName!);
    await service.updatePlayerColors(
        finalName!, finalStartColor!, finalEndColor!);
    await service.updatePlayerIcon(finalName!, finalIcon!);

    // Mettre à jour les couleurs et l'icône du joueur actuel si c'est le même
    if (finalName == widget.currentName) {
      widget.onBackgroundColorsChanged(
        finalStartColor!,
        finalEndColor!,
      );
      widget.onIconChanged?.call(finalIcon!);
    }
    // Invalider le provider pour rafraîchir la liste des joueurs
    ref.invalidate(playerNamesProvider);

    // Retourner le nom final
    if (mounted) {
      Navigator.of(context).pop(finalName);
    }
  }

  Future<void> _showEditDialog(String oldName) async {
    final service = ref.read(playerHistoryServiceProvider);
    final player = service.getPlayerByName(oldName);

    if (player == null) return;

    final (startColor, endColor) = service.getPlayerColors(oldName);
    final iconAssetPath = service.getPlayerIcon(oldName);

    await showDialog(
      context: context,
      builder: (context) => PlayerEditDialog(
        playerId: player.id!,
        playerName: oldName,
        playerColor: widget.playerColor,
        backgroundColorStart: startColor ?? widget.backgroundColorStart,
        backgroundColorEnd: endColor ?? widget.backgroundColorEnd,
        iconAssetPath:
            iconAssetPath ?? 'assets/images/player_icons/mickey_icon.png',
        onPlayerUpdated: ({
          required String name,
          required Color backgroundColorStart,
          required Color backgroundColorEnd,
          required String iconAssetPath,
        }) {
          // Mettre à jour les couleurs, l'icône et le nom du joueur actuel si c'est le même
          if (oldName == widget.currentName) {
            widget.onBackgroundColorsChanged(
              backgroundColorStart,
              backgroundColorEnd,
            );
            widget.onIconChanged?.call(iconAssetPath);
            // Si le nom a changé, le signaler
            if (name != oldName) {
              widget.onNameChanged?.call(name);
            }
          }
          // Invalider le provider pour rafraîchir la liste des joueurs
          ref.invalidate(playerNamesProvider);
          // Rafraîchir l'interface
          setState(() {});
        },
      ),
    );
  }
}
