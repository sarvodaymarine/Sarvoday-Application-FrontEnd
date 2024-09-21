import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_loading_dialog.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_floating_action.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_no_available_widget.dart';
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart';
import 'package:sarvoday_marine/features/employee_module/employee_injection_container.dart';
import 'package:sarvoday_marine/features/employee_module/presentation/cubit/employee_cubit.dart';

import '../../../client_module/presentation/widgets/client_card_view.dart';

@RoutePage()
class EmployeeListPage extends StatelessWidget implements AutoRouteWrapper {
  EmployeeListPage({super.key});

  List<EmployeeModel> employeeList = [];
  bool isDeleteAction = false;
  bool isDisableAction = false;

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return Scaffold(
        floatingActionButton: CommonFloatingAction(
            context: context,
            onPressed: () {
              AutoRouter.of(context)
                  .push(EmployeeDetailsAddUpdateRoute(isFromEdit: false))
                  .then((_) async {
                await context.read<EmployeeCubit>().getAllEmployee();
              });
            }).addActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar:
            CommonAppBar(context: context, title: StringConst.smEmployeeTitle)
                .appBar(),
        body: BlocConsumer<EmployeeCubit, EmployeeState>(
          listener: (context, state) {
            if (state is EmpStateOnCrudSuccess) {
              hideLoadingDialog(context);
              CommonMethods.showToast(context, state.response);
              if (!isDeleteAction || !isDisableAction) {
                context.read<EmployeeCubit>().getAllEmployee();
              }
            } else if (state is EmpStateErrorGeneral) {
              hideLoadingDialog(context);
              CommonMethods.showCommonDialog(
                  context, "Error", state.errorMessage.toString());
            } else if (state is EmpStateNoData) {
              showLoadingDialog(context);
            }
          },
          builder: (context, state) {
            if (state is EmpStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmpStateOnSuccess) {
              employeeList = state.response;
            } else if (state is EmpStateOnCrudSuccess) {
              isDeleteAction = false;
              isDisableAction = false;
            }
            return SafeArea(
              child: employeeList.isEmpty
                  ? const NoItemsAvailable(
                      message: "No employees are available",
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: employeeList.length,
                      itemBuilder: (context, item) {
                        return Padding(
                          padding: EdgeInsets.all(
                              SmTextTheme.getResponsiveSize(context, 4)),
                          child: InkWell(
                            onTap: () {
                              AutoRouter.of(context)
                                  .push(EmployeeDetailsAddUpdateRoute(
                                      isFromEdit: true,
                                      employeeModel: employeeList[item]))
                                  .then((_) async {
                                await context
                                    .read<EmployeeCubit>()
                                    .getAllEmployee();
                              });
                            },
                            child: ClientCardView(
                              name:
                                  "${employeeList[item].firstName ?? ""} ${employeeList[item].lastName ?? ""}",
                              mobile:
                                  '${employeeList[item].userDetail?.countryCode} ${employeeList[item].userDetail?.mobile}',
                              date: employeeList[item].createdAt ?? "",
                              email: employeeList[item].userDetail?.email ?? "",
                              onDisableClick: (context) async {
                                await context
                                    .read<EmployeeCubit>()
                                    .disableEmployee(
                                        employeeList[item].userId!,
                                        !employeeList[item]
                                            .userDetail!
                                            .isActive!);
                              },
                              onDeleteClick: (context) async {
                                isDeleteAction = true;
                                await context
                                    .read<EmployeeCubit>()
                                    .deleteEmployee(employeeList[item].id!);
                              },
                              isActive:
                                  employeeList[item].userDetail?.isActive ??
                                      false,
                            ),
                          ),
                        );
                      }),
            );
          },
        ));
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => employeeSl<EmployeeCubit>()..getAllEmployee(),
      child: this,
    );
  }
}
