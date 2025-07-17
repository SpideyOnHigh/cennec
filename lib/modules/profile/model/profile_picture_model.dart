import 'dart:io';

class ProfilePictureModel {
  final File? imageFile;
  final bool? containsDatabaseImage;
  final bool? isUpdate;
  final bool? isDefault;
  final int? imageId;
  final String? imageDatabaseUrl;

  ProfilePictureModel({
    this.imageFile,
    this.containsDatabaseImage = false,
    this.isDefault = false,
    this.isUpdate = false,
    this.imageDatabaseUrl,
    this.imageId = 0,
  });

  ProfilePictureModel copyWith({
    File? imageFile,
    bool? containsDatabaseImage,
    bool? isUpdate,
    bool? isDefault,
    int? imageId,
    String? imageDatabaseUrl,
  }) {
    return ProfilePictureModel(
      imageFile: imageFile ?? this.imageFile,
      containsDatabaseImage: containsDatabaseImage ?? this.containsDatabaseImage,
      isUpdate: isUpdate ?? this.isUpdate,
      isDefault: isDefault ?? this.isDefault,
      imageId: imageId ?? this.imageId,
      imageDatabaseUrl: imageDatabaseUrl ?? this.imageDatabaseUrl,
    );
  }
}
