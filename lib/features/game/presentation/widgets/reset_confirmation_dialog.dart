import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';

/// Options de réinitialisation disponibles
enum ResetOption {
  cancel,
  scores,
  round,
}

/// Dialog de confirmation pour réinitialiser la partie
class ResetConfirmationDialog extends StatefulWidget {
  const ResetConfirmationDialog({super.key});

  @override
  State<ResetConfirmationDialog> createState() =>
      _ResetConfirmationDialogState();
}

class _ResetConfirmationDialogState extends State<ResetConfirmationDialog>
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

  void _handleSelection(ResetOption option) {
    HapticUtils.light();
    Navigator.of(context).pop(option);
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: errorColor,
        maxWidth: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête
            DialogHeader(
              icon: Icons.restart_alt,
              title: 'Réinitialiser',
              accentColor: errorColor,
              onClose: () => _handleSelection(ResetOption.cancel),
            ),

            const SizedBox(height: 16),

            // Question
            Row(
              children: [
                Icon(
                  Icons.help_outline,
                  size: 18,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Que voulez-vous réinitialiser ?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Options
            _ResetOptionCard(
              icon: Icons.refresh,
              title: 'Réinitialiser Partie',
              description: 'Remet les scores à 0 (garde les victoires)',
              color: Colors.blue,
              onTap: () => _handleSelection(ResetOption.scores),
              shimmerController: shimmerController,
            ),
            const SizedBox(height: 12),
            _ResetOptionCard(
              icon: Icons.replay_circle_filled,
              title: 'Réinitialiser Round',
              description: 'Remet tout à zéro (scores et victoires)',
              color: Colors.orange,
              onTap: () => _handleSelection(ResetOption.round),
              shimmerController: shimmerController,
            ),

            const SizedBox(height: 16),

            // Bouton Annuler
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _handleSelection(ResetOption.cancel),
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte d'option de réinitialisation
class _ResetOptionCard extends StatefulWidget {
  const _ResetOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    required this.shimmerController,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final AnimationController shimmerController;

  @override
  State<_ResetOptionCard> createState() => _ResetOptionCardState();
}

class _ResetOptionCardState extends State<_ResetOptionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: AppTheme.transparentColor,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.color.withValues(alpha: _isHovered ? 0.15 : 0.08),
                  widget.color.withValues(alpha: _isHovered ? 0.08 : 0.04),
                ],
              ),
              border: Border.all(
                color: widget.color.withValues(alpha: _isHovered ? 0.6 : 0.3),
                width: _isHovered ? 3 : 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.2),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: widget.color,
                      size: 18,
                    ),
                  ],
                ),
                // Effet shimmer
                if (_isHovered)
                  ShimmerEffect(
                    controller: widget.shimmerController,
                    borderRadius: BorderRadius.circular(12),
                    opacity: 0.4,
                  ),
                // Particules scintillantes
                if (_isHovered)
                  SparklesOverlay(
                    controller: widget.shimmerController,
                    color: widget.color,
                    sparkleCount: 4,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
