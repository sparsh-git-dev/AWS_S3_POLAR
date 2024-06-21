import 'dart:convert';

class GramPowerModel {
  String formName;
  List<Field> fields;

  GramPowerModel({
    required this.formName,
    required this.fields,
  });

  factory GramPowerModel.fromRawJson(String str) =>
      GramPowerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GramPowerModel.fromJson(Map<String, dynamic> json) => GramPowerModel(
        formName: json["form_name"],
        fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "form_name": formName,
        "fields": List<dynamic>.from(fields.map((x) => x.toJson())),
      };
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
