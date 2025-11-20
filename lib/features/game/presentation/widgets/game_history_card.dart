import 'package:flutter/material.dart';
import '../../domain/game_history.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Widget affichant une carte d'historique de partie
class GameHistoryCard extends StatelessWidget {
  const GameHistoryCard({
    super.key,
    required this.game,
    required this.onDelete,
  });

  final GameHistory game;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isPlayer1Winner = !game.isDraw && game.winnerName == game.player1Name;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticUtils.light();
          _showGameDetails(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec date et durée
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(game.endTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        game.formattedDuration,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Joueurs et scores
              Row(
                children: [
                  // Joueur 1
                  Expanded(
                    child: _PlayerScoreColumn(
                      playerName: game.player1Name,
                      score: game.player1FinalScore,
                      wins: game.player1Wins,
                      isWinner: isPlayer1Winner,
                      isDraw: game.isDraw,
                      deckColors: game.player1DeckColors,
                    ),
                  ),

                  // VS ou DRAW
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: game.isDraw ? Colors.orange[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        game.isDraw ? 'NUL' : 'VS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: game.isDraw ? Colors.orange[700] : Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  // Joueur 2
                  Expanded(
                    child: _PlayerScoreColumn(
                      playerName: game.player2Name,
                      score: game.player2FinalScore,
                      wins: game.player2Wins,
                      isWinner: !isPlayer1Winner && !game.isDraw,
                      isDraw: game.isDraw,
                      deckColors: game.player2DeckColors,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Format et bouton supprimer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      game.matchFormat,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: Colors.red[400],
                    onPressed: () {
                      HapticUtils.medium();
                      _showDeleteConfirmation(context);
                    },
                    tooltip: 'Supprimer',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Hier ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showGameDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Détails de la partie'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(
                label: 'Résultat',
                value: game.resultText,
                icon: game.isDraw ? Icons.handshake : Icons.emoji_events,
                color: game.isDraw ? Colors.orange : Colors.amber,
              ),
              const SizedBox(height: 8),
              _DetailRow(
                label: 'Format',
                value: game.matchFormat,
                icon: Icons.gamepad,
              ),
              const SizedBox(height: 8),
              _DetailRow(
                label: 'Durée',
                value: game.formattedDuration,
                icon: Icons.timer,
              ),
              const SizedBox(height: 8),
              _DetailRow(
                label: 'Date',
                value: _formatFullDate(game.endTime),
                icon: Icons.calendar_today,
              ),
              const Divider(height: 24),
              _DetailRow(
                label: game.player1Name,
                value: '${game.player1FinalScore} pts (${game.player1Wins} victoires)',
                icon: Icons.person,
                color: Colors.blue,
              ),
              if (game.player1DeckColors.isNotEmpty) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Text(
                    'Deck: ${game.player1DeckColors.join(', ')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              _DetailRow(
                label: game.player2Name,
                value: '${game.player2FinalScore} pts (${game.player2Wins} victoires)',
                icon: Icons.person,
                color: Colors.purple,
              ),
              if (game.player2DeckColors.isNotEmpty) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Text(
                    'Deck: ${game.player2DeckColors.join(', ')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette partie ?'),
        content: const Text(
          'Cette action est irréversible. Les statistiques de cette partie seront perdues.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

/// Colonne affichant le nom et le score d'un joueur
class _PlayerScoreColumn extends StatelessWidget {
  const _PlayerScoreColumn({
    required this.playerName,
    required this.score,
    required this.wins,
    required this.isWinner,
    required this.isDraw,
    required this.deckColors,
  });

  final String playerName;
  final int score;
  final int wins;
  final bool isWinner;
  final bool isDraw;
  final List<String> deckColors;

  @override
  Widget build(BuildContext context) {
    final displayColor = isDraw
        ? Colors.orange
        : (isWinner ? Colors.amber : Colors.grey);

    return Column(
      children: [
        // Nom du joueur avec couronne si gagnant
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isWinner && !isDraw)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.emoji_events,
                  size: 16,
                  color: Colors.amber,
                ),
              ),
            Flexible(
              child: Text(
                playerName,
                style: TextStyle(
                  fontWeight: isWinner || isDraw ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                  color: isDraw
                      ? Colors.orange[700]
                      : (isWinner ? Colors.amber[700] : Colors.black87),
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        // Couleurs de deck
        if (deckColors.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: deckColors.map((color) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getDeckColor(color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getDeckColor(color).withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    color,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: _getDeckColor(color),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 6),

        // Score
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: displayColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: displayColor.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Text(
            '$score',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: isDraw
                  ? Colors.orange[700]
                  : (isWinner ? Colors.amber[700] : Colors.black87),
            ),
          ),
        ),

        // Nombre de victoires
        const SizedBox(height: 4),
        Text(
          '$wins victoire${wins > 1 ? 's' : ''}',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Retourne la couleur associée à une couleur de deck Lorcana
  Color _getDeckColor(String deckColor) {
    switch (deckColor.toLowerCase()) {
      case 'amber':
        return Colors.amber[700]!;
      case 'amethyst':
        return Colors.purple[700]!;
      case 'emerald':
        return Colors.green[700]!;
      case 'ruby':
        return Colors.red[700]!;
      case 'sapphire':
        return Colors.blue[700]!;
      case 'steel':
        return Colors.grey[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}

/// Widget pour afficher une ligne de détail
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color ?? Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
