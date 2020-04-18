import 'package:helphub/core/services/Services.dart';
import 'package:helphub/imports.dart';

class DeveloperHomeServices extends Services {
  SharedPreferencesHelper sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();
  DeveloperHomeServices() {
    currentWorkingStudent();
  }
  Future<Student> currentWorkingStudent() async {
    String id = await sharedPreferencesHelper.getDevelopersId();
    DocumentSnapshot devSnapshot =
        await getProfileReference(id, UserType.DEVELOPERS).get();
    Developer developer = Developer.fromJson(devSnapshot.data);
    String currentStudent = developer.currentlyworkingWith;
    await sharedPreferencesHelper.setStudentsEmail(currentStudent);
    await sharedPreferencesHelper.setCurrentProject(developer.currentProject);
    if (currentStudent != '' &&
        currentStudent != null &&
        currentStudent != 'none') {
      DocumentSnapshot snapshot =
          await getProfileReference(currentStudent, UserType.STUDENT).get();
      Student student;
      student = Student.dataFromSnapshot(snapshot.data);
      return student;
    } else {
      Student student;
      student = Student(displayName: '');
      return student;
    }
  }

  Future updateProgress(
      DocumentReference projectReference, String phase) async {
    Project project;
    await projectReference.updateData({'Progress.$phase': DateTime.now()});
    String stuemail = await sharedPreferencesHelper.getStudentsEmail();
    String devId = await sharedPreferencesHelper.getDevelopersId();
    DocumentReference developerReference =
        getProfileReference(devId, UserType.DEVELOPERS);
    DocumentReference studentreference =
        getProfileReference(stuemail, UserType.STUDENT);
    project = Project.fromSnapshot(await projectReference.get());
    if (project.progress.length == 6) {
      /*  Firestore.instance.runTransaction((tx) async {
        await tx.update(projectReference, {'current': false, 'view': false});
       await  tx.update(studentreference, {
          'currentProject': 'none',
        });
       await tx.update(developerReference,
            {'current project': 'none', 'currentlyworkingWith': 'none'});
      }); */
      projectReference.updateData({'current': false, 'view': false});
      studentreference.updateData({
        'currentProject': 'none',
      });
      developerReference.updateData(
          {'current project': 'none', 'currentlyworkingWith': 'none'});
    }
    project = Project.fromSnapshot(await projectReference.get());
    await studentreference
        .collection('Projects')
        .document(project.name)
        .updateData(project.toMap(project));
  }

  Future<bool> acceptRequest(Student student) async {
    Timestamp time = Timestamp.now();
    student.acceptDate = time;
    String devId = await sharedPreferencesHelper.getDevelopersId();
    DocumentReference ref =
        getProfileReference(student.email, UserType.STUDENT);

    DocumentReference enrolledRef = firestore
        .collection('users')
        .document('Enrolled')
        .collection(devId)
        .document(student.displayName);
    await enrolledRef.setData(student.acceptRequest(student));
    await ref.updateData({'enrolled': true, 'enrolledWith': devId});
    await getProfileReference(devId, UserType.DEVELOPERS)
        .collection('EnrollmentRequest')
        .document(student.displayName)
        .delete();
    DocumentSnapshot snapshot = await enrolledRef.get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> rejectRequest(Student student) async {
    DocumentReference ref =
        getProfileReference(student.email, UserType.STUDENT);
    await ref.updateData({'enrolled': false, 'enrolledWith': 'none'});
    await ref
        .collection('EnrollmentRequest')
        .document(student.displayName)
        .delete();
    DocumentReference sturef =
        getProfileReference(student.email, UserType.STUDENT);
    DocumentSnapshot snapshot = await sturef.get();
    if (snapshot.data['enrolled'] == false) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> selectStudent({Student student, Project project}) async {
    if (student != null) {
      String devId = await sharedPreferencesHelper.getDevelopersId();
      await getProfileReference(devId, UserType.DEVELOPERS).updateData({
        'current project': project.name,
        'currentlyworkingWith': student.email
      });
      project.studentProfile =
          getProfileReference(student.email, UserType.STUDENT);
      await project.studentProfile.updateData({'currentProject': project.name});
      await project.studentProfile
          .collection('Projects')
          .document(project.name)
          .setData(project.toMap(project));
      await project.projectReference.updateData(project.setRef(project));
      DocumentSnapshot snapshot = await project.studentProfile
          .collection('Projects')
          .document(project.name)
          .get();
      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    } else {
      print('No Student selected');
      return false;
    }
  }

  Future<List<Student>> getEnrolled() async {
    String devId = await sharedPreferencesHelper.getDevelopersId();
    QuerySnapshot collectionReference = await firestore
        .collection('users')
        .document('Enrolled')
        .collection(devId)
        .getDocuments();
    List<Student> student = List<Student>();
    for (var i = 0; i < collectionReference.documents.length; i++) {
      student
          .add(Student.dataFromSnapshot(collectionReference.documents[i].data));
      print(student[i].displayName);
    }
    return student;
  }

  Future<List<Student>> getRequest() async {
    String devId = await sharedPreferencesHelper.getDevelopersId();
    try {
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .document('Profile')
          .collection('Developers')
          .document(devId)
          .collection('EnrollmentRequest')
          .getDocuments();
      List<Student> students = List<Student>();
      if (snapshot.documents.length > 0) {
        for (var i = 0; i < snapshot.documents.length; i++) {
          students.add(Student.requestFromMap(snapshot.documents[i].data));
          print(students[i].displayName);
        }
      } else {
        students = [];
      }
      return students;
    } catch (e) {
      print(e.details);
      List<Student> students = [Student(displayName: "netException")];
      print(e.code);
      return students;
    }
  }

  Future<List<Project>> getProjects() async {
    String devId = await sharedPreferencesHelper.getDevelopersId();
    QuerySnapshot snapshot = await firestore
        .collection('users')
        .document('Projects')
        .collection(devId)
        .orderBy('current', descending: true)
        .getDocuments();
    List<Project> projects = List<Project>();
    for (var i = 0; i < snapshot.documents.length; i++) {
      Project project = Project.fromMap(snapshot.documents[i].data);
      projects.add(project);
      print(project.name);
    }
    return projects;
  }

  Future<Project> getCurrentProject() async {
    Project project;
    //String name = await sharedPreferencesHelper.getCurrentProject();
    String devId = await sharedPreferencesHelper.getDevelopersId();
    QuerySnapshot snap = await firestore
        .collection('users')
        .document('Projects')
        .collection(devId)
        .where('view', isEqualTo: true)
        .getDocuments();
    if (snap.documents.length != 0) {
      project = Project.fromMap(snap.documents.first.data);
    } else {
      project = Project(name: 'none');
    }
    return project;
  }
}
