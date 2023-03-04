String getChatRoomId(String a, String b) {
  if (a.compareTo(b) == 1) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
