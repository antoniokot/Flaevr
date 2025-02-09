import 'package:flaevr/components/charts/dataBar.dart';
import 'package:flaevr/components/charts/dataBarSubtitle.dart';
import 'package:flaevr/components/skeleton.dart';
import 'package:flaevr/models/AdditionalInformation.dart';
import 'package:flaevr/models/Ingredient.dart';
import 'package:flaevr/models/NutritionalFacts.dart';
import 'package:flaevr/models/NutritionalFactsRow.dart';
import 'package:flaevr/models/NutritionalQuantity.dart';
import 'package:flaevr/models/User.dart';
import 'package:flaevr/services/AdditionalInformationService.dart';
import 'package:flaevr/utils/nutritionalCalculator.dart';
import 'package:flaevr/utils/sessionManager.dart';
import 'package:flaevr/utils/styles.dart';
import 'package:flaevr/utils/warnings.dart';
import 'package:flutter/material.dart';

import 'ingredientTile.dart';

class NutriData extends StatelessWidget {
  NutriData(
      {required this.ingredients,
      required this.nutritionalFacts,
      required this.dataBarSize,
      required this.user});

  final NutritionalFacts nutritionalFacts;
  final List<Ingredient> ingredients;
  final double dataBarSize;
  final User? user;

  double lookForItemInNutrients(String key) {
    for (NutritionalFactsRow nutrient in nutritionalFacts.nutrients) {
      if (nutrient.nutrient.toUpperCase() == key.toUpperCase()) {
        return double.parse(
            nutrient.value.replaceAll(new RegExp(r'[^0-9\.\,]'), ''));
      }
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    const List<Color> colorsList = [
      Color(0xFF3BCCC5),
      Color(0xFFFFF634),
      Color(0xFFff3858),
    ];
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: Styles.sidePadding.add(EdgeInsets.only(top: 10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Calorias",
                        style: Styles.smallTitle,
                      ),
                      FutureBuilder<AdditionalInformation?>(
                        future: AdditionalInformationService
                            .getAdditionalInformation(this.user!.id ?? 1),
                        builder: (context, snapshot) {
                          if (snapshot.hasData)
                            return Text(
                              NutritionalCalculator.EER(
                                          snapshot.data!.age,
                                          snapshot.data!.weight,
                                          snapshot.data!.height,
                                          snapshot.data!.af,
                                          snapshot.data!.gender
                                              .substring(0, 1)
                                              .toUpperCase())
                                      .toStringAsFixed(1) +
                                  " kCal",
                              style: Styles.smallText
                                  .apply(color: Color(0xFFFF4646)),
                            );

                          return Skeleton(
                            width: 50,
                            height: 15,
                          );
                        },
                      )
                    ]),
                FutureBuilder<AdditionalInformation?>(
                  future: AdditionalInformationService.getAdditionalInformation(
                      this.user!.id ?? 1),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return DataBar(
                        padding: EdgeInsets.only(top: 10),
                        max: NutritionalCalculator.EER(
                            snapshot.data!.age,
                            snapshot.data!.weight,
                            snapshot.data!.height,
                            snapshot.data!.af,
                            snapshot.data!.gender
                                .substring(0, 1)
                                .toUpperCase()),
                        data: () {
                          try {
                            return [lookForItemInNutrients("Valor energético")];
                          } catch (e) {
                            return [200.0];
                          }
                        }(),
                        width: dataBarSize,
                      );

                    return DataBar(
                      padding: EdgeInsets.only(top: 10),
                      max: 2000.0,
                      data: () {
                        try {
                          return [lookForItemInNutrients("Valor energético")];
                        } catch (e) {
                          return [200.0];
                        }
                      }(),
                      width: dataBarSize,
                    );
                  },
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: () {
                  List<Widget> ret = [];
                  double sugar = NutritionalCalculator.toHundredGramsBase(
                      double.parse(this
                          .nutritionalFacts
                          .serving
                          .replaceAll(new RegExp(r'[^0-9\.\,]'), '')),
                      lookForItemInNutrients("Açúcares"));
                  if (sugar > 5) {
                    ret.add(IngredientTile(
                      title: Warnings.sugar[0],
                      text: "Contém " +
                          sugar.toStringAsFixed(1) +
                          "g de açucar para cada 100 gramas de produto. " +
                          Warnings.sugar[2],
                      trailingColor: Colors.red,
                    ));
                  }
                  if (sugar < 5 && sugar > 0)
                    ret.add(IngredientTile(
                      title: "Baixo em açúcar",
                      text: "Contém " +
                          sugar.toStringAsFixed(1) +
                          "g de açucar para cada 100 gramas de produto. " +
                          Warnings.sugar[2],
                      trailingColor: Colors.green,
                    ));
                  if (sugar == 0 && this.nutritionalFacts.idProduct > 0)
                    ret.add(IngredientTile(
                      title: "Zero açúcar",
                      text: Warnings.sugar[2],
                      trailingColor: Colors.green,
                    ));

                  double sodium = NutritionalCalculator.toHundredGramsBase(
                      double.parse(this
                          .nutritionalFacts
                          .serving
                          .replaceAll(new RegExp(r'[^0-9\.\,]'), '')),
                      lookForItemInNutrients("Sódio"));
                  if (sodium > 400)
                    ret.add(IngredientTile(
                      title: Warnings.sodium[0],
                      text: "Contém " +
                          sodium.toStringAsFixed(1) +
                          "g de sódio para cada 100 gramas de produto. " +
                          Warnings.sodium[2],
                      trailingColor: Colors.red,
                    ));
                  if (sodium <= 400 && sodium >= 200)
                    ret.add(IngredientTile(
                      title: "Médio em sódio",
                      text: "Contém " +
                          sodium.toStringAsFixed(1) +
                          " de sódio para cada 100 gramas de produto. " +
                          Warnings.sodium[2],
                      trailingColor: Colors.yellow,
                    ));
                  if (sodium < 200 && sodium > 0)
                    ret.add(IngredientTile(
                      title: "Baixo em sódio",
                      text: "Contém " +
                          sodium.toStringAsFixed(1) +
                          " de sódio para cada 100 gramas de produto. " +
                          Warnings.sodium[2],
                      trailingColor: Colors.green,
                    ));
                  if (sodium == 0 && this.nutritionalFacts.idProduct > 0)
                    ret.add(IngredientTile(
                      title: "Zero sódio",
                      text: Warnings.sodium[2],
                      trailingColor: Colors.green,
                    ));

                  // ret.add(IngredientTile(
                  //   title: Warnings.add[0],
                  //   text: Warnings.add[2],
                  //   imageTrailing: AssetImage(Warnings.add[1]),
                  //   trailingColor: Colors.red,
                  // ));
                  return ret;
                }(),
              )),
          Padding(
              padding: Styles.sidePadding.add(EdgeInsets.only(top: 25)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Composição calórica",
                          style: Styles.smallTitle,
                        ),
                        Text(
                          lookForItemInNutrients("Valor energético")
                                  .toString() +
                              " kCal",
                          style: Styles.smallText,
                        ),
                      ]),
                  DataBar(
                    padding: EdgeInsets.only(top: 10),
                    max: lookForItemInNutrients("Valor energético"),
                    isDataInPercentage: false,
                    data: NutritionalCalculator.caloriesPercentage(
                            lookForItemInNutrients("Valor energético"),
                            lookForItemInNutrients("Carboidratos"),
                            lookForItemInNutrients("Gorduras Totais"),
                            lookForItemInNutrients("Proteínas"))
                        .toDoubleList(),
                    width: dataBarSize,
                    colors: colorsList,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: DataBarSubtitle(
                      data: ["Carboidratos", "Gorduras", "Proteínas"],
                      colors: colorsList,
                    ),
                  )
                ],
              )),
          Padding(
              padding: Styles.sidePadding.add(EdgeInsets.only(top: 25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Composição",
                    style: Styles.smallTitle,
                    textAlign: TextAlign.start,
                  ),
                  DataBar(
                    colors: colorsList,
                    padding: EdgeInsets.only(top: 10),
                    max: this.nutritionalFacts.serving.isNotEmpty
                        ? double.parse(
                            this.nutritionalFacts.serving.replaceAll("g", ''))
                        : 100,
                    isDataInPercentage: true,
                    data: NutritionalCalculator.gramsCompositionPercentage(
                        double.parse(
                            this.nutritionalFacts.serving.replaceAll("g", '')),
                        new NutritionalQuantities(
                            carbs: lookForItemInNutrients("Carboidratos"),
                            fats: lookForItemInNutrients("Gorduras totais"),
                            proteins: lookForItemInNutrients("Proteínas"))),
                    width: dataBarSize,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: DataBarSubtitle(
                        data: ["Carboidratos", "Gorduras", "Proteínas"],
                        colors: colorsList),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
