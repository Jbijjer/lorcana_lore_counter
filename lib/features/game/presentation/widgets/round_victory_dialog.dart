import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/player.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';

/// Dialog de victoire de manche avec portrait du joueur
class RoundVictoryDialog extends StatefulWidget {
  const RoundVictoryDialog({
    required this.winner,
    required this.loser,
    required this.isMatchComplete,
    required this.winnerWins,
    required this.loserWins,
    this.previousPlayer1DeckColors = const [],
    this.previousPlayer2DeckColors = const [],
    this.isPlayer1Winner = true,
    super.key,
  });

  final Player winner;
  final Player loser;
  final bool isMatchComplete;
  final int winnerWins;
  final int loserWins;
  final List<String> previousPlayer1DeckColors;
  final List<String> previousPlayer2DeckColors;
  final bool isPlayer1Winner;

  @override
  State<RoundVictoryDialog> createState() => _RoundVictoryDialogState();
}

class _RoundVictoryDialogState extends State<RoundVictoryDialog>
    with TickerProviderStateMixin, DialogAnimationsMixin {
  late AnimationController _confettiController;
  late TextEditingController _noteController;

  // Couleur et image de victoire aléatoires
  late String _victoryImageName;
  late Color _victoryColor;

  // Couleurs de deck sélectionnées
  late List<String> _player1DeckColors;
  late List<String> _player2DeckColors;

  // Qui a commencé cette partie (1 ou 2, null si non sélectionné)
  int? _firstToPlay;

  // Map des couleurs disponibles pour l'image de victoire
  static const Map<String, Color> _colorMap = {
    'bleu': Colors.blue,
    'gris': Colors.grey,
    'jaune': Colors.amber,
    'mauve': Colors.purple,
    'rouge': Colors.red,
    'vert': Colors.green,
  };

  // Couleurs de deck Lorcana
  static const List<LorcanaDeckColor> _lorcanaColors = [
    LorcanaDeckColor(name: 'Ambre', color: Color(0xFFFFC107)),
    LorcanaDeckColor(name: 'Améthyste', color: Color(0xFF9C27B0)),
    LorcanaDeckColor(name: 'Émeraude', color: Color(0xFF4CAF50)),
    LorcanaDeckColor(name: 'Rubis', color: Color(0xFFE53935)),
    LorcanaDeckColor(name: 'Saphir', color: Color(0xFF2196F3)),
    LorcanaDeckColor(name: 'Acier', color: Color(0xFF9E9E9E)),
  ];

  @override
  void initState() {
    super.initState();
    initDialogAnimations();

    // Initialiser le contrôleur de texte pour la note
    _noteController = TextEditingController();

    // Initialiser les couleurs de deck avec les valeurs précédentes
    _player1DeckColors = List.from(widget.previousPlayer1DeckColors);
    _player2DeckColors = List.from(widget.previousPlayer2DeckColors);

    // Sélection aléatoire d'une couleur
    final random = math.Random();
    final colorKeys = _colorMap.keys.toList();
    _victoryImageName = colorKeys[random.nextInt(colorKeys.length)];
    _victoryColor = _colorMap[_victoryImageName]!;

    // Animation des confettis (une seule fois, plus lente)
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..forward();

    HapticUtils.success();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _confettiController.dispose();
    disposeDialogAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: _victoryColor,
        maxWidth: 400,
        child: Stack(
          children: [
            // Contenu principal
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image de victoire
                  SizedBox(
                    height: 120,
                    child: Image.asset(
                      'assets/images/victoire_$_victoryImageName.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Portrait du joueur
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Halo de lumière
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.winner.color.withValues(alpha: 0.4),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),

                      // Portrait avec gradient
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.winner.backgroundColorStart,
                              widget.winner.backgroundColorEnd,
                            ],
                          ),
                          border: Border.all(
                            color: _victoryColor,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _victoryColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            widget.winner.iconAssetPath,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Champ de note
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: 'Note de la partie',
                      hintText: 'Ex: Bonne partie...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                  ),

                  const SizedBox(height: 16),

                  // Sélection des couleurs de deck
                  _buildDeckColorsSelection(),

                  // Sélection de qui a commencé la partie
                  const SizedBox(height: 16),
                  _buildFirstToPlaySelector(),

                  const SizedBox(height: 20),

                  // Bouton principal avec effet shimmer
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Le bouton
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              HapticUtils.light();
                              Navigator.of(context).pop({
                                'note': _noteController.text.trim().isEmpty
                                    ? null
                                    : _noteController.text.trim(),
                                'player1DeckColors': _player1DeckColors,
                                'player2DeckColors': _player2DeckColors,
                                'firstToPlay': _firstToPlay,
                              });
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: _victoryColor,
                              foregroundColor: AppTheme.pureWhite,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 8,
                              shadowColor: _victoryColor.withValues(alpha: 0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.isMatchComplete
                                      ? Icons.refresh
                                      : Icons.arrow_forward,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.isMatchComplete
                                      ? 'Nouvelle Partie'
                                      : 'Manche Suivante',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Effet shimmer sur le bouton
                        SimpleShimmerEffect(
                          animationValue: shimmerController.value,
                          borderRadius: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Confettis au premier plan
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _confettiController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _ConfettiPainter(
                        animationValue: _confettiController.value,
                        color: _victoryColor,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Sparkles overlay
            Positioned.fill(
              child: IgnorePointer(
                child: SparklesOverlay(
                  controller: shimmerController,
                  color: _victoryColor,
                  sparkleCount: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeckColorsSelection() {
    return Column(
      children: [
        // Ligne pour le gagnant
        _buildPlayerColorRow(
          playerName: widget.winner.name,
          deckColors: widget.isPlayer1Winner ? _player1DeckColors : _player2DeckColors,
          isPlayer1: widget.isPlayer1Winner,
          isWinner: true,
        ),
        const SizedBox(height: 8),
        // Ligne pour le perdant
        _buildPlayerColorRow(
          playerName: widget.loser.name,
          deckColors: widget.isPlayer1Winner ? _player2DeckColors : _player1DeckColors,
          isPlayer1: !widget.isPlayer1Winner,
          isWinner: false,
        ),
      ],
    );
  }

  Widget _buildPlayerColorRow({
    required String playerName,
    required List<String> deckColors,
    required bool isPlayer1,
    required bool isWinner,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isWinner ? _victoryColor.withValues(alpha: 0.15) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWinner ? _victoryColor : Colors.grey[300]!,
          width: isWinner ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          if (isWinner) ...[
            Icon(
              Icons.emoji_events,
              color: _victoryColor,
              size: 20,
            ),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              playerName,
              style: TextStyle(
                fontWeight: isWinner ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
                color: isWinner ? _victoryColor : Colors.grey[600],
              ),
            ),
          ),
          // Deux carrés de couleurs
          _buildColorSquare(
            colorName: deckColors.isNotEmpty ? deckColors[0] : null,
            onTap: () => _showColorPicker(isPlayer1, 0),
          ),
          const SizedBox(width: 8),
          _buildColorSquare(
            colorName: deckColors.length > 1 ? deckColors[1] : null,
            onTap: () => _showColorPicker(isPlayer1, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSquare({String? colorName, required VoidCallback onTap}) {
    final Color? color = colorName != null
        ? _lorcanaColors.firstWhere((c) => c.name == colorName).color
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color != null ? Colors.white : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: color == null
            ? Icon(Icons.add, color: Colors.grey[600], size: 20)
            : null,
      ),
    );
  }

  Future<void> _showColorPicker(bool isPlayer1, int colorIndex) async {
    final colors = isPlayer1 ? _player1DeckColors : _player2DeckColors;

    final selectedColor = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une couleur'),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _lorcanaColors.map((lorcanaColor) {
            final isSelected = colors.contains(lorcanaColor.name);
            return InkWell(
              onTap: () {
                HapticUtils.light();
                Navigator.of(context).pop(lorcanaColor.name);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: lorcanaColor.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.white,
                    width: isSelected ? 3 : 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 30)
                    : null,
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticUtils.light();
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
        ],
      ),
    );

    if (selectedColor != null) {
      setState(() {
        if (colorIndex < colors.length) {
          colors[colorIndex] = selectedColor;
        } else {
          colors.add(selectedColor);
        }
      });
    }
  }

  Widget _buildFirstToPlaySelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flag,
                size: 18,
                color: _victoryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Qui a commencé la partie ?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFirstToPlayButton(
                  player: widget.isPlayer1Winner ? widget.winner : widget.loser,
                  playerNumber: 1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFirstToPlayButton(
                  player: widget.isPlayer1Winner ? widget.loser : widget.winner,
                  playerNumber: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFirstToPlayButton({
    required Player player,
    required int playerNumber,
  }) {
    final isSelected = _firstToPlay == playerNumber;
    final accentColor = playerNumber == 1 ? AppTheme.amberColor : AppTheme.sapphireColor;

    return InkWell(
      onTap: () {
        HapticUtils.light();
        setState(() {
          if (_firstToPlay == playerNumber) {
            _firstToPlay = null;
          } else {
            _firstToPlay = playerNumber;
          }
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor,
                    accentColor.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  player.iconAssetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                player.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LorcanaDeckColor {
  final String name;
  final Color color;

  const LorcanaDeckColor({
    required this.name,
    required this.color,
  });
}

/// Painter pour les têtes de Mickey qui tombent
class _ConfettiPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _ConfettiPainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Dessiner des têtes de Mickey multicolores
    for (int i = 0; i < 25; i++) {
      // Seed unique pour chaque confetti
      final confettiRandom = math.Random(42 + i * 789);

      final offsetX = size.width * confettiRandom.nextDouble();

      // Délai de départ pour chaque confetti (0.0 à 0.4 de l'animation)
      final startDelay = confettiRandom.nextDouble() * 0.4;

      // Temps effectif d'animation pour ce confetti
      final effectiveAnimation = (animationValue - startDelay).clamp(0.0, 1.0);

      // Position de départ
      final startY = -50 - (confettiRandom.nextDouble() * 200);

      // Vitesse plus lente pour chaque confetti (entre 0.7x et 1.0x)
      final speedFactor = 0.7 + (confettiRandom.nextDouble() * 0.3);
      // Distance totale pour garantir que tous les confettis sortent de l'écran
      final currentY = startY + (size.height + 500) * effectiveAnimation * speedFactor;

      // Calculer l'opacité avec fade in au départ et fade out à la fin
      double opacity = 0.8;

      // Fade in au début de l'animation de ce confetti
      if (effectiveAnimation < 0.1) {
        opacity = 0.8 * (effectiveAnimation / 0.1);
      }

      // Fade out seulement une fois en dehors de l'écran visible
      final fadeStart = size.height + 100;
      if (currentY > fadeStart) {
        final fadeEnd = size.height + 400;
        final fadeProgress = (currentY - fadeStart) / (fadeEnd - fadeStart);
        opacity *= (1.0 - fadeProgress.clamp(0.0, 1.0));
      }

      // Skip seulement si complètement transparent ou très loin en dehors
      if (opacity <= 0.0 || currentY > size.height + 500) continue;

      // Couleurs multicolores variées
      final colors = [
        color,
        Colors.amber,
        Colors.blue,
        Colors.pink,
        Colors.purple,
        Colors.red,
        Colors.orange,
        Colors.cyan,
        Colors.teal,
        Colors.lime,
      ];
      paint.color = colors[i % colors.length].withValues(alpha: opacity);

      // Rotation légère
      final rotation = (animationValue + (i * 0.1)) * math.pi * 2;

      // Taille de la tête de Mickey
      final mickeySize = 12 + (confettiRandom.nextDouble() * 8);
      final headRadius = mickeySize / 2;
      final earRadius = headRadius * 0.6;

      canvas.save();
      canvas.translate(offsetX, currentY);
      canvas.rotate(rotation);

      // Dessiner la tête de Mickey (3 cercles)
      // Oreille gauche
      canvas.drawCircle(
        Offset(-headRadius * 0.6, -headRadius * 0.6),
        earRadius,
        paint,
      );

      // Oreille droite
      canvas.drawCircle(
        Offset(headRadius * 0.6, -headRadius * 0.6),
        earRadius,
        paint,
      );

      // Tête principale
      canvas.drawCircle(
        Offset.zero,
        headRadius,
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}
