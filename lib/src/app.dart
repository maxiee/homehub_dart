import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Application {
  Application(
      {required this.appName,
      required this.minioClient,
      required this.mongoClient}) {}

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

  Future<String> uploadFile(
      String bucketName, String objectName, String filePath) async {
    return await minioClient.fPutObject(bucketName, objectName, filePath);
  }

  String _fullMongoUri(String appName, String mongoUri) {
    if (mongoUri.endsWith('/')) {
      return mongoUri + appName;
    } else {
      return mongoUri + '/' + appName;
    }
  }
}
