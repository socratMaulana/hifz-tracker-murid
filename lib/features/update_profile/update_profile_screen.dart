import 'package:hifz_tracker/features/update_profile/update_profile_controller.dart';

import '../../core_imports.dart';

class UpdateProfileScreen extends GetView<UpdateProfileController> {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.transparent(title: 'Update Profile'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.key,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    CustomLabeledTextFormField(
                      label: 'Nama Lengkap',
                      controller: controller.fullNameCtr,
                      prefixIcon: Icons.person,
                    ),
                    CustomLabeledTextFormField(
                      label: 'Nomor Handphone',
                      controller: controller.phoneCtr,
                      prefixIcon: Icons.phone_android_outlined,
                      textInputType: TextInputType.number,
                    ),
                    CustomLabeledTextFormField(
                      label: 'Email',
                      controller: controller.emailCtr,
                      textInputType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              Obx(
                () => CustomElevatedButton(
                  text: 'Update profile',
                  onPressed: () => controller.updateProfile(),
                  borderRadius: 16,
                  isLoading: controller.isLoading.value,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
