import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/accessibility_provider.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Écran des paramètres de l'application
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityPrefs = ref.watch(accessibilityNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            HapticUtils.light();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: accessibilityPrefs.when(
        data: (prefs) => ListView(
          children: [
            // Section Accessibilité
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Accessibilité',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            // Toggle Mode Contraste Élevé
            SwitchListTile(
              title: const Text('Mode contraste élevé'),
              subtitle: const Text(
                'Augmente le contraste des couleurs pour une meilleure lisibilité (WCAG AAA)',
              ),
              value: prefs.highContrastMode,
              onChanged: (value) {
                HapticUtils.light();
                ref.read(accessibilityNotifierProvider.notifier).toggleHighContrast();
              },
              secondary: const Icon(Icons.contrast),
            ),

            const Divider(),

            // Informations sur le mode contraste élevé
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'À propos du mode contraste élevé',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Le mode contraste élevé utilise des couleurs vives et des bordures épaisses pour améliorer la visibilité. '
                        'Il respecte les normes WCAG 2.1 niveau AAA pour l\'accessibilité.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Texte noir sur fond blanc (mode clair)\n'
                        '• Texte blanc sur fond noir (mode sombre)\n'
                        '• Bordures épaisses autour des éléments\n'
                        '• Couleurs saturées et vives',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Erreur: $error'),
        ),
      ),
    );
  }
}
