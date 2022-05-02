import 'package:iba/data/models/custmor_model.dart';

abstract class CustmorsState {
  const CustmorsState();
}

class InitalCustmorsState extends CustmorsState {
  const InitalCustmorsState();
}

class CustmorsLoadingState extends CustmorsState {
  const CustmorsLoadingState();
}

class CustmorsLoadedState extends CustmorsState {
  final List<CustmorModel>? custmorsList;
  const CustmorsLoadedState(this.custmorsList);
}

class CustmorsErrorState extends CustmorsState {
  final String message;
  const CustmorsErrorState(this.message);
}
