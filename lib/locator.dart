import 'package:get_it/get_it.dart';
import 'package:helphub/Developers/Models/DeveloperHomeModel.dart';
import 'package:helphub/Developers/services/DeveloperHomeServices.dart';
import 'package:helphub/Students/Models/StudentHomeModel.dart';
import 'package:helphub/Students/Services/StudentHomeServices.dart';
import 'imports.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => SharedPreferencesHelper());

  locator.registerLazySingleton(() => AuthenticationServices());
  locator.registerFactory(() => LoginPageModel());

  locator.registerLazySingleton(() => StudentProfilePageModel());
  locator.registerLazySingleton(() => StudentProfileServices());
  locator.registerLazySingleton(() => DeveloperProfilePageModel());
  locator.registerLazySingleton(() => DeveloperProfileServices());
  locator.registerLazySingleton(() => StudentHomeModel());
  locator.registerLazySingleton(() => StudentHomeServices());
  locator.registerLazySingleton(() => DeveloperHomeModel());
  locator.registerLazySingleton(() => DeveloperHomeServices());

  locator.registerLazySingleton(() => StorageServices());
}
