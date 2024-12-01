import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promo/Apis/network.dart';
import 'package:promo/Apis/exception_handler.dart';
import 'package:promo/Apis/urls.dart';
import 'package:promo/app/Validation/Cubit/States/qr_state.dart';
import 'package:promo/app/offers/models/offer_response.dart';

class QRCubit extends Cubit<QRState> {
  QRCubit() : super(QRInitialState());
  static QRCubit get(context) => BlocProvider.of(context);


  bool showValidate = false;

  Future<void> recciveNotifivation({required int id}) async {
    showValidate = true;
    emit(RecciveNotifivationState());
  }

  Future<void> acceptOffer({required int offerId}) async {
    emit(AcceptOfferLoadingState(offerId: offerId));
    try {
      await Network.postData(
        url: Urls.acceptOffer(id: offerId),
      );
      showValidate = false;

      emit(AcceptOfferSuccessState(offerId: offerId));
    } on DioException catch (error) {
      emit(AcceptOfferErrorState(message: exceptionsHandle(error: error)));
    } catch (error) {
      emit(AcceptOfferErrorState(message: "An error occurred :("));
    }
  }

  OfferResponse? offer;
  Future<QRState> getOffer({required int offerId}) async {
    try {
      emit(GetOfferLoodingState());

      Response response = await Network.getData(url: Urls.getOffer(offerId));

      offer = OfferResponse.fromJson(response.data['data']);
      emit(GetOfferSuccessState());

      return GetOfferSuccessState();
    } on DioException catch (error) {
      emit(GetOfferErrorState(message: exceptionsHandle(error: error)));
      return GetOfferErrorState(message: "An error ocoure");
    } catch (error) {
      emit(GetOfferErrorState(message: "An error ocour"));
      return GetOfferErrorState(message: "An error ocour");
    }
  }

  void removeOffer() {
    offer = null;
    emit(RemoveOfferState());
  }

  List<OfferResponse> offersResponse = [];
  Future<void> getValidationRequests() async {
    try {
      emit(ValidationRequestsLoadingState());

      final Response response =
          await Network.getData(url: Urls.validationRequest);
      offersResponse = List<OfferResponse>.from(
          response.data["data"].map((x) => OfferResponse.fromJson(x)));

      emit(ValidationRequestsSuccessState());
    } on DioException catch (error) {
      emit(ValidateRequestsErrorState(message: exceptionsHandle(error: error)));
    } catch (error) {
      emit(ValidateRequestsErrorState(message: "An error occurred :("));
    }
  }

  Future<void> rejectOffer({required int id}) async {
    try {
      emit(RejectOfferLoadingState(offerId: id));

      await Network.deleteData(url: Urls.rejectAnOffer(id: id));
      deleteOffer(id: id);
      emit(RejectOfferSuccessState());
    } on DioException catch (error) {
      emit(ValidateRequestsErrorState(message: exceptionsHandle(error: error)));
    } catch (error) {
      emit(ValidateRequestsErrorState(message: "An error occurred :("));
    }
  }

  void deleteOffer({required int id}) {
    for (int index = 0; index < offersResponse.length; index++) {
      if (offersResponse[index].offer.id == id) {
        offersResponse.removeAt(index);
        break;
      }
    }
  }
}
