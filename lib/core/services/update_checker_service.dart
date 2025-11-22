import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_update_info.dart';

/// Service pour vérifier les mises à jour de l'application via GitHub Releases
class UpdateCheckerService {
  UpdateCheckerService({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// Repository GitHub (format: owner/repo)
  static const String _githubRepo = 'Jbijjer/lorcana_lore_counter';

  /// URL de l'API GitHub pour récupérer la dernière release
  static const String _latestReleaseUrl =
      'https://api.github.com/repos/$_githubRepo/releases/latest';

  /// Vérifie s'il y a une mise à jour disponible
  Future<AppUpdateInfo> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    try {
      final response = await _httpClient.get(
        Uri.parse(_latestReleaseUrl),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return _parseGitHubRelease(data, currentVersion);
      } else if (response.statusCode == 404) {
        // Pas encore de release publiée
        return AppUpdateInfo(
          latestVersion: currentVersion,
          currentVersion: currentVersion,
          downloadUrl: '',
          releaseUrl: 'https://github.com/$_githubRepo/releases',
          isUpdateAvailable: false,
        );
      } else {
        throw Exception(
          'Erreur lors de la vérification: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Parse la réponse de l'API GitHub
  AppUpdateInfo _parseGitHubRelease(
    Map<String, dynamic> data,
    String currentVersion,
  ) {
    // Le tag_name est généralement "v1.2.0" ou "1.2.0"
    final tagName = data['tag_name'] as String? ?? '';
    final latestVersion = tagName.startsWith('v') ? tagName.substring(1) : tagName;

    final releaseUrl = data['html_url'] as String? ?? '';
    final releaseNotes = data['body'] as String?;
    final publishedAtStr = data['published_at'] as String?;

    DateTime? publishedAt;
    if (publishedAtStr != null) {
      publishedAt = DateTime.tryParse(publishedAtStr);
    }

    // Chercher l'APK dans les assets
    String downloadUrl = '';
    final assets = data['assets'] as List<dynamic>? ?? [];
    for (final asset in assets) {
      final assetMap = asset as Map<String, dynamic>;
      final name = assetMap['name'] as String? ?? '';
      if (name.endsWith('.apk')) {
        downloadUrl = assetMap['browser_download_url'] as String? ?? '';
        break;
      }
    }

    // Si pas d'APK, utiliser l'URL de la release
    if (downloadUrl.isEmpty) {
      downloadUrl = releaseUrl;
    }

    final isUpdateAvailable = _isNewerVersion(latestVersion, currentVersion);

    return AppUpdateInfo(
      latestVersion: latestVersion,
      currentVersion: currentVersion,
      downloadUrl: downloadUrl,
      releaseUrl: releaseUrl,
      releaseNotes: releaseNotes,
      publishedAt: publishedAt,
      isUpdateAvailable: isUpdateAvailable,
    );
  }

  /// Compare deux versions sémantiques
  /// Retourne true si [latest] est plus récente que [current]
  bool _isNewerVersion(String latest, String current) {
    if (latest.isEmpty || current.isEmpty) return false;

    try {
      final latestParts = latest.split('.').map(int.parse).toList();
      final currentParts = current.split('.').map(int.parse).toList();

      // S'assurer que les deux listes ont la même longueur
      while (latestParts.length < 3) {
        latestParts.add(0);
      }
      while (currentParts.length < 3) {
        currentParts.add(0);
      }

      // Comparer major, minor, patch
      for (var i = 0; i < 3; i++) {
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }

      return false; // Versions identiques
    } catch (e) {
      // En cas d'erreur de parsing, comparer comme des strings
      return latest.compareTo(current) > 0;
    }
  }

  /// Ouvre l'URL de téléchargement dans le navigateur
  Future<bool> openDownloadUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
    return false;
  }

  /// Ouvre la page des releases sur GitHub
  Future<bool> openReleasesPage() async {
    final uri = Uri.parse('https://github.com/$_githubRepo/releases');
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
    return false;
  }
}
