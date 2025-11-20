import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';

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
    with TickerProviderStateMixin, DialogAnimationsMixin {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    initDialogAnimations();
    _controller = TextEditingController(text: widget.currentScore.toString());

    // Sélectionner tout le texte au démarrage
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    disposeDialogAnimations();
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
    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: widget.playerColor,
        maxWidth: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête stylisé
            DialogHeader(
              icon: Icons.edit,
              title: 'Score de ${widget.playerName}',
              accentColor: widget.playerColor,
              onClose: () {
                HapticUtils.light();
                Navigator.of(context).pop();
              },
            ),

            const SizedBox(height: 20),

            // TextField pour le score
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

            // Aide
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Entrez un score entre ${AppConstants.minScore} et ${AppConstants.maxScore}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    HapticUtils.light();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _validateAndSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.playerColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirmer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
