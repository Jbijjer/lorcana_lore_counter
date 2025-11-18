import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/player.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Widget représentant la zone d'un joueur
class PlayerZone extends StatefulWidget {
  const PlayerZone({
    super.key,
    required this.player,
    required this.score,
    required this.isRotated,
    required this.onIncrement,
    required this.onDecrement,
    this.onNameTap,
    this.onScoreLongPress,
    this.wins = 0,
    this.winsNeeded = 1,
  });

  final Player player;
  final int score;
  final bool isRotated;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;
  final VoidCallback? onNameTap;
  final VoidCallback? onScoreLongPress;
  final int wins;
  final int winsNeeded;

  @override
  State<PlayerZone> createState() => _PlayerZoneState();
}

class _PlayerZoneState extends State<PlayerZone> {
  final GlobalKey<_AnimatedScoreDisplayState> _scoreKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.player.backgroundColorStart.withValues(alpha: 0.6),
            widget.player.backgroundColorEnd.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Affichage du score avec contrôles +/-
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Affichage du score avec contrôles +/-, descendu de 50 pixels
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, 50),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, 22),
                          child: _ScoreActionButton(
                            icon: Icons.remove,
                            playerColor: widget.player.color,
                            semanticsLabel: 'Diminuer le score',
                            onTap: () {
                              // Déclencher shake si on est déjà à 0
                              if (widget.score <= AppConstants.minScore) {
                                _scoreKey.currentState?.shake();
                              }
                              HapticUtils.light();
                              widget.onDecrement(1);
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
                              // Score au centre, descendu de 22 pixels avec animations
                              Transform.translate(
                                offset: const Offset(-1, 22),
                                child: Center(
                                  child: _AnimatedScoreDisplay(
                                    key: _scoreKey,
                                    score: widget.score,
                                    onScoreLongPress: widget.onScoreLongPress,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding * 2),
                        Transform.translate(
                          offset: const Offset(0, 22),
                          child: _ScoreActionButton(
                            icon: Icons.add,
                            playerColor: widget.player.color,
                            semanticsLabel: 'Augmenter le score',
                            onTap: () {
                              // Déclencher shake si on est déjà à 25
                              if (widget.score >= AppConstants.maxScore) {
                                _scoreKey.currentState?.shake();
                              }
                              HapticUtils.light();
                              widget.onIncrement(1);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Avatar dans le coin haut-gauche (cliquable)
          Positioned(
            top: AppConstants.defaultPadding,
            left: AppConstants.defaultPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nom du joueur au-dessus du portrait avec outline
                Stack(
                  children: [
                    // Outline noir
                    Text(
                      widget.player.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black,
                      ),
                    ),
                    // Texte blanc
                    Text(
                      widget.player.name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Avatar avec icônes Mickey à droite
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    GestureDetector(
                      onTap: widget.onNameTap != null
                          ? () {
                              HapticUtils.light();
                              widget.onNameTap!();
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 3.6,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 31.5,
                          backgroundColor: widget.player.color.withValues(alpha: 0.08),
                          child: ClipOval(
                            child: Image.asset(
                              widget.player.iconAssetPath,
                              width: 63,
                              height: 63,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Icônes Mickey à droite
                    if (widget.winsNeeded > 1)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: _MickeyWinsIndicator(
                          wins: widget.wins,
                          winsNeeded: widget.winsNeeded,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Expanded(
      child: widget.isRotated
          ? RotatedBox(
              quarterTurns: 2,
              child: content,
            )
          : content,
    );
  }
}

/// Widget animé pour afficher le score avec bounce et shake
class _AnimatedScoreDisplay extends StatefulWidget {
  const _AnimatedScoreDisplay({
    super.key,
    required this.score,
    this.onScoreLongPress,
  });

  final int score;
  final VoidCallback? onScoreLongPress;

  @override
  State<_AnimatedScoreDisplay> createState() => _AnimatedScoreDisplayState();
}

class _AnimatedScoreDisplayState extends State<_AnimatedScoreDisplay>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _shakeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shakeAnimation;
  int _previousScore = 0;
  int _displayedScore = 0;

  @override
  void initState() {
    super.initState();
    _previousScore = widget.score;
    _displayedScore = widget.score;

    // Animation de bounce (quand le score change)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeOutBack,
      ),
    );

    // Animation de shake (quand on atteint une limite)
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void didUpdateWidget(_AnimatedScoreDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Déclencher l'animation bounce si le score a changé
    if (widget.score != _previousScore) {
      // Ne déclencher le bounce que pour les petits changements (±1 ou ±2)
      final delta = (widget.score - _previousScore).abs();
      if (delta <= 2) {
        _bounceController.forward(from: 0.0).then((_) {
          if (mounted) {
            _bounceController.reverse();
          }
        });
      }
      _displayedScore = _previousScore; // Sauvegarder pour TweenAnimationBuilder
      _previousScore = widget.score;
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  /// Déclenche l'animation de shake (appelée depuis le parent)
  void shake() {
    _shakeController.forward(from: 0.0).then((_) {
      if (mounted) {
        _shakeController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounceController, _shakeController]),
      builder: (context, child) {
        // Calculer l'offset de shake (un seul mouvement gauche-droite-centre)
        // Utilise une fonction sinusoïdale pour un mouvement fluide
        final shakeOffset = _shakeAnimation.value *
            (1 - _shakeAnimation.value) * // Décroissance pour revenir à 0
            15 * // Amplitude max
            (_shakeAnimation.value < 0.5 ? 1 : -1); // Direction

        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Transform.translate(
            offset: Offset(shakeOffset, 0),
            child: GestureDetector(
              onLongPress: widget.onScoreLongPress != null
                  ? () {
                      HapticUtils.medium();
                      widget.onScoreLongPress!();
                    }
                  : null,
              child: TweenAnimationBuilder<int>(
                // Durée proportionnelle au delta (min 150ms, max 400ms)
                duration: Duration(
                  milliseconds: ((widget.score - _displayedScore).abs() * 30)
                      .clamp(150, 400)
                      .toInt(),
                ),
                curve: Curves.easeOut,
                tween: IntTween(begin: _displayedScore, end: widget.score),
                builder: (context, animatedScore, child) {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
                      child: Text(
                        animatedScore.toString(),
                        style: const TextStyle(
                          fontSize: 70.7,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: -4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Bouton d'action pour augmenter ou diminuer le score avec animation
class _ScoreActionButton extends StatefulWidget {
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
  State<_ScoreActionButton> createState() => _ScoreActionButtonState();
}

class _ScoreActionButtonState extends State<_ScoreActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Mélange de la couleur du joueur avec du blanc pour une teinte pastel
    final buttonColor = Color.lerp(Colors.white, widget.playerColor, 0.15);

    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: buttonColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Widget affichant les victoires avec des icônes Mickey
class _MickeyWinsIndicator extends StatelessWidget {
  const _MickeyWinsIndicator({
    required this.wins,
    required this.winsNeeded,
  });

  final int wins;
  final int winsNeeded;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(winsNeeded, (index) {
        final isWon = index < wins;
        return Padding(
          padding: EdgeInsets.only(bottom: index < winsNeeded - 1 ? 2 : 0),
          child: SvgPicture.asset(
            isWon
                ? 'assets/images/mickey-noir.svg'
                : 'assets/images/mickey-blanc.svg',
            width: 20,
            height: 20,
          ),
        );
      }),
    );
  }
}

