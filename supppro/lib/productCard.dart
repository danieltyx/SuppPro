import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supppro/providers/suppItem.dart';

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SuppItem _suppItem = Provider.of<SuppItems>(context, listen: false)
        .currentSuppItem as SuppItem;
    return Card(
      color: Colors.grey[200],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryText('Product Information', Colors.orange),
            SizedBox(height: 8.0),
            _buildText('Product Name', _suppItem.productName),
            _buildText('Product Type', _suppItem.productType),
            _buildText('Brand Name', _suppItem.brandName),
            _buildText('Market Status', _suppItem.marketStatus),
            _buildText('Net Contents', _suppItem.netContents),
            SizedBox(height: 16.0),
            _buildCategoryText('Supplement Facts', Colors.blue),
            SizedBox(height: 8.0),
            _buildText('Serving Size', _suppItem.servingSize),
            _buildText('Suggested Use', _suppItem.suggestedUse),
            _buildText('Supplement Form', _suppItem.supplementForm),
            SizedBox(height: 16.0),
            _buildCategoryText('Additional Information', Colors.green),
            SizedBox(height: 8.0),
            _buildText('Barcode', _suppItem.barCode),
            _buildText('DSLD ID', _suppItem.dSLDId),
            _buildText('Date Entered into DSLD', _suppItem.dateEnteredIntoDSLD),
            _buildText('URL', _suppItem.url),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryText(String text, Color color) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
  }
}
