import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/assignment.dart';
import '../../core/theme/app_theme.dart';
import '../view_models/home_view_model.dart';
import '../../practice/views/practice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadAssignments();
    });
  }

  void _showJoinClassDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.group_add, color: AppTheme.primaryBlue),
            SizedBox(width: 8),
            Text('加入班级', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('请输入英语老师提供的 6 位班级邀请码：', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLength: 6,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: '例如：PEPSEL1',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = controller.text.trim();
              if (code.isNotEmpty) {
                final success = await context.read<HomeViewModel>().joinClass(code);
                if (mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(success ? '成功加入班级 $code' : '邀请码格式错误')),
                  );
                }
              }
            },
            child: const Text('确定加入'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('人教版高中英语听说训练'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add_outlined),
            tooltip: '加入班级',
            onPressed: _showJoinClassDialog,
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => viewModel.loadAssignments(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. 顶部学生与班级身份横幅
                  _buildHeaderBanner(viewModel),
                  const SizedBox(height: 16),

                  // 2. 人教版教材册次选择器 (默认选必一)
                  _buildBookSelector(viewModel),
                  const SizedBox(height: 16),

                  // 3. 学情统计指标行
                  _buildStatRow(viewModel),
                  const SizedBox(height: 20),

                  // 4. 任务分类切换与列表标题
                  _buildSectionHeader(viewModel),
                  const SizedBox(height: 12),

                  // 5. 任务作业列表
                  if (viewModel.filteredAssignments.isEmpty)
                    _buildEmptyState()
                  else
                    ...viewModel.filteredAssignments.map((assignment) => _buildAssignmentCard(assignment)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderBanner(HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBlue, Color(0xFF2C74D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: Text('李', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('李华 同学', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('高中英语听力与口语强化班', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: _showJoinClassDialog,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.swap_horiz, size: 16),
                label: const Text('切班', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    viewModel.currentClassCode,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookSelector(HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_stories, color: AppTheme.primaryBlue, size: 18),
              const SizedBox(width: 6),
              const Text(
                '教材册次：',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMain),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Text('新课标人教版', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: viewModel.availableBooks.map((book) {
              final isSelected = viewModel.selectedBook == book;
              final isSelective1 = book == '选择性必修第一册';

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => viewModel.setBook(book),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryBlue.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isSelective1 ? '选必一' : '必修一',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppTheme.textMain,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isSelective1) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.amber : Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '当前',
                                    style: TextStyle(
                                      color: isSelected ? Colors.black86 : Colors.amber.shade900,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            book,
                            style: TextStyle(
                              color: isSelected ? Colors.white70 : AppTheme.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(HomeViewModel viewModel) {
    return Row(
      children: [
        _buildStatItem('待完成任务', '${viewModel.pendingCount} 篇', Icons.assignment_late, AppTheme.accentOrange),
        const SizedBox(width: 10),
        _buildStatItem('已完成任务', '${viewModel.completedCount} 篇', Icons.task_alt, AppTheme.secondaryCyan),
        const SizedBox(width: 10),
        _buildStatItem(
          '平均得分',
          viewModel.averageScore > 0 ? '${viewModel.averageScore.toStringAsFixed(1)} 分' : '--',
          Icons.speed,
          AppTheme.primaryBlue,
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(HomeViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '${viewModel.selectedBook} 听说任务',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textMain),
            ),
          ],
        ),
        Row(
          children: [
            _buildFilterChip('全部', 'all', viewModel),
            const SizedBox(width: 6),
            _buildFilterChip('待完成', 'pending', viewModel),
            const SizedBox(width: 6),
            _buildFilterChip('已完成', 'completed', viewModel),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, HomeViewModel viewModel) {
    final isSelected = viewModel.selectedFilter == value;
    return GestureDetector(
      onTap: () => viewModel.setFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text('当前分类暂无作业', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PracticeScreen(assignment: assignment),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标签行 (册次/单元板块 + 任务类型)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '人教版 ${assignment.bookName} · ${assignment.unitTitle}',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(assignment.taskType.badgeIcon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          assignment.taskType.displayName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 任务大标题
                Text(
                  assignment.title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textMain),
                ),
                const SizedBox(height: 6),

                // 板块与截止时间
                Row(
                  children: [
                    const Icon(Icons.menu_book, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(assignment.sectionName, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    const SizedBox(width: 12),
                    const Icon(Icons.timer_outlined, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '截止: ${DateFormat('MM-dd HH:mm').format(assignment.dueDate)}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Colors.black12),
                const SizedBox(height: 10),

                // 底部动作行与成绩状态
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('示范口音: ', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        Text(
                          assignment.accentMode.displayName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                        ),
                      ],
                    ),
                    assignment.isCompleted
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, size: 14, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  '已完成 ${assignment.lastScore ?? 90}分',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PracticeScreen(assignment: assignment),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            icon: const Icon(Icons.play_arrow, size: 16),
                            label: const Text('开始训练'),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
