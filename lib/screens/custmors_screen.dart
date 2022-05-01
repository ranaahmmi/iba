import 'package:flutter/material.dart';
import 'package:iba/helper/constants.dart';
import 'package:iba/helper/style.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class CustmorsScreen extends StatefulWidget {
  const CustmorsScreen({Key? key}) : super(key: key);
  @override
  State<CustmorsScreen> createState() => _CustmorsScreenState();
}

class _CustmorsScreenState extends State<CustmorsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              child: Stack(
                children: [
                  const Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: 'Customers'.text.bold.size(14).black.makeCentered(),
                  ),
                ],
              ),
            ).px(16),
            AppTextField(
              textFieldType: TextFieldType.NAME,
              decoration: Constatnts().appInputDucoration(
                  'Search Name', AppColors.primaryColor,
                  icon: Icons.search),
            ).px(10),
            10.heightBox,
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return const CustomerCards(
                      name: 'Aslam',
                      location: 'Customer Address',
                      phone: 'Customer Phone',
                      storeName: 'Store Name',
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerCards extends StatelessWidget {
  final String name, storeName, location, phone;
  const CustomerCards({
    Key? key,
    required this.name,
    required this.storeName,
    required this.location,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 249, 252, 255),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 198, 216, 240).withOpacity(0.5),
              offset: const Offset(4, 10),
              blurRadius: 20,
            ),
          ]),
      child: Row(
        children: [
          Icon(
            Icons.person,
            size: 23,
            color: AppColors.grey,
          ).p(10).box.roundedFull.color(Colors.white).make(),
          10.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                name.text.black.bold.size(14).make(),
                5.heightBox,
                storeName.text.color(AppColors.grey).size(10).make(),
                5.heightBox,
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 20,
                    ),
                    2.widthBox,
                    location.text.gray600.size(10).make(),
                  ],
                ),
                5.heightBox,
              ],
            ),
          ),
        ],
      ).pSymmetric(h: 20, v: 10),
    );
  }
}
