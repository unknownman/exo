import 'exceptions.dart';
import 'failure.dart';
import '../constants/app_strings.dart';

mixin ErrorHandlerMixin {
  Future<Result<T>> executeSafely<T>(Future<T> Function() execution) async {
    try {
      final result = await execution();
      return Success(result);
    } on DatabaseException catch (e) {
      return Error(DatabaseFailure(e.message));
    } on Exception catch (e) {
      return Error(DatabaseFailure('${AppStrings.databaseSaveError} (${e.toString()})'));
    } catch (e) {
      return Error(UnknownFailure('${AppStrings.unknownError} (${e.toString()})'));
    }
  }
}
