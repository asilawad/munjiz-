import 'package:get/get.dart';

import '../controllers/task_detail_controller.dart';
import '../data/repositories/task_repository.dart';

class TaskDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskDetailController>(
      () => TaskDetailController(Get.find<TaskRepository>()),
    );
  }
}
