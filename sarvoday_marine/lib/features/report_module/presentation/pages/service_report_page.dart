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
import 'package:sarvoday_marine/core/utils/widgets/image_upload_service.dart';
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
  List<Map<String, dynamic>> imageList = [];
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
        } else if (state is StateOnCrudSuccess) {
          hideLoadingDialog(context);
          CommonMethods.showToast(context, "Report updated successfully");
        } else if (state is StateErrorGeneral) {
          hideLoadingDialog(context);
          CommonMethods.showToast(context, state.errorMsg);
        }
      },
      builder: (context, state) {
        if (state is StateLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is StateOnSuccess2) {
          userRole = context.read<ReportCubit>().user;
          imageList = context.read<ReportCubit>().images;
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
                        containerReport: containerReport,
                        serviceName: serviceReportDetail?.serviceName ?? "",
                        orderId: widget.orderId,
                        index: index,
                        userRole: userRole,
                        imageList: imageList,
                        formGroupList: formGroupList,
                        containerList: containerList,
                      );
                    },
                  ),
                  SizedBox(
                    height: SmTextTheme.getResponsiveSize(context, 12),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SmTextTheme.getResponsiveSize(context, 12)),
                    child: SizedBox(
                        width: double.infinity,
                        child: CustomSmButton(
                            text: formGroupList.every((form) => form.valid)
                                ? "Submit"
                                : "save",
                            onTap: () async {
                              for (var element in formGroupList) {
                                final formValues = {
                                  'containerNo':
                                      element.control('containerNo').value,
                                  'maxGrossWeight':
                                      element.control('maxGrossWeight').value,
                                  'tareWeight':
                                      element.control('tareWeight').value,
                                  'containerSize':
                                      element.control('containerSize').value,
                                  'batchNo': element.control('batchNo').value,
                                  'lineSealNo':
                                      element.control('lineSealNo').value,
                                  'customSealNo':
                                      element.control('customSealNo').value,
                                  'typeOfBaggage':
                                      element.control('typeOfBaggage').value,
                                  'baggageName':
                                      element.control('baggageName').value,
                                  'quantity': element.control('quantity').value,
                                  'noOfPkg': element.control('noOfPkg').value,
                                  'netWeight':
                                      element.control('netWeight').value,
                                  'comment': element.control('comment').value,
                                  'background':
                                      element.control('background').value,
                                  'survey': element.control('survey').value,
                                  'packing': element.control('packing').value,
                                  'baggageCondition':
                                      element.control('baggageCondition').value,
                                  'conclusion':
                                      element.control('conclusion').value,
                                };

                                final containerModel = ContainerModel(
                                  containerImages: imageList
                                      .map((element) =>
                                          ContainerImageModel.fromJson(element))
                                      .toList(),
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
                                  baggageCondition:
                                      formValues['baggageCondition'],
                                  conclusion: formValues['conclusion'],
                                );
                                containerList.add(containerModel);
                              }
                              final ServiceContainerModel
                                  serviceReportResponse = ServiceContainerModel(
                                      serviceName:
                                          serviceReportDetail?.serviceName,
                                      containerReports: containerList,
                                      reportStatus:
                                          serviceReportDetail?.reportStatus);
                              context.read<ReportCubit>().updateServiceReport(
                                  widget.serviceId,
                                  widget.reportId,
                                  serviceReportResponse);
                            })),
                  ),
                ],
              ),
            ));
      },
    );
  }
}

class ContainerCard extends StatelessWidget {
  ContainerCard(
      {super.key,
      required this.containerReport,
      required this.serviceName,
      required this.orderId,
      required this.index,
      required this.userRole,
      required this.imageList,
      required this.formGroupList,
      required this.containerList});

  final ContainerModel? containerReport;
  List<FormGroup> formGroupList = [];
  final String serviceName;
  final String orderId;
  final int index;
  final String userRole;
  final List<Map<String, dynamic>> imageList;
  List<ContainerModel> containerList = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ExpansionTile(
        title: Text(containerReport?.containerNo ?? "Container ${index + 1}"),
        children: [
          ReactiveFormComponent(
            containerDetails: containerReport,
            serviceName: serviceName,
            orderId: orderId,
            imageList: imageList,
            userRole: userRole,
            formGroupList: formGroupList,
            containerList: containerList,
          ),
        ],
      ),
    );
  }
}

class ReactiveFormComponent extends StatefulWidget {
  ReactiveFormComponent(
      {super.key,
      required this.containerDetails,
      required this.serviceName,
      required this.orderId,
      required this.userRole,
      required this.imageList,
      required this.formGroupList,
      required this.containerList});

  final ContainerModel? containerDetails;
  final String serviceName;
  final String orderId;
  final String userRole;
  final List<Map<String, dynamic>> imageList;
  List<ContainerModel> containerList = [];
  List<FormGroup> formGroupList = [];

  @override
  State<ReactiveFormComponent> createState() => _ReactiveFormComponentState();
}

class _ReactiveFormComponentState extends State<ReactiveFormComponent> {
  late FormGroup _form;
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
    _form = FormGroup({
      'containerNo': FormControl<String>(
          value: widget.containerDetails?.containerNo ?? "",
          validators: [Validators.required]),
      'maxGrossWeight': FormControl<String>(
          value: widget.containerDetails?.maxGrossWeight ?? "",
          validators: [Validators.required]),
      'tareWeight': FormControl<String>(
          value: widget.containerDetails?.tareWeight ?? "",
          validators: [Validators.required]),
      'containerSize': FormControl<String>(
          value: widget.containerDetails?.containerSize ?? "",
          validators: [Validators.required]),
      'batchNo': FormControl<String>(
          value: widget.containerDetails?.batchNo ?? "",
          validators: [Validators.required]),
      'lineSealNo': FormControl<String>(
          value: widget.containerDetails?.lineSealNo ?? "",
          validators: [Validators.required]),
      'customSealNo': FormControl<String>(
          value: widget.containerDetails?.customSealNo ?? "",
          validators: [Validators.required]),
      'typeOfBaggage': FormControl<String>(
          value: widget.containerDetails?.typeOfBaggage ?? "",
          validators: [Validators.required]),
      'quantity': FormControl<int>(
          value: widget.containerDetails?.quantity,
          validators: [Validators.required]),
      'noOfPkg': FormControl<int>(
          value: widget.containerDetails?.noOfPkg,
          validators: [Validators.required]),
      'netWeight': FormControl<String>(
          value: widget.containerDetails?.netWeight ?? "",
          validators: [Validators.required]),
      'comment': FormControl<String>(
          value: widget.containerDetails?.comment ?? "",
          validators:
              (widget.userRole == "admin" || widget.userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
      'baggageName': FormControl<String>(
          value: widget.containerDetails?.baggageName ?? "",
          validators: [Validators.required]),
      'background': FormControl<String>(
          value: widget.containerDetails?.background ?? "",
          validators:
              (widget.userRole == "admin" || widget.userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
      'survey': FormControl<String>(
          value: widget.containerDetails?.survey ?? "",
          validators:
              (widget.userRole == "admin" || widget.userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
      'packing': FormControl<String>(
          value: widget.containerDetails?.packing ?? "",
          validators:
              (widget.userRole == "admin" || widget.userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
      'baggageCondition': FormControl<String>(
          value: widget.containerDetails?.baggageCondition ?? "",
          validators: [Validators.required]),
      'conclusion': FormControl<String>(
          value: widget.containerDetails?.conclusion ?? "",
          validators:
              (widget.userRole == "admin" || widget.userRole == "superAdmin")
                  ? [Validators.required]
                  : []),
    });
    if (widget.userRole == "client") {
      _form.markAsDisabled();
    }
    widget.formGroupList.add(_form);
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: _form,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField(_form, "containerNo", "Container No"),
            _buildDropdown(
                _form, "typeOfBaggage", "Type of Baggage", baggageOptions),
            _buildTextFormField(_form, "containerSize", "Container Size",
                keyboardType: TextInputType.number,
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(_form, "batchNo", "Batch No",
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(_form, "noOfPkg", "No of Packages",
                keyboardType: TextInputType.number,
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(_form, "maxGrossWeight", "Max Gross Weight",
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"],
                keyboardType: TextInputType.number),
            _buildTextFormField(_form, "tareWeight", "Tare Weight",
                keyboardType: TextInputType.number,
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(_form, "lineSealNo", "Line Seal No",
                baggageName: ["Baggage1", "Baggage2"]),
            _buildTextFormField(_form, "customSealNo", "Custom Seal No",
                baggageName: ["Baggage2", "Baggage3"]),
            _buildTextFormField(_form, "baggageName", "Baggage Name",
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            _buildTextFormField(_form, "quantity", "Quantity",
                keyboardType: TextInputType.number, baggageName: ["Baggage1"]),
            _buildTextFormField(_form, "netWeight", "Net Weight",
                keyboardType: TextInputType.number,
                baggageName: ["Baggage1", "Baggage2", "Baggage3", "Baggage4"]),
            SizedBox(height: SmTextTheme.getResponsiveSize(context, 16)),
            Visibility(
              visible: widget.imageList.isNotEmpty,
              child: RichText(
                  text: TextSpan(
                      text: 'Upload Images:',
                      style: SmTextTheme.confirmButtonTextStyle(context))),
            ),
            SizedBox(height: SmTextTheme.getResponsiveSize(context, 10)),
            ImageGridWidget(imageList: widget.imageList),
            SizedBox(height: SmTextTheme.getResponsiveSize(context, 10)),
            Visibility(
                visible: widget.userRole == 'admin' ||
                    widget.userRole == 'superAdmin' ||
                    widget.userRole == 'client',
                child: _buildTextFormField(_form, "comment", "Comment",
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
              child: _buildTextFormField(_form, "background", "Background",
                  minLine: 3,
                  maxLine: 5,
                  baggageName: ["Baggage1", "Baggage2", "Baggage3"]),
            ),
            Visibility(
                visible: widget.userRole == 'admin' ||
                    widget.userRole == 'superAdmin' ||
                    widget.userRole == 'client',
                child: _buildTextFormField(_form, "survey", "Survey",
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
                child: _buildTextFormField(_form, "packing", "Packing",
                    minLine: 3,
                    maxLine: 5,
                    baggageName: ["Baggage1", "Baggage4"])),
            Visibility(
                visible: widget.userRole == 'admin' ||
                    widget.userRole == 'superAdmin' ||
                    widget.userRole == 'client',
                child: _buildTextFormField(
                    _form, "baggageCondition", "Baggage Condition",
                    minLine: 3,
                    maxLine: 5,
                    baggageName: ["Baggage2", "Baggage3"])),
            Visibility(
                visible: widget.userRole == 'admin' ||
                    widget.userRole == 'superAdmin' ||
                    widget.userRole == 'client',
                child: _buildTextFormField(_form, "conclusion", "Conclusion",
                    minLine: 5,
                    maxLine: 7,
                    baggageName: [
                      "Baggage1",
                      "Baggage2",
                      "Baggage3",
                      "Baggage4"
                    ])),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_form.valid) {
                    List<String> filePaths = widget.imageList
                        .map((element) =>
                            (element['imagePath'] ?? "").toString())
                        .toList();
                    List<String> fileNames = widget.imageList
                        .map((element) => element['imageName'].toString())
                        .toList();
                    S3Service().uploadMultipleImages(filePaths, fileNames);
                  } else {
                    _form.markAllAsTouched();
                  }
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
