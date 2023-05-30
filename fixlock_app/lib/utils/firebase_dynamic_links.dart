//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class FirebaseDynamicLinkService{

  static Future<String> createDynamicLink(bool  short, int id) async{
    String _linkMessage;

    /*final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://sudoesteservicos.page.link',
      link: Uri.parse('https://sudoesteservicos.com/promotion?id=$id'),
      androidParameters: const AndroidParameters(
        packageName: 'br.com.megasoftware.sudoesteservicos',
        minimumVersion: 125,
      ),
      // iOS application details needed for opening correct app on device/App Store
      iosParameters: const IOSParameters(
      bundleId: "",
      minimumVersion: '2',
    ),
    );

    final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri uri = shortDynamicLink.shortUrl;

    _linkMessage = uri.toString();
    return _linkMessage;*/
    return "";
  }

  static Future<void> initDynamicLink(BuildContext context)async {
    /*FirebaseDynamicLinks.instance.onLink;

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();

    try{
      final Uri? deepLink = data?.link;
      bool? isStory = deepLink?.pathSegments.contains('promotion');
      if(isStory != null){
        if(isStory) {
          String? id = deepLink?.queryParameters['id'];

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              PromotionScreen(promotionId: id)
          ));
        }
        // try{
        //   await firebaseFirestore.collection('Stories').doc(id).get()
        //       .then((snapshot) {
        //     StoryData storyData = StoryData.fromSnapshot(snapshot);
        //
        //     return Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //         StoryPage(story: storyData,)
        //     ));
        //   });
        // }catch(e){
        //   print(e);
        // }
      }
    }catch(e){
      print('No deepLink found');
    }*/
  }
}