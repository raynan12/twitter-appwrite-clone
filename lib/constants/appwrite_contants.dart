class AppWriteConstants {
  static const String databaseId = '64fe0ca6e08fa291cdcf';
  static const String projectId = '64fced6d665b79b540c8';
  static const String endPoint = 'http://SEU IP/v1';

  static const String userCollection = '6505b87f762f60bbe710';
  static const String tweetsCollection = '65063e3921fca5e03f5f';
  static const String notificationCollection = '6519f4deb4b95b079382';

  static const String imagesBucket = '650789f8abb226b7cbfe';

  static String imageUrl(String imageId) => 
    '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin'; 

}