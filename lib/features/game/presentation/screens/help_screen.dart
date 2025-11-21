import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Écran d'aide de l'application
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Aide',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // En-tête
          _buildHeader(context),
          const SizedBox(height: 24),

          // Section: Démarrage rapide
          _buildSectionHeader(context, 'Démarrage rapide', Icons.rocket_launch),
          _buildHelpCard(
            context,
            title: 'Commencer une partie',
            steps: [
              'Appuyez sur "Nouveau Round" depuis l\'écran d\'accueil',
              'Sélectionnez les joueurs ou créez-en de nouveaux',
              'Personnalisez les couleurs si nécessaire',
              'Appuyez sur "Commencer" pour débuter la partie',
            ],
          ),
          const SizedBox(height: 16),

          // Section: Pendant la partie
          _buildSectionHeader(context, 'Pendant la partie', Icons.sports_esports),
          _buildHelpCard(
            context,
            title: 'Compter les points',
            steps: [
              'Appui simple sur + ou - : ajoute/retire 1 point',
              'Appui long sur + ou - : ajoute/retire 5 points',
              'La barre de progression montre l\'avancement vers 20 points',
              'Victoire automatique quand un joueur atteint 20 points',
            ],
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            context,
            title: 'Menu radial',
            steps: [
              'Appuyez sur l\'icône menu pour ouvrir les options',
              'Options disponibles : Modifier score, Changer couleur, Annuler, Réinitialiser',
              'Vous pouvez éditer directement le score d\'un joueur',
              'Annuler : revient à l\'état précédent',
            ],
          ),
          const SizedBox(height: 16),

          // Section: Statistiques
          _buildSectionHeader(context, 'Statistiques', Icons.bar_chart),
          _buildHelpCard(
            context,
            title: 'Consulter les statistiques',
            steps: [
              'Accédez aux statistiques depuis l\'écran d\'accueil',
              'Vue d\'ensemble : total des parties, durée moyenne, victoires',
              'Historique détaillé de toutes vos parties',
              'Statistiques par joueur : victoires, défaites, parties nulles',
            ],
          ),
          const SizedBox(height: 16),

          // Section: Paramètres
          _buildSectionHeader(context, 'Paramètres', Icons.settings),
          _buildHelpCard(
            context,
            title: 'Options d\'accessibilité',
            steps: [
              'Mode contraste élevé pour une meilleure lisibilité',
              'Feedback haptique pour les interactions',
              'Interface adaptée aux personnes malvoyantes',
            ],
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            context,
            title: 'Gestion des données',
            steps: [
              'Supprimer la partie en cours si nécessaire',
              'Effacer l\'historique des parties et statistiques',
              'Les données des joueurs sont conservées',
            ],
          ),
          const SizedBox(height: 16),

          // Section: Astuces
          _buildSectionHeader(context, 'Astuces', Icons.lightbulb),
          _buildTipsCard(context, [
            _TipItem(
              icon: Icons.touch_app,
              text: 'Utilisez l\'appui long pour gagner du temps lors de gros changements de score',
            ),
            _TipItem(
              icon: Icons.save,
              text: 'Votre partie en cours est automatiquement sauvegardée',
            ),
            _TipItem(
              icon: Icons.undo,
              text: 'Le bouton Annuler vous permet de corriger les erreurs rapidement',
            ),
            _TipItem(
              icon: Icons.palette,
              text: 'Personnalisez les couleurs des joueurs pour mieux les distinguer',
            ),
          ]),
          const SizedBox(height: 24),

          // Contact et support
          _buildContactCard(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.secondaryColor.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.help_outline,
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue dans l\'aide',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Découvrez comment utiliser Lorcana Score Keeper',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
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

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(
    BuildContext context, {
    required String title,
    required List<String> steps,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context, List<_TipItem> tips) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tips.asMap().entries.map((entry) {
            final tip = entry.value;
            final isLast = entry.key == tips.length - 1;
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        tip.icon,
                        color: AppTheme.secondaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tip.text,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                if (!isLast) const SizedBox(height: 12),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.infoColor.withValues(alpha: 0.1),
              AppTheme.secondaryColor.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.support_agent,
              size: 48,
              color: AppTheme.infoColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Besoin d\'aide supplémentaire ?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Si vous rencontrez un problème ou avez une suggestion, '
              'n\'hésitez pas à nous contacter.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Classe pour représenter un conseil
class _TipItem {
  final IconData icon;
  final String text;

  const _TipItem({
    required this.icon,
    required this.text,
  });
}
