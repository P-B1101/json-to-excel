import 'package:injectable/injectable.dart';

import '../repository/json_to_excel_repository.dart';

@lazySingleton
class StartJsonToExcelProcess {
  final JsonToExcelRepository repository;
  const StartJsonToExcelProcess({
    required this.repository,
  });

  Stream<String> call() => repository.startJsonToExcelProccess();
}
