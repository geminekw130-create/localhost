import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motoboy/common_widgets/confirmation_bottomsheet_widget.dart';
import 'package:motoboy/features/html/domain/html_enum_types.dart';
import 'package:motoboy/features/profile/controllers/profile_controller.dart';
import 'package:motoboy/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:motoboy/features/ride/controllers/ride_controller.dart';
import 'package:motoboy/features/safety_setup/screens/safety_setup_screen.dart';
import 'package:motoboy/features/wallet/screens/payment_info_screen.dart';
import 'package:motoboy/util/dimensions.dart';
import 'package:motoboy/util/images.dart';
import 'package:motoboy/util/styles.dart';
import 'package:motoboy/features/auth/controllers/auth_controller.dart';
import 'package:motoboy/features/chat/screens/chat_screen.dart';
import 'package:motoboy/features/help_and_support/screens/help_and_support_screen.dart';
import 'package:motoboy/features/html/screens/policy_viewer_screen.dart';
import 'package:motoboy/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:motoboy/features/profile/screens/profile_screen.dart';
import 'package:motoboy/features/profile/widgets/profile_level_widget.dart';
import 'package:motoboy/features/review/screens/review_screen.dart';
import 'package:motoboy/features/setting/screens/setting_screen.dart';
import 'package:motoboy/features/splash/controllers/splash_controller.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {

  @override
  void initState() {
    Get.find<RideController>().updateRoute(true, notify: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.85),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const ProfileLevelWidgetWidget(),
            const SizedBox(height: 20),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [

                      _menuItem(Images.profileIcon, 'profile', ()=> Get.to(()=> const ProfileScreen())),
                      _menuItem(Images.message, 'message', ()=> Get.to(()=> const ChatScreen())),
                      _menuItem(Images.destinationIcon, 'my_reviews', ()=> Get.to(()=> const ReviewScreen())),
                      _menuItem(Images.privacyPolicy, 'safety', ()=> Get.to(()=> const SafetySetupScreen())),
                      _menuItem(Images.leaderBoardIcon, 'leader_board', ()=> Get.to(()=> const LeaderboardScreen())),

                      if((Get.find<SplashController>().config?.referralEarningStatus ?? false) ||
                          ((Get.find<ProfileController>().profileInfo?.wallet?.referralEarn ?? 0) > 0))
                        _menuItem(Images.referralIcon1, 'refer&earn', ()=> Get.to(()=> const ReferAndEarnScreen())),

                      _menuItem(Images.leaderBoardIcon, 'add_withdraw_info', ()=> Get.to(()=> const PaymentInfoScreen())),
                      _menuItem(Images.helpAndSupportIcon, 'help_and_support', ()=> Get.to(()=> const HelpAndSupportScreen())),
                      _menuItem(Images.setting, 'setting', ()=> Get.to(()=> const SettingScreen())),

                      _menuItem(Images.privacyPolicy, 'privacy_policy', (){
                        Get.to(()=> PolicyViewerScreen(
                          htmlType: HtmlType.privacyPolicy,
                          image: Get.find<SplashController>().config?.privacyPolicy?.image ?? '',
                        ));
                      }),

                      _menuItem(Images.termsAndCondition, 'terms_and_condition', (){
                        Get.to(()=> PolicyViewerScreen(
                          htmlType: HtmlType.termsAndConditions,
                          image: Get.find<SplashController>().config?.termsAndConditions?.image ?? '',
                        ));
                      }),

                      _menuItem(Images.termsAndCondition, 'refund_policy', (){
                        Get.to(()=> PolicyViewerScreen(
                          htmlType: HtmlType.refundPolicy,
                          image: Get.find<SplashController>().config?.refundPolicy?.image ?? '',
                        ));
                      }),

                      _menuItem(Images.privacyPolicy, 'legal', (){
                        Get.to(()=> PolicyViewerScreen(
                          htmlType: HtmlType.legal,
                          image: Get.find<SplashController>().config?.legal?.image ?? '',
                        ));
                      }),

                      _menuItem(Images.logOutIcon, 'logout', (){
                        Get.bottomSheet(GetBuilder<AuthController>(builder: (authController) {
                          return ConfirmationBottomsheetWidget(
                            icon: Images.exitIcon,
                            iconColor: Theme.of(context).cardColor,
                            isLoading: authController.logging,
                            title: 'logout'.tr,
                            description: 'do_you_want_to_log_out_this_account'.tr,
                            onYesPressed: ()=> authController.logOut(),
                            onNoPressed: ()=> Get.back(),
                          );
                        }));
                      }),

                      _menuItem(Images.logOutIcon, 'permanently_delete_account'.tr, (){
                        Get.bottomSheet(GetBuilder<AuthController>(builder: (authController) {
                          return ConfirmationBottomsheetWidget(
                            icon: Images.exitIcon,
                            isLoading: authController.logging,
                            iconColor: Theme.of(context).cardColor,
                            isLogOut: true,
                            title: 'delete_account'.tr,
                            description: 'permanently_delete_confirm_msg'.tr,
                            onNoPressed: ()=> Get.back(),
                            onYesPressed: ()=> authController.permanentDelete(),
                          );
                        }));
                      }),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String icon, String title, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  icon,
                  width: 22,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title.tr,
                  style: textSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
