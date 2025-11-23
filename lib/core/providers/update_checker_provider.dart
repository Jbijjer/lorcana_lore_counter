import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/app_update_info.dart';
import '../services/update_checker_service.dart';

part 'update_checker_provider.g.dart';

/// Provider pour le service de vérification des mises à jour
@riverpod
UpdateCheckerService updateCheckerService(UpdateCheckerServiceRef ref) {
  return UpdateCheckerService();
}

/// Provider pour gérer l'état de la vérification des mises à jour
@riverpod
class UpdateChecker extends _$UpdateChecker {
  @override
  UpdateCheckState build() {
    return const UpdateCheckState.initial();
  }

  /// Vérifie si une mise à jour est disponible
  Future<void> checkForUpdate() async {
    state = const UpdateCheckState.checking();

    try {
      final service = ref.read(updateCheckerServiceProvider);
      final info = await service.checkForUpdate();

      if (info.isUpdateAvailable) {
        state = UpdateCheckState.updateAvailable(info);
      } else {
        state = UpdateCheckState.upToDate(info.currentVersion);
      }
    } catch (e) {
      state = UpdateCheckState.error(e.toString());
    }
  }

  /// Ouvre l'URL de téléchargement
  Future<bool> openDownloadUrl(String url) async {
    final service = ref.read(updateCheckerServiceProvider);
    return service.openDownloadUrl(url);
  }

  /// Ouvre la page des releases
  Future<bool> openReleasesPage() async {
    final service = ref.read(updateCheckerServiceProvider);
    return service.openReleasesPage();
  }

  /// Réinitialise l'état
  void reset() {
    state = const UpdateCheckState.initial();
  }
}
