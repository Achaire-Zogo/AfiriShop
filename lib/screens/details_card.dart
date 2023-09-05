import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:m_product/model/product.dart';
import '../db/localDb.dart';
import '../widget/custom_number_input.dart';
import '../widget/textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  late int productNumber;
  bool isEditable = false; // Utilisez un booléen pour gérer l'état éditable

  @override
  void initState() {
    super.initState();

    // Initialiser les contrôleurs avec les valeurs de widget.item.product.title
    titleController.text = widget.product.title;
    descriptionController.text = widget.product.description;
    purchasePriceController.text = widget.product.purchasePrice.toString();
    unitPriceController.text = widget.product.sellingPrice.toString();
    productNumber = widget.product.quantity;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.details_produit),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.3,
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.70,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: !isEditable
                    ? null
                    : Text(
                        AppLocalizations.of(context)!.update_message,
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
                hintText: 'Huile Mayor',
                txtController: titleController,
                readOnly:
                    !isEditable, // Configurez le champ en lecture seule ou éditable
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                maxLine: 5,
                hintText: 'Huile de cuisson',
                txtController: descriptionController,
                readOnly:
                    !isEditable, // Configurez le champ en lecture seule ou éditable
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      maxLine: 1,
                      hintText: AppLocalizations.of(context)!.p_price,
                      txtController: purchasePriceController,
                      readOnly: !isEditable,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      // Configurez le champ en lecture seule ou éditable
                    ),
                  ),
                  SizedBox(width: 10), // Ajouter un espace entre les champs
                  Expanded(
                    child: TextFieldWidget(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      maxLine: 1,
                      hintText: AppLocalizations.of(context)!.s_price,
                      txtController: unitPriceController,
                      readOnly:
                          !isEditable, // Configurez le champ en lecture seule ou éditable
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  if (isEditable)
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
                height: 10,
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
                        onPressed: () {
                          setState(() {
                            // Inversez l'état éditable lorsque le bouton Modifier est cliqué
                            isEditable = !isEditable;
                          });
                        },
                        child: Text(
                          isEditable
                              ? AppLocalizations.of(context)!.exit_response_non
                              : AppLocalizations.of(context)!.update_btn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: !isEditable
                          ? null
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade800,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () async {
                                if (titleController.text == '' ||
                                    descriptionController.text == '' ||
                                    purchasePriceController.text == '' ||
                                    unitPriceController.text == '') {
                                  EasyLoading.showError(
                                      AppLocalizations.of(context)!
                                          .error_all_fields,
                                      duration: Duration(seconds: 3));
                                } else {
                                  // await LocalDataBase(context).updateProduct(
                                  //     id: widget.product.id,
                                  //     productName: widget.product.title,
                                  //     descriptionProduct:
                                  //         widget.product.description,
                                  //     prixAchat: widget.product.purchasePrice,
                                  //     prixVente: widget.product.sellingPrice,
                                  //     quantite: widget.product.quantity);
                                  await LocalDataBase(context).deleteProductById(widget.product.id);

                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.update_btn,
                              ),
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
}
