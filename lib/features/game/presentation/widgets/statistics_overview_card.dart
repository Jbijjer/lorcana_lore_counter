import 'package:flutter/material.dart';
import '../../data/game_statistics_service.dart';

/// Widget affichant la vue d'ensemble des statistiques
class StatisticsOverviewCard extends StatelessWidget {
  const StatisticsOverviewCard({
    super.key,
    required this.statistics,
  });

  final GlobalStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final totalGames = statistics.totalGames;

    if (totalGames == 0) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune partie jouée',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Jouez votre première partie pour voir vos statistiques !',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec icône
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bar_chart,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vue d\'ensemble',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalGames partie${totalGames > 1 ? 's' : ''} jouée${totalGames > 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistiques par joueur
            if (statistics.playerStats.isNotEmpty) ...[
              Text(
                'Statistiques par joueur',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ...statistics.playerStats.values.map(
                (playerStats) => _PlayerStatsRow(
                  stats: playerStats,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher les statistiques d'un joueur
class _PlayerStatsRow extends StatelessWidget {
  const _PlayerStatsRow({
    required this.stats,
  });

  final PlayerStatistics stats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nom du joueur
          Row(
            children: [
              Expanded(
                child: Text(
                  stats.playerName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getWinrateColor(stats.winrate).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${stats.winrate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: _getWinrateColor(stats.winrate),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: stats.winrate / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getWinrateColor(stats.winrate),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Détails (victoires/défaites/nuls/moyenne)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _StatChip(
                icon: Icons.emoji_events,
                label: '${stats.wins}V',
                color: Colors.green,
              ),
              _StatChip(
                icon: Icons.close,
                label: '${stats.losses}D',
                color: Colors.red,
              ),
              if (stats.draws > 0)
                _StatChip(
                  icon: Icons.handshake,
                  label: '${stats.draws}N',
                  color: Colors.orange,
                ),
              _StatChip(
                icon: Icons.trending_up,
                label: '${stats.averageScore.toStringAsFixed(1)} pts',
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getWinrateColor(double winrate) {
    if (winrate >= 60) return Colors.green;
    if (winrate >= 40) return Colors.orange;
    return Colors.red;
  }
}

/// Widget pour afficher une petite statistique
class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
