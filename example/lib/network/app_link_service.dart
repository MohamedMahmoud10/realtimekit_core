import 'package:app_links/app_links.dart';
import 'package:example/models/either.dart';

class AppLinkService {
  AppLinkService._();

  final AppLinks _appLinks = AppLinks();

  static AppLinkService get instance => AppLinkService._();

  Future<Either<Unit, Uri>> getInitialLink() async {
    final initialLinkUri = await _appLinks.getInitialLink();
    if (initialLinkUri != null) {
      return right(initialLinkUri);
    }
    return left(unit);
  }

  Stream<Uri> getLinkStream() => _appLinks.uriLinkStream;
}
