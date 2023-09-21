import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lfc_web/main.dart';

class Helper {
  static getFile({
    required FileType type,
    required void Function() showLoading,
    required void Function(Uint8List?) onDone,
    required void Function(dynamic) onError,
  }) async {
    try {
      showLoading();
      var picked = await FilePicker.platform.pickFiles(
          type: type,
          allowedExtensions: type == FileType.custom ? ['pdf'] : null);
      if (type == FileType.image) {
        if (picked != null && picked.files.single.bytes!.length <= 2500000) {
          onDone(picked.files.single.bytes);
        } else if (picked == null) {
          onError("No image picked");
        } else {
          onError("Image cannot be more than 2.5 MB");
        }
      } else if (type == FileType.video) {
        if (picked != null) {
          onDone(picked.files.single.bytes);
        } else if (picked == null) {
          onError("No file picked");
        }
      } else {
        if (picked != null && picked.files.single.bytes!.length <= 25000000) {
          onDone(picked.files.single.bytes);
        } else if (picked == null) {
          onError("No file picked");
        } else {
          onError("File cannot be more than 25 MB");
        }
      }
    } catch (_) {
      onError(_.toString());
    }
  }

  static Future<void> uploadFile({
    required String storagePath,
    required void Function() showLoading,
    required void Function(String) onDone,
    required void Function(dynamic) onError,
    required void Function(TaskSnapshot)? onData,
    required Uint8List file,
  }) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('$storagePath/${DateTime.now().toIso8601String()}');
      UploadTask task = ref.putData(
          file,
          SettableMetadata(
              contentType: storagePath == 'books/document'
                  ? 'application/pdf'
                  : storagePath == 'audios/audio'
                      ? 'audio/mpeg'
                      : storagePath == 'videos/video'
                          ? 'video/mp4'
                          : 'image/jpeg'));
      task.snapshotEvents.listen(onData);
      task.whenComplete(() async {
        onDone(await ref.getDownloadURL());
      });
    } catch (e) {
      onError('Error uploading file: $e');
    }
  }

  static deleteFromStorage(String url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }

  static showToast(String msg) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(backgroundColor: Colors.orange, content: Text(msg)));
  }

  /// Set precision point
  static double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static bool isYouTubeLink(String link) {
    RegExp youtubeRegex = RegExp(
      r'^(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/|youtube\.com/live_stream\?channel=|youtube\.com/live/)',
      caseSensitive: false,
    );
    return youtubeRegex.hasMatch(link);
  }

  static bool isInteger(String input) {
    final int? parsedInt = int.tryParse(input);
    return parsedInt != null;
  }
}
