import 'package:flutter/material.dart';
import 'components.dart';
import 'primitives/button.dart';
import 'primitives/input.dart';
import 'primitives/card.dart';
import 'widgets/alert.dart';
import 'widgets/avatar.dart';
import 'widgets/badge.dart';
import 'widgets/breadcrumb.dart';
import 'widgets/checkbox.dart';
import 'widgets/dialog.dart';
import 'widgets/dropdown.dart';
import 'widgets/progress.dart';
import 'widgets/tooltip.dart';

class ComponentsDemoPage extends StatefulWidget {
  const ComponentsDemoPage({super.key});

  @override
  State<ComponentsDemoPage> createState() => _ComponentsDemoPageState();
}

class _ComponentsDemoPageState extends State<ComponentsDemoPage> {
  bool _checkboxValue = false;
  List<String> _checkboxGroupValues = ['option1'];
  String? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Components Demo'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buttons section
            Text('Buttons', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                AppButton(
                  onPressed: () {},
                  child: const Text('Primary'),
                ),
                AppButton(
                  variant: ButtonVariant.secondary,
                  onPressed: () {},
                  child: const Text('Secondary'),
                ),
                AppButton(
                  variant: ButtonVariant.ghost,
                  onPressed: () {},
                  child: const Text('Ghost'),
                ),
                AppButton(
                  onPressed: () {},
                  icon: Icons.add,
                  child: const Text('With Icon'),
                ),
                AppButton(
                  onPressed: () {},
                  child: const Text('Loading'),
                  loading: true,
                ),
                AppButton(
                  onPressed: () {},
                  child: const Text('Disabled'),
                  disabled: true,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            // Inputs section
            Text('Inputs', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            AppInput(
              label: 'Name',
              placeholder: 'Enter your name',
            ),
            SizedBox(height: AppSpacing.sm),
            AppInput(
              label: 'Email',
              placeholder: 'Enter your email',
              error: 'Please enter a valid email',
            ),
            SizedBox(height: AppSpacing.sm),
            AppInput(
              label: 'Password',
              placeholder: 'Enter your password',
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.lg),

            // Cards section
            Text('Cards', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Text(
                      'This is a basic card with some content inside.',
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppCardWithHeader(
                    title: 'Card with Header',
                    subtitle: Text(
                      'Subtitle text',
                      style: AppTypography.bodySmall,
                    ),
                    actions: [
                      AppButton(
                        variant: ButtonVariant.ghost,
                        size: ButtonSize.small,
                        onPressed: () {},
                        child: const Text('Action'),
                      ),
                    ],
                    child: Text(
                      'Card content goes here...',
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            // Alerts section
            Text('Alerts', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            AppAlert(
              variant: AlertVariant.info,
              title: 'Information',
              message: 'This is an informational alert.',
            ),
            SizedBox(height: AppSpacing.sm),
            AppAlert(
              variant: AlertVariant.success,
              title: 'Success',
              message: 'Your action was completed successfully.',
            ),
            SizedBox(height: AppSpacing.sm),
            AppAlert(
              variant: AlertVariant.warning,
              title: 'Warning',
              message: 'Please review this information carefully.',
            ),
            SizedBox(height: AppSpacing.sm),
            AppAlert(
              variant: AlertVariant.error,
              title: 'Error',
              message: 'An error occurred while processing your request.',
            ),
            SizedBox(height: AppSpacing.lg),

            // Avatars section
            Text('Avatars', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                AppAvatar(
                  name: 'John Doe',
                  size: AvatarSize.xs,
                ),
                AppAvatar(
                  name: 'Jane Smith',
                  size: AvatarSize.sm,
                ),
                AppAvatar(
                  name: 'Alice Johnson',
                  size: AvatarSize.md,
                ),
                AppAvatar(
                  name: 'Bob Williams',
                  size: AvatarSize.lg,
                ),
                AppAvatar(
                  name: 'Carol Brown',
                  size: AvatarSize.xl,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            // Badges section
            Text('Badges', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                AppBadge(
                  text: 'Primary',
                  variant: BadgeVariant.primary,
                ),
                AppBadge(
                  text: 'Secondary',
                  variant: BadgeVariant.secondary,
                ),
                AppBadge(
                  text: 'Success',
                  variant: BadgeVariant.success,
                ),
                AppBadge(
                  text: 'Warning',
                  variant: BadgeVariant.warning,
                ),
                AppBadge(
                  text: 'Error',
                  variant: BadgeVariant.error,
                ),
                AppBadge(
                  text: 'Info',
                  variant: BadgeVariant.info,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            // Breadcrumbs section
            Text('Breadcrumbs', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            AppBreadcrumb(
              items: [
                BreadcrumbItem(label: 'Home'),
                BreadcrumbItem(label: 'Library'),
                BreadcrumbItem(label: 'Data'),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            // Checkboxes section
            Text('Checkboxes', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            AppCheckbox(
              value: _checkboxValue,
              onChanged: (value) {
                setState(() {
                  _checkboxValue = value ?? false;
                });
              },
              label: 'Accept terms and conditions',
            ),
            SizedBox(height: AppSpacing.sm),
            Text('Checkbox Group', style: AppTypography.h6),
            AppCheckboxGroup(
              values: _checkboxGroupValues,
              onChanged: (values) {
                setState(() {
                  _checkboxGroupValues = values;
                });
              },
              items: [
                CheckboxItem(value: 'option1', label: 'Option 1'),
                CheckboxItem(value: 'option2', label: 'Option 2'),
                CheckboxItem(value: 'option3', label: 'Option 3'),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            // Dropdown section
            Text('Dropdown', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            AppDropdown<String>(
              value: _dropdownValue,
              onChanged: (value) {
                setState(() {
                  _dropdownValue = value;
                });
              },
              items: [
                AppDropdownItem(value: 'option1', text: 'Option 1'),
                AppDropdownItem(value: 'option2', text: 'Option 2'),
                AppDropdownItem(value: 'option3', text: 'Option 3'),
              ],
              placeholder: 'Select an option',
              label: const Text('Choose an option'),
            ),
            SizedBox(height: AppSpacing.lg),

            // Progress section
            Text('Progress', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            AppProgress(value: 0.6),
            SizedBox(height: AppSpacing.sm),
            AppProgress(value: 0.4, variant: ProgressVariant.success),
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                AppCircularProgress(value: 0.7),
                SizedBox(width: AppSpacing.md),
                AppCircularProgress(value: 0.3, variant: ProgressVariant.success),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            // Tooltip section
            Text('Tooltips', style: AppTypography.h4),
            SizedBox(height: AppSpacing.sm),
            AppTooltip(
              message: 'This is a helpful tooltip',
              child: const Text(
                'Hover over me to see a tooltip',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Dialog trigger
            AppButton(
              onPressed: () {
                showAppDialog(
                  context: context,
                  title: 'Confirmation',
                  message: 'Are you sure you want to proceed with this action?',
                );
              },
              child: const Text('Show Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}