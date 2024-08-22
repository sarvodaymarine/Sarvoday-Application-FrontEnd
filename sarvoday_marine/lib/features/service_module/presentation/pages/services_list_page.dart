import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_loading_dialog.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_floating_action.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_slidable_card_view.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/presentation/cubit/service_cubit.dart';
import 'package:sarvoday_marine/features/service_module/service_module_injection_container.dart';

@RoutePage()
class ServicesListPage extends StatelessWidget implements AutoRouteWrapper {
  ServicesListPage({super.key});

  List<ServiceModel> serviceList = [];
  bool isDeleteAction = false;

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return Scaffold(
        floatingActionButton: CommonFloatingAction(
            context: context,
            onPressed: () {
              context.router
                  .push(AddUpdateServiceRoute(isEdit: false))
                  .then((Object? value) {
                if (value != null) {
                  context.read<ServiceCubit>().getAllServices();
                }
              });
            }).addActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: CommonAppBar(
          context: context,
          title: StringConst.smServiceTitle,
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
              serviceList = state.response;
            } else if (state is StateOnCrudSuccess) {
              isDeleteAction = false;
            }
            return SafeArea(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: serviceList.length,
                  itemBuilder: (context, item) {
                    return Padding(
                      padding: EdgeInsets.all(
                          SmTextTheme.getResponsiveSize(context, 4)),
                      child: CustomSlidableCardView(
                        isFromServicePage: true,
                        title: serviceList[item].serviceName ?? "",
                        subTitle:
                            "" /*'${serviceList[item].container1Price} ₹'*/,
                        date: serviceList[item].createdAt ?? "",
                        onEditClick: (context) {
                          context.router
                              .push(AddUpdateServiceRoute(
                                  isEdit: true,
                                  serviceModel: serviceList[item]))
                              .then((Object? value) {
                            if (value != null) {
                              context.read<ServiceCubit>().getAllServices();
                            }
                          });
                        },
                        onDeleteClick: (context) async {
                          isDeleteAction = true;
                          await context
                              .read<ServiceCubit>()
                              .deleteService(serviceList[item].id!);
                        },
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
      create: (context) => servicesSl<ServiceCubit>(),
      child: this,
    );
  }
}
