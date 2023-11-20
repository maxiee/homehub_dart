import 'package:minio/minio.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Application {
  Application(
      {required this.appName,
      required String mongoUri,
      required String minioEndpoint,
      required String accessKey,
      required String secretKey,
      bool secure = true}) {
    mongoClient = Db(_fullMongoUri(appName, mongoUri));
    minioClient = Minio(
      endPoint: minioEndpoint,
      accessKey: accessKey,
      secretKey: secretKey,
      useSSL: secure,
    );
    mongoClient.open(secure: secure);
  }

  final String appName;
  late Db mongoClient;
  late Minio minioClient;

  DbCollection getCollection(String collectionName) {
    return mongoClient.collection("${appName}_$collectionName");
  }

  Future<Map<String, dynamic>> insertDocument(
      String collectionName, Map<String, dynamic> document) async {
    return await getCollection(collectionName).insert(document);
  }

  String _fullMongoUri(String appName, String mongoUri) {
    if (mongoUri.endsWith('/')) {
      return mongoUri + appName;
    } else {
      return mongoUri + '/' + appName;
    }
  }
}
