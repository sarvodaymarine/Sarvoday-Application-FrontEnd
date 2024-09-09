class ImageConfig {
  String? _imageName;
  int? _imageCount;
  List<String>? _imageUrlLink;

  ImageConfig({
    String? imageName,
    int? imageCount,
    List<String>? imageUrlLink,
  }) {
    _imageName = imageName;
    _imageCount = imageCount;
    _imageUrlLink = imageUrlLink ?? [];
  }

  ImageConfig.fromJson(Map<String, dynamic> json) {
    _imageName = json['imageName'];
    _imageCount = json['imageCount'];
    _imageUrlLink = List<String>.from(json['imageUrlLink'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageName'] = _imageName;
    map['imageCount'] = _imageCount;
    map['imageUrlLink'] = _imageUrlLink;
    return map;
  }

  ImageConfig copyWith({
    String? imageName,
    int? imageCount,
    List<String>? imageUrlLink,
  }) {
    return ImageConfig(
      imageName: imageName ?? _imageName,
      imageCount: imageCount ?? _imageCount,
      imageUrlLink: imageUrlLink ?? _imageUrlLink,
    );
  }

  String? get imageName => _imageName;

  int? get imageCount => _imageCount;

  List<String>? get imageUrlLink => _imageUrlLink;

  void addImageUrl(String url) {
    _imageUrlLink ??= [];
    if (_imageUrlLink!.length < (_imageCount ?? 0)) {
      _imageUrlLink!.add(url);
    } else {
      throw Exception("Cannot add more URLs than the image count");
    }
  }
}

class ContainerImageModel {
  String? _imageName;
  String? _imageId;
  String? _imageUrlLink;

  ContainerImageModel({
    String? imageName,
    String? imageId,
    String? imageUrlLink,
  }) {
    _imageName = imageName;
    _imageId = imageId;
    _imageUrlLink = imageUrlLink ?? "";
  }

  ContainerImageModel.fromJson(Map<String, dynamic> json) {
    _imageName = json['imageName'] ?? "";
    _imageId = json['imageId'];
    _imageUrlLink = json['imageUrlLink'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageName'] = _imageName;
    map['imageCount'] = _imageId;
    map['imageUrlLink'] = _imageUrlLink;
    return map;
  }

  ContainerImageModel copyWith({
    String? imageName,
    String? imageId,
    String? imageUrlLink,
  }) {
    return ContainerImageModel(
      imageName: imageName ?? _imageName,
      imageId: imageId ?? _imageId,
      imageUrlLink: imageUrlLink ?? _imageUrlLink,
    );
  }

  String? get imageName => _imageName;

  String? get imageId => _imageId;

  String? get imageUrlLink => _imageUrlLink;
}
