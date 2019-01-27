import 'Snapshot.dart';

class Social{
  String facebook, instagram, whatsApp, link;

  Social(this.facebook, this.instagram, this.whatsApp, this.link);

  Social.fromDB(Snapshot snapshot){
    facebook = snapshot.getData('facebook');
    instagram = snapshot.getData('instagram');
    whatsApp = snapshot.getData('whatsapp');
    link = snapshot.getData('link');
  }

  Map<String, dynamic> toJson() => {
    'facebook': facebook,
    'whatsapp': whatsApp,
    'instagram': instagram,
    'link': link
  };

}