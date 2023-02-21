import 'package:flutter/material.dart';

const politicasDePrivacidade = "https://flossyyuri.com/main/termos";
const APP_URL =
    "https://play.google.com/store/apps/details?id=mz.co.chillstudio.codigo_de_estrada_mz";

//Configuracoes
const pagePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);

showSnackBar(BuildContext context, String mensagem, Color cor,
    {SnackBarAction action}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensagem,
        style:
            TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: branco),
      ),
      backgroundColor: cor,
      duration: Duration(seconds: 2),
      action: action != null ? action : null,
    ),
  );
}

// Cores Solidas;
const preto = Colors.black;
const branco = Colors.white;
const transparente = Colors.transparent;
// const mainBG = Color.fromRGBO(238, 66, 102, 1);
const mainBG = Color(0xFF3D3963);
const secBG = Color(0xFF434273);
const lightBG = Color(0xFF736AB7);
const darkblue = Color(0xFF137BE1);
const lightblue = Color(0xFF199AFF);
const darkred = Color(0xFFD34641);
const lightred = Color(0xFFF45D44);
const lightgreen = Color(0xFF0ACE87);
const darkgreen = Color(0xFF05A76F);
// const mainBG = Color.fromRGBO(2, 119, 189, 1);
// const mainBG = Color.fromRGBO(13, 71, 161, 1);
const mainColor1 = Color.fromRGBO(29, 38, 113, 1);
const mainColor2 = Color.fromRGBO(194, 54, 99, 1);
const warningBG = Color.fromRGBO(235, 117, 7, 1);

// Gradientes
const mainGrad = LinearGradient(
  colors: [Color.fromRGBO(195, 55, 100, 1), Color.fromRGBO(29, 38, 113, 1)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
const questGrad3 = LinearGradient(
  colors: [
    Color.fromRGBO(195, 55, 100, 1),
    Color.fromRGBO(29, 38, 113, 1),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

//ADS INFO
String getAppId() {
  return 'ca-app-pub-7627687887475703~9931353819';
}

String getBannerAdUnitId() {
  // return BannerAd.testAdUnitId;
  return 'ca-app-pub-7627687887475703/5992108804';
}

String getRewardedVideoAdUnitId() {
  // return RewardedVideoAd.testAdUnitId;
  return 'ca-app-pub-7627687887475703/7105981552';
}

String getIntersticialAdUnitId() {
  // return InterstitialAd.testAdUnitId;
  return 'ca-app-pub-7627687887475703/7250663236';
}

// const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//   childDirected: false,
//   keywords: [
//     "MOZAMBIQUE",
//     "Mobile Games",
//     "Mobile APPS",
//     "GEARBEST",
//     "ALIEXPRESS",
//     "ONLINE SHOPPING",
//     "YOUTUBE",
//     "Driving School",
//     "Social Media",
//   ],
// );
