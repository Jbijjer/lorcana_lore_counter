import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../domain/player.dart';
import '../../domain/game_state.dart';
import 'player_selection_dialog.dart';
import 'player_edit_dialog.dart';
import '../../data/player_history_service.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';

/// Dialog pour configurer une nouvelle partie en sélectionnant les deux joueurs
class GameSetupDialog extends ConsumerStatefulWidget {
  const GameSetupDialog({super.key});

  @override
  ConsumerState<GameSetupDialog> createState() => _GameSetupDialogState();
}

class _GameSetupDialogState extends ConsumerState<GameSetupDialog>
    with TickerProviderStateMixin, DialogAnimationsMixin {
  Player? _player1;
  Player? _player2;
  MatchFormat _selectedFormat = MatchFormat.bestOf3;

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

  /// Affiche le dialog de sélection pour un joueur
  Future<void> _selectPlayer(int playerNumber) async {
    // Exclure l'autre joueur de la liste
    final excludedPlayerName =
        playerNumber == 1 ? _player2?.name : _player1?.name;

    final player = await showDialog<Player>(
      context: context,
      builder: (context) => PlayerSelectionDialog(
        title: playerNumber == 1
            ? 'Sélectionner le Joueur 1'
            : 'Sélectionner le Joueur 2',
        defaultColor: playerNumber == 1
            ? AppTheme.amberColor
            : AppTheme.sapphireColor,
        excludedPlayerName: excludedPlayerName,
      ),
    );

    if (player != null && mounted) {
      HapticUtils.success();
      setState(() {
        if (playerNumber == 1) {
          _player1 = player;
        } else {
          _player2 = player;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canStart = _player1 != null &&
        _player2 != null &&
        _player1!.name != _player2!.name;

    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: AppTheme.amberColor,
        maxWidth: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // En-tête avec icône
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.amberColor.withValues(alpha: 0.2),
                        AppTheme.sapphireColor.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sports_esports,
                    color: AppTheme.amberColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [
                              AppTheme.amberColor,
                              AppTheme.sapphireColor,
                            ],
                          ).createShader(bounds);
                        },
                        child: Text(
                          'Nouvelle partie',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.pureWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sélectionnez les joueurs',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sélection Joueur 1
            _buildPlayerSelector(
              context,
              playerNumber: 1,
              player: _player1,
              label: 'Joueur 1',
              onTap: () => _selectPlayer(1),
            ),
            const SizedBox(height: 16),

            // Sélection Joueur 2
            _buildPlayerSelector(
              context,
              playerNumber: 2,
              player: _player2,
              label: 'Joueur 2',
              onTap: () => _selectPlayer(2),
            ),
            const SizedBox(height: 24),

            // Sélection du format de match
            _buildMatchFormatSelector(),
            const SizedBox(height: 24),

            // Bouton démarrer
            _buildStartButton(canStart),
            const SizedBox(height: 12),

            // Bouton annuler
            OutlinedButton(
              onPressed: () {
                HapticUtils.light();
                Navigator.of(context).pop(null);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Annuler',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerSelector(
    BuildContext context, {
    required int playerNumber,
    required Player? player,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = player != null;
    final accentColor =
        playerNumber == 1 ? AppTheme.amberColor : AppTheme.sapphireColor;

    return InkWell(
      onTap: () {
        HapticUtils.light();
        onTap();
      },
      onLongPress: isSelected
          ? () {
              HapticUtils.medium();
              _editPlayer(playerNumber);
            }
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        player.backgroundColorStart,
                        player.backgroundColorEnd,
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.surfaceContainerLowest,
                        Theme.of(context).colorScheme.surfaceContainer,
                      ],
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.5)
                    : Theme.of(context).colorScheme.outlineVariant,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Avatar du joueur
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppTheme.pureWhite.withValues(alpha: 0.2)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: Border.all(
                      color: AppTheme.pureBlack,
                      width: isSelected ? 3 : 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipOval(
                    child: isSelected
                        ? _buildPlayerAvatar(player)
                        : Icon(
                            Icons.person_add,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 28,
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Nom du joueur
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.pureWhite.withValues(alpha: 0.8)
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isSelected)
                        Stack(
                          children: [
                            // Outline noir
                            Text(
                              player.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 3
                                  ..color = Colors.black,
                              ),
                            ),
                            // Texte blanc
                            Text(
                              player.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.pureWhite,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Sélectionner un joueur',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),

                // Icône de sélection
                Icon(
                  isSelected ? Icons.check_circle : Icons.arrow_forward_ios,
                  color: isSelected ? Colors.greenAccent : accentColor,
                  size: isSelected ? 28 : 20,
                ),
              ],
            ),
          ),
          // Effet shimmer sur tout le bouton
          if (isSelected)
            SimpleShimmerEffect(
              animationValue: shimmerController.value,
              borderRadius: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildStartButton(bool canStart) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: canStart
            ? LinearGradient(
                colors: [
                  AppTheme.amberColor,
                  AppTheme.amberColor.withValues(alpha: 0.8),
                ],
              )
            : null,
        boxShadow: canStart
            ? [
                BoxShadow(
                  color: AppTheme.amberColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: canStart
            ? () {
                HapticUtils.success();
                Navigator.of(context).pop({
                  'player1': _player1!,
                  'player2': _player2!,
                  'matchFormat': _selectedFormat,
                });
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canStart ? AppTheme.transparentColor : Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: canStart ? AppTheme.pureBlack : Theme.of(context).colorScheme.onSurfaceVariant,
          shadowColor: AppTheme.transparentColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow,
              size: 24,
              color: canStart ? AppTheme.pureBlack : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Démarrer la partie',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: canStart ? AppTheme.pureBlack : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchFormatSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.sports_score,
              color: AppTheme.amberColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Format du match',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFormatButton(
                format: MatchFormat.bestOf1,
                label: 'Best of 1',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildFormatButton(
                format: MatchFormat.bestOf3,
                label: 'Best of 3',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildFormatButton(
                format: MatchFormat.bestOf5,
                label: 'Best of 5',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormatButton({
    required MatchFormat format,
    required String label,
  }) {
    final isSelected = _selectedFormat == format;

    return InkWell(
      onTap: () {
        HapticUtils.light();
        setState(() {
          _selectedFormat = format;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.amberColor,
                    AppTheme.amberColor.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.amberColor
                : Theme.of(context).colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.amberColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AppTheme.pureBlack : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerAvatar(Player player) {
    // Priorité au portrait personnalisé
    if (player.customPortraitPath != null && player.customPortraitPath!.isNotEmpty) {
      return Image.file(
        File(player.customPortraitPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback vers l'icône si le fichier n'existe plus
          return Image.asset(
            player.iconAssetPath,
            fit: BoxFit.cover,
          );
        },
      );
    }

    // Sinon, utiliser l'icône
    return Image.asset(
      player.iconAssetPath,
      fit: BoxFit.cover,
    );
  }

  /// Édite un joueur déjà sélectionné
  Future<void> _editPlayer(int playerNumber) async {
    HapticUtils.medium();

    final player = playerNumber == 1 ? _player1 : _player2;
    if (player == null) return;

    final service = ref.read(playerHistoryServiceProvider);

    // Variables pour stocker les nouvelles valeurs
    String? selectedName;
    Color? selectedStartColor;
    Color? selectedEndColor;
    String? selectedIcon;
    String? selectedCustomPortrait;
    bool playerValidated = false;

    // Ouvrir le dialog de personnalisation avec les valeurs actuelles
    await showDialog(
      context: context,
      builder: (context) => PlayerEditDialog(
        playerId: player.id,
        playerName: player.name,
        playerColor: playerNumber == 1 ? AppTheme.amberColor : AppTheme.sapphireColor,
        backgroundColorStart: player.backgroundColorStart,
        backgroundColorEnd: player.backgroundColorEnd,
        iconAssetPath: player.iconAssetPath,
        customPortraitPath: player.customPortraitPath,
        onPlayerUpdated: ({
          required String name,
          required Color backgroundColorStart,
          required Color backgroundColorEnd,
          required String iconAssetPath,
          String? customPortraitPath,
        }) {
          selectedName = name;
          selectedStartColor = backgroundColorStart;
          selectedEndColor = backgroundColorEnd;
          selectedIcon = iconAssetPath;
          selectedCustomPortrait = customPortraitPath;
          playerValidated = true;
        },
      ),
    );

    // Si l'utilisateur a annulé, on ne fait rien
    if (!mounted || !playerValidated) return;

    // Mettre à jour le joueur dans la base de données
    await service.addOrUpdatePlayerName(selectedName!);
    await service.updatePlayerColors(
        selectedName!, selectedStartColor!, selectedEndColor!);
    await service.updatePlayerIcon(selectedName!, selectedIcon!);
    await service.updatePlayerCustomPortrait(selectedName!, selectedCustomPortrait);

    // Créer l'objet Player mis à jour
    final updatedPlayer = Player.create(
      name: selectedName!,
      color: playerNumber == 1 ? AppTheme.amberColor : AppTheme.sapphireColor,
      backgroundColorStart: selectedStartColor!,
      backgroundColorEnd: selectedEndColor!,
      iconAssetPath: selectedIcon!,
      customPortraitPath: selectedCustomPortrait,
    );

    // Rafraîchir l'affichage
    if (mounted) {
      setState(() {
        if (playerNumber == 1) {
          _player1 = updatedPlayer;
        } else {
          _player2 = updatedPlayer;
        }
      });
    }
  }

}
