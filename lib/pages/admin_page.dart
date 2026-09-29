import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_spacing.dart';
import '../core/widgets/app_header.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Product List',
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primary,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          )
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = productProvider.products;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${products.length} PRODUK DITEMUKAN',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.primary, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.s4),
                          decoration: BoxDecoration(color: AppTheme.surfaceContainerLow, borderRadius: BorderRadius.circular(AppRadius.small)),
                          child: const Icon(Icons.view_list, size: 20, color: AppTheme.primary),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        const Icon(Icons.grid_view, size: 20, color: AppTheme.outlineVariant),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                  border: Border.all(color: AppTheme.surfaceContainerHighest),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2, color: AppTheme.secondary, size: 20),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Text(
                        'Semua katalog aktif dan siap disinkronisasi.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Text('Info', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              if (products.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.outlineVariant),
                        const SizedBox(height: AppSpacing.s16),
                        Text('Katalog Produk Kosong', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.s8),
                        Text(
                          'Belum ada produk yang ditambahkan\nke tokomu. Mulai jual item pertamamu sekarang!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.s16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(AppRadius.large),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                          ]
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.s12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(AppRadius.medium),
                                    ),
                                    child: Stack(
                                      children: [
                                        if (product.imagePath != null && product.imagePath!.isNotEmpty)
                                          Positioned.fill(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(AppRadius.medium),
                                              child: Image.file(
                                                File(product.imagePath!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        else
                                          const Center(child: Icon(Icons.image, color: AppTheme.outlineVariant)),
                                        Positioned(
                                          top: 4,
                                          left: 4,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.secondaryContainer,
                                              borderRadius: BorderRadius.circular(AppRadius.full),
                                            ),
                                            child: const Text('Baru', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.s16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text('Rp ${product.price.toStringAsFixed(0)}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(color: AppTheme.surfaceContainer, borderRadius: BorderRadius.circular(AppRadius.small)),
                                              child: Text('Stok: 50', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.onSurfaceVariant)),
                                            ),
                                            const SizedBox(width: AppSpacing.s8),
                                            Text('SKU: FS001', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.outline)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20, color: AppTheme.outlineVariant),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditProductPage(product: product),
                                            ),
                                          );
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(height: AppSpacing.s16),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 20, color: AppTheme.error),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.large)),
                                              title: const Text('Hapus Produk?'),
                                              content: const Text('Tindakan ini tidak dapat dibatalkan.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(ctx),
                                                  child: const Text('Batal', style: TextStyle(color: AppTheme.outline)),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                                                  onPressed: () {
                                                    productProvider.deleteProduct(product.id!);
                                                    Navigator.pop(ctx);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text('Produk berhasil dihapus'),
                                                        behavior: SnackBarBehavior.floating,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text('Hapus'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
                              decoration: const BoxDecoration(
                                border: Border(top: BorderSide(color: AppTheme.surfaceContainerHigh)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.secondary, shape: BoxShape.circle)),
                                      const SizedBox(width: AppSpacing.s8),
                                      Text('Terlihat di Etalase', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.onSurfaceVariant)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Statistik', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.outline)),
                                      const Icon(Icons.chevron_right, size: 16, color: AppTheme.outline),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(
        title: 'Tambah Produk',
        centerTitle: true,
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primary,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: AppTheme.surfaceContainerHighest, width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppTheme.surfaceContainerLowest,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_a_photo_outlined, size: 32, color: AppTheme.primary),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text('Unggah Foto Produk', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.s8),
                  Text('Format PNG, JPG atau WEBP\n(Maksimal ukuran file 5MB)', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.outline)),
                  const SizedBox(height: AppSpacing.s16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Pilih dari Galeri', style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
                    ),
                  ),
                  if (_imageFile != null) ...[
                    const SizedBox(height: AppSpacing.s24),
                    Row(
                      children: [
                        _buildImagePreview(_imageFile!, isMain: true),
                        const SizedBox(width: 8),
                        _buildEmptyImagePreview('Foto 2'),
                        const SizedBox(width: 8),
                        _buildEmptyImagePreview('Foto 3'),
                        const SizedBox(width: 8),
                        _buildEmptyImagePreview('Foto 4'),
                      ],
                    )
                  ]
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nama Produk *', style: Theme.of(context).textTheme.labelMedium),
                Text('0/120', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.outline)),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Contoh: Jaket Parka Outdoor Scout',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel_outlined, size: 20, color: AppTheme.outline),
                  onPressed: () => _nameController.clear(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text('Harga Satuan *', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.s8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: 'Rp  ',
                prefixStyle: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.onSurface),
                hintText: '0',
                suffixIcon: Icon(Icons.sell_outlined, size: 20, color: AppTheme.outline),
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  final name = _nameController.text;
                  final price = double.tryParse(_priceController.text) ?? 0.0;

                  if (name.isNotEmpty && price > 0) {
                    context.read<ProductProvider>().addProduct(
                          name,
                          price,
                          _imageFile?.path,
                        );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Produk berhasil ditambahkan'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Nama produk dan harga harus diisi!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppTheme.error,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.publish),
                label: const Text('Simpan & Terbitkan Produk'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(File file, {bool isMain = false}) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.small),
            border: Border.all(color: AppTheme.primary, width: 2),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            )
          ),
          child: isMain ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: AppTheme.primary.withValues(alpha: 0.8),
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: const Text('Utama', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ) : null,
        ),
      ),
    );
  }

  Widget _buildEmptyImagePreview(String label) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.small),
            border: Border.all(color: AppTheme.outlineVariant, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: AppTheme.outlineVariant, size: 16),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.outlineVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toStringAsFixed(0));
    if (widget.product.imagePath != null && widget.product.imagePath!.isNotEmpty) {
      _imageFile = File(widget.product.imagePath!);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(
        title: 'Edit Produk',
        centerTitle: true,
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primary,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: AppTheme.surfaceContainerHighest, width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppTheme.surfaceContainerLowest,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_a_photo_outlined, size: 32, color: AppTheme.primary),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text('Ubah Foto Produk', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.s8),
                  Text('Format PNG, JPG atau WEBP\n(Maksimal ukuran file 5MB)', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.outline)),
                  const SizedBox(height: AppSpacing.s16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Pilih dari Galeri', style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
                    ),
                  ),
                  if (_imageFile != null) ...[
                    const SizedBox(height: AppSpacing.s24),
                    Row(
                      children: [
                        _buildImagePreview(_imageFile!, isMain: true),
                        const SizedBox(width: 8),
                        _buildEmptyImagePreview('Foto 2'),
                        const SizedBox(width: 8),
                        _buildEmptyImagePreview('Foto 3'),
                        const SizedBox(width: 8),
                        _buildEmptyImagePreview('Foto 4'),
                      ],
                    )
                  ]
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nama Produk *', style: Theme.of(context).textTheme.labelMedium),
                Text('0/120', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.outline)),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Contoh: Jaket Parka Outdoor Scout',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel_outlined, size: 20, color: AppTheme.outline),
                  onPressed: () => _nameController.clear(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text('Harga Satuan *', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.s8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: 'Rp  ',
                prefixStyle: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.onSurface),
                hintText: '0',
                suffixIcon: Icon(Icons.sell_outlined, size: 20, color: AppTheme.outline),
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  final name = _nameController.text;
                  final price = double.tryParse(_priceController.text) ?? 0.0;

                  if (name.isNotEmpty && price > 0) {
                    context.read<ProductProvider>().updateProduct(
                          widget.product.id!,
                          name,
                          price,
                          _imageFile?.path,
                        );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Produk berhasil diperbarui'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Nama produk dan harga harus diisi!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppTheme.error,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Simpan Perubahan'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(File file, {bool isMain = false}) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.small),
            border: Border.all(color: AppTheme.primary, width: 2),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            )
          ),
          child: isMain ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: AppTheme.primary.withValues(alpha: 0.8),
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: const Text('Utama', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ) : null,
        ),
      ),
    );
  }

  Widget _buildEmptyImagePreview(String label) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.small),
            border: Border.all(color: AppTheme.outlineVariant, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: AppTheme.outlineVariant, size: 16),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.outlineVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
