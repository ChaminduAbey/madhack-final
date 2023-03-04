class ApiEndpoints {
  static String getProfile({required String uid}) {
    return "profiles/$uid";
  }

  static String getUniversities() {
    return "universities/";
  }

  static String getProperty({required String propertyId}) {
    return "rooms/$propertyId";
  }

  static String getProperties() {
    return "rooms/";
  }

  static String getProfiles() {
    return "profiles/";
  }
}
