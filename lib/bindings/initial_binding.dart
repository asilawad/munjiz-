import 'package:get/get.dart';

import '../core/utils/app_platform.dart';
import '../data/repositories/synced_task_repository.dart';
import '../data/repositories/task_repository.dart';
import '../data/services/auth_service.dart';
import '../data/services/firebase_bootstrap.dart';
import '../data/services/local_task_service.dart';
import '../data/services/notification_service.dart';
import '../data/services/push_service.dart';
import '../data/services/task_sync_service.dart';

/// App-wide dependencies.
///
/// Controllers depend on [TaskRepository] only. With Firebase available the
/// repository mirrors changes to the cloud; otherwise it is local-only.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final LocalTaskService local = Get.put<LocalTaskService>(
      LocalTaskService(),
      permanent: true,
    );
    final bool cloud = FirebaseBootstrap.isReady;

    if (cloud) {
      final AuthService auth = Get.put<AuthService>(
        AuthService(),
        permanent: true,
      );
      Get.put<TaskRepository>(
        SyncedTaskRepository(local, TaskSyncService(local, auth)),
        permanent: true,
      );
    } else {
      Get.put<TaskRepository>(local, permanent: true);
    }

    if (AppPlatform.supportsMobileServices) {
      final NotificationService notifications = Get.put<NotificationService>(
        NotificationService(Get.find<TaskRepository>()),
        permanent: true,
      );
      if (cloud) {
        Get.put<PushService>(
          PushService(Get.find<AuthService>(), notifications),
          permanent: true,
        );
      }
    }
  }
}
