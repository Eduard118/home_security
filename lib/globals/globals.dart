/* Parametrii globali */

import 'package:flutter/material.dart';

// tipuri de ferestre (pentru widgeturi automat generate)
enum QwindowType {row, listW, overflowBar}

class Globals {
  static String? unicId;// identificator unic Android/ iOS

  static String appVersion = "";

  static String appName= "";

  static bool darkmode = false;
  static String? skinColor;

  static int gradientValue = 500;

  static int lastScale = 0;

  static bool viewDemo = true;
  static bool keepLog = false;

 // static late UserSettingsModel userSettingsModel;

 // static late SharedPreferences prefs;

  static int loadingCounter = 0;
  static int maxCounter = 99;

  static String messageLogin = "";


  /* Application */
  static String? pushNotificationID;

  /* Autentifcat QBS */
  static late bool autentificatQBS;
  /* Alias BD cu care s-a facut logarea in aplicatie */
  static String? qSN;

  /* Persoana */
  static String? usEmail;     // email cu care s-a logat utilizatorul
  // String idPersoana;
  // String rsrc;
  static String? usPssw;

  //static UserModel currentUser = UserModel.fromEmail('');

  static String removeSpecialChars(String? input){
    if(input == null) return "";

    input = input.replaceAll("ș", "s");
    input = input.replaceAll("ț", "t");
    input = input.replaceAll("ă", "a");
    input = input.replaceAll("î", "i");
    input = input.replaceAll("â", "a");
    input = input.replaceAll("Ș", "S");
    input = input.replaceAll("Ț", "T");
    input = input.replaceAll("Ă", "A");
    input = input.replaceAll("Î", "I");
    input = input.replaceAll("Â", "A");

    return input.trimRight();
  }

  static void setObjectFlagByKey(dynamic object, String key, bool value){
    switch (key){
      case "shouldBeShown":{
        if(object.shouldBeShown is bool) {
          object.shouldBeShown = value;
        }
      }
      break;
      case 'isVisible':{
        if(object.isVisible is bool) {
          object.isVisible = value;
        }
      }
      break;
      default: break;
    }
  }

  static String getSearchStringByKey(dynamic object, String key){
    switch (key){
      case "searchString":
        {
          return object.searchString;
        }
      case "search_string":
        {
          return object.search_string;
        }

      case "name":
        {
          return object.attachType;
        }
      default:
        {
          return "";
        }
    }
  }

  static void asyncSearchProcess(List searchList, String text, {String flagKey = "shouldBeShown", String searchStringKey = "searchString"}) {

    String val = text.trimRight();

    val = Globals.removeSpecialChars(val);

    if (val.length >= 2) {
      var listOfSearchWords = val.toUpperCase().split(RegExp('\\s+'));
      List<int> highestHits = List.filled(searchList.length, 0);
      int itemIndex = 0,
          maxHits = 0;
      for (var row in searchList) {
        setObjectFlagByKey(row, flagKey, false);
        for (String word in listOfSearchWords) {
          if (word.startsWith('+') && word.length > 1) {
            if (!getSearchStringByKey(row, searchStringKey).toUpperCase().contains(word.substring(1))) {
              //setObjectFlagByKey(row, flagKey, false);

              highestHits[itemIndex] = -1;
              break;
            }
          } else if (word.startsWith('-') && word.length > 1) {
            if (getSearchStringByKey(row, searchStringKey).toUpperCase().contains(word.substring(1))) {
              //setObjectFlagByKey(row, flagKey, false);

              highestHits[itemIndex] = -1;
              break;
            }
          } else {
            highestHits[itemIndex] += searchFunction(getSearchStringByKey(row, searchStringKey).toUpperCase(), word.toUpperCase());
          }
        }

        if (highestHits[itemIndex] > maxHits){
          maxHits = highestHits[itemIndex];
        }
        itemIndex++;
      }
      int index = 0;
      if (maxHits > 0) {
        for (var row in searchList) {
          if (highestHits[index] == maxHits){
            setObjectFlagByKey(row, flagKey, true);
          }
          index++;
        }
      }
      else {
        if (highestHits.indexWhere((element) => element == -1) == -1) {
          for (var row in searchList) {
            setObjectFlagByKey(row, flagKey, false);
          }
        }
        else {
          for (var row in searchList) {
            if (highestHits[index] == 0){
              setObjectFlagByKey(row, flagKey, true);
            }

            else {
              setObjectFlagByKey(row, flagKey, false);
            }
            index++;
          }
        }
      }

    } else {
      for (var row in searchList) {
        setObjectFlagByKey(row, flagKey, true);
      }
    }
  }

  static int searchFunction(String searchString, searchField){

    if(searchField != null){
      if((" $searchString ").contains("${" "+searchField} ")) {
        return 3;
      } else if((" $searchString").contains(" "+searchField)) return 2;
      else if(("$searchString ").contains(searchField+" ")) return 2;
      else return (searchString.contains(searchField)) ? 1 : 0;
    }
    return 0;
  }

  /* versiune program */
  static String? progVers;

  // limba selectata
  static String? language;

  static double scale = 0.75;

  // root widget
  static late var rootW;
  // root context
  static BuildContext? rootContext;

  // definitiile de culori pt.skin
  static Map<String, Color> dColor = {
    'blue': //Colors.blue
    const MaterialColor(0xff307fc2, <int, Color> {
      50:Color.fromRGBO(48, 127, 194, .2),
      100:Color.fromRGBO(48, 127, 194, .2),
      200:Color.fromRGBO(141, 185, 210, 1),
      300:Color.fromRGBO(48, 127, 194, .4),
      400:Color.fromRGBO(48, 127, 194, .5),
      500:Color.fromRGBO(48, 127, 194, .6),
      600:Color.fromRGBO(48, 127, 194, .7),
      700:Color.fromRGBO(48, 127, 194, .8),
      800:Color.fromRGBO(48, 127, 194, .9),
      900:Color.fromRGBO(48, 127, 194, 1),
    },),
    'green': const MaterialColor(0xff6aa193, <int, Color> {
      50:Color.fromRGBO(106, 161, 147, .2),
      100:Color.fromRGBO(106, 161, 147, .2),
      200:Color.fromRGBO(163, 215, 204, 1.0),
      300:Color.fromRGBO(163, 215, 204, 1.0),
      400:Color.fromRGBO(106, 161, 147, .5),
      500:Color.fromRGBO(106, 161, 147, .6),
      600:Color.fromRGBO(106, 161, 147, .7),
      700:Color.fromRGBO(106, 161, 147, .8),
      800:Color.fromRGBO(106, 161, 147, .9),
      900:Color.fromRGBO(106, 161, 147, 1),
    },),
    //'grey': Colors.grey,
    'purple': Colors.purple,
    'red': const MaterialColor(0xffc95443, <int, Color> {
      50:Color.fromRGBO(201, 84, 61, .2),
      100:Color.fromRGBO(201, 84, 61, .2),
      200:Color.fromRGBO(255, 187, 173, 1.0),
      300:Color.fromRGBO(255, 187, 173, 1.0),
      400:Color.fromRGBO(201, 84, 61, .5),
      500:Color.fromRGBO(201, 84, 61, .6),
      600:Color.fromRGBO(201, 84, 61, .7),
      700:Color.fromRGBO(201, 84, 61, .8),
      800:Color.fromRGBO(201, 84, 61, .9),
      900:Color.fromRGBO(201, 84, 61, 1.0),
    },) };


}

// operatii refresh fereastra
enum OpRefrW {
  nop,       // no operation
  waiting,   // waiting
  refresh,   // refresh
  display    // display windows
}

