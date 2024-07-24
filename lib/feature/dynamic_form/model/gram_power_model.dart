import 'dart:convert';

import '../../../polaris/model/polaris_app_model.dart';

final class GramPowerModel extends PolarisAppModel {
  String formName;
  List<Field> fields;

  GramPowerModel({
    required this.formName,
    required this.fields,
  });

  factory GramPowerModel.fromRawJson(String str) =>
      GramPowerModel.fromJson(json.decode(str));

  @override
  String toRawJson() => json.encode(toJson());

  static T fromJson<T>(Map<String, dynamic> json) =>
      GramPowerModel._fromJson(json) as T;

  factory GramPowerModel._fromJson(Map<String, dynamic> json) => GramPowerModel(
        formName: json["form_name"],
        fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "form_name": formName,
        "fields": List<dynamic>.from(fields.map((x) => x.toJson())),
      };

  @override
  GramPowerModel copyWith({
    String? formName,
    List<Field>? fields,
  }) {
    return GramPowerModel(
      formName: formName ?? this.formName,
      fields: fields ?? this.fields,
    );
  }
}

class Field {
  MetaInfo metaInfo;
  String componentType;
  String answer;
  List<String>? answers;

  Field({
    required this.metaInfo,
    required this.componentType,
    this.answer = "",
    this.answers,
  });

  factory Field.fromRawJson(String str) => Field.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        metaInfo: MetaInfo.fromJson(json["meta_info"]),
        componentType: json["component_type"],
      );

  Map<String, dynamic> toJson() => {
        "meta_info": metaInfo.toJson(),
        "component_type": componentType,
      };

  /// The function `toPostPayload` creates a map with key-value pairs from a JSON object and includes an
  /// "answer" field with a comma-separated list of answers if available.
  Map<String, dynamic> toPostPayload() => {
        ...toJson(),
        // answers for Checkbox , storing them as String
        "answer": answers?.isNotEmpty ?? false ? answers!.join(", ") : answer
      };
}

class MetaInfo {
  String label;
  String? componentInputType;
  String mandatory;
  List<String>? options;
  int? noOfImagesToCapture;
  String? savingFolder;

  MetaInfo({
    required this.label,
    this.componentInputType,
    required this.mandatory,
    this.options,
    this.noOfImagesToCapture,
    this.savingFolder,
  });

  factory MetaInfo.fromRawJson(String str) =>
      MetaInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetaInfo.fromJson(Map<String, dynamic> json) => MetaInfo(
        label: json["label"],
        componentInputType: json["component_input_type"],
        mandatory: json["mandatory"],
        options: json["options"] == null
            ? []
            : List<String>.from(
                json["options"]!.map((x) => x.toString().trim())),
        noOfImagesToCapture: json["no_of_images_to_capture"],
        savingFolder: json["saving_folder"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "component_input_type": componentInputType,
        "mandatory": mandatory,
        "options":
            options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "no_of_images_to_capture": noOfImagesToCapture,
        "saving_folder": savingFolder,
      };
}
