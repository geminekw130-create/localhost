import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:motoboy/common_widgets/custom_asset_image_widget.dart';
import 'package:motoboy/localization/localization_controller.dart';
import 'package:motoboy/theme/theme_controller.dart';
import 'package:motoboy/util/dimensions.dart';
import 'package:motoboy/util/images.dart';
import 'package:motoboy/util/styles.dart';
import 'package:motoboy/features/setting/controllers/setting_controller.dart';
import 'package:motoboy/common_widgets/app_bar_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  void initState() {
    Get.find<LocalizationController>().setInitialIndex();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBarWidget(title: 'setting'.tr, regularAppbar: true),
        body: GetBuilder<SettingController>(builder: (settingController) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSize),
                    border: Border.all(color: Theme.of(context).hintColor, width: .5)
                ),
                child: Row(children: [
                  Expanded(child: ListTile(
                    title: Text('theme'.tr,style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    )),
                    leading: CustomAssetImageWidget(Images.themeLogo, width: 20, color: Theme.of(context).primaryColor),
                  )),

                  GetBuilder<ThemeController>(builder: (themeController){
                    return Padding(padding: const EdgeInsets.only(right: 8.0),
                      child: FlutterSwitch(
                        value: themeController.darkTheme,
                        onToggle: (value){
                          themeController.changeThemeSetting(value);
                        },
                        width: 60, height: 30,
                        activeIcon: Image.asset(Images.darkThemeIcon,color: Theme.of(context).primaryColor),
                        activeToggleColor: Theme.of(context).cardColor,
                        inactiveToggleColor: Theme.of(context).cardColor,
                        inactiveIcon: Image.asset(Images.lightThemeIcon, color: Theme.of(context).primaryColor, height: 60, width: 60, scale: 0.5),
                        inactiveColor: Colors.grey.withValues(alpha:0.25),
                        activeColor: Theme.of(context).primaryColor.withValues(alpha:0.25),
                      ),
                    );
                  })
                ]),
              ),
            ]),
          );
        }),
      ),
    );
  }
}
