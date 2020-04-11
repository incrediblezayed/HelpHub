import 'dart:io';
import 'package:helphub/core/enums/UserType.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';

import 'Services.dart';

class StorageServices extends Services {
  StorageServices() {
    getFirebaseUser();
  }
  Future<String> setProfilePhoto(String filePath) async {
    if (firebaseUser == null) 
    await getFirebaseUser();
    // String schoolCode = await sharedPreferencesHelper.getSchoolCode();

    String _extension = p.extension(filePath);
    String fileName = firebaseUser.uid + _extension;
    UserType userType = await sharedPreferencesHelper.getUserType();
    StorageUploadTask uploadTask;
    if (userType == UserType.STUDENT) {
      uploadTask = storageReference
          .child("Profile" + '/' + "Students" + '/' + fileName)
          .putFile(
            File(filePath),
            StorageMetadata(
              contentType: "image",
              customMetadata: {
                "uploadedBy": firebaseUser.uid,
              },
            ),
          );
    } else {
      uploadTask = storageReference
          .child("Profile" + '/' + "Developers" + '/' + fileName)
          .putFile(
            File(filePath),
            StorageMetadata(
              contentType: "image",
              customMetadata: {
                "uploadedBy": firebaseUser.uid,
              },
            ),
          );
    }

    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    final String profileUrl = await downloadUrl.ref.getDownloadURL();

    await sharedPreferencesHelper.setLoggedInUserPhotoUrl(profileUrl);

    return profileUrl;
  }

  /* Future<String> sendImage(String path) async {
    String 
  } */

}
