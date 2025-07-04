import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../constants.dart';
import '../../screens/home/home_screen.dart';
import '../../utils/rive_utils.dart';
import '../../model/menu.dart';
import '../pages/about_screen.dart';
import '../pages/athlete_screen.dart';
import '../pages/team_screen.dart';
import '../pages/transfert_screen.dart';
import 'components/btm_nav_item.dart';
import 'components/menu_btn.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {

  Menu selectedBottonNav = bottomNavItems.first;

  late SMIBool isMenuOpenInput;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  // Sélection dynamique de la page en fonction du menu
  Widget getSelectedPage() {
    switch (selectedBottonNav.title) {
      case "Accueil":
        return HomePage();
      case "Equipes":
        return TeamsScreen();
      case "Athlètes":
        return AthletesScreen();
      case "Transferts":
        return TransfersScreen();
      case "À propos / Contact":
        return AboutScreen();
      default:
        return const HomePage();
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));

    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: getSelectedPage(), // ← Page dynamique ici
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor2.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                bottomNavItems.length,
                    (index) {
                  Menu navBar = bottomNavItems[index];
                  return BtmNavItem(
                    navBar: navBar,
                    press: () {
                      if (navBar.rive.status != null) {
                        RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                      }
                      updateSelectedBtmNav(navBar);
                    },
                    riveOnInit: (artboard) {
                      navBar.rive.status = RiveUtils.getRiveInput(
                        artboard,
                        stateMachineName: navBar.rive.stateMachineName,
                      );
                    },
                    selectedNav: selectedBottonNav,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
