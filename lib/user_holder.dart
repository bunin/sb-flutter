import 'models/user.dart';
import 'models/user.dart';
import 'models/user.dart';
import 'models/user.dart';
import 'models/user.dart';
import 'models/user.dart';

class UserHolder {
  Map<String, User> users = {};

  void registerUser(String name, String phone, String email) {
    User user = User(name: name, phone: phone, email: email);

    print(user.toString());

    if (users.containsKey(user.login))
      throw Exception('A user with this name already exists');

    users[user.login] = user;
  }

  User getUserByLogin(String login) {
    return users[login];
  }

  User registerUserByPhone(String name, String phone) {
    User user = User(name: name, phone: phone);
    if (users.containsKey(user.login))
      throw Exception('A user with this phone already exists');

    users[user.login] = user;
    return user;
  }

  User registerUserByEmail(String name, String email) {
    User user = User(name: name, email: email);
    if (users.containsKey(user.login))
      throw Exception('A user with this email already exists');

    users[user.login] = user;
    return user;
  }

  void setFriends(String login, List<User> friends) {
    users[login].addFriend(friends);
  }

  User findUserInFriends(String login, User friend) {
    User user = users[login];
    int i = user.friends.indexOf(friend);
    if (i < 0) throw Exception("${user.login} is not a friend of the $login");
    return user.friends.elementAt(i);
  }

  List<User> importUsers(List<String> list) {
    List<User> users = [];
    for (var item in list) {
      List<String> parts = item.trim().split(";");
      User user = User(
        name: parts[0].trim(),
        email: parts[1].trim(),
        phone: parts[2].trim(),
      );
      users.add(user);
      this.users[user.login] = user;
    }
    return users;
  }
}
