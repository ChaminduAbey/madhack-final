class ApiEndpoints {
  static String getProfile({required String uid}) {
    return "profiles/$uid";
  }

  static String getUniversities() {
    return "universities/";
  }

  static String getRoom({required String roomId}) {
    return "rooms/$roomId";
  }

  static String getRooms() {
    return "rooms/";
  }
}
