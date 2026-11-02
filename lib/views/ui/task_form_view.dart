import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/task_form_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../widgets/app_button.dart';
import '../widgets/category_selector.dart';
import '../widgets/content_width_box.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/gradient_background.dart';
import '../widgets/labeled_field.dart';
import '../widgets/routine_picker.dart';

/// Screen 2 - add / edit task.
class TaskFormView extends GetView<TaskFormController> {
  const TaskFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: controller.cancel,
          ),
          title: Text(
            controller.isEditing
                ? AppStrings.editTaskTitle
                : AppStrings.addTaskTitle,
          ),
        ),
        body: SafeArea(
          child: ContentWidthBox(
            child: Form(
              key: controller.formKey,
              child: ListView(
                padding: AppDimensions.screenPadding,
                children: <Widget>[
                  LabeledField(
                    label: AppStrings.fieldTitle,
                    child: TextFormField(
                      controller: controller.titleController,
                      maxLength: AppConfig.titleMaxLength,
                      validator: Validators.required,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: AppStrings.titleHint,
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  LabeledField(
                    label: AppStrings.fieldDescription,
                    child: TextFormField(
                      controller: controller.descriptionController,
                      maxLength: AppConfig.descriptionMaxLength,
                      minLines: AppConfig.descriptionMinLines,
                      maxLines: AppConfig.descriptionMaxLines,
                      decoration: const InputDecoration(
                        hintText: AppStrings.descriptionHint,
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  const LabeledField(
                    label: AppStrings.fieldCategory,
                    child: CategorySelector(),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  LabeledField(
                    label: AppStrings.fieldDueDate,
                    child: Obx(
                      () => DatePickerField(
                        value: controller.dueDate.value,
                        onChanged: controller.setDueDate,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  const RoutinePicker(),
                  const SizedBox(height: AppDimensions.spaceXl),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AppButton(
                          label: AppStrings.save,
                          onPressed: controller.save,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceSm),
                      Expanded(
                        child: AppButton(
                          label: AppStrings.cancel,
                          style: AppButtonStyle.outlined,
                          onPressed: controller.cancel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
