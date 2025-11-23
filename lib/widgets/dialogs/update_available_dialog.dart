import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/app_update_info.dart';
import '../../core/utils/haptic_utils.dart';
import 'common/dialog_animations_mixin.dart';
import 'common/dialog_header.dart';
import 'common/animated_dialog_wrapper.dart';

/// Dialogue affichant qu'une mise à jour est disponible
class UpdateAvailableDialog extends StatefulWidget {
  const UpdateAvailableDialog({
    required this.updateInfo,
    required this.onDownload,
    super.key,
  });

  /// Informations sur la mise à jour
  final AppUpdateInfo updateInfo;

  /// Callback appelé quand l'utilisateur veut télécharger
  final VoidCallback onDownload;

  @override
  State<UpdateAvailableDialog> createState() => _UpdateAvailableDialogState();
}

class _UpdateAvailableDialogState extends State<UpdateAvailableDialog>
    with TickerProviderStateMixin, DialogAnimationsMixin {
  @override
  void initState() {
    super.initState();
    initDialogAnimations();
  }

  @override
  void dispose() {
    disposeDialogAnimations();
    super.dispose();
  }

  void _handleDownload() {
    HapticUtils.medium();
    Navigator.of(context).pop();
    widget.onDownload();
  }

  void _handleLater() {
    HapticUtils.light();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = AppTheme.successColor;

    return buildAnimatedDialog(
      child: ScrollableAnimatedDialogWrapper(
        accentColor: accentColor,
        maxWidth: 420,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête
            DialogHeader(
              icon: Icons.system_update,
              title: 'Mise à jour disponible',
              subtitle: 'Version ${widget.updateInfo.latestVersion}',
              accentColor: accentColor,
              onClose: _handleLater,
            ),

            const SizedBox(height: 20),

            // Informations de version
            _buildVersionInfo(),

            const SizedBox(height: 16),

            // Notes de release (si disponibles)
            if (widget.updateInfo.releaseNotes != null &&
                widget.updateInfo.releaseNotes!.isNotEmpty)
              _buildReleaseNotes(),

            const SizedBox(height: 24),

            // Boutons d'action
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.successColor.withValues(alpha: 0.1),
            AppTheme.successColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Version actuelle
          Expanded(
            child: Column(
              children: [
                Text(
                  'Actuelle',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'v${widget.updateInfo.currentVersion}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Flèche
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: AppTheme.successColor,
              size: 20,
            ),
          ),

          // Nouvelle version
          Expanded(
            child: Column(
              children: [
                Text(
                  'Nouvelle',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'v${widget.updateInfo.latestVersion}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReleaseNotes() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Nouveautés',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxHeight: 150),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Text(
              widget.updateInfo.releaseNotes!,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bouton principal - Télécharger
        ElevatedButton.icon(
          onPressed: _handleDownload,
          icon: const Icon(Icons.download, color: AppTheme.pureWhite),
          label: const Text(
            'Télécharger la mise à jour',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.pureWhite,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.successColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Bouton secondaire - Plus tard
        TextButton(
          onPressed: _handleLater,
          child: Text(
            'Plus tard',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Affiche le dialogue de mise à jour
Future<void> showUpdateAvailableDialog(
  BuildContext context, {
  required AppUpdateInfo updateInfo,
  required VoidCallback onDownload,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => UpdateAvailableDialog(
      updateInfo: updateInfo,
      onDownload: onDownload,
    ),
  );
}
