import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motoboy/util/dimensions.dart';
import 'package:motoboy/util/styles.dart';
import 'package:motoboy/features/profile/controllers/profile_controller.dart';
import 'package:motoboy/features/splash/controllers/splash_controller.dart';
import 'package:motoboy/common_widgets/image_widget.dart';

class ProfileLevelWidgetWidget extends StatelessWidget {
  const ProfileLevelWidgetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Container(
        margin: const EdgeInsets.fromLTRB(
          Dimensions.paddingSizeDefault, 80,
          Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [

            /// Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ImageWidget(
                width: 60,
                height: 60,
                image:
                    '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage}/${profileController.profileInfo?.profileImage ?? ""}',
              ),
            ),

            const SizedBox(width: Dimensions.paddingSizeDefault),

            /// Nome + Level
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    '${profileController.profileInfo?.firstName ?? ''} ${profileController.profileInfo?.lastName ?? ''}',
                    style: textBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  if (Get.find<SplashController>().config!.levelStatus!)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (profileController.profileInfo != null &&
                                profileController.profileInfo!.level != null)
                            ? '${profileController.profileInfo?.level?.name}'
                            : '',
                        style: textSemiBold.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// Botão fechar
            GestureDetector(
              onTap: () =>
                  Get.find<ProfileController>().toggleDrawer(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.clear,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
