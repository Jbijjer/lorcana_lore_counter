import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget du mode Time qui s'affiche au centre sans bloquer les zones de joueurs
class TimeOverlay extends StatefulWidget {
  const TimeOverlay({
    required this.timeCount,
    required this.onIncrement,
    required this.onDecrement,
    required this.onConfirmDraw,
    required this.onCancel,
    super.key,
  });

  final int timeCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onConfirmDraw;
  final VoidCallback onCancel;

  @override
  State<TimeOverlay> createState() => _TimeOverlayState();
}

class _TimeOverlayState extends State<TimeOverlay>
    with TickerProviderStateMixin {
  late AnimationController _growController;
  late AnimationController _flipController;
  late AnimationController _menuController;
  late Animation<double> _growAnimation;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  bool _showMenu = false;
  bool _hasFlipped = false;

  @override
  void initState() {
    super.initState();

    // Animation de grandissement du logo
    _growController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _growAnimation = Tween<double>(
      begin: 88.0,
      end: 120.0,
    ).animate(CurvedAnimation(
      parent: _growController,
      curve: Curves.easeOut,
    ));

    // Animation de flip du logo
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: math.pi, // 180 degrés
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    // Animation du menu radial
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOut,
    );

    // Séquence d'animations : grow -> flip -> menu
    _growController.forward().then((_) {
      if (mounted) {
        _flipController.forward().then((_) {
          if (mounted) {
            setState(() {
              _showMenu = true;
              _hasFlipped = true;
            });
            _menuController.forward();
          }
        });
      }
    });

    HapticUtils.medium();
  }

  @override
  void dispose() {
    _growController.dispose();
    _flipController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _handleIncrement() {
    if (widget.timeCount < 5) {
      HapticUtils.light();
      widget.onIncrement();
    }
  }

  void _handleDecrement() {
    if (widget.timeCount > 0) {
      HapticUtils.light();
      widget.onDecrement();
    }
  }

  void _handleConfirmDraw() {
    HapticUtils.success();
    widget.onConfirmDraw();
  }

  void _handleCancel() {
    HapticUtils.medium();
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDrawState = widget.timeCount == 0;

    // En état Nulle, on bloque tout l'écran
    // Sinon, on laisse les zones de joueurs accessibles
    if (isDrawState) {
      return _buildFullScreenOverlay();
    } else {
      return _buildCenterOnlyWidget();
    }
  }

  /// Overlay plein écran pour l'état Nulle (bloque les interactions)
  Widget _buildFullScreenOverlay() {
    return Stack(
      children: [
        // Fond semi-transparent
        Positioned.fill(
          child: Container(
            color: AppTheme.pureBlack.withValues(alpha: 0.7),
          ),
        ),

        // Compteur et boutons au centre
        Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Boutons Oui/Non en état Nulle
                if (_showMenu) ...[
                  _buildMenuButton(
                    label: 'Oui',
                    angle: math.pi / 2, // Bas
                    color: AppTheme.successColor,
                    onTap: _handleConfirmDraw,
                  ),
                  _buildMenuButton(
                    label: 'Non',
                    angle: -math.pi / 2, // Haut
                    color: AppTheme.errorColor,
                    onTap: _handleCancel,
                  ),
                ],

                // Compteur au centre
                _buildCounterDisplay(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Widget central seulement (permet les interactions avec les zones de joueurs)
  Widget _buildCenterOnlyWidget() {
    return Stack(
      children: [
        // Fond transparent qui laisse passer les clics
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),

        // Compteur et boutons au centre uniquement
        Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Boutons +/- (si menu visible)
                if (_showMenu) ...[
                  // Bouton -
                  _buildControlButton(
                    label: '-',
                    angle: math.pi, // Gauche
                    color: AppTheme.errorColor,
                    onTap: _handleDecrement,
                    isEnabled: widget.timeCount > 0,
                  ),
                  // Bouton +
                  _buildControlButton(
                    label: '+',
                    angle: 0, // Droite
                    color: AppTheme.successColor,
                    onTap: _handleIncrement,
                    isEnabled: widget.timeCount < 5,
                  ),
                ],

                // Logo/Compteur au centre avec animation de flip
                // Cliquer dessus annule le Time pour accéder au menu radial
                GestureDetector(
                  onTap: _handleCancel,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      final showFront = _flipAnimation.value < math.pi / 2;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(_flipAnimation.value),
                        child: showFront
                            ? _buildLogo()
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateX(math.pi),
                                child: _buildCounterDisplay(),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _growAnimation,
      builder: (context, child) {
        final size = _growAnimation.value;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.pureBlack.withValues(alpha: 0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/lorcana_logo.png',
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCounterDisplay() {
    final bool isDrawState = widget.timeCount == 0;
    final displayText = isDrawState ? 'Nulle?' : '${widget.timeCount}';

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isDrawState ? AppTheme.warningColor : AppTheme.secondaryColor)
                .withValues(alpha: 0.6),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Image du jeton multicolore
          ClipOval(
            child: Image.asset(
              'assets/images/jeton_multicolor.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          // Texte du compteur par-dessus
          Text(
            displayText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.pureWhite,
              fontSize: isDrawState ? 20 : 48,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: AppTheme.pureBlack.withValues(alpha: 0.8),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
                Shadow(
                  color: AppTheme.pureBlack.withValues(alpha: 0.5),
                  offset: const Offset(0, 0),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String label,
    required double angle,
    required Color color,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    const radius = 100.0;
    final x = radius * math.cos(angle);
    final y = radius * math.sin(angle);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = _scaleAnimation.value;
        final offsetX = x * scale;
        final offsetY = y * scale;

        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: (isEnabled ? 1.0 : 0.5) * scale.clamp(0.0, 1.0),
              child: GestureDetector(
                onTap: isEnabled ? onTap : null,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isEnabled ? color : Colors.grey,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.pureBlack.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: AppTheme.pureWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuButton({
    required String label,
    required double angle,
    required Color color,
    required VoidCallback onTap,
  }) {
    const radius = 120.0;
    final x = radius * math.cos(angle);
    final y = radius * math.sin(angle);

    final imageAsset = label == 'Oui'
        ? 'assets/images/jeton_vert.png'
        : 'assets/images/jeton_rouge.png';

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = _scaleAnimation.value;
        final offsetX = x * scale;
        final offsetY = y * scale;

        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: scale.clamp(0.0, 1.0),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.pureBlack.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          imageAsset,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        label,
                        style: TextStyle(
                          color: AppTheme.pureWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: AppTheme.pureBlack.withValues(alpha: 0.8),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                            Shadow(
                              color: AppTheme.pureBlack.withValues(alpha: 0.5),
                              offset: const Offset(0, 0),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
