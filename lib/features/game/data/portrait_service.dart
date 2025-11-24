import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'portrait_service.g.dart';

/// Service pour gérer les portraits personnalisés des joueurs
class PortraitService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Répertoire où sont stockés les portraits
  Future<Directory> _getPortraitDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final portraitDir = Directory('${appDir.path}/portraits');
    if (!await portraitDir.exists()) {
      await portraitDir.create(recursive: true);
    }
    return portraitDir;
  }

  /// Sélectionne une image depuis la galerie et retourne le chemin après recadrage
  Future<String?> pickAndCropImage(BuildContext context) async {
    try {
      // Sélectionner l'image depuis la galerie
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      // Recadrer l'image en cercle
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 85,
        maxWidth: 256,
        maxHeight: 256,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recadrer le portrait',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Recadrer le portrait',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return null;

      // Sauvegarder l'image dans le répertoire de l'application
      final portraitDir = await _getPortraitDirectory();
      final fileName = 'portrait_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${portraitDir.path}/$fileName';

      // Copier le fichier recadré vers le répertoire de l'application
      await File(croppedFile.path).copy(savedPath);

      return savedPath;
    } catch (e) {
      debugPrint('Erreur lors de la sélection/recadrage de l\'image: $e');
      return null;
    }
  }

  /// Supprime un portrait du stockage local
  Future<void> deletePortrait(String? portraitPath) async {
    if (portraitPath == null || portraitPath.isEmpty) return;

    try {
      final file = File(portraitPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Erreur lors de la suppression du portrait: $e');
    }
  }

  /// Vérifie si un fichier portrait existe
  Future<bool> portraitExists(String? portraitPath) async {
    if (portraitPath == null || portraitPath.isEmpty) return false;

    try {
      final file = File(portraitPath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}

/// Provider pour le service de portraits
@Riverpod(keepAlive: true)
PortraitService portraitService(Ref ref) {
  return PortraitService();
}
