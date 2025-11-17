import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/player.dart';
import 'player_selection_dialog.dart';

/// Dialog pour configurer une nouvelle partie en sélectionnant les deux joueurs
class GameSetupDialog extends ConsumerStatefulWidget {
  const GameSetupDialog({super.key});

  @override
  ConsumerState<GameSetupDialog> createState() => _GameSetupDialogState();
}

class _GameSetupDialogState extends ConsumerState<GameSetupDialog> {
  Player? _player1;
  Player? _player2;

  /// Affiche le dialog de sélection pour un joueur
  Future<void> _selectPlayer(int playerNumber) async {
    final player = await showDialog<Player>(
      context: context,
      builder: (context) => PlayerSelectionDialog(
        title: playerNumber == 1 ? 'Sélectionner le Joueur 1' : 'Sélectionner le Joueur 2',
        defaultColor: playerNumber == 1 ? AppTheme.amberColor : AppTheme.sapphireColor,
      ),
    );

    if (player != null && mounted) {
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
    final canStart = _player1 != null && _player2 != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.amberColor.withOpacity(0.2),
              AppTheme.sapphireColor.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Titre
                  Text(
                    'Nouvelle partie',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sélectionnez les joueurs',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 32),

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
                  const SizedBox(height: 32),

                  // Bouton démarrer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: canStart
                          ? () => Navigator.of(context).pop((_player1!, _player2!))
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.amberColor,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade800,
                        disabledForegroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Démarrer la partie',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: player != null
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
                    Colors.grey.shade800,
                    Colors.grey.shade900,
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: player != null ? Colors.white.withOpacity(0.3) : Colors.grey.shade700,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Icône du joueur
            if (player != null)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    player.iconAssetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade700,
                ),
                child: Icon(
                  Icons.person_add,
                  color: Colors.grey.shade500,
                  size: 28,
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
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    player?.name ?? 'Sélectionner un joueur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Icône de sélection
            Icon(
              player != null ? Icons.check_circle : Icons.arrow_forward_ios,
              color: player != null ? Colors.greenAccent : Colors.white54,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
