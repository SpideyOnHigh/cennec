import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/common_text_field.dart';
import 'package:flutter/cupertino.dart';

import '../../core/utils/common_import.dart';

class EditBioScreen extends StatefulWidget {
  const EditBioScreen({super.key});

  @override
  State<EditBioScreen> createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  TextEditingController bioTextEditingController = TextEditingController();

  Widget _topSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              "About yourself",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 40), // Placeholder for alignment
        ],
      ),
    );
  }

  final fomKey = GlobalKey<FormState>();

  Widget getBody() {
    return Column(
      children: [
        _topSection(),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimens.margin30).copyWith(bottom: Dimens.margin20),
            child: Form(
              key: fomKey,
              child: Column(
                children: [
                  Expanded(
                    child: CommonTextFormField(
                      label: "Write about yourself",
                      maxLength: 300,
                      maxLines: 4,
                      controller: bioTextEditingController,
                      validator: (String? val) {
                        if (val?.isEmpty ?? false) {
                          return "Please enter the bio";
                        }
                        return null;
                      },
                    ),
                  ),
                  CommonButton(
                    backgroundColor: AppColors.colorDarkBlue,
                    onTap: () {
                      if(fomKey.currentState?.validate() ??  false){
                        Navigator.pop(context, bioTextEditingController.text.trim());
                      }
                    },
                    text: "Save",
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorRoundedBgContainer,
      body: SafeArea(child: getBody()),
    );
  }
}
