import 'package:flutter/material.dart';
import '../utils/app_style.dart';
import '../widget/custom_number_input.dart';
import '../widget/textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateTask extends StatefulWidget {
  const UpdateTask({
    super.key,
  });

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController purchasePriceController = TextEditingController();
    TextEditingController sellingPriceController = TextEditingController();
    int productNumber = 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.3,
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.70,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
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
                ),
                SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  maxLine: 5,
                  hintText: 'Huile de cuisson',
                  txtController: descriptionController,
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
                      ),
                    ),
                    SizedBox(width: 10), // Ajouter un espace entre les champs
                    Expanded(
                      child: TextFieldWidget(
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
                          child: Text(AppLocalizations.of(context)!.update_btn),
                        ),
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
