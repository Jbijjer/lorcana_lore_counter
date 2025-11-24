import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../data/game_statistics_service.dart';
import '../../data/player_history_service.dart';
import '../../domain/player.dart';
import '../widgets/player_selection_dialog.dart';
import '../widgets/deck_color_picker_dialog.dart';

/// Écran de saisie manuelle des parties
/// Permet d'entrer manuellement des parties sans passer par l'interface de jeu
class ManualEntryScreen extends ConsumerStatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  ConsumerState<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends ConsumerState<ManualEntryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // État du formulaire
  Player? _player1;
  Player? _player2;
  List<String> _player1DeckColors = [];
  List<String> _player2DeckColors = [];
  int _player1Score = 0;
  int _player2Score = 0;
  String? _firstToPlay;
  String? _note;
  bool _isDraw = false;
  int? _roundNumber;

  final TextEditingController _player1ScoreController = TextEditingController(text: '0');
  final TextEditingController _player2ScoreController = TextEditingController(text: '0');
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _player1ScoreController.dispose();
    _player2ScoreController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// Vérifie si le formulaire est valide
  bool get _isFormValid {
    if (_player1 == null || _player2 == null) return false;
    if (_player1!.name == _player2!.name) return false;
    if (_isDraw) return true;
    // Pour une victoire, un score doit être >= 20
    return _player1Score >= 20 || _player2Score >= 20;
  }

  /// Détermine le gagnant basé sur les scores
  String? get _winner {
    if (_isDraw) return null;
    if (_player1Score >= 20 && _player1Score > _player2Score) {
      return _player1?.name;
    }
    if (_player2Score >= 20 && _player2Score > _player1Score) {
      return _player2?.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.secondaryColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPlayersSection(),
                        const SizedBox(height: 24),
                        _buildDeckColorsSection(),
                        const SizedBox(height: 24),
                        _buildScoresSection(),
                        const SizedBox(height: 24),
                        _buildFirstToPlaySection(),
                        const SizedBox(height: 24),
                        _buildRoundNumberSection(),
                        const SizedBox(height: 24),
                        _buildNoteSection(),
                        const SizedBox(height: 32),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.pureBlack.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              HapticUtils.light();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'Saisie Manuelle',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.pureWhite,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  'Enregistrer une partie jouée',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.edit_note,
              color: AppTheme.pureWhite,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  Widget _buildPlayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Joueurs', Icons.people, AppTheme.amberColor),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPlayerCard(
                player: _player1,
                label: 'Joueur 1',
                onTap: () => _selectPlayer(1),
                accentColor: AppTheme.amberColor,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                'VS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPlayerCard(
                player: _player2,
                label: 'Joueur 2',
                onTap: () => _selectPlayer(2),
                accentColor: AppTheme.sapphireColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerCard({
    required Player? player,
    required String label,
    required VoidCallback onTap,
    required Color accentColor,
  }) {
    final isSelected = player != null;

    return InkWell(
      onTap: () {
        HapticUtils.light();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    player.backgroundColorStart,
                    player.backgroundColorEnd,
                  ],
                )
              : null,
          color: isSelected ? null : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppTheme.pureWhite.withValues(alpha: 0.2)
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: AppTheme.pureBlack,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: isSelected
                    ? _buildPlayerAvatar(player)
                    : Icon(
                        Icons.person_add,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? AppTheme.pureWhite.withValues(alpha: 0.8)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isSelected ? player.name : 'Sélectionner',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppTheme.pureWhite
                    : Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerAvatar(Player player) {
    // Priorité au portrait personnalisé
    if (player.customPortraitPath != null && player.customPortraitPath!.isNotEmpty) {
      return Image.file(
        File(player.customPortraitPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback vers l'icône si le fichier n'existe plus
          return Image.asset(
            player.iconAssetPath,
            fit: BoxFit.cover,
          );
        },
      );
    }

    // Sinon, utiliser l'icône
    return Image.asset(
      player.iconAssetPath,
      fit: BoxFit.cover,
    );
  }

  Widget _buildDeckColorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Couleurs de deck', Icons.palette, AppTheme.amethystColor),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDeckColorPicker(
                label: _player1?.name ?? 'Joueur 1',
                colors: _player1DeckColors,
                accentColor: _player1?.backgroundColorStart ?? AppTheme.amberColor,
                onColorSelected: (color) {
                  setState(() {
                    if (_player1DeckColors.contains(color)) {
                      _player1DeckColors.remove(color);
                    } else if (_player1DeckColors.length < 2) {
                      _player1DeckColors.add(color);
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.palette,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDeckColorPicker(
                label: _player2?.name ?? 'Joueur 2',
                colors: _player2DeckColors,
                accentColor: _player2?.backgroundColorStart ?? AppTheme.sapphireColor,
                onColorSelected: (color) {
                  setState(() {
                    if (_player2DeckColors.contains(color)) {
                      _player2DeckColors.remove(color);
                    } else if (_player2DeckColors.length < 2) {
                      _player2DeckColors.add(color);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeckColorPicker({
    required String label,
    required List<String> colors,
    required Color accentColor,
    required Function(String) onColorSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...colors.map((color) => _buildColorChip(
                    color,
                    accentColor,
                    onRemove: () => onColorSelected(color),
                  )),
              if (colors.length < 2)
                InkWell(
                  onTap: () => _showColorPicker(accentColor, colors, onColorSelected),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: accentColor,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: accentColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(String colorName, Color accentColor, {required VoidCallback onRemove}) {
    final lorcanaColor = lorcanaColors.firstWhere(
      (c) => c.name == colorName,
      orElse: () => lorcanaColors.first,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: lorcanaColor.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.pureBlack, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            colorName,
            style: const TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: AppTheme.pureBlack, blurRadius: 2)],
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppTheme.pureWhite,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showColorPicker(
    Color accentColor,
    List<String> selectedColors,
    Function(String) onColorSelected,
  ) async {
    HapticUtils.light();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => DeckColorPickerDialog(
        accentColor: accentColor,
        selectedColors: selectedColors,
      ),
    );

    if (result != null) {
      HapticUtils.success();
      onColorSelected(result);
    }
  }

  Widget _buildScoresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSectionTitle('Scores', Icons.scoreboard, AppTheme.emeraldColor),
            ),
            // Toggle match nul
            Row(
              children: [
                Text(
                  'Match nul',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _isDraw,
                  onChanged: (value) {
                    HapticUtils.light();
                    setState(() {
                      _isDraw = value;
                    });
                  },
                  activeColor: AppTheme.warningColor,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildScoreInput(
                label: _player1?.name ?? 'Joueur 1',
                controller: _player1ScoreController,
                accentColor: _player1?.backgroundColorStart ?? AppTheme.amberColor,
                onChanged: (value) {
                  setState(() {
                    _player1Score = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                '-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreInput(
                label: _player2?.name ?? 'Joueur 2',
                controller: _player2ScoreController,
                accentColor: _player2?.backgroundColorStart ?? AppTheme.sapphireColor,
                onChanged: (value) {
                  setState(() {
                    _player2Score = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
          ],
        ),
        if (!_isDraw && _winner != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.successColor.withValues(alpha: 0.2),
                  AppTheme.successColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.successColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: AppTheme.successColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Gagnant: $_winner',
                  style: const TextStyle(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScoreInput({
    required String label,
    required TextEditingController controller,
    required Color accentColor,
    required Function(String) onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              hintText: '0',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildFirstToPlaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Qui a commencé ?', Icons.play_arrow, AppTheme.rubyColor),
        const SizedBox(height: 12),
        if (_player1 == null && _player2 == null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Sélectionnez d\'abord les joueurs',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          Row(
            children: [
              if (_player1 != null)
                Expanded(
                  child: _buildFirstToPlayOption(_player1!.name),
                ),
              if (_player1 != null && _player2 != null) const SizedBox(width: 12),
              if (_player2 != null)
                Expanded(
                  child: _buildFirstToPlayOption(_player2!.name),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildFirstToPlayOption(String playerName) {
    final isSelected = _firstToPlay == playerName;

    return InkWell(
      onTap: () {
        HapticUtils.light();
        setState(() {
          _firstToPlay = isSelected ? null : playerName;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.rubyColor,
                    AppTheme.rubyColor.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.rubyColor : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? AppTheme.pureWhite
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                playerName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppTheme.pureWhite
                      : Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundNumberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Numéro de partie (optionnel)', Icons.format_list_numbered, AppTheme.steelColor),
        const SizedBox(height: 8),
        Text(
          'Ex: Partie 1 ou 2 dans un Best of 3',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildRoundNumberOption(null, 'Aucun'),
            _buildRoundNumberOption(1, '1'),
            _buildRoundNumberOption(2, '2'),
            _buildRoundNumberOption(3, '3'),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundNumberOption(int? number, String label) {
    final isSelected = _roundNumber == number;

    return InkWell(
      onTap: () {
        HapticUtils.light();
        setState(() {
          _roundNumber = number;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.steelColor,
                    AppTheme.steelColor.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.steelColor : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected
                ? AppTheme.pureWhite
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Note (optionnel)', Icons.note, AppTheme.infoColor),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          child: TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Ajouter une note sur cette partie...',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) {
              setState(() {
                _note = value.isEmpty ? null : value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Column(
      children: [
        // Résumé de la validation
        if (!_isFormValid && (_player1 != null || _player2 != null))
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.warningColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.warningColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getValidationMessage(),
                    style: const TextStyle(
                      color: AppTheme.warningColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Bouton sauvegarder
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: _isFormValid
                ? const LinearGradient(
                    colors: [AppTheme.successColor, Color(0xFF66BB6A)],
                  )
                : null,
            boxShadow: _isFormValid
                ? [
                    BoxShadow(
                      color: AppTheme.successColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: _isFormValid ? _saveGame : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid ? AppTheme.transparentColor : null,
              foregroundColor: _isFormValid ? AppTheme.pureWhite : null,
              disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
              shadowColor: AppTheme.transparentColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.save,
                  color: _isFormValid
                      ? AppTheme.pureWhite
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  'Enregistrer la partie',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isFormValid
                        ? AppTheme.pureWhite
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getValidationMessage() {
    if (_player1 == null || _player2 == null) {
      return 'Sélectionnez les deux joueurs';
    }
    if (_player1!.name == _player2!.name) {
      return 'Les joueurs doivent être différents';
    }
    if (!_isDraw && _player1Score < 20 && _player2Score < 20) {
      return 'Un joueur doit avoir au moins 20 points (ou activer Match nul)';
    }
    return '';
  }

  Future<void> _selectPlayer(int playerNumber) async {
    final excludedPlayerName = playerNumber == 1 ? _player2?.name : _player1?.name;

    final player = await showDialog<Player>(
      context: context,
      builder: (context) => PlayerSelectionDialog(
        title: playerNumber == 1 ? 'Sélectionner le Joueur 1' : 'Sélectionner le Joueur 2',
        defaultColor: playerNumber == 1 ? AppTheme.amberColor : AppTheme.sapphireColor,
        excludedPlayerName: excludedPlayerName,
      ),
    );

    if (player != null && mounted) {
      HapticUtils.success();
      setState(() {
        if (playerNumber == 1) {
          _player1 = player;
        } else {
          _player2 = player;
        }
      });
    }
  }

  Future<void> _saveGame() async {
    if (!_isFormValid) return;

    HapticUtils.success();

    final statisticsService = ref.read(gameStatisticsServiceProvider);
    final playerHistoryService = ref.read(playerHistoryServiceProvider);

    // Mettre à jour l'historique des joueurs
    await playerHistoryService.addOrUpdatePlayerName(_player1!.name);
    await playerHistoryService.addOrUpdatePlayerName(_player2!.name);

    // Sauvegarder la partie
    await statisticsService.savePartie(
      player1Name: _player1!.name,
      player2Name: _player2!.name,
      player1Score: _player1Score,
      player2Score: _player2Score,
      winnerName: _winner,
      player1DeckColors: _player1DeckColors,
      player2DeckColors: _player2DeckColors,
      note: _note,
      firstToPlayName: _firstToPlay,
      roundNumber: _roundNumber,
    );

    if (!mounted) return;

    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.pureWhite),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isDraw
                    ? 'Match nul enregistré !'
                    : 'Victoire de $_winner enregistrée !',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );

    // Demander si l'utilisateur veut enregistrer une autre partie
    final addAnother = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
            SizedBox(width: 12),
            Text('Autre partie ?'),
          ],
        ),
        content: const Text('Voulez-vous enregistrer une autre partie ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Non, retour'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.pureWhite,
            ),
            child: const Text('Oui, nouvelle partie'),
          ),
        ],
      ),
    );

    if (addAnother == true && mounted) {
      // Réinitialiser le formulaire (garder les joueurs)
      // Incrémenter le numéro de partie si défini (max 5)
      final nextRoundNumber = _roundNumber != null && _roundNumber! < 5
          ? _roundNumber! + 1
          : _roundNumber;
      setState(() {
        _player1DeckColors = [];
        _player2DeckColors = [];
        _player1Score = 20;
        _player2Score = 0;
        _player1ScoreController.text = '20';
        _player2ScoreController.text = '0';
        _firstToPlay = null;
        _note = null;
        _noteController.clear();
        _isDraw = false;
        _roundNumber = nextRoundNumber;
      });
    } else if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
