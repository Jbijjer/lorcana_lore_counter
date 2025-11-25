import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/player_history_service.dart';
import '../../data/portrait_service.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/constants/player_icons.dart';
import '../../../../core/theme/app_theme.dart';
import 'color_picker_dialog.dart';
import '../../../../widgets/dialogs/common/dialog_animations_mixin.dart';
import '../../../../widgets/dialogs/common/dialog_header.dart';
import '../../../../widgets/dialogs/common/animated_dialog_wrapper.dart';
import '../../../../widgets/dialogs/common/shimmer_effect.dart';
import '../../../../widgets/dialogs/common/sparkles_painter.dart';

/// Dialogue pour éditer un joueur existant
class PlayerEditDialog extends ConsumerStatefulWidget {
  const PlayerEditDialog({
    required this.playerId,
    required this.playerName,
    required this.playerColor,
    required this.backgroundColorStart,
    required this.backgroundColorEnd,
    required this.iconAssetPath,
    required this.onPlayerUpdated,
    this.customPortraitPath,
    super.key,
  });

  final String playerId;
  final String playerName;
  final Color playerColor;
  final Color backgroundColorStart;
  final Color backgroundColorEnd;
  final String iconAssetPath;
  final String? customPortraitPath;
  final Function({
    required String name,
    required Color backgroundColorStart,
    required Color backgroundColorEnd,
    required String iconAssetPath,
    String? customPortraitPath,
  }) onPlayerUpdated;

  @override
  ConsumerState<PlayerEditDialog> createState() => _PlayerEditDialogState();
}

class _PlayerEditDialogState extends ConsumerState<PlayerEditDialog>
    with TickerProviderStateMixin, DialogAnimationsMixin {
  late TextEditingController _nameController;
  late Color _backgroundColorStart;
  late Color _backgroundColorEnd;
  late String _selectedIconAssetPath;
  String? _customPortraitPath;
  late AnimationController _portraitChangeController;

  @override
  void initState() {
    super.initState();
    initDialogAnimations();

    _nameController = TextEditingController(text: widget.playerName);
    _backgroundColorStart = widget.backgroundColorStart;
    _backgroundColorEnd = widget.backgroundColorEnd;
    _selectedIconAssetPath = widget.iconAssetPath;
    _customPortraitPath = widget.customPortraitPath;

    // Animation pour le changement de portrait
    _portraitChangeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _portraitChangeController.dispose();
    disposeDialogAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildAnimatedDialog(
      child: AnimatedDialogWrapper(
        accentColor: widget.playerColor,
        maxWidth: 550,
        maxHeight: 700,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête
              DialogHeader(
                icon: Icons.edit,
                title: 'Éditer le joueur',
                accentColor: widget.playerColor,
                onClose: () => Navigator.of(context).pop(),
              ),

              const SizedBox(height: 24),

              // Aperçu du joueur avec shimmer
              _buildPlayerPreview(),

              const SizedBox(height: 24),

              // Champ de saisie du nom
              TextField(
                controller: _nameController,
                maxLength: 15,
                onChanged: (_) => setState(() {}),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Nom du joueur',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  counterStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.playerColor,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 19),

              // Sélection du portrait (icônes + portraits personnalisés)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: widget.playerColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Portrait',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.swipe_vertical,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Glissez pour voir plus',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildPortraitSelector(),

              const SizedBox(height: 16),

              // Bouton pour changer les couleurs de fond
              _buildColorButton(),

              const SizedBox(height: 12),

              // Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Annuler',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildSaveButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerPreview() {
    return AnimatedBuilder(
      animation: shimmerController,
      builder: (context, child) {
        return Stack(
          children: [
            // Conteneur principal avec gradient
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _backgroundColorStart,
                    _backgroundColorEnd,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.playerColor.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar avec effet glow et changement animé
                    _buildAnimatedAvatar(),
                    const SizedBox(width: 12),
                    // Nom du joueur
                    Stack(
                      children: [
                        // Outline noir
                        Text(
                          _nameController.text.isNotEmpty
                              ? _nameController.text
                              : 'Joueur',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = AppTheme.pureBlack,
                          ),
                        ),
                        // Texte avec gradient
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                AppTheme.pureWhite,
                                AppTheme.pureWhite.withValues(alpha: 0.9),
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            _nameController.text.isNotEmpty
                                ? _nameController.text
                                : 'Joueur',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.pureWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Effet shimmer
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Transform.translate(
                  offset: Offset(
                    -200 + (shimmerController.value * 400),
                    0,
                  ),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppTheme.transparentColor,
                          AppTheme.pureWhite.withValues(alpha: 0.3),
                          AppTheme.transparentColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedAvatar() {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(
          parent: _portraitChangeController,
          curve: Curves.easeInOut,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.playerColor.withValues(alpha: 0.5),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.pureBlack,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 29.25,
            backgroundColor: widget.playerColor.withValues(alpha: 0.3),
            child: ClipOval(
              child: _customPortraitPath != null && _customPortraitPath!.isNotEmpty
                  ? Image.file(
                      File(_customPortraitPath!),
                      width: 58.5,
                      height: 58.5,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          _selectedIconAssetPath,
                          width: 58.5,
                          height: 58.5,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      _selectedIconAssetPath,
                      width: 58.5,
                      height: 58.5,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitSelector() {
    final service = ref.read(playerHistoryServiceProvider);
    final customPortraits = service.getAllCustomPortraits();

    // Total d'items = icônes + portraits personnalisés + bouton "ajouter"
    final totalItems = PlayerIcons.availableIcons.length + customPortraits.length + 1;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.playerColor.withValues(alpha: 0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          // Les portraits personnalisés en premier
          if (index < customPortraits.length) {
            return _buildCustomPortraitItem(customPortraits[index]);
          }

          // Ensuite le bouton "Ajouter une photo"
          if (index == customPortraits.length) {
            return _buildAddPhotoButton();
          }

          // Enfin les icônes prédéfinies
          final iconIndex = index - customPortraits.length - 1;
          final playerIcon = PlayerIcons.availableIcons[iconIndex];
          return _buildIconItem(playerIcon);
        },
      ),
    );
  }

  Widget _buildCustomPortraitItem(String portraitPath) {
    final isSelected = _customPortraitPath == portraitPath;

    return Tooltip(
      message: 'Ma photo',
      child: InkWell(
        onTap: () {
          HapticUtils.light();
          setState(() {
            _customPortraitPath = portraitPath;
            // Garder l'icône par défaut mais donner priorité au portrait
          });
          _portraitChangeController.forward(from: 0.0);
        },
        onLongPress: () async {
          HapticUtils.medium();
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Supprimer cette photo'),
              content: const Text('Voulez-vous supprimer définitivement cette photo ?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Supprimer',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          );

          if (shouldDelete == true && mounted) {
            final portraitService = ref.read(portraitServiceProvider);
            await portraitService.deletePortrait(portraitPath);

            // Si c'était le portrait sélectionné, le désélectionner
            if (_customPortraitPath == portraitPath) {
              setState(() {
                _customPortraitPath = null;
              });
            } else {
              setState(() {}); // Rafraîchir pour retirer de la liste
            }
            _portraitChangeController.forward(from: 0.0);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.playerColor.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? widget.playerColor : Theme.of(context).colorScheme.outlineVariant,
              width: isSelected ? 3 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: widget.playerColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(portraitPath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 32),
                    );
                  },
                ),
              ),
              // Effet scintillant pour le portrait sélectionné
              if (isSelected)
                Positioned.fill(
                  child: _buildSparkles(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return Tooltip(
      message: 'Ajouter une photo',
      child: InkWell(
        onTap: _pickCustomPortrait,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.playerColor.withValues(alpha: 0.15),
                widget.playerColor.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.playerColor.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                color: widget.playerColor,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                'Ajouter',
                style: TextStyle(
                  color: widget.playerColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconItem(dynamic playerIcon) {
    final isSelected = _customPortraitPath == null && playerIcon.assetPath == _selectedIconAssetPath;

    return Tooltip(
      message: playerIcon.label,
      child: InkWell(
        onTap: () {
          HapticUtils.light();
          setState(() {
            _selectedIconAssetPath = playerIcon.assetPath;
            _customPortraitPath = null; // Désélectionner le portrait personnalisé
          });
          _portraitChangeController.forward(from: 0.0);
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.playerColor.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? widget.playerColor : Theme.of(context).colorScheme.outlineVariant,
              width: isSelected ? 3 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: widget.playerColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                    playerIcon.assetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Effet scintillant pour l'icône sélectionnée
              if (isSelected)
                Positioned.fill(
                  child: _buildSparkles(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSparkles() {
    return SparklesOverlay(
      controller: shimmerController,
      color: widget.playerColor,
    );
  }

  Future<void> _pickCustomPortrait() async {
    HapticUtils.light();
    final portraitService = ref.read(portraitServiceProvider);
    final newPortraitPath = await portraitService.pickAndCropImage(context);

    if (newPortraitPath != null) {
      setState(() {
        _customPortraitPath = newPortraitPath;
      });
      _portraitChangeController.forward(from: 0.0);
      HapticUtils.medium();
    }
  }

  Widget _buildColorButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            widget.playerColor.withValues(alpha: 0.1),
            widget.playerColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: OutlinedButton.icon(
        onPressed: _showColorPicker,
        icon: Icon(Icons.palette, color: widget.playerColor),
        label: const Text('Modifier les couleurs de fond'),
        style: OutlinedButton.styleFrom(
          foregroundColor: widget.playerColor,
          side: BorderSide(color: widget.playerColor, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            widget.playerColor,
            widget.playerColor.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.playerColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.transparentColor,
          shadowColor: AppTheme.transparentColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.save, color: AppTheme.pureWhite),
            SizedBox(width: 8),
            Text(
              'Enregistrer',
              style: TextStyle(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showColorPicker() async {
    HapticUtils.light();
    final result = await showDialog<Map<String, Color>>(
      context: context,
      builder: (context) => ColorPickerDialog(
        currentColorStart: _backgroundColorStart,
        currentColorEnd: _backgroundColorEnd,
        playerColor: widget.playerColor,
      ),
    );

    if (result != null) {
      setState(() {
        _backgroundColorStart = result['start']!;
        _backgroundColorEnd = result['end']!;
      });
    }
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le nom ne peut pas être vide'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    HapticUtils.medium();

    final service = ref.read(playerHistoryServiceProvider);

    // Déterminer si le portrait a été supprimé
    final portraitWasRemoved = widget.customPortraitPath != null && _customPortraitPath == null;

    // Si c'est un joueur existant (avec ID), le mettre à jour dans la base
    if (widget.playerId.isNotEmpty) {
      await service.updatePlayerById(
        id: widget.playerId,
        oldName: widget.playerName,
        newName: name,
        backgroundColorStart: _backgroundColorStart,
        backgroundColorEnd: _backgroundColorEnd,
        iconAssetPath: _selectedIconAssetPath,
        customPortraitPath: _customPortraitPath,
        clearCustomPortrait: portraitWasRemoved,
      );
      // Invalider le provider pour rafraîchir la liste
      ref.invalidate(playerNamesProvider);
    }
    // Si c'est un nouveau joueur (ID vide), on ne le crée PAS ici
    // C'est le code appelant qui décidera de le créer après validation

    // Callback avec les nouvelles données
    widget.onPlayerUpdated(
      name: name,
      backgroundColorStart: _backgroundColorStart,
      backgroundColorEnd: _backgroundColorEnd,
      iconAssetPath: _selectedIconAssetPath,
      customPortraitPath: _customPortraitPath,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
