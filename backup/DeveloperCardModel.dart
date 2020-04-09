import 'package:helphub/core/enums/ViewState.dart';
import 'package:helphub/core/viewmodel/BaseModel.dart';
import 'package:helphub/imports.dart';

import 'DeveloperCardServices.dart';

class DeveloperCardModel extends BaseModel {
  DeveloperCardServices developerCardServices =
      locator<DeveloperCardServices>();
  bool requested ;

  Future<bool> getEnrollmentAndRequestStatus(DocumentReference reference)async{
    setState(ViewState.Busy);
    setState2(ViewState.Busy);
    requested = await developerCardServices.getStatus(reference);
    setState2(ViewState.Idle);
    setState2(ViewState.Idle);
    return requested;
  }
  Future<bool> sendEnrollmentRequest(Student student, Developer developer,
      DocumentReference documentReference) async {
    setState(ViewState.Busy);
    setState2(ViewState.Busy);
    bool res = await developerCardServices.requestForEnrollment(
        student, developer, documentReference);
    setState2(ViewState.Idle);
    setState2(ViewState.Idle);
    return res;
  }
}
