import 'package:algolia/algolia.dart';
import 'package:Flowby/models/user.dart';

class AlgoliaService {
  static const String APP_ID = 'KYG4R1G5D1';
  static const String SEARCH_API_KEY = 'd778c09854324069664247708d5de6d6';

  Algolia algolia = Algolia.init(
    applicationId: APP_ID,
    apiKey: SEARCH_API_KEY,
  );

  Future<List<User>> getUsers({String searchTerm}) async {
    AlgoliaQuery query = algolia.instance.index('users');
    query = query.search(searchTerm);

    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> myhits = querySnap.hits;

    List<User> users = myhits.map((AlgoliaObjectSnapshot snap) {
      return User.fromMapAlgolia(map: snap.data);
    }).toList();
    print('algolia users: $users');
    return users;
  }
}
