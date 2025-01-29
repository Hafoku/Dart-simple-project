import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_app_getx/app/core/utils/extensions.dart';
import 'package:todo_app_getx/app/modules/home/controller.dart';
import '../../core/values/colors.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: Obx(() {
          var createdTasks = homeCtrl.getTotalTask();
          int completedTasks = homeCtrl.getTotalDoneTask();
          var liveTasks = createdTasks - completedTasks;
          var percent = (createdTasks == 0 ? 0 : (completedTasks / createdTasks * 100)).toStringAsFixed(0);
          
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(4.0.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок и настройки
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'statistics'.tr,
                        style: TextStyle(
                          fontSize: 24.0.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.grey),
                        onPressed: () => homeCtrl.showSettingsDialog(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.0.wp),
                  Text(
                    DateFormat.yMMMd().format(DateTime.now()),
                    style: TextStyle(fontSize: 14.0.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 5.0.wp),
                  // Статистика
                  Container(
                    padding: EdgeInsets.all(3.0.wp),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusCard(
                          context,
                          Colors.green,
                          liveTasks,
                          'active_tasks'.tr,
                        ),
                        _buildStatusCard(
                          context,
                          Colors.orange,
                          completedTasks,
                          'completed'.tr,
                        ),
                        _buildStatusCard(
                          context,
                          Colors.blue,
                          createdTasks,
                          'created'.tr,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0.wp),
                  // Круговой индикатор
                  Center(
                    child: SizedBox(
                      width: 70.0.wp,
                      height: 70.0.wp,
                      child: CircularStepProgressIndicator(
                        totalSteps: createdTasks == 0 ? 1 : createdTasks,
                        currentStep: completedTasks,
                        stepSize: 20,
                        selectedColor: purple,
                        unselectedColor: Colors.grey[200],
                        padding: 0,
                        width: 150,
                        height: 150,
                        selectedStepSize: 22,
                        roundedCap: (_, __) => true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$percent%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0.sp,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 1.0.wp),
                            Text(
                              'efficiency'.tr,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, Color color, int number, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 3.0.wp,
          width: 3.0.wp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 0.5.wp, color: color),
          ),
        ),
        SizedBox(height: 2.0.wp),
        Text(
          number.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0.sp,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 2.0.wp),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0.sp,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
