import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/app/core/utils/extensions.dart';
import 'package:todo_app_getx/app/core/values/colors.dart';
import 'package:todo_app_getx/app/data/models/task.dart';
import 'package:todo_app_getx/app/modules/home/controller.dart';
import 'package:todo_app_getx/app/widgets/icon.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var cardWidth = Get.width - 12.0.wp;
    return Container(
      width: cardWidth / 2,
      height: cardWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          DateTime? selectedDate;
          TimeOfDay? selectedTime;
          
          await Get.defaultDialog(
            titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
            radius: 10,
            title: 'task_type'.tr,
            titleStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black,
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey[800] 
                : Colors.white,
            content: Form(
              key: homeCtrl.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                    child: TextFormField(
                      controller: homeCtrl.formEditCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'title'.tr,
                        labelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.white70 
                              : Colors.grey[700],
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white 
                            : Colors.black,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'enter_task_title'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0.wp),
                    child: Wrap(
                      spacing: 2.0.wp,
                      children: icons
                          .map(
                            (element) => Obx(
                              () {
                                final index = icons.indexOf(element);
                                return ChoiceChip(
                                  selectedColor: Colors.grey[200],
                                  pressElevation: 4,
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark 
                                      ? Colors.grey[700] 
                                      : Colors.white,
                                  label: element,
                                  selected: homeCtrl.chipIndex.value == index,
                                  onSelected: (bool selected) {
                                    homeCtrl.chipIndex.value =
                                        selected ? index : 0;
                                  },
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0.wp),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          selectedDate = date;
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            selectedTime = time;
                          }
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text('select_deadline'.tr),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: const Size(150, 40),
                    ),
                    onPressed: () {
                      if (homeCtrl.formKey.currentState!.validate()) {
                        int icon = icons[homeCtrl.chipIndex.value].icon!.codePoint;
                        String color = icons[homeCtrl.chipIndex.value].color!.toHex();
                        
                        DateTime? deadline;
                        if (selectedDate != null && selectedTime != null) {
                          deadline = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                        }
                        
                        var task = Task(
                          title: homeCtrl.formEditCtrl.text,
                          icon: icon,
                          color: color,
                          deadline: deadline,
                        );
                        
                        Get.back();
                        homeCtrl.addTask(task)
                            ? EasyLoading.showSuccess('task_created'.tr)
                            : EasyLoading.showError('task_exists'.tr);

                        homeCtrl.formEditCtrl.clear();
                        homeCtrl.changeChipIndex(0);
                      }
                    },
                    child: Text('add'.tr),
                  )
                ],
              ),
            ),
          );
          homeCtrl.formEditCtrl.clear();
          homeCtrl.changeChipIndex(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [10, 8],
          child: Center(
            child: Icon(
              Icons.add,
              size: 10.0.wp,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
