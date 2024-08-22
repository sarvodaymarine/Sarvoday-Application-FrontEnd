import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
import 'package:sarvoday_marine/core/utils/widgets/custom_text_form_field.dart';
import 'package:sarvoday_marine/features/client_module/client_module_injection_container.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_Service_model.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/presentation/cubit/client_cubit.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/presentation/cubit/service_cubit.dart';
import 'package:sarvoday_marine/features/service_module/service_module_injection_container.dart';

@RoutePage()
class ClientAddUpdatePage extends StatefulWidget implements AutoRouteWrapper {
  const ClientAddUpdatePage(
      {super.key, this.clientModel, required this.isFromEdit});

  final ClientModel? clientModel;
  final bool isFromEdit;

  @override
  State<ClientAddUpdatePage> createState() => _ClientAddUpdatePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => servicesSl<ServiceCubit>()),
      BlocProvider(create: (context) => clientSl<ClientCubit>())
    ], child: this);
  }
}

class _ClientAddUpdatePageState extends State<ClientAddUpdatePage> {
  late FormGroup form;

  /*= FormGroup({
    'firstName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'countryCode':
        FormControl<String>(validators: [Validators.required], value: '+91'),
    'mobile': FormControl<String>(validators: [Validators.required]),
    'clientAddress': FormControl<String>(validators: [Validators.required]),
    'services': FormArray<double>([]),
  });*/

  List<Widget> serviceWidgetList = [];

  @override
  void initState() {
    form = FormGroup({
      'clientAddress': FormControl<String>(
          validators: [Validators.required],
          value: widget.clientModel?.clientAddress ?? ""),
      'firstName': FormControl<String>(
          validators: [Validators.required],
          value: widget.clientModel?.firstName ?? ""),
      'lastName': FormControl<String>(
          validators: [Validators.required],
          value: widget.clientModel?.lastName ?? ""),
      'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
          value: widget.clientModel?.userDetail?.email ?? ""),
      'countryCode': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(1),
        Validators.maxLength(4)
      ], value: widget.clientModel?.userDetail?.countryCode ?? '+91'),
      'mobile': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(10),
        Validators.maxLength(10)
      ], value: widget.clientModel?.userDetail?.mobile ?? ""),
      'services': FormArray([]),
    });
    if (widget.isFromEdit) {
      _initializeFormWithExistingData(widget.clientModel?.services ?? []);
    }
    super.initState();
  }

  List<ServiceModel>? services;

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        title: widget.isFromEdit ? "Edit Client Details" : "Add Client Details",
      ).appBar(),
      body: BlocConsumer<ServiceCubit, ServiceState>(
        listener: (context, state) {
          if (state is StateOnCrudSuccess) {
            hideLoadingDialog(context);
            CommonMethods.showToast(context, state.response);
          } else if (state is StateErrorGeneral) {
            hideLoadingDialog(context);
            CommonMethods.showCommonDialog(
                context, "Error", state.errorMessage.toString());
          } else if (state is StateNoData) {
            showLoadingDialog(context);
          }
        },
        builder: (context, state) {
          if (state is StateOnSuccess) {
            services = state.response;
          }
          return BlocConsumer<ClientCubit, ClientState>(
            listener: (context, state) {
              if (state is CStateOnCrudSuccess) {
                hideLoadingDialog(context);
                CommonMethods.showToast(context, state.response);
                Navigator.of(context).pop(true);
              } else if (state is CStateErrorGeneral) {
                hideLoadingDialog(context);
                CommonMethods.showCommonDialog(
                    context, "Error", state.errorMessage.toString());
              } else if (state is CStateNoData) {
                showLoadingDialog(context);
              }
            },
            builder: (context, state) {
              if (state is CStateOnSuccess2) {
                services = state.response;
              }
              return Padding(
                padding:
                    EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 16)),
                child: ReactiveForm(
                  formGroup: form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 16.0)),
                        const CustomTextFormField(
                          formControlName: "firstName",
                          labelText: "First Name",
                          hintText: "Please enter first name",
                        ),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 16.0)),
                        const CustomTextFormField(
                          formControlName: "lastName",
                          labelText: "Last Name",
                          hintText: "Please enter last name",
                        ),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        CustomTextFormField(
                          formControlName: "email",
                          labelText: "Email",
                          hintText: "Please enter email",
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Email is required',
                            ValidationMessage.email: (error) =>
                                'Invalid email format',
                          },
                        ),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: CustomTextFormField(
                                formControlName: "countryCode",
                                isReadOnly: true,
                                onTap: (FormControl value) =>
                                    CommonMethods.commonShowCountryPicker(
                                        context, value, form),
                                labelText: "Ph Code",
                              ),
                            ),
                            SizedBox(
                                width: SmTextTheme.getResponsiveSize(
                                    context, 10.0)),
                            Expanded(
                              flex: 5,
                              child: CustomTextFormField(
                                formControlName: "mobile",
                                keyboardType: TextInputType.number,
                                labelText: "Mobile",
                                hintText: "Please enter mobile number",
                                validationMessages: {
                                  ValidationMessage.required: (error) =>
                                      "Mobile number is Required",
                                  ValidationMessage.mustMatch: (error) =>
                                      "Please enter valid phone Number"
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 16.0)),
                        const CustomTextFormField(
                          maxLines: 5,
                          minLines: 3,
                          formControlName: "clientAddress",
                          labelText: "Address",
                          hintText: "Please enter client address",
                        ),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   mainAxisSize: MainAxisSize.max,
                        //   children: <Widget>[
                        //     RichText(
                        //       text: TextSpan(
                        //           text: "Add Service",
                        //           style: SmTextTheme.confirmButtonTextStyle(
                        //                   context)
                        //               .copyWith(
                        //                   fontSize:
                        //                       SmTextTheme.getResponsiveSize(
                        //                           context, 14.0))),
                        //     ),
                        //     SizedBox(
                        //         width: SmTextTheme.getResponsiveSize(
                        //             context, 16.0)),
                        //     IconButton(
                        //       icon: const Icon(Icons.add),
                        //       onPressed: () => serviceDialog(context),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Add Service",
                                  style: SmTextTheme.confirmButtonTextStyle(
                                          context)
                                      .copyWith(
                                          fontSize:
                                              SmTextTheme.getResponsiveSize(
                                                  context, 14.0))),
                            ),
                          ],
                        ),
                        SizedBox(
                            width:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        serviceSearchWidget(context),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 16.0)),
                        _buildServiceFields(),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 16.0)),
                        for (int i = 0; i < serviceWidgetList.length; i++)
                          serviceWidgetList[i],
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 16.0)),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: CustomSmButton(
                            text: widget.isFromEdit ? "Update" : "Add",
                            onTap: () {
                              if (form.valid) {
                                String mobile = form.control('mobile').value;
                                String countryCode =
                                    form.control('countryCode').value;
                                String email = form.control('email').value;
                                String firstName =
                                    form.control('firstName').value;
                                String lastName =
                                    form.control('lastName').value;
                                List<Object?> services =
                                    form.control('services').value;
                                String clientAddress =
                                    form.control('clientAddress').value;
                                if (widget.isFromEdit &&
                                    widget.clientModel != null &&
                                    ((widget.clientModel!.userDetail
                                                    ?.firstName ??
                                                widget
                                                    .clientModel!.firstName) !=
                                            firstName ||
                                        (widget.clientModel!.userDetail?.lastName ??
                                                widget.clientModel!.lastName) !=
                                            lastName ||
                                        widget.clientModel!.userDetail?.mobile !=
                                            mobile ||
                                        widget.clientModel!.userDetail
                                                ?.countryCode !=
                                            countryCode ||
                                        widget.clientModel!.userDetail?.email !=
                                            email ||
                                        widget.clientModel!.clientAddress !=
                                            clientAddress ||
                                        checkServiceChanged(services))) {
                                  context.read<ClientCubit>().updateClient(
                                      widget.clientModel?.id ?? "",
                                      firstName,
                                      lastName,
                                      mobile,
                                      email,
                                      countryCode,
                                      clientAddress,
                                      convertToListOfMap(services));
                                } else if (!widget.isFromEdit) {
                                  context.read<ClientCubit>().addClient(
                                      firstName,
                                      lastName,
                                      email,
                                      countryCode,
                                      mobile,
                                      clientAddress,
                                      convertToListOfMap(services));
                                }
                              } else {
                                form.markAllAsTouched();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _initializeFormWithExistingData(List<ClientServiceModel> services) {
    FormArray servicesArray = form.control('services') as FormArray;

    for (var service in services) {
      servicesArray.add(FormGroup({
        'serviceId': FormControl<String>(value: service.serviceId),
        'serviceName': FormControl<String>(value: service.serviceName),
        'container1Price': FormControl<double>(value: service.container1Price),
        'container2Price': FormControl<double>(value: service.container2Price),
        'container3Price': FormControl<double>(value: service.container3Price),
        'container4Price': FormControl<double>(value: service.container4Price),
      }));
    }
    setState(() {});
  }

  Widget _buildServiceFields() {
    return ReactiveFormArray(
        formArrayName: 'services',
        builder: (context, formArray, child) {
          final formArrayControls = formArray as FormArray;
          return ListView.builder(
              itemCount: formArrayControls.controls.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final serviceGroup =
                    formArrayControls.controls[index] as FormGroup;
                final serviceName = serviceGroup.control('serviceName').value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 20)),
                    RichText(
                        text: TextSpan(
                            text: serviceName,
                            style: SmTextTheme.confirmButtonTextStyle(context)
                                .copyWith(
                                    fontSize: SmTextTheme.getResponsiveSize(
                                        context, 12)))),
                    SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 16)),
                    ReactiveTextField<double>(
                      formControl: serviceGroup.control('container1Price')
                          as FormControl<double>,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: "1 container price",
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
                            'price for single container is required'
                      },
                    ),
                    SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 16)),
                    ReactiveTextField<double>(
                      formControl: serviceGroup.control('container2Price')
                          as FormControl<double>,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: "2 container price",
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
                            'Price for 2 container is required'
                      },
                    ),
                    SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 16)),
                    ReactiveTextField<double>(
                      formControl: serviceGroup.control('container3Price')
                          as FormControl<double>,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: "3 container price",
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
                            'Price for 3 container is required'
                      },
                    ),
                    SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 16)),
                    ReactiveTextField<double>(
                      formControl: serviceGroup.control('container4Price')
                          as FormControl<double>,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: "4 container price",
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
                            'Price for 4 container is required'
                      },
                    ),
                  ],
                );
              });
        });
  }

  bool checkServiceChanged(List<Object?> services) {
    if (widget.clientModel!.services!.length != services.length) {
      return true;
    } else {
      for (var element in widget.clientModel!.services!) {
        var res = services.firstWhere((item) {
          if (item is Map<String, dynamic>) {
            return item['serviceId'] == element.serviceId &&
                item['container1Price'] != element.container1Price &&
                item['container2Price'] != element.container2Price &&
                item['container3Price'] != element.container3Price &&
                item['container4Price'] != element.container4Price;
          }
          return false;
        }, orElse: () => null);
        if (res != null) {
          return true;
        }
      }
      return false;
    }
  }

  List<Map<String, dynamic>> convertToListOfMap(List<Object?> objects) {
    return objects
        .whereType<Map<String, dynamic>>()
        .map((item) => item)
        .toList();
  }

  serviceSearchWidget(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return TypeAheadField<ServiceModel>(
      controller: controller,
      builder: (context, controller, focusNode) => TextField(
        controller: controller,
        focusNode: focusNode,
        style: SmTextTheme.confirmButtonTextStyle(context)
            .copyWith(fontSize: SmTextTheme.getResponsiveSize(context, 12)),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          labelText: "Select Services",
          labelStyle: TextStyle(
              fontSize: SmTextTheme.getResponsiveSize(context, 16.0),
              fontWeight: FontWeight.w400,
              color: SmAppTheme.isDarkMode(context)
                  ? SmColorDarkTheme.secondaryTextColor
                  : SmColorLightTheme.secondaryTextColor),
        ),
      ),
      decorationBuilder: (context, child) => Material(
        type: MaterialType.card,
        elevation: 4,
        borderRadius: BorderRadius.circular(16.0),
        child: child,
      ),
      itemBuilder: (context, product) => ListTile(
        title: RichText(
          text: TextSpan(
              text: product.serviceName,
              style: SmTextTheme.confirmButtonTextStyle(context).copyWith(
                  fontSize: SmTextTheme.getResponsiveSize(context, 12))),
        ),
      ),
      onSelected: (value) {
        setState(() {
          (form.control('services') as FormArray).add(FormGroup({
            'id': FormControl<String>(value: value.id),
            'serviceName': FormControl<String>(value: value.serviceName),
            'container1Price':
                FormControl<double>(value: value.container1Price),
            'container2Price':
                FormControl<double>(value: value.container2Price),
            'container3Price':
                FormControl<double>(value: value.container3Price),
            'container4Price':
                FormControl<double>(value: value.container4Price),
          }));
        });
      },
      suggestionsCallback: (String search) {
        return services;
      },
    );
    // CommonMethods.showCommonDialogWithChild(
    //     context,
    //     "Select Service",
    //
    //     positiveButtonString: 'Cancel');
  }

/*Widget serviceUI(BuildContext context) {
    return services != null && services!.isNotEmpty
        ? SizedBox(
            height: SmTextTheme.getResponsiveSize(context, 300),
            width: SmTextTheme.getResponsiveSize(context, 320),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: services!.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      (form.controls['services'] as FormArray<double>).add(
                          FormControl<double>(
                              value: services![index].container1Price));
                      serviceWidgetList.add(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: services![index].serviceName,
                                style:
                                    SmTextTheme.confirmButtonTextStyle(context)
                                        .copyWith(
                                            fontSize:
                                                SmTextTheme.getResponsiveSize(
                                                    context, 14))),
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 20.0)),
                          ReactiveTextField<double>(
                            formControlName: "services[${services![index].id}]",
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                labelText: "Price",
                                labelStyle: TextStyle(
                                    fontSize: SmTextTheme.getResponsiveSize(
                                        context, 16.0),
                                    fontWeight: FontWeight.w400,
                                    color: SmAppTheme.isDarkMode(context)
                                        ? SmColorDarkTheme.secondaryTextColor
                                        : SmColorLightTheme
                                            .secondaryTextColor)),
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  "Price is Required",
                            },
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 20.0)),
                        ],
                      ));
                      context
                          .read<ClientCubit>()
                          .addServiceUiChange(services!, services![index]);
                      Navigator.of(context).pop();
                    } */ /*_showAddServiceDialog(context, services![index])*/ /*,
                    child: ListTile(
                      hoverColor: SmAppTheme.isDarkMode(context)
                          ? SmColorDarkTheme.primaryLightColor
                          : SmColorLightTheme.primaryLightColor,
                      style: ListTileStyle.list,
                      title: RichText(
                          text: TextSpan(
                        text: services![index].serviceName,
                        style: SmTextTheme.confirmButtonTextStyle(context)
                            .copyWith(
                                fontSize:
                                    SmTextTheme.getResponsiveSize(context, 12)),
                      )),
                    ),
                  );
                }),
          )
        : RichText(
            text: TextSpan(
            text: "No data Found",
            style: SmTextTheme.unselectedLabelStyle(context)
                .copyWith(fontSize: SmTextTheme.getResponsiveSize(context, 12)),
          ));
  }*/
}

convertServicesToFormGroups(List<ServiceModel>? services) {
  if (services == null || services.isEmpty) {
    return [];
  }
  return services.map((service) {
    return FormGroup({
      'id': FormControl<String>(value: service.id),
      'serviceName': FormControl<String>(value: service.serviceName),
      'container1Price': FormControl<double>(value: service.container1Price),
      'container2Price': FormControl<double>(value: service.container2Price),
      'container3Price': FormControl<double>(value: service.container3Price),
      'container4Price': FormControl<double>(value: service.container4Price),
    });
  }).toList() as FormArray;
}
