import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_loading_dialog.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_button.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_text_form_field.dart';
import 'package:sarvoday_marine/core/utils/widgets/download_pdf.dart';
import 'package:sarvoday_marine/features/report_module/data/models/container_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/image_config_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/service_report.dart';
import 'package:sarvoday_marine/features/report_module/presentation/cubit/report_cubit.dart';
import 'package:sarvoday_marine/features/report_module/presentation/widgets/image_grid_widget.dart';
import 'package:sarvoday_marine/features/report_module/report_injection_container.dart';

@RoutePage()
class ServiceDetailPage extends StatefulWidget implements AutoRouteWrapper {
  const ServiceDetailPage(
      {super.key,
      required this.serviceId,
      required this.orderId,
      required this.reportId});

  final String serviceId;
  final String orderId;
  final String reportId;

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => reportSl<ReportCubit>(),
      child: this,
    );
  }
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  String userRole = '';
  Map<String, dynamic> imageList = {};
  List<FormGroup> formGroupList = [];
  ServiceContainerModel? serviceReportDetail;
  List<ContainerModel> containerList = [];

  @override
  void initState() {
    context.read<ReportCubit>().loadServiceReport(widget.serviceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is StateNoData) {
          showLoadingDialog(context);
        } else if (state is StateImageUploaded) {
          hideLoadingDialog(context);
          if (state.response != "") {
            CommonMethods.showToast(context, state.response);
          }
        } else if (state is StateOnCrudSuccess) {
          hideLoadingDialog(context);
          CommonMethods.showToast(context, "Report Updated successfully");
        } else if (state is StateErrorGeneral) {
          hideLoadingDialog(context);
          CommonMethods.showToast(context, state.errorMsg);
        }
      },
      builder: (context, state) {
        if (state is StateLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is StateOnSuccess2) {
          userRole = context.read<ReportCubit>().user;
          imageList = context.read<ReportCubit>().images;
          serviceReportDetail = state.response;
          loadFormData();
        } else if (state is StateImageUploaded) {
          imageList = context.read<ReportCubit>().images;
        } else if (state is StateOnCrudSuccess) {
          serviceReportDetail = state.response;
        }
        return Scaffold(
            appBar: CommonAppBar(
              context: context,
              title: serviceReportDetail?.serviceName ?? "",
            ).appBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        serviceReportDetail?.containerReports?.length ?? 0,
                    itemBuilder: (context, index) {
                      final containerReport =
                          serviceReportDetail?.containerReports?[index];
                      return ContainerCard(
                        serviceStatus:
                            serviceReportDetail?.reportStatus ?? "Pending",
                        reportId: widget.reportId,
                        containerReport: containerReport,
                        serviceName: serviceReportDetail?.serviceName ?? "",
                        orderId: widget.orderId,
                        index: index,
                        userRole: userRole,
                        imageList: imageList[containerReport!.containerId!],
                        formGroupList: formGroupList,
                        containerList: containerList,
                        serviceId: widget.serviceId,
                      );
                    },
                  ),
                  SizedBox(
                    height: SmTextTheme.getResponsiveSize(context, 12),
                  ),
                  Visibility(
                    visible: userRole != "client" ||
                        !(userRole == "employee" &&
                            (serviceReportDetail?.reportStatus == "Completed" ||
                                serviceReportDetail?.reportStatus ==
                                    "Reviewed")),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SmTextTheme.getResponsiveSize(context, 12),
                          horizontal:
                              SmTextTheme.getResponsiveSize(context, 12)),
                      child: SizedBox(
                          width: double.infinity,
                          child: CustomSmButton(
                              text: ((serviceReportDetail?.isEdited ?? false) &&
                                          (userRole == "admin" ||
                                              userRole == "superAdmin") &&
                                          serviceReportDetail?.reportStatus ==
                                              "Completed") ||
                                      (userRole == "superAdmin" &&
                                          serviceReportDetail?.reportStatus ==
                                              "Completed")
                                  ? "Reviewed"
                                  : formGroupList.every((form) => form.valid)
                                      ? "Submit"
                                      : "save",
                              onTap: () async {
                                final containerModels =
                                    await _createContainerModels(formGroupList);

                                final serviceReportResponse =
                                    ServiceContainerModel(
                                  serviceName: serviceReportDetail?.serviceName,
                                  containerReports: containerModels,
                                  reportStatus:
                                      ((serviceReportDetail?.isEdited ??
                                                      false) &&
                                                  ((userRole == "admin") &&
                                                      serviceReportDetail
                                                              ?.reportStatus ==
                                                          "Completed")) ||
                                              (userRole == "superAdmin" &&
                                                  serviceReportDetail
                                                          ?.reportStatus ==
                                                      "Completed")
                                          ? "Reviewed"
                                          : serviceReportDetail?.reportStatus,
                                );
                                if (context.mounted) {
                                  context
                                      .read<ReportCubit>()
                                      .updateServiceReport(
                                          widget.serviceId,
                                          widget.reportId,
                                          serviceReportResponse,
                                          ((userRole == "admin" ||
                                                  userRole == "superAdmin") &&
                                              serviceReportDetail
                                                      ?.reportStatus ==
                                                  "Completed"));
                                }
                              })),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  loadFormData() {
    if (serviceReportDetail != null &&
        serviceReportDetail?.containerReports != null) {
      for (var containerDetails in serviceReportDetail!.containerReports!) {
        formGroupList.add(FormGroup({
          'id': FormControl<String>(
            value: containerDetails.containerId ?? "",
          ),
          'containerNo': FormControl<String>(
              value: containerDetails.containerNo ?? "",
              validators: [Validators.required]),
          'maxGrossWeight': FormControl<String>(
              value: containerDetails.maxGrossWeight ?? "",
              validators: [Validators.required]),
          'tareWeight': FormControl<String>(
              value: containerDetails.tareWeight ?? "",
              validators: [Validators.required]),
          'containerSize': FormControl<String>(
              value: containerDetails.containerSize ?? "",
              validators: [Validators.required]),
          'batchNo': FormControl<String>(
              value: containerDetails.batchNo ?? "",
              validators: [Validators.required]),
          'lineSealNo': FormControl<String>(
              value: containerDetails.lineSealNo ?? "",
              validators: [Validators.required]),
          'customSealNo': FormControl<String>(
              value: containerDetails.customSealNo ?? "",
              validators: [Validators.required]),
          'typeOfBaggage': FormControl<String>(
              value: containerDetails.typeOfBaggage ?? "",
              validators: [Validators.required]),
          'quantity': FormControl<int>(
              value: containerDetails.quantity,
              validators: [Validators.required]),
          'noOfPkg': FormControl<int>(
              value: containerDetails.noOfPkg,
              validators: [Validators.required]),
          'netWeight': FormControl<String>(
              value: containerDetails.netWeight ?? "",
              validators: [Validators.required]),
          'comment': FormControl<String>(
              value: containerDetails.comment ?? "",
              validators: (userRole == "admin" || userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
          'baggageName': FormControl<String>(
              value: containerDetails.baggageName ?? "",
              validators: [Validators.required]),
          'background': FormControl<String>(
              value: containerDetails.background ?? "",
              validators: (userRole == "admin" || userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
          'survey': FormControl<String>(
              value: containerDetails.survey ?? "",
              validators: (userRole == "admin" || userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
          'packing': FormControl<String>(
              value: containerDetails.packing ?? "",
              validators: (userRole == "admin" || userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
          'baggageCondition': FormControl<String>(
              value: containerDetails.baggageCondition ?? "",
              validators: [Validators.required]),
          'conclusion': FormControl<String>(
              value: containerDetails.conclusion ?? "",
              validators: (userRole == "admin" || userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
        }));
      }
    }
    if (userRole == "client" ||
        (userRole == "employee" &&
            (serviceReportDetail?.reportStatus == "Completed" ||
                serviceReportDetail?.reportStatus == "Reviewed"))) {
      disableAllFormGroups(formGroupList);
    }
  }

  Future<List<ContainerModel>> _createContainerModels(
      List<FormGroup> formGroupList) async {
    final List<ContainerModel> containerModels = [];

    for (var element in formGroupList) {
      final formValues = _extractFormValues(element);

      final containerModel = ContainerModel(
        containerImages: (imageList[formValues['id']] as List<dynamic>)
            .map((element) =>
                ContainerImageModel.fromJson((element as Map<String, dynamic>)))
            .toList(),
        containerId: formValues['id'],
        containerNo: formValues['containerNo'],
        maxGrossWeight: formValues['maxGrossWeight'],
        tareWeight: formValues['tareWeight'],
        containerSize: formValues['containerSize'],
        batchNo: formValues['batchNo'],
        lineSealNo: formValues['lineSealNo'],
        customSealNo: formValues['customSealNo'],
        typeOfBaggage: formValues['typeOfBaggage'],
        baggageName: formValues['baggageName'],
        quantity: formValues['quantity'],
        noOfPkg: formValues['noOfPkg'],
        netWeight: formValues['netWeight'],
        comment: formValues['comment'],
        background: formValues['background'],
        survey: formValues['survey'],
        packing: formValues['packing'],
        baggageCondition: formValues['baggageCondition'],
        conclusion: formValues['conclusion'],
      );

      containerModels.add(containerModel);
    }

    return containerModels;
  }

  Map<String, dynamic> _extractFormValues(FormGroup element) {
    return {
      'id': element.control('id').value,
      'containerNo': element.control('containerNo').value,
      'maxGrossWeight': element.control('maxGrossWeight').value,
      'tareWeight': element.control('tareWeight').value,
      'containerSize': element.control('containerSize').value,
      'batchNo': element.control('batchNo').value,
      'lineSealNo': element.control('lineSealNo').value,
      'customSealNo': element.control('customSealNo').value,
      'typeOfBaggage': element.control('typeOfBaggage').value,
      'baggageName': element.control('baggageName').value,
      'quantity': element.control('quantity').value,
      'noOfPkg': element.control('noOfPkg').value,
      'netWeight': element.control('netWeight').value,
      'comment': element.control('comment').value,
      'background': element.control('background').value,
      'survey': element.control('survey').value,
      'packing': element.control('packing').value,
      'baggageCondition': element.control('baggageCondition').value,
      'conclusion': element.control('conclusion').value,
    };
  }

  void disableAllFormGroups(List<FormGroup> formGrpList) {
    for (var formGroup in formGrpList) {
      formGroup.markAsDisabled();
    }
  }
}

class ContainerCard extends StatelessWidget {
  ContainerCard(
      {super.key,
      required this.containerReport,
      required this.reportId,
      required this.serviceName,
      required this.orderId,
      required this.index,
      required this.serviceStatus,
      required this.userRole,
      required this.imageList,
      required this.serviceId,
      required this.formGroupList,
      required this.containerList});

  final ContainerModel? containerReport;
  final String reportId;
  List<FormGroup> formGroupList = [];
  final String serviceName;
  final String orderId;
  final int index;
  final String serviceStatus;
  final String serviceId;
  final String userRole;
  final List<Map<String, dynamic>> imageList;
  List<ContainerModel> containerList = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ExpansionTile(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: RichText(
                  maxLines: 2,
                  text: TextSpan(
                      style: SmTextTheme.labelDescriptionStyle(context),
                      text: containerReport?.containerNo ??
                          "Container ${index + 1}")),
            ),
            if (containerReport != null &&
                containerReport?.containerReportUrl != null &&
                containerReport!.containerReportUrl!.isNotEmpty &&
                (userRole == "client" || userRole == "superAdmin"))
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SmTextTheme.getResponsiveSize(context, 14)),
                  child: DownloadPDFButton(
                    signedUrl: containerReport?.containerReportUrl ?? "",
                    fileName: (containerReport?.containerReportPath ?? "")
                        .split('/')
                        .last,
                  )),
          ],
        ),
        children: [
          ReactiveFormComponent(
            containerDetails: containerReport,
            serviceId: serviceId,
            serviceStatus: serviceStatus,
            serviceName: serviceName,
            orderId: orderId,
            imageList: imageList,
            userRole: userRole,
            formGroupList: formGroupList,
            form: formGroupList[index],
            containerList: containerList,
            reportId: reportId,
          ),
        ],
      ),
    );
  }
}

class ReactiveFormComponent extends StatefulWidget {
  ReactiveFormComponent(
      {super.key,
      required this.reportId,
      required this.serviceId,
      required this.containerDetails,
      required this.serviceName,
      required this.orderId,
      required this.userRole,
      required this.imageList,
      required this.serviceStatus,
      required this.formGroupList,
      required this.form,
      required this.containerList});

  final ContainerModel? containerDetails;
  final String reportId;
  final String serviceId;
  final String serviceName;
  final String serviceStatus;
  final String orderId;
  final String userRole;
  final List<Map<String, dynamic>> imageList;
  List<ContainerModel> containerList = [];
  List<FormGroup> formGroupList = [];
  final FormGroup form;

  @override
  State<ReactiveFormComponent> createState() => _ReactiveFormComponentState();
}

class _ReactiveFormComponentState extends State<ReactiveFormComponent> {
  String currentTypeOfBaggage = "";
  final List<String> baggageOptions = [
    'Baggage1',
    'Baggage2',
    'Baggage3',
    'Baggage4'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.form,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField(widget.form, "containerNo", "Container No"),
            _buildDropdown(widget.form, "typeOfBaggage", "Type of Baggage",
                baggageOptions),
            _buildTextFormField(widget.form, "containerSize", "Container Size",
                keyboardType: TextInputType.number,
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(widget.form, "batchNo", "Batch No",
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(widget.form, "noOfPkg", "No of Packages",
                keyboardType: TextInputType.number,
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(
                widget.form, "maxGrossWeight", "Max Gross Weight",
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"],
                keyboardType: TextInputType.number),
            _buildTextFormField(widget.form, "tareWeight", "Tare Weight",
                keyboardType: TextInputType.number,
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(widget.form, "lineSealNo", "Line Seal No",
                baggageName: ["Baggage1", "Baggage2"]),
            _buildTextFormField(widget.form, "customSealNo", "Custom Seal No",
                baggageName: ["Baggage2", "Baggage3"]),
            _buildTextFormField(widget.form, "baggageName", "Baggage Name",
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(widget.form, "quantity", "Quantity",
                keyboardType: TextInputType.number, baggageName: ["Baggage1"]),
            _buildTextFormField(widget.form, "netWeight", "Net Weight",
                keyboardType: TextInputType.number,
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            SizedBox(height: SmTextTheme.getResponsiveSize(context, 16)),
            Visibility(
              visible: widget.imageList.isNotEmpty,
              child: RichText(
                  text: TextSpan(
                      text: 'Inspection Images:',
                      style: SmTextTheme.confirmButtonTextStyle(context))),
            ),
            SizedBox(height: SmTextTheme.getResponsiveSize(context, 10)),
            ImageGridWidget(
              imageList: widget.imageList,
              userRole: widget.userRole,
            ),
            SizedBox(height: SmTextTheme.getResponsiveSize(context, 10)),
            Visibility(
                visible: widget.userRole == 'admin' ||
                    widget.userRole == 'superAdmin' ||
                    widget.userRole == 'client',
                child: _buildTextFormField(widget.form, "comment", "Comment",
                    minLine: 3,
                    maxLine: 5,
                    baggageName: [
                      "Baggage1",
                      "Baggage2",
                      "Baggage3",
                      "Baggage4"
                    ])),
            Visibility(
              visible: widget.userRole == 'admin' ||
                  widget.userRole == 'superAdmin' ||
                  widget.userRole == 'client',
              child: _buildTextFormField(
                  widget.form, "background", "Background",
                  minLine: 3,
                  maxLine: 5,
                  baggageName: ["Baggage1", "Baggage2", "Baggage3"]),
            ),
            Visibility(
                visible: widget.userRole == 'admin' ||
                    widget.userRole == 'superAdmin' ||
                    widget.userRole == 'client',
                child: _buildTextFormField(widget.form, "survey", "Survey",
                    minLine: 3,
                    maxLine: 5,
                    baggageName: [
                      "Baggage1",
                      "Baggage2",
                      "Baggage3",
                      "Baggage4"
                    ])),
            Visibility(
                visible: widget.userRole == 'admin' ||
                    widget.userRole == 'superAdmin' ||
                    widget.userRole == 'client',
                child: _buildTextFormField(widget.form, "packing", "Packing",
                    minLine: 3,
                    maxLine: 5,
                    baggageName: ["Baggage1", "Baggage4"])),
            Visibility(
                visible: widget.userRole == 'admin' ||
                    widget.userRole == 'superAdmin' ||
                    widget.userRole == 'client',
                child: _buildTextFormField(
                    widget.form, "baggageCondition", "Baggage Condition",
                    minLine: 3,
                    maxLine: 5,
                    baggageName: ["Baggage2", "Baggage3"])),
            Visibility(
                visible: widget.userRole == 'admin' ||
                    widget.userRole == 'superAdmin' ||
                    widget.userRole == 'client',
                child: _buildTextFormField(
                    widget.form, "conclusion", "Conclusion",
                    minLine: 5,
                    maxLine: 7,
                    baggageName: [
                      "Baggage1",
                      "Baggage2",
                      "Baggage3",
                      "Baggage4"
                    ])),
            Visibility(
              visible: widget.userRole != "client" ||
                  !(widget.userRole == "employee" &&
                      (widget.serviceStatus == "Completed" ||
                          widget.serviceStatus == "Reviewed")),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<ReportCubit>().uploadImageService(
                        widget.reportId,
                        widget.serviceId,
                        widget.containerDetails?.containerId ?? "",
                        widget.imageList);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(SmColorLightTheme.onPrimary)),
                  child: RichText(
                      text: TextSpan(
                          text: 'Upload',
                          style: SmTextTheme.cancelButtonTextStyle(context))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(FormGroup form, String formControlName,
      String labelText, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReactiveDropdownField<String>(
          formControlName: formControlName,
          onChanged: (value) {
            if (value.isNotNullOrEmpty) {
              setState(() {
                currentTypeOfBaggage = value.value ?? "";
              });
            }
          },
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
            labelText: labelText,
            hintText: "Please select $labelText",
            hintStyle: SmTextTheme.hintTextStyle(context),
            labelStyle: SmTextTheme.infoContentStyle6(context),
          ),
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
        ),
        SizedBox(height: SmTextTheme.getResponsiveSize(context, 10)),
      ],
    );
  }

  Widget _buildTextFormField(
      FormGroup form, String formControlName, String labelText,
      {TextInputType? keyboardType,
      int maxLine = 1,
      int minLine = 1,
      List<String>? baggageName}) {
    String typeOfBaggage = form.control("typeOfBaggage").value;
    return Visibility(
      visible: !(baggageName != null && baggageName.isNotEmpty) ||
          (baggageName.contains(typeOfBaggage)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            maxLines: maxLine,
            minLines: minLine,
            isReadOnly: widget.userRole == "client",
            formControlName: formControlName,
            labelText: labelText,
            hintText: "Please enter $labelText",
            keyboardType: keyboardType,
          ),
          SizedBox(height: SmTextTheme.getResponsiveSize(context, 10)),
        ],
      ),
    );
  }
}
