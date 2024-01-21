[![](https://img.shields.io/badge/Buy%20me%20-coffee!-orange.svg?logo=buy-me-a-coffee&color=795548)](https://www.buymeacoffee.com/tommak)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE.md)
[![PRs welcome!](https://img.shields.io/badge/contributions-welcome-green.svg?style=flat)](https://github.com/gardenifi/raspirri_server/issues)  
  
# RaspirryV1 Control Android app

This app has been created to oversee the [RaspirriV1 server](https://github.com/gardenifi/raspirri_server) system through MQTT communication. Using this application, you can easily oversee and schedule irrigation activities for your garden or agricultural setup. It supports mobile phones and tablets running on Android 5 (Lollipop, API 21) and later versions. The app is developed using [Flutter](https://flutter.dev/).

## Table of Contents
- [RaspirryV1 Control Android app](#raspirryv1-control-android-app)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
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
- Compatible Android device with USB debugging enabled.
- [RaspirriV1 server](https://github.com/gardenifi/raspirri_server/tree/main) installed and configured on a Raspberry Pi.
- Internet and Bluetooth connectivity for both the mobile device and the Raspberry Pi.

## Installation
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
4. Connect your Android device to the computer and ensure it is recognized by Flutter:
```
flutter devices
```
5. Run the app
```
flutter -v -d <your-android-device-name> run
```
## About app
- App is written in **Flutter framework** using **Dart** programming language.
- App utilizes [Riverpod](https://riverpod.dev/) package to manage the state seamlessly and efficiently. Riverpod makes it easy to organize, share, and update the application's state, ensuring a smooth and maintainable development experience.
- Leverages the power of the [mqtt_client](https://pub.dev/packages/mqtt_client) package for efficient and reliable communication using the MQTT protocol. The mqtt_client package provides a simple and easy-to-use interface for integrating MQTT functionality into your Flutter app.
- Supports English and Greek language adapting automaticaly based on your device settings. Provide flexibility for easy addition of any language as it is described below.

## Configuration
The first time you open the app on your mobile device you will need to configure it.
1. First connect the app to the Raspirri1V server via **Bluetooth**.  
![viber_image_2024-01-18_20-30-14-490](https://github.com/makis73/readmeTest/assets/39548053/f4b17b5e-d37e-4c8a-92f6-62c519633fed) ![viber_image_2024-01-18_20-36-16-890](https://github.com/makis73/readmeTest/assets/39548053/9ab57735-9b21-49a4-a232-a1b95d7a0bbf) ![viber_image_2024-01-18_20-36-38-390](https://github.com/makis73/readmeTest/assets/39548053/30c5417b-5302-4cc4-bc36-507e8eac3e0f)

2. Next you must connect RaspirriV1 server with **your local Wi-Fi network**, by choosing the SSID of the Wi-Fi network and inputting the corresponding passkey.  
![viber_image_2024-01-18_21-27-55-726](https://github.com/makis73/readmeTest/assets/39548053/abc134ba-64d4-4d5c-b84a-b73e225685cf) ![viber_image_2024-01-18_21-29-07-632](https://github.com/makis73/readmeTest/assets/39548053/e8b739c3-e812-4f7d-8fbc-7f630c36b894)  
You are ready!!! Now you can use the app to control irrigation, set schedule and monitor system status.

## Usage
1. The first time you open the app, **no valves are enabled**. You may enable a valve on Raspberry Pi and select the corresponding port from the app.  
  ![viber_image_2024-01-18_21-29-53-591](https://github.com/makis73/readmeTest/assets/39548053/75c897ef-9ed0-49ce-a412-f3533bd4fcab)
2. Then you can turn on/off the valve from the toggle button or create a scheduling program for each valve.  
   ![viber_image_2024-01-18_21-30-33-940](https://github.com/makis73/readmeTest/assets/39548053/4833395d-4b94-4ee0-81a5-e7a1f8e03514)
4. To create a program just select **days**, **start time** and **duration**. You may change the name of the valve if you wish.  
   ![viber_image_2024-01-20_23-43-10-597](https://github.com/makis73/readmeTest/assets/39548053/2bf36502-29ad-4572-a22b-f1188c658fa6) ![viber_image_2024-01-18_21-31-17-449](https://github.com/makis73/readmeTest/assets/39548053/0ba6b5b1-5186-4127-8769-4df3da16bc60) ![viber_image_2024-01-18_21-31-37-169](https://github.com/makis73/readmeTest/assets/39548053/25f3d232-d1e6-4b4a-a099-5fd9739b8413) ![viber_image_2024-01-18_21-32-32-802](https://github.com/makis73/readmeTest/assets/39548053/73b34673-8e9d-4456-8a4c-d33661adb6f5)
5. You are ready!  
   ![viber_image_2024-01-18_21-33-12-276](https://github.com/makis73/readmeTest/assets/39548053/6f9f1e74-c109-4adb-9e9f-b124b7e7172f)

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
This project is licensed under the MIT License. see the LICENSE.md file for details.

## Acknowledgments
- Thanks for the icon of the app <a href="http://www.freepik.com">Designed by Stock6design / Freepik</a>
- Thanks to the Flutter and MQTT open-source communities for their valuable contributions.

## Contact
For questions or feedback, please contact Thomas Makrodimos at [tom.makrodi@gmail.com].

Happy Irrigating! 🌱💧
