import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/providers/app_state.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  test("Freshly generated wordpair should not be included in favourites yet", () {
    final appState = MyAppState();

    appState.getNext();

    expect(appState.favourites.asMap().containsKey(appState.current), false);
  });
}