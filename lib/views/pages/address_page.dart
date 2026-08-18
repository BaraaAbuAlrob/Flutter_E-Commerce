import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/address_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/address_cubit/address_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_app_bar.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_snack_bar.dart';
import 'package:flutter_ecommerce_app/views/widgets/main_button.dart';
import 'package:flutter_ecommerce_app/views/widgets/map_preview_painter.dart';

class AddressPage extends StatefulWidget {
  final AddressModel? initialSelectedAddress;

  const AddressPage({super.key, this.initialSelectedAddress});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final addressCubit = BlocProvider.of<AddressCubit>(context);
    addressCubit.fetchAddresses(widget.initialSelectedAddress);

    if (widget.initialSelectedAddress != null) {
      _locationController.text =
          '${widget.initialSelectedAddress!.city}, ${widget.initialSelectedAddress!.country}';
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _showAddAddressDialog(BuildContext context, AddressCubit cubit) {
    final cityController = TextEditingController();
    final countryController = TextEditingController();
    final streetController = TextEditingController();
    final titleController = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Add New Location',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: dialogFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'City *',
                    hintText: 'e.g. Miami',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please enter a city'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country *',
                    hintText: 'e.g. United States',
                    prefixIcon: Icon(Icons.public),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please enter a country'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(
                    labelText: 'Detailed Street (Optional)',
                    hintText: 'e.g. 123 Ocean Dr',
                    prefixIcon: Icon(Icons.home_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Label (Optional)',
                    hintText: 'e.g. Vacation Home',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (dialogFormKey.currentState!.validate()) {
                cubit.addAddress(
                  city: cityController.text,
                  country: countryController.text,
                  street: streetController.text,
                  title: titleController.text,
                );
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AddressCubit>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Address',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_location_alt_outlined,
              color: AppColors.primary,
            ),
            tooltip: 'Add new address',
            onPressed: () => _showAddAddressDialog(context, cubit),
          ),
        ],
      ),
      body: BlocConsumer<AddressCubit, AddressState>(
        bloc: cubit,
        listenWhen: (previous, current) =>
            current is AddressAdded ||
            current is FailureFetchingAddresses ||
            current is AddingAddressFailed,
        listener: (context, state) {
          if (state is AddressAdded) {
            CustomSnackBar.showSuccess(
              context,
              message:
                  'Added location "${state.newAddress.city}" successfully!',
              duration: const Duration(seconds: 2),
            );
            _locationController.text =
                '${state.newAddress.city}, ${state.newAddress.country}';
          } else if (state is AddingAddressFailed) {
            CustomSnackBar.showError(context, message: state.errorMessage);
          } else if (state is FailureFetchingAddresses) {
            CustomSnackBar.showError(context, message: state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is FetchingAddresses) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is FailureFetchingAddresses) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage,
                    style: const TextStyle(color: AppColors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => cubit.fetchAddresses(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          AddressModel? selectedAddress;
          List<AddressModel> addresses = [];

          if (state is AddressesFetched) {
            addresses = state.addresses;
            selectedAddress = state.selectedAddress;
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Choose your location',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: AppColors.black87,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        // Subtitle
                        Text(
                          "Let's find your unforgettable event. Choose a location below to get started.",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey500,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        // Location Search / Input Field
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _locationController,
                            onChanged: (val) {
                              cubit.searchAddresses(val);
                            },
                            decoration: InputDecoration(
                              hintText: 'San Diego, CA',
                              hintStyle: TextStyle(
                                color: AppColors.grey400,
                                fontSize: 15,
                              ),
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                                color: AppColors.black,
                                size: 24,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.my_location_outlined,
                                  color: AppColors.grey,
                                  size: 22,
                                ),
                                onPressed: () {
                                  if (selectedAddress != null) {
                                    _locationController.text =
                                        '${selectedAddress.city}, ${selectedAddress.country}';
                                    cubit.searchAddresses('');
                                  }
                                },
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide(
                                  color: AppColors.grey300,
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(
                                  color: AppColors.red,
                                  width: 1.2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please choose or type a location';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        // Section Header
                        Text(
                          'Select location',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.black87,
                              ),
                        ),
                        const SizedBox(height: 12.0),
                        // Address list
                        if (addresses.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.location_off_outlined,
                                  size: 48,
                                  color: AppColors.grey400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No locations match your search',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: addresses.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12.0),
                            itemBuilder: (context, index) {
                              final addressItem = addresses[index];
                              final isSelected =
                                  selectedAddress?.id == addressItem.id;

                              return InkWell(
                                onTap: () {
                                  cubit.selectAddress(addressItem);
                                  _locationController.text =
                                      '${addressItem.city}, ${addressItem.country}';
                                },
                                borderRadius: BorderRadius.circular(16.0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 14.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).primaryColor.withValues(alpha: 0.04)
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : AppColors.grey300,
                                      width: isSelected ? 2.0 : 1.0,
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: Theme.of(context).primaryColor
                                              .withValues(alpha: 0.12),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        )
                                      else
                                        BoxShadow(
                                          color: AppColors.shadowSubtle,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              addressItem.city,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected
                                                    ? Theme.of(
                                                        context,
                                                      ).primaryColor
                                                    : AppColors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 6.0),
                                            Text(
                                              addressItem.subtitle,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: AppColors.grey500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      MapPreviewWidget(
                                        width: 58,
                                        height: 58,
                                        isCircular: true,
                                        pinColor:
                                            addressItem.pinColor ??
                                            const Color(0xFF00D2B4),
                                        isSelected: isSelected,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                // Sticky Confirm Button
                Container(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 12.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(color: AppColors.grey200, width: 1),
                    ),
                  ),
                  child: MainButton(
                    text: 'Confirm',
                    onTap: () {
                      if (selectedAddress != null) {
                        Navigator.of(context).pop(selectedAddress);
                      } else if (addresses.isNotEmpty) {
                        Navigator.of(context).pop(addresses.first);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
