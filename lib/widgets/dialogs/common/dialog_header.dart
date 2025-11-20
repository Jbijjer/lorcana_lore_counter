import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// En-tête stylisé réutilisable pour les dialogues
///
/// Affiche une icône colorée, un titre avec effet gradient, et un bouton de fermeture
///
/// Usage:
/// ```dart
/// DialogHeader(
///   icon: Icons.palette,
///   title: 'Couleur de fond',
///   accentColor: playerColor,
///   onClose: () => Navigator.of(context).pop(),
/// )
/// ```
class DialogHeader extends StatelessWidget {
  const DialogHeader({
    required this.icon,
    required this.title,
    required this.accentColor,
    this.onClose,
    this.subtitle,
    super.key,
  });

  /// L'icône à afficher dans le coin gauche
  final IconData icon;

  /// Le titre du dialogue
  final String title;

  /// Le sous-titre optionnel
  final String? subtitle;

  /// La couleur d'accent utilisée pour l'icône et le gradient
  final Color accentColor;

  /// Callback appelé quand l'utilisateur clique sur le bouton fermer
  /// Si null, le bouton de fermeture n'est pas affiché
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icône avec background coloré
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: accentColor,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),

        // Titre avec effet gradient
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      accentColor,
                      accentColor.withValues(alpha: 0.6),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.pureWhite,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ],
          ),
        ),

        // Bouton de fermeture
        if (onClose != null)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
      ],
    );
  }
}
