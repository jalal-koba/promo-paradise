import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:promo/app/Validation/Cubit/States/vouchers_states.dart';
 import 'package:promo/app/Validation/Model/vouchers_response.dart';
import 'package:promo/app/offers/models/offer_response.dart';

import '../../../../Apis/network.dart';
import '../../../../Apis/urls.dart';
import '../../Model/vouchers.dart';

class VouchersCubit extends Cubit<VouchersStates> {
  VouchersCubit() : super(VouchersInitial());
  static VouchersCubit get(context) => BlocProvider.of(context);

  String? qrUrl;
  int? totalActiveVouchers;
  List<OfferResponse> vouchersUsingHistory = [];
  List<UserPackage> packages = [];

  int screen = 0;
  void changeScreen(int toScreen) {
    if (screen != toScreen) {
      screen = toScreen;
      emit(VouchersChangeScreen());
    }
  }

  void getPackages() async {
    emit(VouchersLooding());
    try {
      final response = await Network.getData(url: Urls.getPackages);
      final vouchersResponse = VouchersResponse.fromJson(response.data);
      qrUrl = vouchersResponse.data.qr;
      totalActiveVouchers = vouchersResponse.data.totalActiveVouchers;
      vouchersUsingHistory = vouchersResponse.data.vouchersUsingHistory;
      packages = vouchersResponse.data.packages;
     

      emit(VouchersSuccess());
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'حدث خطأ ما يرجى المحاولة مرة اخرى';
      emit(VouchersError(message: message));
    }  
  }
}
