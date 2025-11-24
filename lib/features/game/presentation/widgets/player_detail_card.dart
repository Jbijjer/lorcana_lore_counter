import 'package:flutter/material.dart';
import '../../data/game_statistics_service.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget affichant les détails complets des statistiques d'un joueur
class PlayerDetailCard extends StatelessWidget {
  const PlayerDetailCard({
    super.key,
    required this.playerStats,
    required this.headToHeadStats,
    required this.colorStats,
    required this.onBack,
  });

  final PlayerStatistics playerStats;
  final List<HeadToHeadStatistics> headToHeadStats;
  final List<ColorStatistics> colorStats;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête avec bouton retour et nom du joueur
          _buildHeader(context),
          const SizedBox(height: 16),

          // Stats générales
          _buildGeneralStatsCard(context),
          const SizedBox(height: 16),

          // Stats Premier à jouer
          if (playerStats.gamesAsFirstPlayer > 0 ||
              playerStats.gamesAsSecondPlayer > 0) ...[
            _buildFirstToPlayCard(context),
            const SizedBox(height: 16),
          ],

          // Stats Head-to-Head
          if (headToHeadStats.isNotEmpty) ...[
            _buildHeadToHeadCard(context),
            const SizedBox(height: 16),
          ],

          // Stats par couleur
          if (colorStats.isNotEmpty) ...[
            _buildColorStatsCard(context),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            playerStats.playerName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getWinrateColor(playerStats.winrate, context)
                .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${playerStats.winrate.toStringAsFixed(1)}%',
            style: TextStyle(
              color: _getWinrateColor(playerStats.winrate, context),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralStatsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Statistiques générales',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Parties jouées
            _StatRow(
              icon: Icons.games,
              label: 'Parties jouées',
              value: '${playerStats.totalGames}',
            ),
            const SizedBox(height: 12),

            // Winrate avec barre de progression
            Row(
              children: [
                const Icon(Icons.percent, size: 20),
                const SizedBox(width: 12),
                const Expanded(child: Text('Taux de victoire')),
                Text(
                  '${playerStats.winrate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getWinrateColor(playerStats.winrate, context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: playerStats.winrate / 100,
                minHeight: 8,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getWinrateColor(playerStats.winrate, context),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // V/D/N
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBox(
                  label: 'Victoires',
                  value: '${playerStats.wins}',
                  color: Theme.of(context).colorScheme.primary,
                  icon: Icons.emoji_events,
                ),
                _StatBox(
                  label: 'Défaites',
                  value: '${playerStats.losses}',
                  color: Theme.of(context).colorScheme.error,
                  icon: Icons.close,
                ),
                _StatBox(
                  label: 'Nuls',
                  value: '${playerStats.draws}',
                  color: Theme.of(context).colorScheme.tertiary,
                  icon: Icons.handshake,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstToPlayCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Premier à jouer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _FirstToPlayStatBox(
                    label: 'Commence',
                    games: playerStats.gamesAsFirstPlayer,
                    wins: playerStats.winsAsFirstPlayer,
                    winrate: playerStats.winrateAsFirstPlayer,
                    icon: Icons.looks_one,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FirstToPlayStatBox(
                    label: 'Second',
                    games: playerStats.gamesAsSecondPlayer,
                    wins: playerStats.winsAsSecondPlayer,
                    winrate: playerStats.winrateAsSecondPlayer,
                    icon: Icons.looks_two,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadToHeadCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Face à face',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...headToHeadStats.map(
              (h2h) => _HeadToHeadRow(stats: h2h),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorStatsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Contre les couleurs',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...colorStats.map(
              (colorStat) => _ColorStatRow(stats: colorStat),
            ),
          ],
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

/// Ligne de statistique simple
class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Box de statistique avec icône
class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

/// Box pour les stats Premier à jouer
class _FirstToPlayStatBox extends StatelessWidget {
  const _FirstToPlayStatBox({
    required this.label,
    required this.games,
    required this.wins,
    required this.winrate,
    required this.icon,
  });

  final String label;
  final int games;
  final int wins;
  final double winrate;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (games == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '-',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      );
    }

    final color = _getWinrateColor(winrate, context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${winrate.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '$wins/$games victoires',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
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

/// Ligne pour les stats head-to-head
class _HeadToHeadRow extends StatelessWidget {
  const _HeadToHeadRow({required this.stats});

  final HeadToHeadStatistics stats;

  @override
  Widget build(BuildContext context) {
    final color = _getWinrateColor(stats.winrate, context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'vs ${stats.opponentName}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.wins}V - ${stats.losses}D - ${stats.draws}N',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${stats.winrate.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
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

/// Ligne pour les stats par couleur
class _ColorStatRow extends StatelessWidget {
  const _ColorStatRow({required this.stats});

  final ColorStatistics stats;

  @override
  Widget build(BuildContext context) {
    final deckColor = AppTheme.getLorcanaColorByName(stats.colorName);
    final winrateColor = _getWinrateColor(stats.winrate, context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Indicateur de couleur
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: deckColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stats.colorName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.wins}V - ${stats.losses}D - ${stats.draws}N (${stats.totalGames} parties)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: winrateColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${stats.winrate.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: winrateColor,
                ),
              ),
            ),
          ],
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
