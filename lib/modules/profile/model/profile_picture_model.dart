import 'dart:io';

class ProfilePictureModel {
  final File? imageFile;
  final bool? containsDatabaseImage;
  final bool? isUpdate;
  final bool? isDefault;
  final int? imageId;
  final String? imageDatabaseUrl;

  ProfilePictureModel({this.imageFile, this.containsDatabaseImage = false,this.isDefault = false,this.isUpdate = false, this.imageDatabaseUrl,this.imageId=0});
}