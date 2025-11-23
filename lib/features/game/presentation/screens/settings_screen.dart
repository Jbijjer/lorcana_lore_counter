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
          // Section Apparence
          _buildSectionHeader('Apparence'),
          _buildAppearanceSettings(),
          const SizedBox(height: 24),

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
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildAppearanceSettings() {
    final accessibilityPrefs = ref.watch(accessibilityNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: accessibilityPrefs.when(
        data: (prefs) => Column(
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getThemeModeIcon(prefs.themeModeIndex),
                  color: colorScheme.primary,
                ),
              ),
              title: const Text('Mode de thème'),
              subtitle: Text(_getThemeModeLabel(prefs.themeModeIndex)),
              trailing: Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
              onTap: () => _showThemeModeDialog(prefs.themeModeIndex),
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

  IconData _getThemeModeIcon(int themeModeIndex) {
    switch (themeModeIndex) {
      case 1:
        return Icons.light_mode;
      case 2:
        return Icons.dark_mode;
      default:
        return Icons.brightness_auto;
    }
  }

  String _getThemeModeLabel(int themeModeIndex) {
    switch (themeModeIndex) {
      case 1:
        return 'Clair';
      case 2:
        return 'Sombre';
      default:
        return 'Système';
    }
  }

  void _showThemeModeDialog(int currentIndex) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mode de thème'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeModeOption(
              icon: Icons.brightness_auto,
              label: 'Système',
              subtitle: 'Suivre les paramètres du système',
              isSelected: currentIndex == 0,
              onTap: () {
                HapticUtils.light();
                ref.read(accessibilityNotifierProvider.notifier).setThemeMode(0);
                Navigator.of(dialogContext).pop();
              },
            ),
            const Divider(height: 1),
            _ThemeModeOption(
              icon: Icons.light_mode,
              label: 'Clair',
              subtitle: 'Toujours utiliser le thème clair',
              isSelected: currentIndex == 1,
              onTap: () {
                HapticUtils.light();
                ref.read(accessibilityNotifierProvider.notifier).setThemeMode(1);
                Navigator.of(dialogContext).pop();
              },
            ),
            const Divider(height: 1),
            _ThemeModeOption(
              icon: Icons.dark_mode,
              label: 'Sombre',
              subtitle: 'Toujours utiliser le thème sombre',
              isSelected: currentIndex == 2,
              onTap: () {
                HapticUtils.light();
                ref.read(accessibilityNotifierProvider.notifier).setThemeMode(2);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
        ],
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
    final colorScheme = Theme.of(context).colorScheme;

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
                    colorScheme.primary.withValues(alpha: 0.2),
                    colorScheme.secondary.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.info_outline,
                color: colorScheme.primary,
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
    final colorScheme = Theme.of(context).colorScheme;
    return state.when(
      initial: () => colorScheme.primary,
      checking: () => colorScheme.primary,
      updateAvailable: (_) => AppTheme.successColor,
      upToDate: (_) => AppTheme.successColor,
      error: (_) => colorScheme.error,
    );
  }

  Widget _buildUpdateIcon(UpdateCheckState state) {
    final colorScheme = Theme.of(context).colorScheme;
    return state.when(
      initial: () => Icon(Icons.system_update, color: colorScheme.primary),
      checking: () => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      updateAvailable: (_) => const Icon(Icons.download, color: AppTheme.successColor),
      upToDate: (_) => const Icon(Icons.check_circle, color: AppTheme.successColor),
      error: (_) => Icon(Icons.error_outline, color: colorScheme.error),
    );
  }

  Widget _buildUpdateSubtitle(UpdateCheckState state) {
    final colorScheme = Theme.of(context).colorScheme;
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
        style: TextStyle(color: colorScheme.error),
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
        child: Text(
          'NOUVEAU',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
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
            SnackBar(
              content: const Text('Impossible d\'ouvrir le lien de téléchargement'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
    );
  }

  void _showDeleteGameConfirmation() async {
    final persistenceService = ref.read(gamePersistenceServiceProvider);
    final hasOngoingGame = persistenceService.hasOngoingGame();
    final colorScheme = Theme.of(context).colorScheme;

    if (!hasOngoingGame) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Aucune partie en cours à supprimer'),
          backgroundColor: colorScheme.primary,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
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
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(width: 8),
              const Text('Partie supprimée avec succès'),
            ],
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _showDeleteAllDataConfirmation() async {
    final colorScheme = Theme.of(context).colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error,
              color: colorScheme.error,
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
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
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
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onError),
              const SizedBox(width: 8),
              const Text('L\'historique a été effacé'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

/// Widget pour afficher une option de mode de thème
class _ThemeModeOption extends StatelessWidget {
  const _ThemeModeOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
