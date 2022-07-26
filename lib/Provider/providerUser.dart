import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:lilicourse/models/user/sharedUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user/user.dart';
import '../services/service.dart';

enum Statut {
  authenticating,
  authenticated,
  notauthenticate,
  registing,
  registed,
  notregisted,
  updating,
  updated,
  notupdated,
  deleting,
  deleted,
  notdeleted,
}

class AuthProvider extends ChangeNotifier {
  String? _token;
  User? _user;
  int? _id;
  String? _name;
  Statut _logStatus = Statut.notauthenticate;
  Statut _registerStatus = Statut.notregisted;
  Statut _deleteStatus = Statut.notdeleted;
  Statut _updateStatus = Statut.notupdated;

  String get token {
    return _token!;
  }

  bool? get isAuth {
    return _token != null;
  }

  User get user {
    return _user!;
  }

  int get id {
    return _id!;
  }

  String get name {
    return _name!;
  }

  void setUSer(User us) {
    us = _user!;
    notifyListeners();
  }

  void setToken(String tok) {
    tok = _token!;
    notifyListeners();
  }

  Statut get logStatus => _logStatus;
  set logStatus(Statut value) {
    _logStatus = value;
  }

  Statut get registerStatus => _registerStatus;
  set registerStatus(Statut value) {
    _registerStatus = value;
  }

  Statut get deleteStatus => _deleteStatus;
  set deleteStatus(Statut value) {
    _deleteStatus = value;
  }

  Statut get updateStatus => _updateStatus;
  set updateStatus(Statut value) {
    _updateStatus = value;
  }

  static Future<List<User>> getUsers() async {
    var url = Uri.parse('${Api_services.httpbaseUrl2}/lilicourse/users');
    final response = await http.get(url);

    var data = jsonDecode(response.body);
    List _temp = [];

    for (var i in data) {
      _temp.add(i);
    }
    return User.usersFromSnapshot(_temp);
  }

  Future<Map<String, dynamic>?> loginUser(String mail, String pass) async {
    print('................................................................;');
    var result;
    var urlLogin = Uri.parse(
        '${Api_services.httpbaseUrl2}/lilicourse/user/login?mail=$mail&passw=$pass');

    try {
      print('Entrer');
      _logStatus = Statut.authenticating;
      notifyListeners();
      print('Ok');
      final response = await http.get(urlLogin);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        UserPreferences.saveUserToSharePreference(data);

        _user = User.fromJson(data);
        //UserPreferences().saveUser(_user!);
        notifyListeners();
        var urlToken = Uri.parse(
            '${Api_services.httpbaseUrl2}/lilicourse/user/generate?mail=${_user!.email}');
        final responseToken = await http.post(urlToken);
        if (responseToken.statusCode == 200) {
          var data1 = jsonDecode(responseToken.body);
          _token = data1['token'];

          _logStatus = Statut.authenticated;
          UserPreferences().saveToken(_token!);
          notifyListeners();

          result = {
            "statut": true,
            "message": "User authenticated",
            "user": _user!,
            "token": _token!
          };
        } else {
          result = {"statut": true, "message": "Error token", "user": _user!};
        }
      } else {
        _logStatus = Statut.notauthenticate;
        notifyListeners();
        result = {
          "statut": false,
          "message": "User not authenticated",
          "user": _user!
        };
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<Map<String, dynamic>?> createUser(User us) async {
    var result;
    var urlCreate =
        Uri.parse('${Api_services.httpbaseUrl2}/lilicourse/user/add_user');
    Map<String, String> header = {"Content-Type": "application/json"};
    try {
      _logStatus = Statut.registing;
      notifyListeners();
      final reponse = await http.post(
        urlCreate,
        headers: header,
        body: json.encode(
          us.toJson(),
        ),
      );
      if (reponse.statusCode == 200) {
        _logStatus = Statut.registed;
        notifyListeners();
        var data = jsonDecode(reponse.body);
        UserPreferences.saveUserToSharePreference(data);
        _user = User.fromJson(data);

        //UserPreferences().saveUser(_user!);
        notifyListeners();

        loginUser(_user!.email, _user!.password);
        result = {
          "statut": true,
          "message": "User is registed",
          "user": _user!
        };
      } else {
        _logStatus = Statut.notregisted;
        notifyListeners();
        result = {
          "statut": false,
          "message": "User is not registed",
          "user": _user!
        };
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<Map<String, dynamic>?> deleteUser(User us) async {
    var urlDelete = Uri.parse('${Api_services.httpbaseUrl2}/lilicourse/user/');
    try {} catch (e) {}
  }

  Future<Map<String, dynamic>?> uploadImage(File image) async {
    var result;
    var urlImage = Uri.parse(
        '${Api_services.httpbaseUrl3}/lilicourse/user/image?file=$image');
    try {
      final responseImage = await http.post(urlImage);
      if (responseImage.statusCode == 200) {
        var data = jsonDecode(responseImage.body);
        _name = data['filename'];
        notifyListeners();
        result = {"statut": true, "message": "Image Added", "filename": _name!};
      } else {
        result = {
          "statut": false,
          "message": "Image is not registed",
          "filename": _name!
        };
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> update_User(String email, User user) async {
    var result;
    print('.............................');
    final urlId = Uri.parse(
        '${Api_services.httpbaseUrl2}/lilicourse/user/getId?mail=$email');
    final headers = {"Content-type": "application/json"};
    try {
      _logStatus = Statut.updating;
      notifyListeners();
      final responseput = await http.get(urlId);
      if (responseput.statusCode == 200) {
        var data = jsonDecode(responseput.body);
        _id = data['user_id'];
        notifyListeners();
        final urlupdate = Uri.parse(
            '${Api_services.httpbaseUrl2}/lilicourse/user/update_user?id=$_id');
        final respon = await http.put(
          urlupdate,
          headers: headers,
          body: jsonEncode(
            user.toJson(),
          ),
        );
        if (respon.statusCode == 200) {
          _logStatus = Statut.updated;
          notifyListeners();
          var data = jsonDecode(respon.body);
          _user = User.fromJson(data);
          UserPreferences.saveUserToSharePreference(data);
          //UserPreferences().saveUser(_user!);
          notifyListeners();

          result = {
            'status': true,
            'message': 'Successfully  updated',
            'user': _user
          };
        }
      } else {
        _logStatus = Statut.notupdated;
        result = {'status': false, 'message': 'Error updating'};
      }
      return result;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> tryAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool result;

    if (prefs.getString('token') == null ||
        prefs.getString('currentUser') == null) {
      print('...........NOT LOGGING..............');
      result = false;
    } else {
      var extractUser = jsonDecode(prefs.getString('currentUser')!);
      print(prefs.getString('currentUser')!);
      print(prefs.getString('token')!);
      _user = User.fromJson(extractUser);

      var extractToken = prefs.getString('token')!;
      _token = extractToken;
      notifyListeners();
      result = true;
      print('............ LOGGED..............');
    }
    return result;
  }

  Future<Map<String, dynamic>?> logOutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result;
    try {
      UserPreferences.removeUserToSharePreference();
      notifyListeners();
      if (prefs.getString('currentUser') == null &&
          prefs.getString('token') == null) {
        result = {"status": true, "message": "User removed", "user": _user};
      } else {
        result = {
          "status": false,
          "message": "User not removed",
          "user": _user
        };
      }
    } catch (e) {
      print(e);
    }
    return result;
  }
}
