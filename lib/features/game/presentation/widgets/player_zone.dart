import 'package:flutter/material.dart';
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
    this.onNameTap,
  });

  final Player player;
  final int score;
  final bool isRotated;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;
  final VoidCallback? onNameTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            player.backgroundColorStart.withValues(alpha: 0.6),
            player.backgroundColorEnd.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nom du joueur (cliquable), descendu de 30 pixels
          Transform.translate(
            offset: const Offset(0, 30),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: GestureDetector(
                onTap: onNameTap != null
                    ? () {
                        HapticUtils.light();
                        onNameTap!();
                      }
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar circulaire avec icône de portrait et contour noir
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: player.color.withValues(alpha: 0.3),
                        child: Icon(
                          IconData(
                            player.iconCodePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: player.color,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Nom du joueur en blanc avec outline noir
                    Stack(
                      children: [
                        // Outline noir (dessous)
                        Text(
                          player.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 30,
                                letterSpacing: 0.5,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 4
                                  ..color = Colors.black,
                              ),
                        ),
                        // Texte blanc (dessus)
                        Text(
                          player.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 30,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Affichage du score avec contrôles +/-
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 25),
                    child: _ScoreActionButton(
                      icon: Icons.remove,
                      playerColor: player.color,
                      semanticsLabel: 'Diminuer le score',
                      onTap: () {
                        HapticUtils.light();
                        onDecrement(1);
                      },
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding * 2),
                  // Affichage du score avec cadre Lore
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Cadre Lore en arrière-plan (rotation gérée par RotatedBox parent)
                        Image.asset(
                          'assets/images/lore_frame.png',
                          fit: BoxFit.contain,
                        ),
                        // Score au centre, légèrement descendu
                        Transform.translate(
                          offset: const Offset(0, 25),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
                                child: Text(
                                  score.toString(),
                                  style: const TextStyle(
                                    fontSize: 86,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    letterSpacing: -4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding * 2),
                  Transform.translate(
                    offset: const Offset(0, 25),
                    child: _ScoreActionButton(
                      icon: Icons.add,
                      playerColor: player.color,
                      semanticsLabel: 'Augmenter le score',
                      onTap: () {
                        HapticUtils.light();
                        onIncrement(1);
                      },
                    ),
                  ),
                ],
              ),
            ),
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
}

/// Bouton d'action pour augmenter ou diminuer le score
class _ScoreActionButton extends StatelessWidget {
  const _ScoreActionButton({
    required this.icon,
    required this.playerColor,
    required this.semanticsLabel,
    required this.onTap,
  });

  final IconData icon;
  final Color playerColor;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: playerColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 32,
          ),
        ),
      ),
    );
  }
}

