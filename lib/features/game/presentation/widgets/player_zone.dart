import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/player.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Widget représentant la zone d'un joueur
class PlayerZone extends StatelessWidget {
  const PlayerZone({
    super.key,
    required this.player,
    required this.score,
    required this.isRotated,
    required this.onIncrement,
    required this.onDecrement,
    required this.onScoreChanged,
    this.onNameTap,
  });

  final Player player;
  final int score;
  final bool isRotated;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;
  final ValueChanged<int> onScoreChanged;
  final VoidCallback? onNameTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            player.color.withOpacity(0.15),
            player.color.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nom du joueur (cliquable)
          GestureDetector(
            onTap: onNameTap != null
                ? () {
                    HapticUtils.light();
                    onNameTap!();
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: onNameTap != null
                  ? BoxDecoration(
                      color: player.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: player.color.withOpacity(0.3),
                        width: 1,
                      ),
                    )
                  : null,
              child: Text(
                player.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: player.color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Score
          GestureDetector(
            onLongPress: () {
              HapticUtils.medium();
              _showScoreDialog(context);
            },
            child: Text(
              score.toString(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 120,
                    fontWeight: FontWeight.w900,
                    color: player.color,
                    letterSpacing: -4,
                  ),
            ),
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Barre de progression vers 20
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.largePadding,
            ),
            child: LinearProgressIndicator(
              value: score / AppConstants.winningScore,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(player.color),
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),

          // Roulette de sélection du score
          _ScoreWheel(
            currentScore: score,
            playerColor: player.color,
            onScoreChanged: onScoreChanged,
          ),
        ],
      ),
    );

    return Expanded(
      child: isRotated
          ? RotatedBox(
              quarterTurns: 2,
              child: content,
            )
          : content,
    );
  }

  void _showScoreDialog(BuildContext context) {
    // TODO: Implémenter le dialogue de modification manuelle du score
  }
}

/// Roulette pour sélectionner le score de 0 à 20
class _ScoreWheel extends StatefulWidget {
  const _ScoreWheel({
    required this.currentScore,
    required this.playerColor,
    required this.onScoreChanged,
  });

  final int currentScore;
  final Color playerColor;
  final ValueChanged<int> onScoreChanged;

  @override
  State<_ScoreWheel> createState() => _ScoreWheelState();
}

class _ScoreWheelState extends State<_ScoreWheel> {
  late FixedExtentScrollController _controller;
  int _selectedScore = 0;

  @override
  void initState() {
    super.initState();
    _selectedScore = widget.currentScore.clamp(0, AppConstants.winningScore);
    _controller = FixedExtentScrollController(
      initialItem: _selectedScore,
    );
  }

  @override
  void didUpdateWidget(_ScoreWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Synchroniser si le score a changé depuis l'extérieur
    if (widget.currentScore != _selectedScore) {
      _selectedScore = widget.currentScore.clamp(0, AppConstants.winningScore);
      if (_controller.hasClients) {
        _controller.jumpToItem(_selectedScore);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: widget.playerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.playerColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: CupertinoPicker(
        scrollController: _controller,
        itemExtent: 50,
        diameterRatio: 1.5,
        useMagnifier: true,
        magnification: 1.2,
        onSelectedItemChanged: (index) {
          HapticUtils.light();
          _selectedScore = index;
          widget.onScoreChanged(index);
        },
        children: List.generate(
          AppConstants.winningScore + 1,
          (index) => Center(
            child: Text(
              index.toString(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.playerColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

