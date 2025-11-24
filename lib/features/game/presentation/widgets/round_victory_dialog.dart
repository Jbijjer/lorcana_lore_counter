import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/player.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';
import 'deck_color_picker_dialog.dart';
import 'game_note_input_dialog.dart';

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

  // Note de la partie
  String _note = '';

  // Couleur et image de victoire aléatoires
  late String _victoryImageName;
  late Color _victoryColor;

  // Seed aléatoire pour les confettis (différent à chaque ouverture)
  late int _confettiSeed;

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


  @override
  void initState() {
    super.initState();
    initDialogAnimations();

    // Initialiser les couleurs de deck avec les valeurs précédentes
    _player1DeckColors = List.from(widget.previousPlayer1DeckColors);
    _player2DeckColors = List.from(widget.previousPlayer2DeckColors);

    // Sélectionner le gagnant comme premier joueur par défaut
    _firstToPlay = widget.isPlayer1Winner ? 1 : 2;

    // Sélection aléatoire d'une couleur et seed pour les confettis
    final random = math.Random();
    final colorKeys = _colorMap.keys.toList();
    _victoryImageName = colorKeys[random.nextInt(colorKeys.length)];
    _victoryColor = _colorMap[_victoryImageName]!;
    _confettiSeed = random.nextInt(10000);

    // Animation des confettis (une seule fois)
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..forward();

    HapticUtils.success();
  }

  @override
  void dispose() {
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
        ignoreKeyboardInsets: true,
        child: Stack(
          children: [
            // Contenu principal
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Texte de victoire stylisé avec glow et sparkles
                  _buildVictoryText(),

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
                          child: _buildWinnerPortrait(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Zone de note cliquable
                  _buildNoteInputZone(),

                  const SizedBox(height: 16),

                  // Sélection des couleurs de deck (tap pour indiquer qui a commencé)
                  _buildDeckColorsSelection(),

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
                                'note': _note.isEmpty ? null : _note,
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
                        seed: _confettiSeed,
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

  Widget _buildVictoryText() {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkles autour du texte
          Positioned.fill(
            child: SparklesOverlay(
              controller: shimmerController,
              color: _victoryColor,
              sparkleCount: 8,
            ),
          ),
          // Texte avec outline et gradient
          Stack(
            children: [
              // Outline noir épais
              Text(
                'Victoire !',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = AppTheme.pureBlack,
                  shadows: [
                    Shadow(
                      color: AppTheme.pureBlack.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              // Texte avec gradient de couleur
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _victoryColor,
                      Color.lerp(_victoryColor, AppTheme.pureWhite, 0.3)!,
                      _victoryColor,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ).createShader(bounds);
                },
                child: Text(
                  'Victoire !',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.pureWhite,
                    shadows: [
                      Shadow(
                        color: _victoryColor.withValues(alpha: 0.8),
                        blurRadius: 20,
                      ),
                      Shadow(
                        color: _victoryColor.withValues(alpha: 0.5),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInputZone() {
    final colorScheme = Theme.of(context).colorScheme;
    final hasNote = _note.isNotEmpty;

    // Aperçu tronqué de la note (max 30 caractères)
    String displayText;
    if (hasNote) {
      displayText = _note.length > 30 ? '${_note.substring(0, 30)}...' : _note;
    } else {
      displayText = 'Ajouter une note...';
    }

    return InkWell(
      onTap: _showNoteDialog,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasNote ? _victoryColor.withValues(alpha: 0.5) : colorScheme.outlineVariant,
            width: hasNote ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasNote ? Icons.edit_note : Icons.note_add_outlined,
              color: hasNote ? _victoryColor : colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  color: hasNote ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontStyle: hasNote ? FontStyle.normal : FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNoteDialog() async {
    HapticUtils.light();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => GameNoteInputDialog(
        initialNote: _note,
        accentColor: _victoryColor,
      ),
    );

    if (result != null) {
      setState(() {
        _note = result;
      });
    }
  }

  Widget _buildDeckColorsSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indication pour sélectionner qui a commencé
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(Icons.touch_app, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                'Tap = premier joueur',
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // Ligne pour le gagnant
        _buildPlayerColorRow(
          playerName: widget.winner.name,
          deckColors: widget.isPlayer1Winner ? _player1DeckColors : _player2DeckColors,
          isPlayer1: widget.isPlayer1Winner,
          isWinner: true,
          playerNumber: widget.isPlayer1Winner ? 1 : 2,
        ),
        const SizedBox(height: 8),
        // Ligne pour le perdant
        _buildPlayerColorRow(
          playerName: widget.loser.name,
          deckColors: widget.isPlayer1Winner ? _player2DeckColors : _player1DeckColors,
          isPlayer1: !widget.isPlayer1Winner,
          isWinner: false,
          playerNumber: widget.isPlayer1Winner ? 2 : 1,
        ),
      ],
    );
  }

  Widget _buildPlayerColorRow({
    required String playerName,
    required List<String> deckColors,
    required bool isPlayer1,
    required bool isWinner,
    required int playerNumber,
  }) {
    final isFirstToPlay = _firstToPlay == playerNumber;

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
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Encadré du joueur (pleine largeur)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isWinner ? _victoryColor.withValues(alpha: 0.15) : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isWinner ? _victoryColor : (isFirstToPlay ? AppTheme.amberColor : Theme.of(context).colorScheme.outlineVariant),
                width: (isWinner || isFirstToPlay) ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    playerName,
                    style: TextStyle(
                      fontWeight: (isWinner || isFirstToPlay) ? FontWeight.bold : FontWeight.w600,
                      fontSize: 14,
                      color: isWinner ? _victoryColor : (isFirstToPlay ? AppTheme.amberColor : Theme.of(context).colorScheme.onSurfaceVariant),
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
          ),
          // Icônes qui dépassent dans la marge gauche
          if (isWinner || isFirstToPlay)
            Positioned(
              left: -20,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isWinner)
                      Icon(
                        Icons.emoji_events,
                        color: _victoryColor,
                        size: 18,
                      ),
                    if (isFirstToPlay)
                      Icon(
                        Icons.flag,
                        color: AppTheme.amberColor,
                        size: 16,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColorSquare({String? colorName, required VoidCallback onTap}) {
    final Color? color = colorName != null
        ? lorcanaColors.firstWhere((c) => c.name == colorName).color
        : null;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color ?? colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color != null ? colorScheme.surface : colorScheme.outlineVariant,
            width: 2,
          ),
        ),
        child: color == null
            ? Icon(Icons.add, color: colorScheme.onSurfaceVariant, size: 20)
            : null,
      ),
    );
  }

  Future<void> _showColorPicker(bool isPlayer1, int colorIndex) async {
    final colors = isPlayer1 ? _player1DeckColors : _player2DeckColors;

    final selectedColor = await showDialog<String>(
      context: context,
      builder: (context) => DeckColorPickerDialog(
        accentColor: _victoryColor,
        selectedColors: colors,
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

  Widget _buildWinnerPortrait() {
    // Priorité au portrait personnalisé
    if (widget.winner.customPortraitPath != null &&
        widget.winner.customPortraitPath!.isNotEmpty) {
      return Image.file(
        File(widget.winner.customPortraitPath!),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback vers l'icône si le fichier n'existe plus
          return Image.asset(
            widget.winner.iconAssetPath,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          );
        },
      );
    }

    // Sinon, utiliser l'icône
    return Image.asset(
      widget.winner.iconAssetPath,
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    );
  }

}

/// Painter pour les têtes de Mickey qui tombent
class _ConfettiPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final int seed;

  _ConfettiPainter({
    required this.animationValue,
    required this.color,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Dessiner des têtes de Mickey multicolores
    for (int i = 0; i < 25; i++) {
      // Seed unique pour chaque confetti (basé sur le seed aléatoire du dialog)
      final confettiRandom = math.Random(seed + i * 789);

      final offsetX = size.width * confettiRandom.nextDouble();

      // Délai de départ pour chaque confetti (0.0 à 0.4 de l'animation)
      final startDelay = confettiRandom.nextDouble() * 0.4;

      // Temps effectif d'animation pour ce confetti
      final effectiveAnimation = (animationValue - startDelay).clamp(0.0, 1.0);

      // Position de départ
      final startY = -50 - (confettiRandom.nextDouble() * 200);

      // Vitesse pour chaque confetti (entre 1.64x et 2.27x)
      final speedFactor = 1.64 + (confettiRandom.nextDouble() * 0.63);
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
