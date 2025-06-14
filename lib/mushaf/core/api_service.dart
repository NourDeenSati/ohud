import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ohud/mushaf/modules/note.dart';
import 'package:ohud/themes/custom_exception.dart';
import 'package:ohud/utils/EndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/error_codes.dart';

class ApiService {
  static Future<List> getDetails({
    required int pageNumber,
    required String studentId,
  }) async {
    if (pageNumber > 604 || pageNumber < 1) {
      throw CustomException(ErrorCodes.outOfRange);
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") == null) {
      throw CustomException(ErrorCodes.userIsNotRegestired);
    }
    String token = prefs.getString("token")!;
    var response = await http.get(
      Uri.parse(
        APIEndpoints.baseUrl +
            APIEndpoints.mushafEndPoints.getDetails(
              studentId: studentId,
              pageNumber: pageNumber,
            ),
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept':'application/json'
      },
    );
    print("YYYYYYYYYYYYYYYYYYYYYYYYYYYy");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map body = jsonDecode(response.body);
      if (body["details"][0]["status"] != "can") {
        if (body["details"][0]["reason"] != "already_in_current") {
          throw CustomException(ErrorCodes.cannotListenThisPage);
        } else {
          throw CustomException(ErrorCodes.orderToReListenThisPage);
        }
      } else {
        print(body);
        return body["details"][0]["recitations"];
      }
    } else {
      throw CustomException(ErrorCodes.noInternetConnection);
    }
  }

  static Future<void> saveNotes({
    required int pageNumber,
    required List<Note> notes,
    required String studentId,
    required bool isOneTest,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") == null) {
      throw CustomException(ErrorCodes.userIsNotRegestired);
    }
    String token = prefs.getString("token")!;

    var response = await http.post(
      Uri.parse(APIEndpoints.baseUrl + APIEndpoints.mushafEndPoints.saveNotes),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept':'application/json'

      },
      body: jsonEncode({
        "student_id": studentId,
        "page": pageNumber,
        "mistakes": Note.getObjectList(notes, isOneTest),
      }),
    );
    print(response.statusCode);
    print({
        "student_id": studentId,
        "page": pageNumber,
        "mistakes": Note.getObjectList(notes, isOneTest),
  });
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      throw CustomException(ErrorCodes.noInternetConnection);
    }
  }
}
