import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../data/game_persistence_service.dart';
import '../providers/game_provider.dart';
import 'play_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

/// Page d'accueil de l'application
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  String _appVersion = '';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  Timer? _flipTimer;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();

    // Animation de fade-in pour l'écran
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // Animation de flip pour le logo
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: math.pi * 2, // 2 tours complets
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    // Démarrer le timer pour le flip périodique
    _startFlipTimer();
  }

  void _startFlipTimer() {
    // Premier flip après 3 secondes
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _performFlip();
      }
    });

    // Puis tous les 8-12 secondes aléatoirement
    _flipTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        // Ajouter un délai aléatoire de 0-4 secondes
        final randomDelay = math.Random().nextInt(4);
        Future.delayed(Duration(seconds: randomDelay), () {
          if (mounted) {
            _performFlip();
          }
        });
      }
    });
  }

  void _performFlip() {
    _flipController.forward(from: 0);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _flipController.dispose();
    _flipTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final persistenceService = ref.watch(gamePersistenceServiceProvider);
    final hasOngoingGame = persistenceService.hasOngoingGame();

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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo et titre
                  _buildHeader(),
                  const SizedBox(height: 60),

                  // Boutons principaux
                  _buildMainButtons(hasOngoingGame),

                  const Spacer(),

                  // Version de l'app
                  if (_appVersion.isNotEmpty)
                    Text(
                      'Version $_appVersion',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo Lorcana avec animation de flip
        AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            // Calculer la rotation
            final angle = _flipAnimation.value;

            // Déterminer si on doit afficher l'arrière (quand l'angle fait qu'on voit l'envers)
            final showBack = (angle % (2 * math.pi)) > math.pi / 2 &&
                             (angle % (2 * math.pi)) < 3 * math.pi / 2;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(angle),
              child: SizedBox(
                width: 140,
                height: 140,
                child: showBack
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: Image.asset(
                          'assets/images/lorcana_logo.png',
                          fit: BoxFit.contain,
                        ),
                      )
                    : Image.asset(
                        'assets/images/lorcana_logo.png',
                        fit: BoxFit.contain,
                      ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // Titre avec gradient
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.secondaryColor,
              ],
            ).createShader(bounds);
          },
          child: Text(
            'Lorcana Score Keeper',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),

        // Sous-titre
        Text(
          'Compteur de Lore',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMainButtons(bool hasOngoingGame) {
    return Column(
      children: [
        // Bouton Continuer Partie (si partie en cours)
        if (hasOngoingGame) ...[
          _buildMenuButton(
            icon: Icons.play_arrow,
            label: 'Continuer Partie',
            gradient: const LinearGradient(
              colors: [AppTheme.successColor, Color(0xFF66BB6A)],
            ),
            onTap: _handleContinueGame,
          ),
          const SizedBox(height: 16),
        ],

        // Bouton Nouveau Round
        _buildMenuButton(
          icon: Icons.add_circle_outline,
          label: 'Nouveau Round',
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryColor.withValues(alpha: 0.7),
            ],
          ),
          onTap: () => _handleNewRound(hasOngoingGame),
        ),
        const SizedBox(height: 16),

        // Bouton Statistiques
        _buildMenuButton(
          icon: Icons.bar_chart,
          label: 'Statistiques',
          gradient: const LinearGradient(
            colors: [AppTheme.infoColor, Color(0xFF42A5F5)],
          ),
          onTap: _handleStatistics,
        ),
        const SizedBox(height: 16),

        // Bouton Paramètres
        _buildMenuButton(
          icon: Icons.settings,
          label: 'Paramètres',
          gradient: LinearGradient(
            colors: [
              Colors.grey[700]!,
              Colors.grey[600]!,
            ],
          ),
          onTap: _handleSettings,
        ),
      ],
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticUtils.medium();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.pureBlack.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.pureWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.pureWhite,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.pureWhite.withValues(alpha: 0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Gestion des actions

  void _handleContinueGame() async {
    final persistenceService = ref.read(gamePersistenceServiceProvider);
    final savedGame = persistenceService.loadLastGame();

    if (savedGame == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune partie en cours'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Afficher un résumé de la partie avec confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Continuer la partie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${savedGame.player1.name} vs ${savedGame.player2.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text('Score: ${savedGame.player1Score} - ${savedGame.player2Score}'),
            Text('Round ${savedGame.currentRound}'),
            Text('Victoires: ${savedGame.player1Wins} - ${savedGame.player2Wins}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Charger la partie et naviguer vers l'écran de jeu
      ref.read(gameProvider.notifier).loadGame(savedGame);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PlayScreen(),
        ),
      );
    }
  }

  void _handleNewRound(bool hasOngoingGame) async {
    if (hasOngoingGame) {
      // Afficher un avertissement
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: AppTheme.warningColor,
              ),
              const SizedBox(width: 8),
              const Text('Attention'),
            ],
          ),
          content: const Text(
            'Une partie est déjà en cours. Êtes-vous sûr de vouloir commencer un nouveau round ? La partie en cours sera perdue.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warningColor,
              ),
              child: const Text('Nouveau Round'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // Supprimer la partie en cours
      ref.read(gamePersistenceServiceProvider).clearGame();
      ref.read(gameProvider.notifier).resetGame();
    }

    if (!mounted) return;

    // Naviguer vers l'écran de jeu (qui affichera le dialog de setup)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const PlayScreen(shouldCheckForOngoingGame: false),
      ),
    );
  }

  void _handleStatistics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const StatisticsScreen(),
      ),
    );
  }

  void _handleSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
}
