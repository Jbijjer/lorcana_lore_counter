import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';

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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation de transition
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSelection(ResetOption option) {
    HapticUtils.light();
    Navigator.of(context).pop(option);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.restart_alt,
                color: Theme.of(context).colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('Réinitialiser'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Que voulez-vous réinitialiser ?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _ResetOptionCard(
                icon: Icons.refresh,
                title: 'Réinitialiser Partie',
                description: 'Remet les scores à 0 (garde les victoires)',
                color: Colors.blue,
                onTap: () => _handleSelection(ResetOption.scores),
              ),
              const SizedBox(height: 12),
              _ResetOptionCard(
                icon: Icons.replay_circle_filled,
                title: 'Réinitialiser Round',
                description: 'Remet tout à zéro (scores et victoires)',
                color: Colors.orange,
                onTap: () => _handleSelection(ResetOption.round),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => _handleSelection(ResetOption.cancel),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte d'option de réinitialisation
class _ResetOptionCard extends StatelessWidget {
  const _ResetOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
