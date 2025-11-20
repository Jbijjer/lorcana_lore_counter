import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Overlay de victoire qui apparaît quand un joueur atteint 20 points
class VictoryOverlay extends StatefulWidget {
  const VictoryOverlay({
    required this.isPlayer1,
    required this.onConfirm,
    required this.onDecline,
    super.key,
  });

  final bool isPlayer1;
  final VoidCallback onConfirm;
  final VoidCallback onDecline;

  @override
  State<VictoryOverlay> createState() => _VictoryOverlayState();
}

class _VictoryOverlayState extends State<VictoryOverlay>
    with TickerProviderStateMixin {
  late AnimationController _growController;
  late AnimationController _flipController;
  late AnimationController _menuController;
  late Animation<double> _growAnimation;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  bool _showMenu = false;

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
          // Afficher immédiatement les boutons après le flip
          if (mounted) {
            setState(() {
              _showMenu = true;
            });
            _menuController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _growController.dispose();
    _flipController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _handleVictoryTap() {
    HapticUtils.medium();
    setState(() {
      _showMenu = true;
    });
    _menuController.forward();
  }

  void _handleConfirm() {
    HapticUtils.success();
    widget.onConfirm();
  }

  void _handleDecline() {
    HapticUtils.medium();
    widget.onDecline();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fond semi-transparent
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.7),
          ),
        ),

        // Logo et texte au centre
        Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Menu radial (si activé)
                if (_showMenu) ...[
                  _buildMenuButton(
                    label: 'Oui',
                    angle: widget.isPlayer1 ? math.pi / 2 : -math.pi / 2,
                    color: Colors.green,
                    onTap: _handleConfirm,
                  ),
                  _buildMenuButton(
                    label: 'Non',
                    angle: widget.isPlayer1 ? -math.pi / 2 : math.pi / 2,
                    color: Colors.red,
                    onTap: _handleDecline,
                  ),
                ],

                // Logo au centre avec animation de flip
                AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    // Déterminer si on affiche le logo ou le texte "Victoire?"
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
                              transform: Matrix4.identity()
                                ..rotateX(math.pi),
                              child: _buildVictoryText(),
                            ),
                    );
                  },
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
                color: Colors.black.withValues(alpha: 0.5),
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

  Widget _buildVictoryText() {
    return GestureDetector(
      onTap: _showMenu ? _handleDecline : _handleVictoryTap,
      child: Transform.rotate(
        angle: widget.isPlayer1 ? math.pi : 0,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.6),
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
              // Texte "Victoire?" par-dessus
              Text(
                'Victoire?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
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
                child: Transform.rotate(
                  angle: widget.isPlayer1 ? math.pi : 0,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
}
