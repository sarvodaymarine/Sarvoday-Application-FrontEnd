import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_loading_dialog.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_button.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_text_form_field.dart';
import 'package:sarvoday_marine/features/employee_module/employee_injection_container.dart';
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart';
import 'package:sarvoday_marine/features/employee_module/presentation/cubit/employee_cubit.dart';

@RoutePage()
class EmployeeDetailsAddUpdatePage extends StatefulWidget
    implements AutoRouteWrapper {
  const EmployeeDetailsAddUpdatePage(
      {super.key, this.employeeModel, required this.isFromEdit});

  final EmployeeModel? employeeModel;
  final bool isFromEdit;

  @override
  State<EmployeeDetailsAddUpdatePage> createState() =>
      _EmployeeDetailsAddUpdatePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => employeeSl<EmployeeCubit>())
    ], child: this);
  }
}

class _EmployeeDetailsAddUpdatePageState
    extends State<EmployeeDetailsAddUpdatePage> {
  final TextEditingController controller = TextEditingController();

  late FormGroup form;

  @override
  void initState() {
    form = FormGroup({
      'firstName': FormControl<String>(
          validators: [Validators.required],
          value: widget.employeeModel?.firstName ?? ""),
      'lastName': FormControl<String>(
          validators: [Validators.required],
          value: widget.employeeModel?.lastName ?? ""),
      'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
          value: widget.employeeModel?.userDetail?.email ?? ""),
      'countryCode': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(1),
        Validators.maxLength(4)
      ], value: widget.employeeModel?.userDetail?.countryCode ?? '+91'),
      'userRole': FormControl<String>(
          validators: [Validators.required],
          value: widget.employeeModel?.userRole ?? 'employee'),
      'mobile': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(10),
        Validators.maxLength(10)
      ], value: widget.employeeModel?.userDetail?.mobile ?? ""),
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return Scaffold(
        appBar: CommonAppBar(
          context: context,
          title: widget.isFromEdit
              ? "Edit Employee Details"
              : "Add Employee Details",
        ).appBar(),
        body: BlocConsumer<EmployeeCubit, EmployeeState>(
          listener: (context, state) {
            if (state is EmpStateOnCrudSuccess) {
              hideLoadingDialog(context);
              CommonMethods.showToast(context, state.response);
              Navigator.of(context).pop(true);
            } else if (state is EmpStateErrorGeneral) {
              hideLoadingDialog(context);
              CommonMethods.showCommonDialog(
                  context, "Error", state.errorMessage.toString());
            } else if (state is EmpStateNoData) {
              showLoadingDialog(context);
            }
          },
          builder: (context, state) {
            return Padding(
              padding:
                  EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 16)),
              child: ReactiveForm(
                formGroup: form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 16.0)),
                      const CustomTextFormField(
                        formControlName: "firstName",
                        labelText: "First Name",
                        hintText: "Please enter first name",
                      ),
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 16.0)),
                      const CustomTextFormField(
                        formControlName: "lastName",
                        labelText: "Last Name",
                        hintText: "Please enter last name",
                      ),
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 20.0)),
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
                          height: SmTextTheme.getResponsiveSize(context, 20.0)),
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
                              width:
                                  SmTextTheme.getResponsiveSize(context, 10.0)),
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
                          height: SmTextTheme.getResponsiveSize(context, 16.0)),
                      ReactiveDropdownField(
                          items: ['employee', 'admin']
                              .map((client) => DropdownMenuItem(
                                    value: client,
                                    child: RichText(
                                      text: TextSpan(
                                          text: client,
                                          style: SmTextTheme
                                                  .confirmButtonTextStyle(
                                                      context)
                                              .copyWith(
                                                  fontSize: SmTextTheme
                                                      .getResponsiveSize(
                                                          context, 12))),
                                    ),
                                  ))
                              .toList(),
                          alignment: Alignment.topCenter,
                          borderRadius: BorderRadius.circular(
                              SmTextTheme.getResponsiveSize(context, 16)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            labelText: "Select Client",
                            labelStyle: SmTextTheme.infoContentStyle6(context),
                          ),
                          formControlName: 'userRole'),
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 16.0)),
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
                              String lastName = form.control('lastName').value;
                              String userRole = form.control('userRole').value;
                              if (widget.isFromEdit) {
                                context.read<EmployeeCubit>().updateEmployee(
                                    widget.employeeModel!.id!,
                                    firstName,
                                    lastName,
                                    mobile,
                                    email,
                                    countryCode,
                                    userRole);
                              } else {
                                context.read<EmployeeCubit>().addEmployee(
                                    firstName,
                                    lastName,
                                    email,
                                    countryCode,
                                    mobile,
                                    userRole);
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
        ));
  }
}
