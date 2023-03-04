import 'package:flutter/material.dart';
import 'package:supppro/providers/suppItem.dart';

class ProductPreview extends StatelessWidget {
  SuppItem _suppItem;
  ProductPreview(this._suppItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // specify the desired width
      height: 200,
      child: Card(
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText('Product Name', _suppItem.productName),
            _buildText('Brand Name', _suppItem.brandName),
            _buildText('Barcode', _suppItem.barCode),
            _buildText('DSLD ID', _suppItem.dSLDId),
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
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 21.0,
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
