import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../domain/player.dart';
import 'player_selection_dialog.dart';

/// Dialog pour configurer une nouvelle partie en sélectionnant les deux joueurs
class GameSetupDialog extends ConsumerStatefulWidget {
  const GameSetupDialog({super.key});

  @override
  ConsumerState<GameSetupDialog> createState() => _GameSetupDialogState();
}

class _GameSetupDialogState extends ConsumerState<GameSetupDialog>
    with TickerProviderStateMixin {
  Player? _player1;
  Player? _player2;
  late AnimationController _dialogAnimationController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation d'entrée du dialog
    _dialogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.elasticOut,
    );

    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeIn,
    );

    // Animation shimmer
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _dialogAnimationController.forward();
  }

  @override
  void dispose() {
    _dialogAnimationController.dispose();
    _shimmerController.dispose();
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.amberColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
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
                          child: Icon(
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
                                  return LinearGradient(
                                    colors: [
                                      AppTheme.amberColor,
                                      AppTheme.sapphireColor,
                                    ],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'Nouvelle partie',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Sélectionnez les joueurs',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
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

                    // Bouton démarrer
                    _buildStartButton(canStart),
                  ],
                ),
              ),
            ),
          ),
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
      child: AnimatedContainer(
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
        child: Stack(
          children: [
            Row(
              children: [
                // Avatar du joueur
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.black,
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
                              ? Colors.white.withValues(alpha: 0.8)
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
                                color: Colors.white,
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
            // Effet shimmer pour joueur sélectionné
            if (isSelected)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Transform.translate(
                        offset: Offset(
                          -200 + (_shimmerController.value * 400),
                          0,
                        ),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(bool canStart) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
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
                Navigator.of(context).pop((_player1!, _player2!));
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canStart ? Colors.transparent : Colors.grey.shade300,
          foregroundColor: canStart ? Colors.black : Colors.grey.shade600,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
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
}
