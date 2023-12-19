// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_appwrite/constants/appwrite_contants.dart';
import 'package:flutter_web_appwrite/core/providers.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImages = await _storage.createFile(
        bucketId: AppWriteConstants.imagesBucket, 
        fileId: ID.unique(), 
        file: InputFile(
          path: file.path,
        ),
      );
      imageLinks.add(
        AppWriteConstants.imageUrl(uploadedImages.$id),
      );
    }
    return imageLinks;
  }
}