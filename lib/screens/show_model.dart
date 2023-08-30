import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_product/utils/theme.dart';

import '../widget/custom_number_input.dart';
import '../widget/textfield.dart';

class AddNewTaskModel extends StatefulWidget {
  AddNewTaskModel({
    super.key,
  });

  @override
  State<AddNewTaskModel> createState() => _AddNewTaskModelState();
}

class _AddNewTaskModelState extends State<AddNewTaskModel> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  int productNumber = 1;

  File? _image;

  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add_message),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        // height: MediaQuery.of(context).size.height * 0.70,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  AppLocalizations.of(context)!.product_add,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Divider(
                thickness: 1.2,
                color: Colors.grey.shade200,
              ),
              SizedBox(
                height: 5,
              ),
              TextFieldWidget(
                maxLine: 1,
                hintText: AppLocalizations.of(context)!.product_add,
                txtController: titleController,
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                maxLine: 5,
                hintText: AppLocalizations.of(context)!.product_desc,
                txtController: descriptionController,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                      maxLine: 1,
                      hintText: AppLocalizations.of(context)!.p_price,
                      txtController: purchasePriceController,
                    ),
                  ),
                  SizedBox(width: 10), // Ajouter un espace entre les champs
                  Expanded(
                    child: TextFieldWidget(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                      maxLine: 1,
                      hintText: AppLocalizations.of(context)!.s_price,
                      txtController: sellingPriceController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _openImagePicker,
                      child: Text(
                        AppLocalizations.of(context)!.select_image,
                        style: TextStyle(color: kblack),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kgrey,
                        foregroundColor: Colors.blue.shade800,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: kgrey,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Ajouter un espace entre les éléments
                  Flexible(
                    child: Text(
                      // _image != null ? _image!.path : 'Please select an image',
                      _image != null
                          ? _image!.path.split('/').last
                          : 'Please select an image',

                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Ajouter un espace entre les éléments

              Row(
                children: [
                  Expanded(
                    child: CustomNumberInput(
                      value: productNumber,
                      onDecrease: () {
                        setState(() {
                          if (productNumber <= 1) {
                          } else {
                            productNumber--;
                          }
                        });
                      },
                      onIncrease: () {
                        setState(() {
                          productNumber++;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade800,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: Colors.blue.shade800,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                            AppLocalizations.of(context)!.exit_response_non),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          titleController.clear();
                          descriptionController.clear();
                          print(titleController.text +
                              " lkjhjkjhjjj " +
                              descriptionController.text);
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.add_message),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      print('You have successfully selected your profile picture!');
    }
  }
}
