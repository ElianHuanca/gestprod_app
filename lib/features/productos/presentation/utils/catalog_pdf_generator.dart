import 'package:gestprod_app/features/categorias/domain/domain.dart';
import 'package:gestprod_app/features/productos/domain/domain.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const double _imageSize = 48;

/// Intenta cargar una imagen desde [url] para el PDF. Devuelve null si falla o la URL está vacía.
Future<pw.ImageProvider?> _loadImage(String url) async {
  final uri = url.trim();
  if (uri.isEmpty) return null;
  try {
    return await networkImage(uri);
  } catch (_) {
    return null;
  }
}

/// Genera un PDF de catálogo con productos agrupados por categoría.
/// Respeta [categoriaIdFilter]: si no es null, solo incluye productos de esa categoría.
/// Las listas en el catálogo se separan por categoría. Incluye imagen de cada producto.
Future<pw.Document> generateCatalogPdf({
  required List<Producto> productos,
  required List<Categoria> categorias,
  String? categoriaIdFilter,
}) async {
  final filtered = categoriaIdFilter == null
      ? productos
      : productos.where((p) => p.categoriaId == categoriaIdFilter).toList();

  final Map<String, List<Producto>> byCategory = {};
  for (final p in filtered) {
    byCategory.putIfAbsent(p.categoriaId, () => []).add(p);
  }

  final doc = pw.Document();
  final catOrder = categorias.map((c) => c.id).toList();

  final categoryIds = byCategory.keys.toList()
    ..sort((a, b) {
      final i = catOrder.indexOf(a);
      final j = catOrder.indexOf(b);
      if (i < 0 && j < 0) return a.compareTo(b);
      if (i < 0) return 1;
      if (j < 0) return -1;
      return i.compareTo(j);
    });

  for (final catId in categoryIds) {
    final items = byCategory[catId]!;
    final catNombre =
        categorias.where((c) => c.id == catId).map((c) => c.nombre).firstOrNull ??
            'Sin categoría';

    final imageProviders = await Future.wait(
      items.map((p) => _loadImage(p.imageUrl)),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        header: (ctx) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Text(
            'Catálogo de productos',
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColors.grey700,
            ),
          ),
        ),
        build: (ctx) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              catNombre,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            columnWidths: {
              0: const pw.FixedColumnWidth(_imageSize + 12),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text('Imagen', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text('Producto', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text('Precio', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              ...List.generate(items.length, (i) {
                final p = items[i];
                final img = imageProviders[i];
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: img != null
                          ? pw.SizedBox(
                              width: _imageSize,
                              height: _imageSize,
                              child: pw.ClipRRect(
                                horizontalRadius: 4,
                                verticalRadius: 4,
                                child: pw.Image(img, fit: pw.BoxFit.cover),
                              ),
                            )
                          : pw.SizedBox(
                              width: _imageSize,
                              height: _imageSize,
                              child: pw.Center(
                                child: pw.Text('—', style: const pw.TextStyle(fontSize: 14)),
                              ),
                            ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(p.nombre, maxLines: 2),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('\$${p.precio.toStringAsFixed(2)}'),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  if (categoryIds.isEmpty) {
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) => pw.Center(
          child: pw.Text(
            'No hay productos para mostrar en el catálogo.',
            style: const pw.TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  return doc;
}
