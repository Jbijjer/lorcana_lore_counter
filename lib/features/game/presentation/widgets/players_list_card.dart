import 'package:flutter/material.dart';
import '../../data/game_statistics_service.dart';

/// Widget affichant la liste des joueurs avec leurs statistiques résumées
class PlayersListCard extends StatelessWidget {
  const PlayersListCard({
    super.key,
    required this.playerStats,
    required this.onPlayerTap,
  });

  final Map<String, PlayerStatistics> playerStats;
  final void Function(String playerName) onPlayerTap;

  @override
  Widget build(BuildContext context) {
    if (playerStats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 80,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun joueur',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Les joueurs apparaîtront ici après avoir joué des parties',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Trier les joueurs par nombre de parties (décroissant)
    final sortedPlayers = playerStats.values.toList()
      ..sort((a, b) => b.totalGames.compareTo(a.totalGames));

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 60),
      itemCount: sortedPlayers.length,
      itemBuilder: (context, index) {
        final stats = sortedPlayers[index];
        return _PlayerListItem(
          stats: stats,
          onTap: () => onPlayerTap(stats.playerName),
        );
      },
    );
  }
}

/// Item de la liste des joueurs
class _PlayerListItem extends StatelessWidget {
  const _PlayerListItem({
    required this.stats,
    required this.onTap,
  });

  final PlayerStatistics stats;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final winrateColor = _getWinrateColor(stats.winrate, context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar avec initiale
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    stats.playerName.isNotEmpty
                        ? stats.playerName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Nom et stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stats.playerName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _MiniStatChip(
                          icon: Icons.games,
                          value: '${stats.totalGames}',
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        _MiniStatChip(
                          icon: Icons.emoji_events,
                          value: '${stats.wins}V',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        _MiniStatChip(
                          icon: Icons.close,
                          value: '${stats.losses}D',
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Winrate badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: winrateColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${stats.winrate.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: winrateColor,
                      ),
                    ),
                    Text(
                      'winrate',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getWinrateColor(double winrate, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (winrate >= 60) return colorScheme.primary;
    if (winrate >= 40) return colorScheme.tertiary;
    return colorScheme.error;
  }
}

/// Mini chip de statistique
class _MiniStatChip extends StatelessWidget {
  const _MiniStatChip({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
