import 'package:music_app/imports_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  AppSettingsStorage();
  var initialRoute = await Routes.initialRoute;
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Obx(
        () => GetMaterialApp(
          translationsKeys: AppTranslation.translations,
          locale: Locale(AppSettingsStorage().retriveLanguage()),
          defaultTransition: Transition.cupertino,
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          getPages: Nav.routes,
          themeMode: Get.put(SettingsController()).selectedTheme.value ?? AppSettingsStorage().retriveTheme(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
        ),
      ),
    );
  }
}
