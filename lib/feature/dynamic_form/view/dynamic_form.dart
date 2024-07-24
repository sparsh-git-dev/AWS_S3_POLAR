import 'package:polaris/feature/dynamic_form/controller/form_screen_controller.dart';
import 'package:polaris/feature/dynamic_form/view/widgets/image_with_dialog.dart';
import 'package:polaris/utility/handler/handler.dart';
import 'package:polaris/utility/permision/permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/gram_power_model.dart';

class DynamicForm extends StatelessWidget {
  const DynamicForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormScreenController>(builder: (logic) {
      return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 26,
        ),
        shrinkWrap: true,
        itemCount: logic.model?.fields.length ?? 0,
        itemBuilder: (context, index) {
          final Field field = logic.model!.fields[index];
          switch (field.componentType) {
            case 'EditText':
              return Column(
                key: ValueKey(index),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.metaInfo.label +
                        (field.metaInfo.mandatory == 'yes' ? " *" : ""),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  GetBuilder<FormScreenController>(
                      id: field.metaInfo.label,
                      builder: (logic) {
                        if (field.answer.isEmpty &&
                            logic.isValidateFields &&
                            field.metaInfo.mandatory == 'yes') {
                          return const Text(
                            "Required",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          );
                        }
                        return Container();
                      }),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: TextEditingController(text: field.answer),
                    onChanged: (String value) {
                      field.answer = value;
                      logic.update([field.metaInfo.label]);
                    },
                    inputFormatters:
                        field.metaInfo.componentInputType == 'INTEGER'
                            ? [
                                FilteringTextInputFormatter.digitsOnly,
                              ]
                            : null,
                    decoration: InputDecoration(
                      label: null,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    keyboardType: field.metaInfo.componentInputType == 'INTEGER'
                        ? TextInputType.number
                        : TextInputType.text,
                    validator: field.metaInfo.mandatory == 'yes' &&
                            logic.isValidateFields
                        ? (value) => value!.isEmpty ? 'Required' : null
                        : null,
                  ),
                ],
              );

            case 'CheckBoxes':
              return GetBuilder<FormScreenController>(
                  key: ValueKey(index),
                  id: field.metaInfo.label,
                  builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field.metaInfo.label +
                              (field.metaInfo.mandatory == 'yes' ? " *" : ""),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if ((field.answers?.isEmpty ?? true) &&
                            logic.isValidateFields &&
                            field.metaInfo.mandatory == 'yes')
                          const Text(
                            "Required",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          ),
                        ...field.metaInfo.options!.map((e) => CheckboxListTile(
                              title: Text(e),
                              value: field.answers?.contains(e) ?? false,
                              onChanged: (bool? value) {
                                field.answers ??= [];
                                if (value != null && value) {
                                  field.answers!.add(e);
                                } else {
                                  field.answers!.remove(e);
                                }
                                logic.update([field.metaInfo.label]);
                              },
                            ))
                      ],
                    );
                  });
            case 'RadioGroup':
              return GetBuilder<FormScreenController>(
                  key: ValueKey(index),
                  id: field.metaInfo.label,
                  builder: (logic) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field.metaInfo.label +
                              (field.metaInfo.mandatory == 'yes' ? " *" : ""),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if (field.answer.isEmpty &&
                            logic.isValidateFields &&
                            field.metaInfo.mandatory == 'yes')
                          const Text(
                            "Required",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          ),
                        ...field.metaInfo.options!.map((option) {
                          return RadioListTile(
                            title: Text(option),
                            value: option,
                            groupValue: field.answer,
                            onChanged: (String? value) {
                              field.answer = value ?? "";
                              logic.update([field.metaInfo.label]);
                            },
                          );
                        }),
                      ],
                    );
                  });
            case 'DropDown':
              return GetBuilder<FormScreenController>(
                  id: field.metaInfo.label,
                  builder: (logic) {
                    return Column(
                      key: ValueKey(index),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field.metaInfo.label +
                              (field.metaInfo.mandatory == 'yes' ? " *" : ""),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if (field.answer.isEmpty &&
                            logic.isValidateFields &&
                            field.metaInfo.mandatory == 'yes')
                          const Text(
                            "Required",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: field.answer.isEmpty ? null : field.answer,
                          hint: const Text("--SELECT--"),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                          validator: field.metaInfo.mandatory == 'yes' &&
                                  logic.isValidateFields
                              ? (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null
                              : null,
                          items: List.from(field.metaInfo.options!
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))),
                          onChanged: (String? value) {
                            field.answer = value ?? "";
                            logic.update([field.metaInfo.label]);
                          },
                        ),
                      ],
                    );
                  });
            case 'CaptureImages':
              return GetBuilder<FormScreenController>(
                  key: ValueKey(index),
                  id: field.metaInfo.label,
                  builder: (logic) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field.metaInfo.label +
                              (field.metaInfo.mandatory == 'yes' ? " *" : ""),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if (field.answer.isEmpty &&
                            logic.isValidateFields &&
                            field.metaInfo.mandatory == 'yes')
                          const Text(
                            "Required",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? photo = await picker.pickImage(
                                  source: ImageSource.camera);

                              bool storagePermission =
                                  await AppPermission.getStoragePermission(
                                      Get.context!);

                              if (photo != null && storagePermission) {
                                String filePath =
                                    await ImageHandler.savePictureToFolder(
                                        photo,
                                        field.metaInfo.savingFolder ??
                                            "POLARIS");
                                field.answer = filePath.split("/").last;

                                logic.update([field.metaInfo.label]);
                                ScaffoldMessenger.of(Get.context!)
                                    .showSnackBar(SnackBar(
                                  content: Text('Image saved to $filePath'),
                                ));
                                field.answer =
                                    await logic.uploadImage(filePath) ??
                                        filePath;
                              }
                            },
                            child: Text(field.metaInfo.label),
                          ),
                        ),
                        if (field.answer.isNotEmpty)
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ImageDialog(
                                  imagePath: field.answer.contains("cloudinary")
                                      ? ""
                                      : field.answer,
                                  imageUrl: field.answer,
                                );
                              },
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.blue[100],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    field.answer.split("/").last,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(
                                      Icons.remove_red_eye_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  });
            default:
              return Container();
          }
        },
      );
    });
  }
}
