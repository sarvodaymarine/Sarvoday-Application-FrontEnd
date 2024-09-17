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
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_no_available_widget.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/presentation/cubit/client_cubit.dart';
import 'package:sarvoday_marine/features/client_module/presentation/widgets/client_card_view.dart';
import 'package:sarvoday_marine/features/service_module/service_module_injection_container.dart';

@RoutePage()
class ClientListPage extends StatelessWidget implements AutoRouteWrapper {
  ClientListPage({super.key});

  List<ClientModel> clientList = [];
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
                  .push(ClientAddUpdateRoute(isFromEdit: false))
                  .then((_) async {
                await context.read<ClientCubit>().getAllClient();
              });
            }).addActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: CommonAppBar(context: context, title: StringConst.smClientTitle)
            .appBar(),
        body: BlocConsumer<ClientCubit, ClientState>(
          listener: (context, state) {
            if (state is CStateOnCrudSuccess) {
              hideLoadingDialog(context);
              CommonMethods.showToast(context, state.response);
              if (!isDeleteAction || !isDisableAction) {
                context.read<ClientCubit>().getAllClient();
              }
            } else if (state is CStateErrorGeneral) {
              hideLoadingDialog(context);
              CommonMethods.showCommonDialog(
                  context, "Error", state.errorMessage.toString());
            } else if (state is CStateNoData) {
              showLoadingDialog(context);
            }
          },
          builder: (context, state) {
            if (state is CStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CStateOnSuccess) {
              clientList = state.response;
            } else if (state is CStateOnCrudSuccess) {
              isDeleteAction = false;
              isDisableAction = false;
            }
            return SafeArea(
              child: clientList.isEmpty
                  ? const NoItemsAvailable(
                      message: "No clients are available",
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: clientList.length,
                      itemBuilder: (context, item) {
                        return Padding(
                          padding: EdgeInsets.all(
                              SmTextTheme.getResponsiveSize(context, 4)),
                          child: InkWell(
                            onTap: () {
                              AutoRouter.of(context)
                                  .push(ClientAddUpdateRoute(
                                      isFromEdit: true,
                                      clientModel: clientList[item]))
                                  .then((_) async {
                                if (context.mounted) {
                                  await context
                                      .read<ClientCubit>()
                                      .getAllClient();
                                }
                              });
                            },
                            child: ClientCardView(
                              name:
                                  '${clientList[item].firstName} ${clientList[item].lastName}',
                              mobile:
                                  '${clientList[item].userDetail?.countryCode} ${clientList[item].userDetail?.mobile}',
                              date: clientList[item].createdAt ?? "",
                              email: clientList[item].userDetail?.email ?? "",
                              onDisableClick: (context) async {
                                await context.read<ClientCubit>().disableClient(
                                    clientList[item].userId!,
                                    !clientList[item].userDetail!.isActive!);
                              },
                              onDeleteClick: (context) async {
                                isDeleteAction = true;
                                await context
                                    .read<ClientCubit>()
                                    .deleteClient(clientList[item].id!);
                              },
                              isActive: clientList[item].userDetail?.isActive ??
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
      create: (context) => servicesSl<ClientCubit>()..getAllClient(),
      child: this,
    );
  }
}
