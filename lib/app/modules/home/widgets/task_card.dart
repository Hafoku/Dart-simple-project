import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_app_getx/app/core/utils/extensions.dart';
import 'package:todo_app_getx/app/data/models/task.dart';
import 'package:todo_app_getx/app/modules/detail/view.dart';
import 'package:todo_app_getx/app/modules/home/controller.dart';

class TaskCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  final Task task;
  TaskCard({super.key, required this.task});

  String _getRemainingTime(DateTime? deadline) {
    if (deadline == null) return '';
    
    final now = DateTime.now();
    final difference = deadline.difference(now);
    
    if (difference.isNegative) {
      return 'просрочено'.tr;
    }
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ${'days_left'.tr}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${'hours_left'.tr}';
    } else {
      return '${difference.inMinutes} ${'minutes_left'.tr}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = HexColor.fromHex(task.color);
    final cardWidth = Get.width - 12.0.wp;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        homeCtrl.changeTask(task);
        homeCtrl.changeTodo(task.todos ?? []);
        Get.to(() => DetailPage());
      },
      child: Container(
        width: cardWidth / 2,
        height: cardWidth / 2,
        margin: EdgeInsets.all(3.0.wp),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey[300]!,
              blurRadius: 8,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5,
              child: StepProgressIndicator(
                totalSteps: homeCtrl.isTodoEmpty(task) ? 1 : task.todos!.length,
                currentStep:
                    homeCtrl.isTodoEmpty(task) ? 0 : homeCtrl.getDoneTodo(task),
                size: 5,
                padding: 0,
                selectedGradientColor: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.5), color],
                ),
                unselectedGradientColor: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark ? Colors.grey[800]! : Colors.white,
                    isDark ? Colors.grey[800]! : Colors.white
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0.wp),
                    child: Icon(
                      IconData(task.icon, fontFamily: 'MaterialIcons'),
                      color: color,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0.wp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0.sp,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.0.wp),
                        Text(
                          '${task.todos?.length ?? 0} ${'tasks'.tr}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        if (task.deadline != null) ...[
                          SizedBox(height: 2.0.wp),
                          Text(
                            _getRemainingTime(task.deadline),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10.0.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
