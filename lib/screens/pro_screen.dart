import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import '../theme/game_config.dart';
import '../services/audio_service.dart';

class ProScreen extends StatefulWidget {
  final GameConfig config;
  final ZerogmarksmanAudio audio;
  const ProScreen({super.key, required this.config, required this.audio});
  @override State<ProScreen> createState() => _ProScreenState();
}
class _ProScreenState extends State<ProScreen> {
  Future<void> _buy(String productId) async {
    final resp = await InAppPurchase.instance.queryProductDetails({productId});
    if (resp.productDetails.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product not available yet — coming soon!')));
      return;
    }
    final param = PurchaseParam(productDetails: resp.productDetails.first);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }
  @override Widget build(BuildContext context) {
    final c = widget.config;
    return Scaffold(backgroundColor: c.darkColor,
      appBar: AppBar(title: const Text('Support the developer'), backgroundColor: c.primaryColor, foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('This game is fully unlocked — nothing is locked behind a purchase.',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('If you enjoy it, you can support the developer with a tip below. Tips are pure donations and unlock nothing.',
            style: TextStyle(color: Colors.white70, fontSize: 15)),
        const SizedBox(height: 20),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () { widget.audio.click(); _buy(c.coffeeId); },
          child: Text('☕ Buy me a coffee (${c.coffeeId})', style: const TextStyle(color: Colors.white))),
        OutlinedButton(onPressed: () { widget.audio.click(); _buy(c.chocolateId); },
          child: Text('🍫 Buy me a chocolate (${c.chocolateId})', style: const TextStyle(color: Colors.white))),
        const SizedBox(height: 20),
        ElevatedButton.icon(icon: const Icon(Icons.share),
          label: const Text('Share this game'),
          onPressed: () { widget.audio.click(); Share.share('Check out ${c.displayName}! ${c.tagline}'); }),
        TextButton(onPressed: () => InAppReview.instance.openStoreListing(),
          child: const Text('Rate us ⭐', style: TextStyle(color: Colors.white70))),
      ]),
    );
  }
}
