import 'package:instagram_app/models/models.dart';

abstract class BaseNotificationRepository {
  Stream<List<Future<Notif>>> getUserNotification({String userId});
}
