import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';

/// Menu radial qui s'étend autour du logo Lorcana central
class RadialMenu extends StatefulWidget {
  const RadialMenu({
    super.key,
    this.onStatisticsTap,
    this.onResetTap,
    this.onTimerTap,
    this.onSettingsTap,
    this.onDiceTap,
    this.onQuitAndSaveTap,
    this.hideCenterLogo = false,
  });

  final VoidCallback? onStatisticsTap;
  final VoidCallback? onResetTap;
  final VoidCallback? onTimerTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onDiceTap;
  final VoidCallback? onQuitAndSaveTap;
  final bool hideCenterLogo;

  @override
  State<RadialMenu> createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _liftAnimation;
  late Animation<double> _shadowAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi, // Rotation de 180° pour le logo
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animation de soulèvement (scale) - monte progressivement avec bounce
    _liftAnimation = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    // Animation de l'ombre - s'intensifie progressivement
    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 2.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    HapticUtils.medium();
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleMenuItemTap(VoidCallback? callback) {
    // Fermer le menu
    _toggleMenu();

    // Attendre que l'animation se termine avant d'appeler le callback
    Future.delayed(const Duration(milliseconds: 150), () {
      callback?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Overlay semi-transparent qui se ferme quand on clique dessus
          if (_isOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                behavior: HitTestBehavior.translucent,
                child: Container(color: AppTheme.transparentColor),
              ),
            ),

          // Boutons du menu radial (distribution égale à 60° d'intervalle)
          _buildMenuItem(
            icon: Icons.bar_chart,
            angle: -math.pi / 2, // Haut (270°)
            color: AppTheme.menuStatsColor,
            label: 'Stats',
            onTap: widget.onStatisticsTap != null
                ? () => _handleMenuItemTap(widget.onStatisticsTap)
                : null,
          ),
          _buildMenuItem(
            icon: Icons.casino,
            angle: -math.pi / 6, // Haut-droite (300°)
            color: AppTheme.secondaryColor,
            label: 'Dés',
            onTap: widget.onDiceTap != null
                ? () => _handleMenuItemTap(widget.onDiceTap)
                : null,
          ),
          _buildMenuItem(
            icon: Icons.refresh,
            angle: math.pi / 6, // Bas-droite (30°)
            color: AppTheme.menuResetColor,
            label: 'Reset',
            onTap: widget.onResetTap != null
                ? () => _handleMenuItemTap(widget.onResetTap)
                : null,
          ),
          _buildMenuItem(
            icon: Icons.timer,
            angle: math.pi / 2, // Bas (90°)
            color: AppTheme.menuTimerColor,
            label: 'Time',
            onTap: widget.onTimerTap != null
                ? () => _handleMenuItemTap(widget.onTimerTap)
                : null,
          ),
          _buildMenuItem(
            icon: Icons.exit_to_app,
            angle: 5 * math.pi / 6, // Bas-gauche (150°)
            color: AppTheme.warningColor,
            label: 'Quitter',
            onTap: widget.onQuitAndSaveTap != null
                ? () => _handleMenuItemTap(widget.onQuitAndSaveTap)
                : null,
          ),
          _buildMenuItem(
            icon: Icons.settings,
            angle: 7 * math.pi / 6, // Haut-gauche (210°)
            color: AppTheme.menuHistoryColor,
            label: 'Paramètres',
            onTap: widget.onSettingsTap != null
                ? () => _handleMenuItemTap(widget.onSettingsTap)
                : null,
          ),

          // Logo Lorcana au centre (bouton principal)
          // Caché quand le mode Time est actif (le TimeOverlay affiche son propre logo)
          if (!widget.hideCenterLogo)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _liftAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: GestureDetector(
                      onTap: _toggleMenu,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3 * _shadowAnimation.value),
                              blurRadius: 12 * _shadowAnimation.value,
                              spreadRadius: 2 * _shadowAnimation.value,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/lorcana_logo.png',
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required double angle,
    required Color color,
    required String label,
    VoidCallback? onTap,
  }) {
    // Distance du centre (rayon)
    const radius = 100.0;

    // Calculer la position x, y à partir de l'angle
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
              child: _MenuButton(
                icon: icon,
                color: color,
                label: label,
                onTap: onTap,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Bouton individuel du menu radial
class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.color,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: () {
        if (isEnabled) {
          HapticUtils.light();
          onTap?.call();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isEnabled ? color : Colors.grey,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
