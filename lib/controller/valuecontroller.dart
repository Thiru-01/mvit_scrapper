import 'dart:convert';
import 'package:est/constant.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

Excel sheet = Excel.createExcel();

class ValueController extends GetxController {
  Rx<TextEditingController> controller = TextEditingController().obs;
  Rx<TextEditingController> pathcontroller =
      TextEditingController(text: defPath).obs;
  Rx<RangeValues> values = const RangeValues(601, 705).obs;
  RxList sem = [1, 2, 3, 4, 5, 6, 7, 8].obs;
  RxList studentInfo = [].obs;
  RxBool flag = false.obs;
  RxBool endFlag = false.obs;
  int counts = 1;
  RxInt semValue = 1.obs;
  List<Widget> widgetList = [];
  Stream<List<String>> getMarks() async* {
    var initialData = ["RegNo", "Name"];
    int flag = 1;
    for (int i = values.value.start.toInt() + 1;
        i < values.value.end.toInt() + 2;
        i++) {
      studentInfo = [].obs;
      Uri url = Uri.parse(
          "http://exam.pondiuni.edu.in//results//app.php?a=DisplayStudentResult&r=${controller.value.text}0$i&e=${semData[semValue.value - 1]}&ct=");

      yield* Stream.fromFuture(http.get(url)).asyncMap((res) {
        if (res.statusCode == 200 &&
            jsonDecode(res.body)["data"]["html"] !=
                "Invalid Register number / No Results found") {
          counts++;
          var data = jsonDecode(res.body)["data"]["html"];
          var dox = parse(data);
          dox
              .getElementById("student_info")
              ?.text
              .split("\n")
              .forEach((element) {
            if (element != '') {
              studentInfo.add(element.trim());
            }
          });
          var grade = [
            studentInfo[1].toString().split("Reg. No. : ")[1].trim(),
            studentInfo[2].toString().split("Name of the Student : ")[1].trim()
          ];
          int count = 1;
          for (var tags
              in dox.getElementsByClassName("tbl_row1, tbl_row_alter1")) {
            if (count == 2 || count == 7) {
              tags.text.length == 1 || tags.text == "Fail"
                  ? grade.add(tags.text)
                  : initialData.length != 11
                      ? initialData.add(tags.text)
                      : initialData.length == 11 && flag == 1
                          ? {
                              flag = 0,
                              sheet.insertRowIterables("sheet1", initialData, 0)
                            }
                          : null;
              if (count == 7) {
                count = 1;
                continue;
              }
            }
            count++;
          }

          return grade;
        }

        return [];
      });
    }
    endFlag.value = true;
  }
}
