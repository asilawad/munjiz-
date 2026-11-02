import 'package:get/get.dart';

import '../controllers/task_form_controller.dart';
import '../data/repositories/task_repository.dart';

class TaskFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskFormController>(
      () => TaskFormController(Get.find<TaskRepository>()),
    );
  }
}
