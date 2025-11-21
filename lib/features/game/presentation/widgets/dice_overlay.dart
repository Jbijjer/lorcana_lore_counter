import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';

/// Overlay qui affiche 2 dés à 6 faces avec animation de lancer
class DiceOverlay extends StatefulWidget {
  const DiceOverlay({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  State<DiceOverlay> createState() => _DiceOverlayState();
}

class _DiceOverlayState extends State<DiceOverlay>
    with TickerProviderStateMixin {
  late AnimationController _rollController;
  late AnimationController _scaleController;

  int _dice1Value = 1;
  int _dice2Value = 1;
  bool _isRolling = false;

  final _random = math.Random();

  @override
  void initState() {
    super.initState();

    _rollController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Lancer les dés automatiquement au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rollDice();
    });
  }

  @override
  void dispose() {
    _rollController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  /// Lance les dés avec animation
  Future<void> _rollDice() async {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
    });

    HapticUtils.medium();

    // Animation de rotation
    await _rollController.forward(from: 0);

    // Générer les valeurs finales
    setState(() {
      _dice1Value = _random.nextInt(6) + 1;
      _dice2Value = _random.nextInt(6) + 1;
      _isRolling = false;
    });

    // Animation de "pop" à la fin
    HapticUtils.light();
    await _scaleController.forward(from: 0);
    await _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.85),
      child: Stack(
        children: [
          // Tap anywhere to close
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onClose,
              behavior: HitTestBehavior.opaque,
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Text(
                    '🎲 Lancer de dés',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Les deux dés
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDice(_dice1Value, 0),
                    const SizedBox(width: 32),
                    _buildDice(_dice2Value, 1),
                  ],
                ),

                const SizedBox(height: 48),

                // Total
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Total: ${_dice1Value + _dice2Value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Relancer button
                    _buildButton(
                      label: 'Relancer',
                      icon: Icons.refresh,
                      color: AppTheme.menuResetColor,
                      onTap: _isRolling ? null : _rollDice,
                    ),
                    const SizedBox(width: 16),
                    // Fermer button
                    _buildButton(
                      label: 'Fermer',
                      icon: Icons.close,
                      color: AppTheme.menuHistoryColor,
                      onTap: widget.onClose,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDice(int value, int index) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rollController, _scaleController]),
      builder: (context, child) {
        // Rotation pendant le lancer
        final rotation = _isRolling
            ? _rollController.value * math.pi * 8
            : 0.0;

        // Scale "pop" à la fin
        final scale = 1.0 + (_scaleController.value * 0.2);

        return Transform.scale(
          scale: scale,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateX(rotation)
              ..rotateY(rotation),
            alignment: Alignment.center,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Center(
                child: _buildDiceFace(value),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiceFace(int value) {
    // Créer les points du dé selon la valeur
    return LayoutBuilder(
      builder: (context, constraints) {
        final dotSize = 14.0;
        final spacing = constraints.maxWidth / 4;

        Widget dot() => Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withValues(alpha: 0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            );

        Widget empty() => SizedBox(width: dotSize, height: dotSize);

        List<Widget> getDots() {
          switch (value) {
            case 1:
              return [
                empty(), empty(), empty(),
                empty(), dot(), empty(),
                empty(), empty(), empty(),
              ];
            case 2:
              return [
                dot(), empty(), empty(),
                empty(), empty(), empty(),
                empty(), empty(), dot(),
              ];
            case 3:
              return [
                dot(), empty(), empty(),
                empty(), dot(), empty(),
                empty(), empty(), dot(),
              ];
            case 4:
              return [
                dot(), empty(), dot(),
                empty(), empty(), empty(),
                dot(), empty(), dot(),
              ];
            case 5:
              return [
                dot(), empty(), dot(),
                empty(), dot(), empty(),
                dot(), empty(), dot(),
              ];
            case 6:
              return [
                dot(), empty(), dot(),
                dot(), empty(), dot(),
                dot(), empty(), dot(),
              ];
            default:
              return [];
          }
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: spacing - dotSize,
            crossAxisSpacing: spacing - dotSize,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: getDots(),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: () {
        if (isEnabled) {
          HapticUtils.light();
          onTap();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [
                    color,
                    color.withValues(alpha: 0.8),
                  ],
                )
              : LinearGradient(
                  colors: [
                    Colors.grey,
                    Colors.grey.withValues(alpha: 0.8),
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isEnabled
                  ? color.withValues(alpha: 0.4)
                  : Colors.grey.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
