import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/interfaces/icustmors_repository.dart';
import 'package:iba/data/riverpod/custmors/custmors_state.dart';

class CustmorsNotifier extends StateNotifier<CustmorsState> {
  final IcutmorsRepository _custmorsRepository;

  CustmorsNotifier(this._custmorsRepository)
      : super(const InitalCustmorsState());

  Future<bool> getCustmors(int placeID,String search) async {
    try {
      state = const CustmorsLoadingState();
      final custmors =
          await _custmorsRepository.fatchCustmor(placeID,search, loadmore: false);
      state = CustmorsLoadedState(custmors);
      return true;
    } catch (e) {
      state = CustmorsErrorState(e.toString());
      return false;
    }
  }

  Future<bool> getCustmorsLoadMore(int placeID,String search) async {
    try {
      final custmors =
          await _custmorsRepository.fatchCustmor(placeID, search, loadmore: true);
      state = CustmorsLoadedState(custmors);
      return true;
    } catch (e) {
      state = CustmorsErrorState(e.toString());
      return false;
    }
  }
}
