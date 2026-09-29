import 'package:highschool_english_student/domain/models/assignment.dart';
import 'package:highschool_english_student/data/services/mock_data_service.dart';

class AssignmentRepository {
  List<Assignment>? _cachedAssignments;

  Future<List<Assignment>> getAssignments({bool forceRefresh = false}) async {
    if (_cachedAssignments != null && !forceRefresh) {
      return _cachedAssignments!;
    }
    // 模拟数据加载
    await Future.delayed(const Duration(milliseconds: 300));
    _cachedAssignments = MockDataService.getAssignments();
    return _cachedAssignments!;
  }

  Future<Assignment?> getAssignmentById(String id) async {
    final list = await getAssignments();
    return list.cast<Assignment?>().firstWhere(
          (a) => a?.id == id,
          orElse: () => null,
        );
  }
}
