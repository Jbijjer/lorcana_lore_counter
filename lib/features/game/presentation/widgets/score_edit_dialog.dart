import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Dialog pour modifier manuellement le score d'un joueur
class ScoreEditDialog extends StatefulWidget {
  const ScoreEditDialog({
    required this.currentScore,
    required this.playerName,
    required this.playerColor,
    super.key,
  });

  final int currentScore;
  final String playerName;
  final Color playerColor;

  @override
  State<ScoreEditDialog> createState() => _ScoreEditDialogState();
}

class _ScoreEditDialogState extends State<ScoreEditDialog>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentScore.toString());

    // Animation de transition
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _animationController.forward();

    // Sélectionner tout le texte au démarrage
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      setState(() {
        _errorText = 'Veuillez entrer un score';
      });
      HapticUtils.error();
      return;
    }

    final score = int.tryParse(text);

    if (score == null) {
      setState(() {
        _errorText = 'Veuillez entrer un nombre valide';
      });
      HapticUtils.error();
      return;
    }

    if (score < AppConstants.minScore || score > AppConstants.maxScore) {
      setState(() {
        _errorText = 'Le score doit être entre ${AppConstants.minScore} et ${AppConstants.maxScore}';
      });
      HapticUtils.error();
      return;
    }

    HapticUtils.success();
    Navigator.of(context).pop(score);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        title: Text('Modifier le score de ${widget.playerName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: InputDecoration(
                labelText: 'Score',
                errorText: _errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: widget.playerColor,
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _errorText = null;
                    });
                  },
                ),
              ),
              onChanged: (value) {
                if (_errorText != null) {
                  setState(() {
                    _errorText = null;
                  });
                }
              },
              onSubmitted: (_) => _validateAndSubmit(),
            ),
            const SizedBox(height: 16),
            Text(
              'Entrez un score entre ${AppConstants.minScore} et ${AppConstants.maxScore}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticUtils.light();
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: _validateAndSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: widget.playerColor,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}
