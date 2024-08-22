import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_loading_dialog.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_button.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/presentation/cubit/service_cubit.dart';
import 'package:sarvoday_marine/features/service_module/service_module_injection_container.dart';

@RoutePage()
class AddUpdateServicePage extends StatefulWidget implements AutoRouteWrapper {
  final bool isEdit;
  final ServiceModel? serviceModel;

  const AddUpdateServicePage({
    super.key,
    this.isEdit = false,
    this.serviceModel,
  });

  @override
  _AddUpdateServicePageState createState() => _AddUpdateServicePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => servicesSl<ServiceCubit>(),
      child: this,
    );
  }
}

class _AddUpdateServicePageState extends State<AddUpdateServicePage> {
  late FormGroup form;
  List<String> imageList = ["Image1", "Image2", "Image3", "Image4", "Image5"];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    form = FormGroup({
      "serviceName": FormControl<String>(
        validators: [Validators.required],
        value: widget.serviceModel?.serviceName ?? "",
      ),
      "container1Price": FormControl<double>(
        validators: [Validators.required],
        value: widget.serviceModel?.container1Price ?? 0,
      ),
      "container2Price": FormControl<double>(
        validators: [Validators.required],
        value: widget.serviceModel?.container2Price ?? 0,
      ),
      "container3Price": FormControl<double>(
        validators: [Validators.required],
        value: widget.serviceModel?.container3Price ?? 0,
      ),
      "container4Price": FormControl<double>(
        validators: [Validators.required],
        value: widget.serviceModel?.container4Price ?? 0,
      ),
      "serviceImage": FormArray([]),
    });

    if (widget.isEdit) {
      _initializeFormWithExistingData(form, widget.serviceModel?.serviceImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);

    return Scaffold(
        appBar: CommonAppBar(
          context: context,
          title: widget.isEdit ? "Edit Service" : "Add Service",
        ).appBar(),
        body: BlocListener<ServiceCubit, ServiceState>(
            listener: (context, state) {
              if (state is StateOnCrudSuccess) {
                hideLoadingDialog(context);
                CommonMethods.showToast(context, state.response);
                Navigator.of(context).pop();
              } else if (state is StateErrorGeneral) {
                hideLoadingDialog(context);
                CommonMethods.showCommonDialog(
                    context, "Error", state.errorMessage.toString());
              } else if (state is StateNoData) {
                showLoadingDialog(context);
              }
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(
                      SmTextTheme.getResponsiveSize(context, 16.0)),
                  child: ReactiveForm(
                    formGroup: form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        _buildTextField<String>("serviceName", "Service Name"),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        _buildTextField<double>(
                            "container1Price", "1 container price"),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        _buildTextField<double>(
                            "container2Price", "2 container price"),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        _buildTextField<double>(
                            "container3Price", "3 container price"),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        _buildTextField<double>(
                            "container4Price", "4 container price"),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        TypeAheadField<String>(
                          controller: controller,
                          builder: (context, controller, focusNode) =>
                              TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  style: SmTextTheme.confirmButtonTextStyle(
                                          context)
                                      .copyWith(
                                          fontSize:
                                              SmTextTheme.getResponsiveSize(
                                                  context, 12)),
                                  decoration: InputDecoration(
                                    prefix: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    labelText: "Search Image",
                                    labelStyle: TextStyle(
                                        fontSize: SmTextTheme.getResponsiveSize(
                                            context, 16.0),
                                        fontWeight: FontWeight.w400,
                                        color: SmAppTheme.isDarkMode(context)
                                            ? SmColorDarkTheme
                                                .secondaryTextColor
                                            : SmColorLightTheme
                                                .secondaryTextColor),
                                  )),
                          decorationBuilder: (context, child) => Material(
                            type: MaterialType.card,
                            elevation: 4,
                            borderRadius: BorderRadius.circular(16.0),
                            child: child,
                          ),
                          itemBuilder: (context, image) => ListTile(
                            title: RichText(
                              text: TextSpan(
                                  text: image,
                                  style: SmTextTheme.confirmButtonTextStyle(
                                          context)
                                      .copyWith(
                                          fontSize:
                                              SmTextTheme.getResponsiveSize(
                                                  context, 12))),
                            ),
                          ),
                          onSelected: (value) {
                            setState(() {
                              (form.control('serviceImage') as FormArray)
                                  .add(FormGroup({
                                'imageName': FormControl<String>(value: value),
                                'imageCount': FormControl<int>(
                                    validators: [Validators.required]),
                              }));
                            });
                          },
                          suggestionsCallback: (String search) {
                            return imageList;
                          },
                        ),
                        _buildImageFields(),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        _buildActionButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  Widget _buildImageFields() {
    final selectedImages = form.controls['serviceImage'] as FormArray;
    return ReactiveFormArray(
        formArrayName: 'serviceImage',
        builder: (context, formArray, child) {
          final formArrayControls = formArray as FormArray;
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: formArrayControls.controls.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final imageGroup =
                    formArrayControls.controls[index] as FormGroup;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 20.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: RichText(
                              text: TextSpan(
                                  text: imageGroup.control('imageName').value,
                                  style: SmTextTheme.confirmButtonTextStyle(
                                          context)
                                      .copyWith(
                                          fontSize:
                                              SmTextTheme.getResponsiveSize(
                                                  context, 12)))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  SmTextTheme.getResponsiveSize(context, 4)),
                          child: IconButton(
                              color: SmCommonColors.errorColor,
                              icon: const Icon(Icons.clear_outlined),
                              onPressed: () {
                                setState(() {
                                  selectedImages.remove(imageGroup);
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 10.0)),
                    ReactiveTextField<int>(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      formControl:
                          imageGroup.control('imageCount') as FormControl<int>,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: "count",
                        hintText: "Please add image count",
                        labelStyle: TextStyle(
                            fontSize:
                                SmTextTheme.getResponsiveSize(context, 16.0),
                            fontWeight: FontWeight.w400,
                            color: SmAppTheme.isDarkMode(context)
                                ? SmColorDarkTheme.secondaryTextColor
                                : SmColorLightTheme.secondaryTextColor),
                      ),
                      validationMessages: {
                        ValidationMessage.required: (error) =>
                            'Image count is required'
                      },
                    ),
                  ],
                );
              });
        });
  }

  Widget _buildTextField<T>(String formControlName, String labelText) {
    return ReactiveTextField<T>(
      formControlName: formControlName,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: SmTextTheme.getResponsiveSize(context, 16.0),
          fontWeight: FontWeight.w400,
          color: SmAppTheme.isDarkMode(context)
              ? SmColorDarkTheme.secondaryTextColor
              : SmColorLightTheme.secondaryTextColor,
        ),
      ),
      validationMessages: {
        ValidationMessage.required: (error) => "$labelText is Required",
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomSmButton(
        text: widget.isEdit ? "Update" : "Add",
        onTap: () async {
          if (form.valid) {
            final List<ServiceImageConfig>? images =
                (form.control("serviceImage").value as List?)
                    ?.map<ServiceImageConfig>((element) => ServiceImageConfig(
                        imageName: element['imageName'],
                        imageCount: element['imageCount']))
                    .toList();
            if (widget.isEdit) {
              await context.read<ServiceCubit>().updatedService(
                  widget.serviceModel!.id!,
                  form.control("serviceName").value,
                  form.control('container1Price').value,
                  form.control('container2Price').value,
                  form.control('container3Price').value,
                  form.control('container4Price').value,
                  images ?? []);
            } else {
              await context.read<ServiceCubit>().addService(
                  form.control("serviceName").value,
                  form.control('container1Price').value,
                  form.control('container2Price').value,
                  form.control('container3Price').value,
                  form.control('container4Price').value,
                  images ?? []);
            }
            if (mounted) {
              Navigator.of(context).pop();
            }
          } else {
            form.markAllAsTouched();
          }
        },
      ),
    );
  }

  void _initializeFormWithExistingData(
      FormGroup form, List<ServiceImageConfig>? imageConfig) {
    FormArray servicesArray = form.control('serviceImage') as FormArray;

    if (imageConfig != null) {
      for (var image in imageConfig) {
        servicesArray.add(FormGroup({
          'imageName': FormControl<String>(value: image.imageName),
          'imageCount': FormControl<int>(
              value: image.imageCount, validators: [Validators.required]),
        }));
      }
    }
  }
}
