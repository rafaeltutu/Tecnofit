import 'package:mobx/mobx.dart';

part 'user_store.g.dart';

class UserStore = _UserStoreBase with _$UserStore;

abstract class _UserStoreBase with Store {
  @observable
  String? token;

  @observable
  String? firstName;

  @observable
  String? lastName;

  @observable
  String? email;

  @observable
  String? avatar;

  @observable
  bool isLoggedIn = false;

  @action
  void login(String newToken) {
    token = newToken;
    isLoggedIn = true;
  }

  @action
  void setUserInfo(String firstName, String lastName, String email, String avatar) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.avatar = avatar;
  }

  @action
  void logout() {
    token = null;
    firstName = null;
    lastName = null;
    email = null;
    avatar = null;
    isLoggedIn = false;
  }
}
