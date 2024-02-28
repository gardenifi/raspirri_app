[![](https://img.shields.io/badge/Buy%20me%20-coffee!-orange.svg?logo=buy-me-a-coffee&color=795548)](https://www.buymeacoffee.com/tommak)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE.md)
[![PRs welcome!](https://img.shields.io/badge/contributions-welcome-green.svg?style=flat)](https://github.com/gardenifi/raspirri_server/issues)
![example workflow](https://github.com/gardenifi/raspirri_app/actions/workflows/tests.yaml/badge.svg)
[![codecov](https://codecov.io/gh/gardenifi/raspirri_app/graph/badge.svg?token=22D00TSRNJ)](https://codecov.io/gh/gardenifi/raspirri_app)


# RaspirryV1 Control Android app

This app has been created to oversee the [RaspirriV1 server](https://github.com/gardenifi/raspirri_server) system through MQTT communication. Using this application, you can easily oversee and schedule irrigation activities for your garden or agricultural setup. It supports mobile phones and tablets running on Android 5 (Lollipop, API 21) and later versions. The app is developed using [Flutter](https://flutter.dev/).

## Table of Contents
- [RaspirryV1 Control Android app](#raspirryv1-control-android-app)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Prerequisites](#prerequisites)
  - [Run on device](#run-on-device)
  - [Build and install an apk](#build-and-install-an-apk)
  - [About app](#about-app)
  - [Configuration](#configuration)
  - [Usage](#usage)
  - [Adding Language Support](#adding-language-support)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)
  - [Contact](#contact)

## Features

-   **Intuitive User Interface:** Enjoy a user-friendly interface that ensures effortless navigation and responsive control, catering to both phones and tablets in both portrait and landscape orientations.
-   **Seamless MQTT Integration**: Employing MQTT (Message Queuing Telemetry Transport) for communication with the Raspberry Pi-based server, the app guarantees reliable and efficient data exchange.
-   **Effortless Irrigation Control**: Take charge of your irrigation system by enabling or disabling irrigation, establishing watering schedules, and customizing parameters such as duration and frequency.
-   **Real-time System Updates**: Stay informed with real-time status updates on the irrigation system, including details like current water flow, upcoming watering times, and overall system health.
-   **Convenient Localization Setup**: The app offers default translations in English and Greek based on the device's platform locale. Additionally, it allows users to effortlessly add their preferred language for a personalized experience.

## Prerequisites
Before using the Flutter Irrigation Control App, ensure the following exist:
- [Flutter and Dart](https://docs.flutter.dev/get-started/install) are installed on your development environment.
- [Dart SDK](https://dart.dev/get-dart)
- Compatible Android device with USB debugging enabled.
- [RaspirriV1 server](https://github.com/gardenifi/raspirri_server/tree/main) installed and configured on a Raspberry Pi.
- Internet and Bluetooth connectivity for both the mobile device and the Raspberry Pi.

## Run on device
1. Clone the repository in your local machine:
```
git clone https://github.com/gardenifi/raspirri_app.git
```
2. Navigate to the project directory:
```
cd raspirri_app
```
3. Install dependencies
```
flutter pub get
```
4. Make sure flutter analyze reports no errors:
```
$ flutter analyze --suggestions

┌───────────────────────────────────────────────────────────┐
│ General Info                                              │
│ [✓] App Name: new_gardenifi_app                           │
│ [✓] Supported Platforms: android, ios, web, macos, linux, │
│ windows                                                   │
│ [✓] Is Flutter Package: yes                               │
│ [✓] Uses Material Design: yes                             │
│ [✓] Is Plugin: no                                         │
│ [✓] Java/Gradle/Android Gradle Plugin: compatible         │
│ java/gradle/agp                                           │
└───────────────────────────────────────────────────────────┘
```

5. Connect your Android device to the computer and ensure it is recognized by Flutter:
```
flutter devices
```
6. Run the app
```
flutter -v -d <your-android-device-name> run
```

## Build and install an apk
You can also build an apk and install the app to your device
1. Clone the repository in your local machine:
```
git clone https://github.com/gardenifi/raspirri_app.git
```
2. Navigate to the project directory:
```
cd raspirri_app
```
3. Install dependencies
```
flutter pub get
```
4. Run the below code:
```
flutter build apk --split-per-abi
```
This command results in three APK files:
    - raspirri_app/build/app/outputs/apk/release/app-armeabi-v7a-release.apk
    - raspirri_app/build/app/outputs/apk/release/app-arm64-v8a-release.apk
    - raspirri_app/build/app/outputs/apk/release/app-x86_64-release.apk

5. Transfer the appropriate apk (usualy v8a for newer android devices) to your device and install it. Or you can just run ``` flutter install ```


## About app
- App is written in **Flutter framework** using **Dart** programming language.
- App utilizes [Riverpod](https://riverpod.dev/) package to manage the state seamlessly and efficiently. Riverpod makes it easy to organize, share, and update the application's state, ensuring a smooth and maintainable development experience.
- Leverages the power of the [mqtt_client](https://pub.dev/packages/mqtt_client) package for efficient and reliable communication using the MQTT protocol. The mqtt_client package provides a simple and easy-to-use interface for integrating MQTT functionality into your Flutter app.
- Supports English and Greek language adapting automaticaly based on your device settings. Provide flexibility for easy addition of any language as it is described below.

## Configuration
The first time you open the app on your mobile device you will need to configure it.
1. First connect the app to the Raspirri1V server via **Bluetooth**.
<img src="https://github.com/gardenifi/raspirri_app/assets/39548053/ba91a3d0-cacd-488d-a444-8dac8d98c283" width="180" heigh="400">
<img src="https://github.com/gardenifi/raspirri_app/assets/39548053/76940407-6a08-4854-896f-d5eb60a2986f)" width="180" heigh="400">
<img src="https://github.com/gardenifi/raspirri_app/assets/39548053/81c3be6b-041a-4c25-8e27-2edb4ab36d2f](https://github.com/gardenifi/raspirri_app/assets/39548053/8385868d-c768-4b40-a0ab-3982f541099e)" width="180" heigh="400">


2. Next you must connect RaspirriV1 server with **your local Wi-Fi network**, by choosing the SSID of the Wi-Fi network and inputting the corresponding passkey.
<img src="https://github.com/gardenifi/raspirri_app/assets/39548053/383fa09e-97a0-4d76-8c35-6bd918b61e91" width="180" heigh="400">
<img src="https://github.com/gardenifi/raspirri_app/assets/39548053/c2bba894-c489-49fe-ae61-5956f9cd8b50)" width="180" heigh="400">

3. You are ready!!! Now you can use the app to control irrigation, set schedule and monitor system status.

## Usage
1. The first time you open the app, **no valves are enabled**. You may enable a valve on Raspberry Pi and select the corresponding port from the app.
   <img src="https://github.com/gardenifi/raspirri_app/assets/39548053/964d4391-7124-4a96-9d38-e052f92e727c)" width="180" heigh="400">
2. Then you can turn on/off the valve from the toggle button or create a scheduling program for each valve.
   <img src="https://github.com/gardenifi/raspirri_app/assets/39548053/3d25327a-9775-4c25-ba2a-b68d997b2e38)" width="180" heigh="400">
3. To create a program just select **days**, **start time** and **duration**. You may change the name of the valve if you wish.
   <img src="https://github.com/gardenifi/raspirri_app/assets/39548053/04e9d243-13b3-4d05-ba30-1778eafa07d1)" width="180" heigh="400">
   <img src="https://github.com/gardenifi/raspirri_app/assets/39548053/457d5ae5-290c-4b42-9014-19faa257c65d)" width="180" heigh="400">
   <img src="https://github.com/gardenifi/raspirri_app/assets/39548053/548a35e1-283d-4155-8061-f3d806f10513)" width="180" heigh="400">
   <img src="https://github.com/gardenifi/raspirri_app/assets/39548053/84571d1f-5014-48c3-ab94-a3a8a063e675)" width="180" heigh="400">
6. You are ready!
   <img src="https://github.com/gardenifi/raspirri_app/assets/39548053/a696dc30-4f0f-4c1e-9e0a-3f2f63f821fb)" width="180" heigh="400">


## Adding Language Support
We understand the importance of catering to diverse audiences. With our app, adding support for any language is a breeze. Follow these simple steps to make your app accessible to users worldwide:
1. **Open the Localizaton folder**:
   Navigate to the "localization" folder inside `lib/src`. Inside there are two `.arb` files, one for English language (`app_en.arb`) and one for Greek language (`app_el.arb`).
2. **Create a New Language File**:
   Simply create a new localization `.arb` file for the desired language. You can copy an existing file and translate the strings into the new language. You must name this file as `app_[language code].arb`. Language code must be in `ISO-639` format. You can find more details about language codes [here](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes)
3. **Generate files**:
  Now, run `flutter pub get` and codegen takes place automatically. You should find generated files in `${FLUTTER_PROJECT}/.dart_tool/flutter_gen/gen_l10n`.
  You can find more details about localization in Flutter [here](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages)

## License
This project is licensed under the MIT License. see the [LICENSE.md](https://github.com/gardenifi/raspirri_app/blob/main/LICENSE.md) file for details.

## Acknowledgments
- Thanks for the icon of the app <a href="http://www.freepik.com">Designed by Stock6design / Freepik</a>
- Thanks to the Flutter and MQTT open-source communities for their valuable contributions.

## Contact
For questions or feedback, please contact Thomas Makrodimos at [tom.makrodi@gmail.com].

Happy Irrigating! 🌱💧
