import 'package:injectable/injectable.dart';

import '../repository/json_to_excel_repository.dart';

@lazySingleton
class StartExcelToJsonProcess {
  final JsonToExcelRepository repository;
  const StartExcelToJsonProcess({
    required this.repository,
  });

  Stream<String> call() => repository.startExcelToJsonProccess();
}
