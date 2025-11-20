import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';

/// Menu radial qui s'étend autour du logo Lorcana central
class RadialMenu extends StatefulWidget {
  const RadialMenu({
    super.key,
    this.onStatisticsTap,
    this.onResetTap,
    this.onTimerTap,
    this.onHistoryTap,
  });

  final VoidCallback? onStatisticsTap;
  final VoidCallback? onResetTap;
  final VoidCallback? onTimerTap;
  final VoidCallback? onHistoryTap;

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
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi * 2, // Rotation complète de 360° pour un effet plus dynamique
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    // Animation de soulèvement plus légère et fluide
    _liftAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    // Animation de l'ombre plus subtile
    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
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

          // Boutons du menu radial
          _buildMenuItem(
            icon: Icons.bar_chart,
            angle: -math.pi / 2, // Haut (90°)
            color: AppTheme.menuStatsColor,
            label: 'Stats',
            onTap: widget.onStatisticsTap != null
                ? () => _handleMenuItemTap(widget.onStatisticsTap)
                : null,
          ),
          _buildMenuItem(
            icon: Icons.refresh,
            angle: 0, // Droite (0°)
            color: AppTheme.menuResetColor,
            label: 'Reset',
            onTap: widget.onResetTap != null
                ? () => _handleMenuItemTap(widget.onResetTap)
                : null,
          ),
          _buildMenuItem(
            icon: Icons.timer,
            angle: math.pi / 2, // Bas (270°)
            color: AppTheme.menuTimerColor,
            label: 'Timer',
            onTap: widget.onTimerTap != null
                ? () => _handleMenuItemTap(widget.onTimerTap)
                : null,
          ),
          _buildMenuItem(
            icon: Icons.history,
            angle: math.pi, // Gauche (180°)
            color: AppTheme.menuHistoryColor,
            label: 'Historique',
            onTap: widget.onHistoryTap != null
                ? () => _handleMenuItemTap(widget.onHistoryTap)
                : null,
          ),

          // Logo Lorcana au centre (bouton principal)
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
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white,
                            Colors.grey.shade100,
                          ],
                          stops: const [0.7, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2 * _shadowAnimation.value),
                            blurRadius: 10 * _shadowAnimation.value,
                            spreadRadius: 1 * _shadowAnimation.value,
                          ),
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.15 * _shadowAnimation.value),
                            blurRadius: 15 * _shadowAnimation.value,
                            spreadRadius: 2 * _shadowAnimation.value,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/images/lorcana_logo.svg',
                          fit: BoxFit.contain,
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
    // Distance du centre (rayon) légèrement augmentée pour plus d'espace
    const radius = 105.0;

    // Calculer la position x, y à partir de l'angle
    final x = radius * math.cos(angle);
    final y = radius * math.sin(angle);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = _scaleAnimation.value;
        final offsetX = x * scale;
        final offsetY = y * scale;

        // Animation d'opacité plus progressive
        final opacity = (scale * 1.2).clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
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
class _MenuButton extends StatefulWidget {
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
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onTap != null;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (isEnabled) {
                setState(() => _isPressed = true);
                _hoverController.forward();
              }
            },
            onTapUp: (_) {
              if (isEnabled) {
                setState(() => _isPressed = false);
                _hoverController.reverse();
              }
            },
            onTapCancel: () {
              if (isEnabled) {
                setState(() => _isPressed = false);
                _hoverController.reverse();
              }
            },
            onTap: () {
              if (isEnabled) {
                HapticUtils.light();
                widget.onTap?.call();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: isEnabled
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.color,
                              widget.color.withValues(alpha: 0.8),
                            ],
                          )
                        : LinearGradient(
                            colors: [Colors.grey.shade400, Colors.grey.shade500],
                          ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                      if (isEnabled && _isPressed)
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
