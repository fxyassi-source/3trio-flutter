import 'dart:async'; import 'package:in_app_purchase/in_app_purchase.dart';
class PremiumService {
 final store=InAppPurchase.instance;
 Stream<List<PurchaseDetails>> get purchases=>store.purchaseStream;
 Future<List<ProductDetails>> products() async { final r=await store.queryProductDetails({'premium_monthly','premium_yearly'}); return r.productDetails; }
 Future<void> buy(ProductDetails p)=>store.buyNonConsumable(purchaseParam:PurchaseParam(productDetails:p));
}