/* import 'package:helphub/imports.dart';

class DeveloperCardServices extends Services {
  requestForEnrollment(Student student, Developer developer,
      DocumentReference documentReference) async {
        Timestamp time = Timestamp.now();
    Student studentreq;
    studentreq = Student(
        city: student.city,
        country: student.country,
        displayName: student.displayName,
        email: student.email,
        requested: true,
        requestDateTime: time,
        qualification: student.qualification,
        yearofcompletion: student.yearofcompletion,
        photoUrl: student.photoUrl);
    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      await documentReference.delete();
    } else {
      documentReference.setData(student.sendRequest(studentreq, developer.id));
    }
  }

  Future<bool> getStatus(DocumentReference reference) async {
    DocumentSnapshot snapshot = await reference.get();
    if (snapshot.exists) {
      if (snapshot.data['Requested'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
 */