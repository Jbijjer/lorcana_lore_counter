import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/accessibility_provider.dart';
import '../../../../core/providers/update_checker_provider.dart';
import '../../../../core/models/app_update_info.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../widgets/dialogs/update_available_dialog.dart';
import '../../data/game_persistence_service.dart';
import '../../data/game_statistics_service.dart';

/// Écran des paramètres de l'application
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.fromActiveGame = false});

  /// Indique si on arrive depuis une partie en cours
  final bool fromActiveGame;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _appVersion = '';
  String _appBuildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _appBuildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Paramètres',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section Accessibilité
          _buildSectionHeader('Accessibilité'),
          _buildAccessibilitySettings(),
          const SizedBox(height: 24),

          // Section Données
          _buildSectionHeader('Données'),
          _buildDataSettings(),
          const SizedBox(height: 24),

          // Section À propos
          _buildSectionHeader('À propos'),
          _buildAboutSettings(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildAccessibilitySettings() {
    final accessibilityPrefs = ref.watch(accessibilityNotifierProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: accessibilityPrefs.when(
        data: (prefs) => Column(
          children: [
            SwitchListTile(
              title: const Text('Mode contraste élevé'),
              subtitle: const Text('Améliore la lisibilité pour les personnes malvoyantes'),
              value: prefs.highContrastMode,
              onChanged: (value) {
                HapticUtils.light();
                ref.read(accessibilityNotifierProvider.notifier).setHighContrast(value);
              },
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.visibility,
                  color: AppTheme.infoColor,
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) => const ListTile(
          title: Text('Erreur de chargement des préférences'),
        ),
      ),
    );
  }

  Widget _buildDataSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: AppTheme.warningColor,
              ),
            ),
            title: const Text('Supprimer la partie en cours'),
            subtitle: const Text('Efface la partie sauvegardée'),
            onTap: _showDeleteGameConfirmation,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_forever,
                color: AppTheme.errorColor,
              ),
            ),
            title: const Text('Effacer l\'historique'),
            subtitle: const Text('Supprime l\'historique des parties et statistiques'),
            onTap: _showDeleteAllDataConfirmation,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings() {
    final updateState = ref.watch(updateCheckerProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Version de l'application
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.2),
                    AppTheme.secondaryColor.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info_outline,
                color: AppTheme.primaryColor,
              ),
            ),
            title: const Text('Version de l\'application'),
            subtitle: Text(
              _appVersion.isNotEmpty
                  ? 'Version $_appVersion (Build $_appBuildNumber)'
                  : 'Chargement...',
            ),
          ),
          const Divider(height: 1),

          // Vérifier les mises à jour
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getUpdateIconColor(updateState).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildUpdateIcon(updateState),
            ),
            title: const Text('Mises à jour'),
            subtitle: _buildUpdateSubtitle(updateState),
            trailing: _buildUpdateTrailing(updateState),
            onTap: () => _handleUpdateTap(updateState),
          ),
        ],
      ),
    );
  }

  Color _getUpdateIconColor(UpdateCheckState state) {
    return state.when(
      initial: () => AppTheme.infoColor,
      checking: () => AppTheme.infoColor,
      updateAvailable: (_) => AppTheme.successColor,
      upToDate: (_) => AppTheme.successColor,
      error: (_) => AppTheme.errorColor,
    );
  }

  Widget _buildUpdateIcon(UpdateCheckState state) {
    return state.when(
      initial: () => const Icon(Icons.system_update, color: AppTheme.infoColor),
      checking: () => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      updateAvailable: (_) => const Icon(Icons.download, color: AppTheme.successColor),
      upToDate: (_) => const Icon(Icons.check_circle, color: AppTheme.successColor),
      error: (_) => const Icon(Icons.error_outline, color: AppTheme.errorColor),
    );
  }

  Widget _buildUpdateSubtitle(UpdateCheckState state) {
    return state.when(
      initial: () => const Text('Appuyez pour vérifier'),
      checking: () => const Text('Vérification en cours...'),
      updateAvailable: (info) => Text(
        'Version ${info.latestVersion} disponible',
        style: const TextStyle(color: AppTheme.successColor),
      ),
      upToDate: (_) => const Text('Vous êtes à jour'),
      error: (message) => Text(
        'Erreur de vérification',
        style: TextStyle(color: AppTheme.errorColor),
      ),
    );
  }

  Widget? _buildUpdateTrailing(UpdateCheckState state) {
    return state.maybeWhen(
      updateAvailable: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.successColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'NOUVEAU',
          style: TextStyle(
            color: AppTheme.pureWhite,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      orElse: () => null,
    );
  }

  void _handleUpdateTap(UpdateCheckState state) {
    HapticUtils.light();

    state.when(
      initial: () => _checkForUpdate(),
      checking: () {}, // Ne rien faire si déjà en cours
      updateAvailable: (info) => _showUpdateDialog(info),
      upToDate: (_) => _checkForUpdate(), // Permettre de re-vérifier
      error: (_) => _checkForUpdate(), // Permettre de réessayer
    );
  }

  Future<void> _checkForUpdate() async {
    await ref.read(updateCheckerProvider.notifier).checkForUpdate();

    if (!mounted) return;

    final state = ref.read(updateCheckerProvider);
    state.maybeWhen(
      updateAvailable: (info) => _showUpdateDialog(info),
      orElse: () {},
    );
  }

  void _showUpdateDialog(AppUpdateInfo info) {
    showUpdateAvailableDialog(
      context,
      updateInfo: info,
      onDownload: () async {
        final success = await ref
            .read(updateCheckerProvider.notifier)
            .openDownloadUrl(info.downloadUrl);

        if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible d\'ouvrir le lien de téléchargement'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
    );
  }

  void _showDeleteGameConfirmation() async {
    final persistenceService = ref.read(gamePersistenceServiceProvider);
    final hasOngoingGame = persistenceService.hasOngoingGame();

    if (!hasOngoingGame) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune partie en cours à supprimer'),
          backgroundColor: AppTheme.infoColor,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: AppTheme.warningColor,
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text('Confirmer la suppression'),
            ),
          ],
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer la partie en cours ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      HapticUtils.medium();
      await persistenceService.clearGame();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.pureWhite),
              SizedBox(width: 8),
              Text('Partie supprimée avec succès'),
            ],
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _showDeleteAllDataConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error,
              color: AppTheme.errorColor,
            ),
            const SizedBox(width: 8),
            const Text('ATTENTION'),
          ],
        ),
        content: const Text(
          'Êtes-vous VRAIMENT sûr de vouloir effacer tout l\'historique ? '
          'Cela supprimera l\'historique des parties, les statistiques et la partie en cours. '
          'Les joueurs seront conservés. '
          'Cette action est IRRÉVERSIBLE.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Effacer l\'historique'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      HapticUtils.heavy();

      // Supprimer toutes les données
      final persistenceService = ref.read(gamePersistenceServiceProvider);
      final statisticsService = ref.read(gameStatisticsServiceProvider);

      await persistenceService.clearGame();
      await statisticsService.deleteAllGames();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.pureWhite),
              SizedBox(width: 8),
              Text('L\'historique a été effacé'),
            ],
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
