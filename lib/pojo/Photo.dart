import 'Snapshot.dart';

class Photo {
  Photo(this.description, this.imageUrl, this.uidImage);

  String description, imageUrl, uidImage;

  Photo.fromDB(Snapshot snapshot){
    description = snapshot.getData('description');
    imageUrl = snapshot.getData('image_url');
    uidImage = snapshot.getData('uid_image');
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'image_url': imageUrl,
    'uid_image': uidImage
  };

}