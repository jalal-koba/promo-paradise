import 'package:promo/app/Widget/app_loading.dart';
import 'package:promo/app/Widget/try_agin.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:promo/constant/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promo/constant/text_style.dart';
import 'package:promo/app/Widget/custom_app_bar.dart';
import 'package:promo/app/Validation/Cubit/Cubit/vouchers_cubit.dart';
import 'package:promo/app/Validation/View/Widgets/vouchers_using_history_card.dart';

import '../../Cubit/States/vouchers_states.dart';
import '../Widgets/q_r_card.dart';
import '../Widgets/vouchers_details_card.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  static const String routeName = "/vouchers-screen";

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen>
    with SingleTickerProviderStateMixin {
  @protected
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 15.h),
        child: const SafeArea(
          child: CustomAppBar("vouchers"),
        ),
      ),
      body: BlocProvider(
        create: (context) => VouchersCubit()..getPackages(),
        child: BlocConsumer<VouchersCubit, VouchersStates>(
          listener: (context, state) {},
          builder: (context, state) {
            VouchersCubit vouchersCubit = VouchersCubit.get(context);
            if (state is VouchersLooding) {
              return const AppLoading();
            }
            if (state is VouchersError) {
              return TryAgain(
                onTap: () => vouchersCubit.getPackages(),
              );
            }
            final qr =
                vouchersCubit.qrUrl ?? 'qr_codes/31727091708QEVs6j8dyP.png';
            final totalActiveVouchers = vouchersCubit.totalActiveVouchers;
            final packages = vouchersCubit.packages;
            final vouchersUsingHistory = vouchersCubit.vouchersUsingHistory;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: QRCard(
                    qrUrl: qr,
                    totalActiveVouchers: totalActiveVouchers ?? 0,
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 60.0,
                    maxHeight: 70.0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 0.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        border: Border(
                          bottom: BorderSide(color: AppColors.blue),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context.read<VouchersCubit>().changeScreen(0);
                              },
                              child: Text(
                                'Vouchers Using History',
                                style: AppTextStyles.defaultStyle(
                                  FontWeight.bold,
                                  11.sp,
                                  color: vouchersCubit.screen == 0
                                      ? AppColors.blue
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context.read<VouchersCubit>().changeScreen(1);
                              },
                              child: Text(
                                'Vouchers Details', // to do
                                style: AppTextStyles.defaultStyle(
                                  FontWeight.bold,
                                  11.sp,
                                  color: vouchersCubit.screen == 1
                                      ? AppColors.blue
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 2.h),
                ),
                SliverList.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 2.h,
                  ),
                  itemBuilder: vouchersCubit.screen == 0
                      ? (context, index) => VouchersUsingHistoryCard(
                            index: index,
                            vouchersUsingHistory: vouchersUsingHistory[index],
                          )
                      : (context, index) => VouchersDetailsCard(
                            index: index,
                            package: packages[index],
                          ),
                  itemCount: vouchersCubit.screen == 0
                      ? vouchersUsingHistory.length
                      : packages.length,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
