import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Wrapper réutilisable pour les dialogues avec structure et style standardisés
///
/// Fournit automatiquement :
/// - Background transparent
/// - Container blanc avec border radius et shadow
/// - Padding standard
/// - BoxShadow coloré
///
/// Usage:
/// ```dart
/// AnimatedDialogWrapper(
///   accentColor: playerColor,
///   maxWidth: 450,
///   child: Column(
///     children: [
///       DialogHeader(...),
///       // Contenu du dialogue
///     ],
///   ),
/// )
/// ```
class AnimatedDialogWrapper extends StatelessWidget {
  const AnimatedDialogWrapper({
    required this.child,
    required this.accentColor,
    this.maxWidth,
    this.maxHeight,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });

  /// Le contenu du dialogue
  final Widget child;

  /// La couleur d'accent pour le box shadow
  final Color accentColor;

  /// Largeur maximale du dialogue
  final double? maxWidth;

  /// Hauteur maximale du dialogue
  final double? maxHeight;

  /// Padding intérieur du dialogue
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.transparentColor,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Wrapper pour dialogues scrollables
///
/// Similaire à AnimatedDialogWrapper mais utilise SingleChildScrollView
class ScrollableAnimatedDialogWrapper extends StatelessWidget {
  const ScrollableAnimatedDialogWrapper({
    required this.child,
    required this.accentColor,
    this.maxWidth,
    this.maxHeight,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });

  /// Le contenu du dialogue
  final Widget child;

  /// La couleur d'accent pour le box shadow
  final Color accentColor;

  /// Largeur maximale du dialogue
  final double? maxWidth;

  /// Hauteur maximale du dialogue
  final double? maxHeight;

  /// Padding intérieur du dialogue
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.transparentColor,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: padding,
        child: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }
}
