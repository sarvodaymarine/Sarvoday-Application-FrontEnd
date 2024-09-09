import 'package:sarvoday_marine/features/report_module/data/models/image_config_model.dart';

class ContainerModel {
  String? containerNo;
  String? maxGrossWeight;
  String? tareWeight;
  String? containerSize;
  String? batchNo;
  String? lineSealNo;
  String? customSealNo;
  String? typeOfBaggage;
  String? baggageName;
  int? quantity;
  int? noOfPkg;
  String? netWeight;
  String? comment;
  String? background;
  String? survey;
  String? packing;
  String? baggageCondition;
  String? conclusion;
  String? containerReportUrl;
  List<ContainerImageModel>? containerImages;

  ContainerModel({
    this.containerNo,
    this.maxGrossWeight,
    this.tareWeight,
    this.containerSize,
    this.batchNo,
    this.lineSealNo,
    this.customSealNo,
    this.typeOfBaggage,
    this.baggageName,
    this.quantity,
    this.noOfPkg,
    this.netWeight,
    this.comment,
    this.background,
    this.survey,
    this.packing,
    this.baggageCondition,
    this.conclusion,
    this.containerReportUrl,
    this.containerImages,
  });

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
        containerNo: json['containerNo'],
        maxGrossWeight: json['maxGrossWeight'],
        tareWeight: json['tareWeight'],
        containerSize: json['containerSize'],
        batchNo: json['batchNo'],
        lineSealNo: json['lineSealNo'],
        customSealNo: json['customSealNo'],
        typeOfBaggage: json['typeOfBaggage'],
        baggageName: json['baggageName'],
        quantity: json['quantity'],
        noOfPkg: json['noOfPkg'],
        netWeight: json['netWeight'],
        comment: json['comment'],
        background: json['background'],
        survey: json['survey'],
        packing: json['packing'],
        baggageCondition: json['baggageCondition'],
        conclusion: json['conclusion'],
        containerReportUrl: json['containerReportUrl'],
        containerImages: (json['containerImages'] as List<dynamic>?)
            ?.map((item) => ContainerImageModel.fromJson(item))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'containerNo': containerNo,
      'maxGrossWeight': maxGrossWeight,
      'tareWeight': tareWeight,
      'containerSize': containerSize,
      'batchNo': batchNo,
      'lineSealNo': lineSealNo,
      'customSealNo': customSealNo,
      'typeOfBaggage': typeOfBaggage,
      'baggageName': baggageName,
      'quantity': quantity,
      'noOfPkg': noOfPkg,
      'netWeight': netWeight,
      'comment': comment,
      'background': background,
      'survey': survey,
      'packing': packing,
      'baggageCondition': baggageCondition,
      'conclusion': conclusion,
      'containerReportUrl': containerReportUrl,
      'containerImages':
          containerImages?.map((image) => image.toJson()).toList(),
    };
  }

  ContainerModel copyWith({
    String? containerNo,
    String? maxGrossWeight,
    String? tareWeight,
    String? containerSize,
    String? batchNo,
    String? lineSealNo,
    String? customSealNo,
    String? typeOfBaggage,
    String? baggageName,
    int? quantity,
    int? noOfPkg,
    String? netWeight,
    String? comment,
    String? background,
    String? survey,
    String? packing,
    String? baggageCondition,
    String? conclusion,
    String? containerReportUrl,
    List<ContainerImageModel>? containerImages,
  }) {
    return ContainerModel(
        containerNo: containerNo ?? this.containerNo,
        maxGrossWeight: maxGrossWeight ?? this.maxGrossWeight,
        tareWeight: tareWeight ?? this.tareWeight,
        containerSize: containerSize ?? this.containerSize,
        batchNo: batchNo ?? this.batchNo,
        lineSealNo: lineSealNo ?? this.lineSealNo,
        customSealNo: customSealNo ?? this.customSealNo,
        typeOfBaggage: typeOfBaggage ?? this.typeOfBaggage,
        baggageName: baggageName ?? this.baggageName,
        quantity: quantity ?? this.quantity,
        noOfPkg: noOfPkg ?? this.noOfPkg,
        netWeight: netWeight ?? this.netWeight,
        comment: comment ?? this.comment,
        background: background ?? this.background,
        survey: survey ?? this.survey,
        packing: packing ?? this.packing,
        baggageCondition: baggageCondition ?? this.baggageCondition,
        conclusion: conclusion ?? this.conclusion,
        containerReportUrl: containerReportUrl ?? this.containerReportUrl,
        containerImages: containerImages ?? this.containerImages);
  }
}
