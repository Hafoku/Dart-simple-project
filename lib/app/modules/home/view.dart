import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/app/core/utils/extensions.dart';
import 'package:todo_app_getx/app/core/values/colors.dart';
import 'package:todo_app_getx/app/data/models/task.dart';
import 'package:todo_app_getx/app/modules/home/controller.dart';
import 'package:todo_app_getx/app/modules/home/widgets/add_card.dart';
import 'package:todo_app_getx/app/modules/home/widgets/add_dialog.dart';
import 'package:todo_app_getx/app/modules/home/widgets/task_card.dart';
import 'package:todo_app_getx/app/modules/report/view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 
        ? 6 
        : screenWidth > 800 
            ? 4 
            : 2;
    
    final maxContentWidth = screenWidth > 1400 ? 1400.0 : screenWidth;

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          sizing: StackFit.expand,
          children: [
            AnimatedOpacity(
              opacity: controller.tabIndex.value == 0 ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: SafeArea(
                child: Center(
                  child: SizedBox(
                    width: maxContentWidth,
                    child: ListView(
                      children: [
                        if (screenWidth > 800)
                          Padding(
                            padding: EdgeInsets.all(4.0.wp),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'my_tasks'.tr,
                                    style: TextStyle(
                                      fontSize: 24.0.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness == Brightness.dark 
                                          ? Colors.white 
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: TextField(
                                    controller: controller.searchController,
                                    decoration: InputDecoration(
                                      hintText: 'search'.tr,
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.dark 
                                            ? Colors.white70 
                                            : Colors.grey[700],
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Theme.of(context).brightness == Brightness.dark 
                                            ? Colors.white70 
                                            : Colors.grey[700],
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 3.0.wp,
                                        vertical: 2.0.wp,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.dark 
                                          ? Colors.white 
                                          : Colors.black,
                                    ),
                                    onChanged: controller.updateSearchText,
                                  ),
                                ),
                                SizedBox(width: 3.0.wp),
                                IconButton(
                                  icon: Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                    size: screenWidth > 1200 ? 32.0 : 24.0,
                                  ),
                                  onPressed: () => controller.showSettingsDialog(context),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          Padding(
                            padding: EdgeInsets.all(4.0.wp),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: TextField(
                                    controller: controller.searchController,
                                    decoration: InputDecoration(
                                      hintText: 'search'.tr,
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.dark 
                                            ? Colors.white70 
                                            : Colors.grey[700],
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Theme.of(context).brightness == Brightness.dark 
                                            ? Colors.white70 
                                            : Colors.grey[700],
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 3.0.wp,
                                        vertical: 2.0.wp,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.dark 
                                          ? Colors.white 
                                          : Colors.black,
                                    ),
                                    onChanged: controller.updateSearchText,
                                  ),
                                ),
                                SizedBox(width: 3.0.wp),
                                IconButton(
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => controller.showSettingsDialog(context),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                            child: Text(
                              'my_tasks'.tr,
                              style: TextStyle(
                                fontSize: 24.0.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white 
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0.wp),
                          child: Obx(
                            () => GridView.count(
                              crossAxisCount: crossAxisCount,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              mainAxisSpacing: 2.0.wp,
                              crossAxisSpacing: 2.0.wp,
                              children: [
                                ...controller.filteredTasks.map((element) => 
                                  LongPressDraggable(
                                    data: element,
                                    onDragStarted: () => 
                                        controller.changeDeleting(true),
                                    onDraggableCanceled: (velocity, offset) =>
                                        controller.changeDeleting(false),
                                    onDragEnd: (details) =>
                                        controller.changeDeleting(false),
                                    feedback: Opacity(
                                      opacity: 0.5,
                                      child: TaskCard(task: element),
                                    ),
                                    child: TaskCard(task: element),
                                  ),
                                ),
                                AddCard(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: controller.tabIndex.value == 1 ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: ReportPage(),
            ),
          ],
        ),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ____) {
          return Obx(
            () => FloatingActionButton(
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('no_tasks'.tr);
                }
              },
              backgroundColor: controller.deleting.value ? Colors.red : darkGreen,
              child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
            ),
          );
        },
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('deleted'.tr);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (int index) => controller.changeTabIndex(index),
          currentIndex: controller.tabIndex.value,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: darkGreen,
          backgroundColor: Theme.of(context).brightness == Brightness.light 
              ? Colors.white 
              : Colors.grey[850],
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              label: 'home'.tr,
              icon: Icon(Icons.apps),
            ),
            BottomNavigationBarItem(
              label: 'report'.tr,
              icon: Icon(Icons.data_usage),
            )
          ],
        ),
      ),
    );
  }
}
