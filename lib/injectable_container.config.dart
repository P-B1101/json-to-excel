// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:file_picker/file_picker.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isolated_worker/js_isolated_worker.dart' as _i4;

import 'feature/js_to_excel/data/data_source/js_data_source.dart' as _i5;
import 'feature/js_to_excel/data/repository/json_to_excel_repository_impl.dart'
    as _i7;
import 'feature/js_to_excel/domain/repository/json_to_excel_repository.dart'
    as _i6;
import 'feature/js_to_excel/domain/use_case/start_excel_to_json_process.dart'
    as _i8;
import 'feature/js_to_excel/domain/use_case/start_json_to_excel_process.dart'
    as _i9;
import 'injectable_container.dart'
    as _i10; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final registerFilePicker = _$RegisterFilePicker();
  final registerJsIsolatedWorker = _$RegisterJsIsolatedWorker();
  gh.factory<_i3.FilePicker>(() => registerFilePicker.client);
  gh.factory<_i4.JsIsolatedWorker>(() => registerJsIsolatedWorker.worker);
  gh.lazySingleton<_i5.JSDataSource>(() => _i5.JSDataSourceImpl(
        worker: get<_i4.JsIsolatedWorker>(),
        filePicker: get<_i3.FilePicker>(),
      ));
  gh.lazySingleton<_i6.JsonToExcelRepository>(
      () => _i7.JsonToExcelRepositoryImpl(dataSource: get<_i5.JSDataSource>()));
  gh.lazySingleton<_i8.StartExcelToJsonProcess>(() =>
      _i8.StartExcelToJsonProcess(
          repository: get<_i6.JsonToExcelRepository>()));
  gh.lazySingleton<_i9.StartJsonToExcelProcess>(() =>
      _i9.StartJsonToExcelProcess(
          repository: get<_i6.JsonToExcelRepository>()));
  return get;
}

class _$RegisterFilePicker extends _i10.RegisterFilePicker {}

class _$RegisterJsIsolatedWorker extends _i10.RegisterJsIsolatedWorker {}
