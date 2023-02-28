import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supppro/providers/suppItem.dart';

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SuppItem suppItem = Provider.of<SuppItems>(context, listen: false)
        .currentSuppItem as SuppItem;
    final marketStatusColor = suppItem.marketStatus == 'Available'
        ? Colors.red
        : Colors.green; // set color based on marketStatus

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Text(suppItem.productName,
                style: TextStyle(
                  fontSize: 36,
                  color: Theme.of(context).colorScheme.primary,
                )
                //Theme.of(context).textTheme.headline6,
                ),
            const SizedBox(height: 8),
            Row(children: [
              _buildInfoBox(
                context,
                'Brand',
                suppItem.brandName,
              ),
              const SizedBox(width: 8),
              _buildInfoBox(context, 'Net Contents', suppItem.netContents),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              _buildInfoBox(context, 'Serving Size', suppItem.servingSize),
              const SizedBox(width: 8),
              _buildInfoBox(context, 'Product Type', suppItem.productType),
              const SizedBox(width: 8)
            ]),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoBox(
                    context, 'Supplement Form', suppItem.supplementForm),
                const SizedBox(width: 8),
                _buildInfoBox(context, 'Market Status', suppItem.marketStatus,
                    marketStatusColor),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Suggested Use',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 8),
            Text(
              suppItem.suggestedUse,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, String label, String value,
      [Color boxcolor = Colors.grey]) {
    return Container(
      decoration: BoxDecoration(
        color: boxcolor,
        //Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
