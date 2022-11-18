import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isolated_worker/js_isolated_worker.dart';

import 'injectable_container.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async => $initGetIt(getIt);

@lazySingleton
@module
abstract class RegisterJsIsolatedWorker {
  JsIsolatedWorker get worker => JsIsolatedWorker();
}

@lazySingleton
@module
abstract class RegisterFilePicker {
  FilePicker get client => FilePicker.platform;
}
