import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/game_statistics_service.dart';
import '../widgets/statistics_overview_card.dart';
import '../widgets/game_history_card.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Écran des statistiques et de l'historique des parties
class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statisticsService = ref.watch(gameStatisticsServiceProvider);
    final globalStats = statisticsService.getGlobalStatistics();
    final allGames = statisticsService.getAllGames();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Statistiques',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(
              icon: Icon(Icons.bar_chart),
              text: 'Vue d\'ensemble',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Historique',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Onglet Vue d'ensemble
          _buildOverviewTab(globalStats),

          // Onglet Historique
          _buildHistoryTab(allGames, statisticsService),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(GlobalStatistics stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatisticsOverviewCard(statistics: stats),
          const SizedBox(height: 16),

          // Informations supplémentaires
          if (stats.totalGames > 0) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Informations',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                      label: 'Parties jouées',
                      value: '${stats.totalGames}',
                      icon: Icons.games,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Joueurs uniques',
                      value: '${stats.playerStats.length}',
                      icon: Icons.people,
                    ),
                  ],
                ),
              ),
            ),
          ],
          // Padding en bas pour éviter que le contenu soit coupé
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(
    List<dynamic> games,
    GameStatisticsService service,
  ) {
    if (games.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 80,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune partie dans l\'historique',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vos parties terminées apparaîtront ici',
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

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return GameHistoryCard(
          game: game,
          onDelete: () => _deleteGame(game.id, service),
        );
      },
    );
  }

  void _deleteGame(String gameId, GameStatisticsService service) {
    HapticUtils.medium();
    service.deleteGame(gameId).then((_) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(width: 8),
              const Text('Partie supprimée'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}

/// Widget pour afficher une ligne d'information
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
