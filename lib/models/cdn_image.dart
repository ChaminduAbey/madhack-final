class CdnImage {
  final String url;
  final String blurhash;

  CdnImage({
    required this.url,
    required this.blurhash,
  });

  // from firebase document
  factory CdnImage.fromDocument(Map<String, dynamic> data) {
    return CdnImage(
      url: data['url'],
      blurhash: data['blurhash'],
    );
  }

  // to firebase document
  Map<String, dynamic> toDocument() {
    return {
      'url': url,
      'blurhash': blurhash,
    };
  }
}
