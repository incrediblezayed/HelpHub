
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:helphub/core/enums/UserType.dart';
import 'package:helphub/core/helpers/shared_preferences_helper.dart';

import '../../locator.dart';

class Services {
  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();
  static String country =
      'India'; //Get this from firstScreen(UI Not developed yet)
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Firestore _firestore = Firestore.instance;

  FirebaseUser firebaseUser;


  String schoolCode;

  final StorageReference _storageReference =
      FirebaseStorage.instance.ref().child(country);

  Firestore get firestore => _firestore;
  FirebaseAuth get auth => _auth;

  DocumentReference getProfileReference(docId, UserType userType) {
    DocumentReference profileReference;
    DocumentReference ref = firestore.collection('users').document('Profile');
    switch (userType) {
      case UserType.DEVELOPERS:
        return profileReference = ref.collection('Developers').document(docId);
        break;
        case UserType.STUDENT:
        return profileReference =ref.collection('Students').document(docId);
        break;
      default:profileReference = ref.collection('Students').document(docId);
    }
    return profileReference;
  }

  StorageReference get storageReference => _storageReference;

  SharedPreferencesHelper get sharedPreferencesHelper =>
      _sharedPreferencesHelper;

  getFirebaseUser() async {
    firebaseUser = await _auth.currentUser();
  }

}
