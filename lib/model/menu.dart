import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;

  Menu({required this.title, required this.rive});
}

List<Menu> bottomNavItems = [
  Menu(
    title: "Accueil",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_Interactivity"),
  ),
  Menu(
    title: "Equipes",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "LIKE/STAR",
        stateMachineName: "STAR_Interactivity"),
  ),
  Menu(
    title: "Athlètes",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
  ),
  Menu(
    title: "Transferts",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "REFRESH/RELOAD",
        stateMachineName: "RELOAD_Interactivity"),
  ),
  Menu(
    title: "À propos / Contact",
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SETTINGS",
        stateMachineName: "SETTINGS_Interactivity"),
  ),
];
