import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:m_product/model/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../db/localDb.dart';
import '../../widget/custom_number_input.dart';
import '../../widget/textfield.dart';
import '../IndexHome.dart';

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
  TextEditingController produitController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  late int productNumber;
  bool isEditable = false; // Utilisez un booléen pour gérer l'état éditable

  @override
  void initState() {
    super.initState();

    // Initialiser les contrôleurs avec les valeurs de widget.item.product.title
    produitController.text = widget.product.nomProduit;
    descriptionController.text = widget.product.description;
    purchasePriceController.text = widget.product.prixAchat.toString();
    unitPriceController.text = widget.product.prixVente.toString();
    productQuantityController.text = widget.product.quantite.toString();
    productNumber = widget.product.quantite;

    print(widget.product.id);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const GreatHome(pos: 3)),
                (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.details_produit),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1.3,
          centerTitle: false,
          leading: IconButton(onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const GreatHome(pos: 3)),
                    (route) => false);
          },icon: const Icon(Icons.backspace_outlined),),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
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
                Container(
                    alignment: Alignment.topLeft,
                    child: Text("Nom: ")),
                SizedBox(
                  height: 5,
                ),
                TextFieldWidget(
                  maxLine: 1,
                  hintText: 'Huile Mayor',
                  txtController: produitController,
                  readOnly:
                      !isEditable, // Configurez le champ en lecture seule ou éditable
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.topLeft,
                    child: Text(AppLocalizations.of(context)!.product_quantite)),
                SizedBox(
                  height: 5,
                ),
                TextFieldWidget(
                  maxLine: 1,
                  hintText: productNumber.toString(),
                  txtController: productQuantityController,
                  readOnly:
                  !isEditable, // Configurez le champ en lecture seule ou éditable
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(AppLocalizations.of(context)!.product_desc)),
                SizedBox(
                  height: 5,
                ),
                TextFieldWidget(
                  maxLine: 3,
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
                        padding: const EdgeInsets.only(bottom: 10),
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
                        padding: const EdgeInsets.only(bottom: 10),
                        child: isEditable
                            ? ElevatedButton(
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
                            if (produitController.text == '' ||
                                descriptionController.text == '' ||
                                purchasePriceController.text == '' ||
                                unitPriceController.text == '') {
                              EasyLoading.showError(
                                  AppLocalizations.of(context)!
                                      .error_all_fields,
                                  duration: Duration(seconds: 3));
                            } else {
                              LocalDataBase(context).updateProduct(
                                widget.product.id!,
                                produitController.text,
                                descriptionController.text,
                                double.parse(purchasePriceController.text),
                                double.parse(unitPriceController.text),
                                productNumber,
                                DateTime.now().toString(),
                              );

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const GreatHome(pos: 3)),
                                      (route) => false);
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.update_btn,
                          ),
                        )
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
