import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_loading_dialog.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_button.dart';
import 'package:sarvoday_marine/features/calendar_module/calendar_injection_container.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';
import 'package:sarvoday_marine/features/calendar_module/presentation/cubit/calendar_cubit.dart';
import 'package:sarvoday_marine/features/calendar_module/presentation/cubit/sales_order_cubit.dart';
import 'package:sarvoday_marine/features/calendar_module/presentation/cubit/sales_order_state.dart';
import 'package:sarvoday_marine/features/client_module/client_module_injection_container.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_Service_model.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/presentation/cubit/client_cubit.dart';
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart';
import 'package:sarvoday_marine/features/employee_module/employee_injection_container.dart';
import 'package:sarvoday_marine/features/employee_module/presentation/cubit/employee_cubit.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';
import 'package:sarvoday_marine/features/location_module/location_injection_container.dart';
import 'package:sarvoday_marine/features/location_module/presentation/cubit/location_cubit.dart';

@RoutePage()
class AddUpdateSalesOrderPage extends StatefulWidget
    implements AutoRouteWrapper {
  const AddUpdateSalesOrderPage(
      {super.key,
      required this.isFromEdit,
      required this.isDisabled,
      required this.isClientOrSuperAdmin,
      this.salesOrderModel});

  final bool isFromEdit;
  final SalesOrderModel? salesOrderModel;
  final bool isClientOrSuperAdmin;
  final bool isDisabled;

  @override
  State<AddUpdateSalesOrderPage> createState() =>
      _AddUpdateSalesOrderPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => calendarSl<CalendarCubit>()),
      BlocProvider(create: (context) => clientSl<ClientCubit>()),
      BlocProvider(create: (context) => locationSl<LocationCubit>()),
      BlocProvider(create: (context) => employeeSl<EmployeeCubit>()),
      BlocProvider(
          create: (context) => SalesOrderCubit(context.read<EmployeeCubit>(),
              context.read<ClientCubit>(), context.read<LocationCubit>())),
    ], child: this);
  }
}

class _AddUpdateSalesOrderPageState extends State<AddUpdateSalesOrderPage> {
  late FormGroup form;
  bool showLoader = false;
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();
  DateTime? selectedDate;
  bool isEditEnabled = false;
  final List priceTypeList = [
    'container1Price',
    'container2Price',
    'container3Price',
    'container4Price'
  ];

  @override
  void initState() {
    form = FormGroup({
      'client': FormControl<String>(
          value: widget.salesOrderModel?.clientId,
          validators: [Validators.required]),
      'orderDate': FormControl<DateTime>(
          value: widget.salesOrderModel?.orderDate != null
              ? DateFormat('yyyy-MM-dd').parse(
                  DateTime.parse(widget.salesOrderModel!.orderDate!)
                      .toLocal()
                      .toString())
              : null,
          validators: [Validators.required]),
      'noOfContainer': FormControl<int>(
          value: widget.salesOrderModel?.noOfContainer,
          validators: [Validators.required]),
      'location': FormControl<String>(
          value: widget.salesOrderModel?.locationName,
          validators: [Validators.required]),
      'products': FormControl<String>(
          value: widget.salesOrderModel?.products,
          validators: [Validators.required]),
      'services': FormArray([], validators: [Validators.minLength(1)]),
      'employees':
          FormArray<SoEmployeeParam>([], validators: [Validators.minLength(1)]),
      'otherExpenses': FormArray([]),
      'comments': FormControl<String>(value: widget.salesOrderModel?.comments),
      'tax': FormArray([], validators: [Validators.minLength(1)]),
    });

    if (widget.isFromEdit) {
      controller.text = widget.salesOrderModel?.clientName ?? "";
      context.read<SalesOrderCubit>().setFieldReadOnly(true, 'client');
      controller3.text = widget.salesOrderModel?.locationName ?? "";
      context.read<SalesOrderCubit>().setFieldReadOnly(true, 'location');
      _initializeFormWithExistingData(form, widget.salesOrderModel!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDisabled || (widget.isFromEdit && !isEditEnabled)) {
      form.markAsDisabled();
    } else {
      form.markAsEnabled();
    }
    SmTextTheme.init(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = _showBackDialog();
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: CommonAppBar(
          context: context,
          title: widget.isDisabled || (widget.isFromEdit && !isEditEnabled)
              ? "Sales Order"
              : widget.isFromEdit && isEditEnabled
                  ? "Edit Sales Order"
                  : "Create Sales Order",
          actionList: [
            Visibility(
              visible: widget.isClientOrSuperAdmin && widget.isFromEdit,
              child: Padding(
                padding:
                    EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 10)),
                child: IconButton(
                    color: SmCommonColors.secondaryColor,
                    icon: const Icon(Icons.receipt_long,
                        color: SmCommonColors.secondaryColor),
                    onPressed: () async {
                      context.router.push(SummaryRoute(
                          salesOrderModel: widget.salesOrderModel!));
                    }),
              ),
            ),
            Visibility(
              visible:
                  !widget.isDisabled && (widget.isFromEdit && !isEditEnabled),
              child: IconButton(
                  color: SmCommonColors.secondaryColor,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditEnabled = true;
                    });
                  }),
            )
          ],
        ).appBar(),
        body: BlocConsumer<CalendarCubit, CalendarState>(
          listener: (context, state) {
            if (state is CMStateNoData) {
              showLoadingDialog(context);
            } else if (state is CMStateOnCrudSuccess) {
              hideLoadingDialog(context);
              CommonMethods.showToast(context, state.response);
              Navigator.of(context).pop(true);
            } else if (state is CMStateError) {
              hideLoadingDialog(context);
              CommonMethods.showCommonDialog(context, "Error", state.message);
            }
          },
          builder: (context, calendarState) {
            return BlocConsumer<SalesOrderCubit, SalesOrderState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state.employeesLoading ||
                    state.clientsLoading ||
                    state.locationsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.employeesError != null ||
                    state.clientsError != null ||
                    state.locationsError != null) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SmTextTheme.getResponsiveSize(context, 14)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          state.employeesError != null
                              ? Text(
                                  'Failed to load employees: ${state.employeesError}')
                              : state.clientsError != null
                                  ? Text(
                                      'Failed to load clients: ${state.clientsError}')
                                  : state.locationsError != null
                                      ? Text(
                                          'Failed to load locations: ${state.locationsError}')
                                      : const SizedBox.shrink(),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<SalesOrderCubit>().fetchData(),
                            child: RichText(
                                text: TextSpan(
                                    text: 'Retry',
                                    style: SmTextTheme.confirmButtonTextStyle(
                                        context))),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ReactiveForm(
                    formGroup: form,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 16.0)),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<SalesOrderCubit>()
                                  .setFieldReadOnly(false, 'client');
                            },
                            child: AbsorbPointer(
                              absorbing: state.clientSelected,
                              child: TypeAheadField<ClientModel>(
                                controller: controller,
                                builder: (context, controller, focusNode) =>
                                    TextField(
                                  controller: controller,
                                  enabled: !widget.isDisabled &&
                                      (!widget.isFromEdit ||
                                          (widget.isFromEdit && isEditEnabled)),
                                  focusNode: focusNode,
                                  style: SmTextTheme.confirmButtonTextStyle(
                                          context)
                                      .copyWith(
                                          fontSize:
                                              SmTextTheme.getResponsiveSize(
                                                  context, 12)),
                                  decoration: InputDecoration(
                                    errorText: widget.isDisabled ||
                                            (widget.isFromEdit &&
                                                !isEditEnabled)
                                        ? null
                                        : form.control('client').isNotNull &&
                                                form
                                                    .control('client')
                                                    .value
                                                    .isNotEmpty
                                            ? null
                                            : 'Please add client',
                                    prefix: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    labelText: "Client",
                                    hintText: "Search Client",
                                    labelStyle: TextStyle(
                                        fontSize: SmTextTheme.getResponsiveSize(
                                            context, 16.0),
                                        fontWeight: FontWeight.w400,
                                        color: SmAppTheme.isDarkMode(context)
                                            ? SmColorDarkTheme
                                                .secondaryTextColor
                                            : SmColorLightTheme
                                                .secondaryTextColor),
                                  ),
                                  readOnly: state
                                      .clientSelected, // Make text field read-only if needed
                                ),
                                decorationBuilder: (context, child) => Material(
                                  type: MaterialType.card,
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: child,
                                ),
                                itemBuilder: (context, client) => ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                        text:
                                            '${client.firstName} ${client.lastName}',
                                        style:
                                            SmTextTheme.confirmButtonTextStyle(
                                                    context)
                                                .copyWith(
                                                    fontSize: SmTextTheme
                                                        .getResponsiveSize(
                                                            context, 12))),
                                  ),
                                ),
                                onSelected: (value) {
                                  form.patchValue({'client': value.userId});
                                  controller.text =
                                      '${value.firstName} ${value.lastName}';
                                  context
                                      .read<SalesOrderCubit>()
                                      .setFieldReadOnly(true, 'client');
                                },
                                suggestionsCallback: (String search) {
                                  if (search.isNotEmpty) {
                                    return state.clients
                                        ?.where((client) =>
                                            (client.firstName != null &&
                                                client.firstName!
                                                    .toLowerCase()
                                                    .contains(search
                                                        .toLowerCase())) ||
                                            (client.lastName != null &&
                                                client.lastName!
                                                    .toLowerCase()
                                                    .contains(
                                                        search.toLowerCase())))
                                        .toList();
                                  }
                                  return state.clients;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 20.0)),
                          TypeAheadField<ClientServiceModel>(
                            controller: controller2,
                            builder: (context, controller, focusNode) =>
                                TextField(
                              controller: controller,
                              focusNode: focusNode,
                              enabled: !widget.isDisabled &&
                                  (!widget.isFromEdit ||
                                      (widget.isFromEdit && isEditEnabled)),
                              style: SmTextTheme.confirmButtonTextStyle(context)
                                  .copyWith(
                                      fontSize: SmTextTheme.getResponsiveSize(
                                          context, 12)),
                              decoration: InputDecoration(
                                errorText: widget.isDisabled ||
                                        (widget.isFromEdit && !isEditEnabled)
                                    ? null
                                    : form.control('services').isNotNull &&
                                            form
                                                .control('services')
                                                .value
                                                .isNotEmpty
                                        ? null
                                        : 'Please add services',
                                prefix: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                hintText: "Search Services",
                                labelText: "Services",
                                labelStyle: TextStyle(
                                    fontSize: SmTextTheme.getResponsiveSize(
                                        context, 16.0),
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
                                (form.control('services') as FormArray)
                                    .add(FormGroup({
                                  'id': FormControl<String>(
                                      value: value.serviceId),
                                  'serviceName': FormControl<String>(
                                      value: value.serviceName),
                                  'priceType': FormControl<String>(
                                      validators: [Validators.required]),
                                }));
                              });
                            },
                            suggestionsCallback: (String search) {
                              if (search.isNotEmpty) {
                                return state.clients
                                    ?.firstWhere((client) =>
                                        client.userId ==
                                        form.control('client').value)
                                    .services
                                    ?.where((service) =>
                                        service.serviceName != null &&
                                        service.serviceName!
                                            .toLowerCase()
                                            .contains(search.toLowerCase()))
                                    .toList();
                              }
                              return state.clients
                                  ?.firstWhere((client) =>
                                      client.userId ==
                                      form.control('client').value)
                                  .services;
                            },
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 20.0)),
                          _buildServiceFields(),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 20.0)),
                          ReactiveTextField<String>(
                            formControlName: "products",
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              labelText: "Product",
                              labelStyle: TextStyle(
                                  fontSize: SmTextTheme.getResponsiveSize(
                                      context, 16.0),
                                  fontWeight: FontWeight.w400,
                                  color: SmAppTheme.isDarkMode(context)
                                      ? SmColorDarkTheme.secondaryTextColor
                                      : SmColorLightTheme.secondaryTextColor),
                            ),
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'Product detail is required'
                            },
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 16.0)),
                          ReactiveTextField<int>(
                            formControlName: "noOfContainer",
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              labelText: "Total Container",
                              labelStyle: TextStyle(
                                  fontSize: SmTextTheme.getResponsiveSize(
                                      context, 16.0),
                                  fontWeight: FontWeight.w400,
                                  color: SmAppTheme.isDarkMode(context)
                                      ? SmColorDarkTheme.secondaryTextColor
                                      : SmColorLightTheme.secondaryTextColor),
                            ),
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'Total No of container is required'
                            },
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 16.0)),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<SalesOrderCubit>()
                                  .setFieldReadOnly(false, 'location');
                            },
                            child: AbsorbPointer(
                              absorbing: state.locationSelected,
                              child: TypeAheadField<LocationModel>(
                                controller: controller3,
                                builder: (context, controller, focusNode) =>
                                    TextField(
                                  enabled: !widget.isDisabled &&
                                      (widget.isFromEdit
                                          ? isEditEnabled
                                          : true),
                                  controller: controller,
                                  focusNode: focusNode,
                                  style: SmTextTheme.confirmButtonTextStyle(
                                          context)
                                      .copyWith(
                                          fontSize:
                                              SmTextTheme.getResponsiveSize(
                                                  context, 12)),
                                  decoration: InputDecoration(
                                    errorText: widget.isDisabled ||
                                            (widget.isFromEdit &&
                                                !isEditEnabled)
                                        ? null
                                        : form.control('location').isNotNull &&
                                                form
                                                    .control('location')
                                                    .value
                                                    .isNotEmpty
                                            ? null
                                            : 'location is Required',
                                    prefix: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    labelText: "Port Location",
                                    hintText: "Search Location",
                                    labelStyle: TextStyle(
                                        fontSize: SmTextTheme.getResponsiveSize(
                                            context, 16.0),
                                        fontWeight: FontWeight.w400,
                                        color: SmAppTheme.isDarkMode(context)
                                            ? SmColorDarkTheme
                                                .secondaryTextColor
                                            : SmColorLightTheme
                                                .secondaryTextColor),
                                  ),
                                  readOnly: state
                                      .locationSelected, // Make text field read-only if needed
                                ),
                                decorationBuilder: (context, child) => Material(
                                  type: MaterialType.card,
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: child,
                                ),
                                itemBuilder: (context, location) => ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                        text: location.locationName,
                                        style:
                                            SmTextTheme.confirmButtonTextStyle(
                                                    context)
                                                .copyWith(
                                                    fontSize: SmTextTheme
                                                        .getResponsiveSize(
                                                            context, 12))),
                                  ),
                                ),
                                onSelected: (value) {
                                  form.patchValue(
                                      {'location': value.locationName});
                                  controller3.text = value.locationName ?? "";
                                  context
                                      .read<SalesOrderCubit>()
                                      .setFieldReadOnly(true, 'location');
                                },
                                suggestionsCallback: (String search) {
                                  if (search.isNotEmpty) {
                                    return state.locations
                                        ?.where((location) =>
                                            (location.address != null &&
                                                location.address!
                                                    .toLowerCase()
                                                    .contains(search
                                                        .toLowerCase())) ||
                                            (location.locationName != null &&
                                                location.locationName!
                                                    .toLowerCase()
                                                    .contains(
                                                        search.toLowerCase())))
                                        .toList();
                                  }
                                  return state.locations;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 16.0)),
                          TypeAheadField<EmployeeModel>(
                            controller: controller4,
                            builder: (context, controller, focusNode) =>
                                TextField(
                              enabled: !widget.isDisabled ||
                                  (widget.isFromEdit && isEditEnabled),
                              controller: controller,
                              focusNode: focusNode,
                              style: SmTextTheme.confirmButtonTextStyle(context)
                                  .copyWith(
                                      fontSize: SmTextTheme.getResponsiveSize(
                                          context, 12)),
                              decoration: InputDecoration(
                                errorText: form.control('employees').valid ||
                                        widget.isDisabled ||
                                        (widget.isFromEdit && !isEditEnabled)
                                    ? null
                                    : 'Please add Employee',
                                prefix: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                labelText: "Employee",
                                hintText: "Search Employee",
                                labelStyle: TextStyle(
                                    fontSize: SmTextTheme.getResponsiveSize(
                                        context, 16.0),
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
                                    text:
                                        '${product.firstName} ${product.lastName}',
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
                                final selectedServices =
                                    form.controls['employees'] as FormArray;
                                selectedServices
                                    .add(FormControl<SoEmployeeParam>(
                                  value: SoEmployeeParam(
                                      employeeId: value.userId,
                                      employeeName:
                                          '${value.firstName} ${value.lastName}',
                                      isAssigned: false),
                                ));
                              });
                            },
                            suggestionsCallback: (String search) {
                              if (search.isNotEmpty) {
                                return state.employees
                                    ?.where((employee) =>
                                        (employee.userRole != null &&
                                            (employee.userRole != 'admin' &&
                                                employee.userRole !=
                                                    'superAdmin')) &&
                                        ((employee.firstName != null &&
                                                employee.firstName!
                                                    .toLowerCase()
                                                    .contains(search
                                                        .toLowerCase())) ||
                                            (employee.lastName != null &&
                                                employee.lastName!
                                                    .toLowerCase()
                                                    .contains(
                                                        search.toLowerCase()))))
                                    .toList();
                              }
                              return state.employees
                                  ?.where((employee) => (employee.userRole !=
                                          null &&
                                      (employee.userRole != '"admin' &&
                                          employee.userRole != 'superAdmin')))
                                  .toList();
                            },
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 16.0)),
                          _buildEmployeeFields(),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 16.0)),
                          InkWell(
                            onTap: () async {},
                            child: ReactiveTextField<DateTime>(
                              formControlName: "orderDate",
                              onTap: (value) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary:
                                                SmColorLightTheme.primaryColor,
                                            onPrimary:
                                                SmColorLightTheme.cardColor,
                                            onSurface:
                                                SmColorLightTheme.onPrimary,
                                          ),
                                          dialogBackgroundColor: Colors.white,
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedDate != null) {
                                    form
                                        .control("orderDate")
                                        .patchValue(pickedDate);
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                labelText: "Select Order Date",
                                labelStyle: TextStyle(
                                    fontSize: SmTextTheme.getResponsiveSize(
                                        context, 16.0),
                                    fontWeight: FontWeight.w400,
                                    color: SmAppTheme.isDarkMode(context)
                                        ? SmColorDarkTheme.secondaryTextColor
                                        : SmColorLightTheme.secondaryTextColor),
                              ),
                              validationMessages: {
                                ValidationMessage.required: (error) =>
                                    'Product detail is required'
                              },
                            ),
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 20.0)),
                          ReactiveTextField<String>(
                            formControlName: "comments",
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              labelText: "Comment",
                              labelStyle: TextStyle(
                                  fontSize: SmTextTheme.getResponsiveSize(
                                      context, 16.0),
                                  fontWeight: FontWeight.w400,
                                  color: SmAppTheme.isDarkMode(context)
                                      ? SmColorDarkTheme.secondaryTextColor
                                      : SmColorLightTheme.secondaryTextColor),
                            ),
                          ),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 20.0)),
                          addIconForTaxAndExpenses(false),
                          _buildOtherExpensesFields(),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 20.0)),
                          addIconForTaxAndExpenses(true),
                          _buildTaxFields(),
                          SizedBox(
                              height:
                                  SmTextTheme.getResponsiveSize(context, 16.0)),
                          SizedBox(
                            width: double.infinity,
                            child: CustomSmButton(
                              text: widget.isFromEdit &&
                                      isEditEnabled &&
                                      !widget.isDisabled
                                  ? "Update"
                                  : widget.isDisabled ||
                                          (widget.isFromEdit && !isEditEnabled)
                                      ? "Survey"
                                      : "Add",
                              onTap: () {
                                if (widget.isDisabled ||
                                    (widget.isFromEdit && !isEditEnabled)) {
                                  context.router.push(ReportRoute(
                                      orderId:
                                          widget.salesOrderModel!.orderId!));
                                } else if (form.valid) {
                                  final List<SoEmployeeParam> employees = form
                                      .control("employees")
                                      .value
                                      ?.where((element) => element != null)
                                      .cast<SoEmployeeParam>()
                                      .toList();
                                  final result = employees.where(
                                      (SoEmployeeParam element) =>
                                          element.isAssigned ?? false);
                                  if (result.isEmpty) {
                                    CommonMethods.showToast(
                                        context, "Please assign an employee.");
                                    return;
                                  }
                                  final List<SoServiceParam>? services = (form
                                          .control("services")
                                          .value as List?)
                                      ?.map<SoServiceParam>((element) =>
                                          SoServiceParam(
                                              serviceName:
                                                  element['serviceName'],
                                              priceType: element['priceType'],
                                              serviceId: element['id']))
                                      .toList();
                                  final ClientModel? client = state.clients
                                      ?.firstWhere((client) =>
                                          client.userId ==
                                          form.control('client').value);
                                  final String products =
                                      form.control('products').value;
                                  final int? noOfContainer =
                                      form.control('noOfContainer').value;
                                  final LocationModel? location =
                                      state.locations?.firstWhere((location) =>
                                          location.locationName ==
                                          form.control('location').value);
                                  final DateTime? orderDate =
                                      form.control('orderDate').value;
                                  final List<ExpenseParam>? otherExpense = (form
                                          .control('otherExpenses')
                                          .value as List?)
                                      ?.map<ExpenseParam>((element) =>
                                          ExpenseParam(
                                              expenseName:
                                                  element['expenseName'],
                                              price: element['expensePrice']))
                                      .toList();
                                  final String? comment =
                                      form.control('comments').value;
                                  final List<TaxParam>? taxList = (form
                                          .control('tax')
                                          .value as List?)
                                      ?.map<TaxParam>((element) => TaxParam(
                                          taxName: element['taxName'],
                                          description: element['description'],
                                          sGST: element['sGST'],
                                          cGST: element['cGST']))
                                      .toList();
                                  if (widget.isFromEdit) {
                                    context.read<CalendarCubit>().updateSalesOrders(
                                        widget.salesOrderModel!.id!,
                                        location?.locationName ?? "",
                                        location?.address ?? "",
                                        comment ?? "",
                                        client?.userId ?? "",
                                        orderDate!,
                                        products,
                                        noOfContainer ?? 0,
                                        services ?? [],
                                        employees,
                                        otherExpense ?? [],
                                        taxList ?? [],
                                        '${client?.firstName ?? ""} ${client?.lastName ?? ""}'
                                            .trim());
                                  } else {
                                    context.read<CalendarCubit>().addSalesOrders(
                                        location?.locationName ?? "",
                                        location?.address ?? "",
                                        comment ?? "",
                                        client?.userId ?? "",
                                        orderDate!,
                                        products,
                                        noOfContainer ?? 0,
                                        services ?? [],
                                        employees,
                                        otherExpense ?? [],
                                        taxList ?? [],
                                        '${client?.firstName ?? ""} ${client?.lastName ?? ""}'
                                            .trim());
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
      ),
    );
  }

  bool _showBackDialog() {
    if (isEditEnabled) {
      setState(() {
        isEditEnabled = false;
      });
      return false;
    } else {
      return true;
    }
  }

  Widget addIconForTaxAndExpenses(bool isForTax) {
    return Visibility(
      visible: !widget.isDisabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (!widget.isDisabled &&
                  (widget.isFromEdit ? isEditEnabled : true)) {
                setState(() {
                  if (isForTax) {
                    (form.control('tax') as FormArray).add(FormGroup({
                      'taxName': FormControl<String>(
                          /*validators: [Validators.required]*/),
                      'description': FormControl<String>(
                          /*validators: [Validators.required]*/),
                      'sGST': FormControl<double>(
                          validators: [Validators.required]),
                      'cGST': FormControl<double>(
                          validators: [Validators.required]),
                    }));
                  } else {
                    (form.control('otherExpenses') as FormArray).add(FormGroup({
                      'expenseName': FormControl<String>(
                          validators: [Validators.required]),
                      'expensePrice': FormControl<double>(
                          validators: [Validators.required]),
                    }));
                  }
                });
              }
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                      text: TextSpan(
                    text: isForTax ? "Tax" : "Expenses",
                    style: SmTextTheme.confirmButtonTextStyle(context).copyWith(
                        fontSize: SmTextTheme.getResponsiveSize(context, 14.0)),
                  )),
                  SizedBox(width: SmTextTheme.getResponsiveSize(context, 12)),
                  const Icon(Icons.add),
                ],
              ),
            ),
          ),
          SizedBox(height: SmTextTheme.getResponsiveSize(context, 10.0)),
        ],
      ),
    );
  }

  Widget _buildServiceFields() {
    final selectedServices = form.controls['services'] as FormArray;
    return ReactiveFormArray(
        formArrayName: 'services',
        builder: (context, formArray, child) {
          final formArrayControls = formArray as FormArray;
          if (widget.isDisabled || (widget.isFromEdit && !isEditEnabled)) {
            formArray.markAsDisabled();
          } else {
            formArray.markAsEnabled();
          }
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: formArrayControls.controls.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final serviceGroup =
                    formArrayControls.controls[index] as FormGroup;
                final serviceName = serviceGroup.control('serviceName').value;
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: SmTextTheme.getResponsiveSize(context, 16.0),
                      right: SmTextTheme.getResponsiveSize(context, 8.0),
                      left: SmTextTheme.getResponsiveSize(context, 12.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: RichText(
                                text: TextSpan(
                                    text: serviceName,
                                    style: SmTextTheme.confirmButtonTextStyle(
                                            context)
                                        .copyWith(
                                            fontSize:
                                                SmTextTheme.getResponsiveSize(
                                                    context, 12)))),
                          ),
                          Expanded(
                            flex: 1,
                            child: Visibility(
                              visible: !widget.isDisabled,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SmTextTheme.getResponsiveSize(
                                        context, 4)),
                                child: IconButton(
                                    color: SmCommonColors.errorColor,
                                    icon: const Icon(Icons.clear_outlined),
                                    onPressed: () {
                                      if ((!widget.isDisabled &&
                                              widget.isFromEdit &&
                                              isEditEnabled) ||
                                          (!widget.isDisabled &&
                                              !widget.isFromEdit)) {
                                        setState(() {
                                          selectedServices.remove(serviceGroup);
                                        });
                                      }
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 8)),
                      ReactiveDropdownField<String>(
                        readOnly: widget.isDisabled ||
                            (widget.isFromEdit && !isEditEnabled),
                        items: priceTypeList
                            .map((e) => DropdownMenuItem(
                                value: e.toString(), child: Text(e)))
                            .toList(),
                        formControl: serviceGroup.control('priceType')
                            as FormControl<String>,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          labelText: "Price Type",
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
                              'PLease select price type'
                        },
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _initializeFormWithExistingData(FormGroup form, SalesOrderModel order) {
    FormArray servicesArray = form.control('services') as FormArray;
    FormArray expensesArray = form.control('otherExpenses') as FormArray;
    FormArray taxesArray = form.control('tax') as FormArray;
    FormArray employeesArray = form.control('employees') as FormArray;

    if (order.services != null) {
      for (var service in order.services!) {
        servicesArray.add(FormGroup({
          'id': FormControl<String>(value: service.serviceId),
          'serviceName': FormControl<String>(value: service.serviceName),
          'priceType': FormControl<String>(
              value: service.priceType, validators: [Validators.required]),
        }));
      }
    }

    if (order.employeeList != null) {
      for (var employee in order.employeeList!) {
        employeesArray.add(FormControl<SoEmployeeParam>(
          value: SoEmployeeParam(
              employeeId: employee.employeeId,
              employeeName: employee.employeeName,
              isAssigned: employee.isAssigned),
        ));
      }
    }

    if (order.tax != null) {
      for (var tax in order.tax!) {
        taxesArray.add(FormGroup({
          'taxName': FormControl<String>(
            value: tax.taxName, /*validators: [Validators.required]*/
          ),
          'description': FormControl<String>(
            value: tax.description, /*validators: [Validators.required]*/
          ),
          'sGST': FormControl<double>(
              value: tax.sGST, validators: [Validators.required]),
          'cGST': FormControl<double>(
              value: tax.cGST, validators: [Validators.required]),
        }));
      }
    }

    if (order.otherExpenses != null) {
      for (var expense in order.otherExpenses!) {
        expensesArray.add(FormGroup({
          'expenseName': FormControl<String>(
              value: expense.expenseName, validators: [Validators.required]),
          'expensePrice': FormControl<double>(
              value: expense.price, validators: [Validators.required]),
        }));
      }
    }

    setState(() {});
  }

  Widget _buildTaxFields() {
    final taxList = form.controls['tax'] as FormArray;
    return ReactiveFormArray(
        formArrayName: 'tax',
        builder: (context, formArray, child) {
          final formArrayControls = formArray as FormArray;
          if (widget.isDisabled || (widget.isFromEdit && !isEditEnabled)) {
            formArray.markAsDisabled();
          } else {
            formArray.markAsEnabled();
          }
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: formArrayControls.controls.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final taxGroup = formArrayControls.controls[index] as FormGroup;
                return Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SmTextTheme.getResponsiveSize(context, 6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Visibility(
                            visible: !widget.isDisabled,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SmTextTheme.getResponsiveSize(
                                      context, 4)),
                              child: IconButton(
                                  color: SmCommonColors.errorColor,
                                  icon: const Icon(Icons.clear_outlined),
                                  onPressed: () {
                                    if (!widget.isDisabled &&
                                        (widget.isFromEdit
                                            ? isEditEnabled
                                            : true)) {
                                      setState(() {
                                        taxList.remove(taxGroup);
                                      });
                                    }
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        ReactiveTextField<double>(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          formControl:
                              taxGroup.control('sGST') as FormControl<double>,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            labelText: "SGST",
                            labelStyle: TextStyle(
                                fontSize: SmTextTheme.getResponsiveSize(
                                    context, 16.0),
                                fontWeight: FontWeight.w400,
                                color: SmAppTheme.isDarkMode(context)
                                    ? SmColorDarkTheme.secondaryTextColor
                                    : SmColorLightTheme.secondaryTextColor),
                          ),
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'SGST is required'
                          },
                        ),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        ReactiveTextField<double>(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          formControl:
                              taxGroup.control('cGST') as FormControl<double>,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            labelText: "CGST",
                            labelStyle: TextStyle(
                                fontSize: SmTextTheme.getResponsiveSize(
                                    context, 16.0),
                                fontWeight: FontWeight.w400,
                                color: SmAppTheme.isDarkMode(context)
                                    ? SmColorDarkTheme.secondaryTextColor
                                    : SmColorLightTheme.secondaryTextColor),
                          ),
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Product detail is required'
                          },
                        ),
                        SizedBox(
                            height: SmTextTheme.getResponsiveSize(context, 16)),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Widget _buildOtherExpensesFields() {
    final expenseList = form.controls['otherExpenses'] as FormArray;
    return ReactiveFormArray(
        formArrayName: 'otherExpenses',
        builder: (context, formArray, child) {
          final formArrayControls = formArray as FormArray;
          if (widget.isDisabled || (widget.isFromEdit && !isEditEnabled)) {
            formArray.markAsDisabled();
          } else {
            formArray.markAsEnabled();
          }
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: formArrayControls.controls.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final expenseGroup =
                    formArrayControls.controls[index] as FormGroup;
                return Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SmTextTheme.getResponsiveSize(context, 6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Visibility(
                            visible: !widget.isDisabled,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SmTextTheme.getResponsiveSize(
                                      context, 4)),
                              child: IconButton(
                                  color: SmCommonColors.errorColor,
                                  icon: const Icon(Icons.clear_outlined),
                                  onPressed: () {
                                    if (!widget.isDisabled &&
                                        (widget.isFromEdit
                                            ? isEditEnabled
                                            : true)) {
                                      setState(() {
                                        expenseList.remove(expenseGroup);
                                      });
                                    }
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        ReactiveTextField<String>(
                          formControl: expenseGroup.control('expenseName')
                              as FormControl<String>,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            labelText: "Expense Information",
                            hintText: 'Please enter Expense Information',
                            labelStyle: TextStyle(
                                fontSize: SmTextTheme.getResponsiveSize(
                                    context, 16.0),
                                fontWeight: FontWeight.w400,
                                color: SmAppTheme.isDarkMode(context)
                                    ? SmColorDarkTheme.secondaryTextColor
                                    : SmColorLightTheme.secondaryTextColor),
                          ),
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Expense information is required'
                          },
                        ),
                        SizedBox(
                            height:
                                SmTextTheme.getResponsiveSize(context, 20.0)),
                        ReactiveTextField<double>(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          formControl: expenseGroup.control('expensePrice')
                              as FormControl<double>,
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
                                    : SmColorLightTheme.secondaryTextColor),
                          ),
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'SGST is required'
                          },
                        ),
                        SizedBox(
                            height: SmTextTheme.getResponsiveSize(context, 16)),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Widget _buildEmployeeFields() {
    final selectedEmployee = form.controls['employees'] as FormArray;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: selectedEmployee.value?.length ?? 0,
      itemBuilder: (context, index) {
        final employeeControl =
            selectedEmployee.controls[index] as FormControl<SoEmployeeParam>;
        final employeeId = employeeControl.value?.employeeId ?? "";
        final employeeName = employeeControl.value?.employeeName ?? "";
        final bool isAssigned = employeeControl.value?.isAssigned ?? false;
        return Padding(
          padding: EdgeInsets.only(
              bottom: SmTextTheme.getResponsiveSize(context, 16.0),
              right: SmTextTheme.getResponsiveSize(context, 8.0),
              left: SmTextTheme.getResponsiveSize(context, 8.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: RichText(
                    maxLines: 3,
                    text: TextSpan(
                        text: employeeName,
                        style: SmTextTheme.confirmButtonTextStyle(context)
                            .copyWith(
                                fontSize: SmTextTheme.getResponsiveSize(
                                    context, 12)))),
              ),
              Expanded(
                flex: 2,
                child: Visibility(
                  visible: !widget.isDisabled,
                  child: SizedBox(
                    height: SmTextTheme.getResponsiveSize(context, 28),
                    child: CustomSmButton(
                        fontSize: 10,
                        color:
                            isAssigned ? SmCommonColors.secondaryColor : null,
                        text: isAssigned ? "Assigned" : "Assign",
                        onTap: () {
                          if (!widget.isDisabled &&
                              (widget.isFromEdit ? isEditEnabled : true)) {
                            setState(() {
                              employeeControl.value = SoEmployeeParam(
                                  employeeId: employeeId,
                                  employeeName: employeeName,
                                  isAssigned: !isAssigned);
                            });
                          }
                        }),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Visibility(
                  visible: !widget.isDisabled,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SmTextTheme.getResponsiveSize(context, 4)),
                    child: IconButton(
                        color: SmCommonColors.errorColor,
                        icon: const Icon(Icons.clear_outlined),
                        onPressed: () {
                          if (!widget.isDisabled &&
                              (widget.isFromEdit ? isEditEnabled : true)) {
                            setState(() {
                              selectedEmployee.remove(employeeControl);
                            });
                          }
                        }),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

bool validateServices(FormArray formArrayControl) {
  final control = formArrayControl as FormArray<ClientServiceModel>;
  if (control.value?.isEmpty ?? true) {
    return false;
  }
  for (final service in control.controls) {
    if (!service.valid) {
      return false;
    }
  }
  return true;
}

class ServicePriceField extends StatelessWidget {
  final FormControl<ClientServiceModel> control;

  const ServicePriceField({super.key, required this.control});

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<ClientServiceModel, double>(
        formControl: control,
        builder: (field) {
          return TextFormField(
            controller: TextEditingController(
              text: field.value?.toString() ?? '',
            ),
            onChanged: (value) {
              field.didChange(double.tryParse(value) ?? 0.0);
            },
          );
        });
  }
}
