import 'package:flutter/foundation.dart';
import 'package:highschool_english_student/data/repositories/assignment_repository.dart';
import 'package:highschool_english_student/domain/models/assignment.dart';

class HomeViewModel extends ChangeNotifier {
  final AssignmentRepository _repository;

  HomeViewModel({required AssignmentRepository repository}) : _repository = repository;

  List<Assignment> _assignments = [];
  bool _isLoading = false;
  String _currentClassCode = '高二 (1) 班 [CODE: PEP-SEL1]';
  String _selectedBook = '选择性必修第一册'; // 默认聚焦「选择性必修第一册（选必一）」
  String _selectedFilter = 'all'; // all | pending | completed

  List<Assignment> get assignments => _assignments;
  bool get isLoading => _isLoading;
  String get currentClassCode => _currentClassCode;
  String get selectedBook => _selectedBook;
  String get selectedFilter => _selectedFilter;

  List<String> get availableBooks => [
        '选择性必修第一册',
        '必修第一册',
      ];

  int get pendingCount => _assignments.where((a) => !a.isCompleted && a.bookName == _selectedBook).length;
  int get completedCount => _assignments.where((a) => a.isCompleted && a.bookName == _selectedBook).length;

  double get averageScore {
    final completed = _assignments.where((a) => a.isCompleted && a.lastScore != null && a.bookName == _selectedBook).toList();
    if (completed.isEmpty) return 0.0;
    final sum = completed.fold<double>(0.0, (prev, curr) => prev + (curr.lastScore ?? 0.0));
    return sum / completed.length;
  }

  List<Assignment> get filteredAssignments {
    return _assignments.where((a) {
      final matchesBook = a.bookName == _selectedBook;
      if (!matchesBook) return false;

      if (_selectedFilter == 'pending') {
        return !a.isCompleted;
      } else if (_selectedFilter == 'completed') {
        return a.isCompleted;
      }
      return true;
    }).toList();
  }

  Future<void> loadAssignments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _assignments = await _repository.getAssignments(forceRefresh: true);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setBook(String book) {
    _selectedBook = book;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<bool> joinClass(String classCode) async {
    if (classCode.trim().length < 4) return false;
    _currentClassCode = '已加入班级 [CODE: ${classCode.toUpperCase()}]';
    notifyListeners();
    return true;
  }
}
