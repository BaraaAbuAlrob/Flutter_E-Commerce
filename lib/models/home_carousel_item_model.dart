class HomeCarouselItemModel {
  final String id;
  final String imgUrl;

  HomeCarouselItemModel({
    required this.id,
    required this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgUrl': imgUrl,
    };
  }

  factory HomeCarouselItemModel.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return HomeCarouselItemModel(
      id: documentId.isNotEmpty ? documentId : (data['id']?.toString() ?? ''),
      imgUrl: data['imgUrl']?.toString() ??
          (data['image']?.toString() ??
              (data['banner']?.toString() ?? '')),
    );
  }
}