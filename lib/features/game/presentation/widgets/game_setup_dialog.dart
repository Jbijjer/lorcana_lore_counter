import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../domain/player.dart';
import '../../domain/game_state.dart';
import 'player_selection_dialog.dart';
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
  int? _firstToPlay; // 1 pour joueur 1, 2 pour joueur 2, null si non défini

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
                              color: Colors.grey[700],
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

            // Sélection de qui commence
            _buildFirstToPlaySelector(),
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
                  color: Colors.grey.shade400,
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
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Annuler',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
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
                        Colors.grey.shade100,
                        Colors.grey.shade200,
                      ],
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.5)
                    : Colors.grey.shade300,
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
                        : Colors.grey.shade300,
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
                        ? Image.asset(
                            player.iconAssetPath,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.person_add,
                            color: Colors.grey.shade600,
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
                              : Colors.grey[600],
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
                            color: Colors.grey[800],
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
                  'firstToPlay': _firstToPlay,
                });
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canStart ? AppTheme.transparentColor : Colors.grey.shade300,
          foregroundColor: canStart ? AppTheme.pureBlack : Colors.grey.shade600,
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
              color: canStart ? Colors.black : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              'Démarrer la partie',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: canStart ? Colors.black : Colors.grey.shade600,
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
                color: Colors.grey[700],
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
          color: isSelected ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.amberColor
                : Colors.grey.shade300,
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
            color: isSelected ? Colors.black : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstToPlaySelector() {
    final hasPlayers = _player1 != null && _player2 != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.flag,
              color: AppTheme.amberColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Qui commence ?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFirstToPlayButton(
                playerNumber: 1,
                player: _player1,
                enabled: hasPlayers,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildFirstToPlayButton(
                playerNumber: 2,
                player: _player2,
                enabled: hasPlayers,
              ),
            ),
          ],
        ),
        if (!hasPlayers)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Sélectionnez les joueurs pour choisir qui commence',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[500],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFirstToPlayButton({
    required int playerNumber,
    required Player? player,
    required bool enabled,
  }) {
    final isSelected = _firstToPlay == playerNumber;
    final hasPlayer = player != null;
    final accentColor =
        playerNumber == 1 ? AppTheme.amberColor : AppTheme.sapphireColor;

    return InkWell(
      onTap: enabled && hasPlayer
          ? () {
              HapticUtils.light();
              setState(() {
                // Si déjà sélectionné, désélectionner
                if (_firstToPlay == playerNumber) {
                  _firstToPlay = null;
                } else {
                  _firstToPlay = playerNumber;
                }
              });
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          gradient: isSelected && hasPlayer
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor,
                    accentColor.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected || !hasPlayer ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected && hasPlayer
                ? accentColor
                : hasPlayer
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected && hasPlayer
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasPlayer) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    player.iconAssetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                hasPlayer ? player.name : 'Joueur $playerNumber',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected && hasPlayer
                      ? Colors.white
                      : hasPlayer
                          ? Colors.grey[700]
                          : Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
