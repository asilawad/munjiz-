import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../data/repositories/task_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<TaskRepository>()),
    );
  }
}
