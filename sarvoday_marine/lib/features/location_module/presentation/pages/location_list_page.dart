import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_loading_dialog.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_floating_action.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_slidable_card_view.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_no_available_widget.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';
import 'package:sarvoday_marine/features/location_module/location_injection_container.dart';
import 'package:sarvoday_marine/features/location_module/presentation/cubit/location_cubit.dart';
import 'package:sarvoday_marine/features/location_module/presentation/widgets/add_update_location_dialog.dart';

@RoutePage()
class LocationListPage extends StatelessWidget implements AutoRouteWrapper {
  LocationListPage({super.key});

  List<LocationModel> locationList = [];
  bool isDeleteAction = false;

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return Scaffold(
        floatingActionButton: CommonFloatingAction(
            context: context,
            onPressed: () async {
              await AddUpdateLocationDialog.showLocationDialog(context, false);
            }).addActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: CommonAppBar(
          context: context,
          title: StringConst.smLocationTitle,
        ).appBar(),
        body: BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state is LocationStateOnCrudSuccess) {
              hideLoadingDialog(context);
              CommonMethods.showToast(context, state.response);
              if (!isDeleteAction) {
                Navigator.of(context).pop();
              }
            } else if (state is LocationStateErrorGeneral) {
              hideLoadingDialog(context);
              CommonMethods.showCommonDialog(
                  context, "Error", state.errorMessage.toString());
            } else if (state is LocationStateNoData) {
              showLoadingDialog(context);
            }
          },
          builder: (context, state) {
            if (state is LocationStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LocationStateOnSuccess) {
              locationList = state.response;
            } else if (state is LocationStateOnCrudSuccess) {
              isDeleteAction = false;
            }
            return SafeArea(
              child: locationList.isEmpty
                  ? const NoItemsAvailable()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: locationList.length,
                      itemBuilder: (context, item) {
                        return Padding(
                          padding: EdgeInsets.all(
                              SmTextTheme.getResponsiveSize(context, 4)),
                          child: CustomSlidableCardView(
                            isFromServicePage: false,
                            title: locationList[item].locationName ?? "",
                            subTitle: '${locationList[item].address}',
                            date: locationList[item].createdAt ?? "",
                            onEditClick: (context) async {
                              await AddUpdateLocationDialog.showLocationDialog(
                                  context, true,
                                  locationId: locationList[item].id ?? "",
                                  locationName:
                                      locationList[item].locationName ?? "",
                                  address: locationList[item].address ?? "",
                                  locationCode:
                                      locationList[item].locationCode ?? "");
                            },
                            onDeleteClick: (context) async {
                              isDeleteAction = true;
                              await context
                                  .read<LocationCubit>()
                                  .deleteLocation(locationList[item].id!);
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
      create: (context) => locationSl<LocationCubit>()..getAllLocations(),
      child: this,
    );
  }
}
