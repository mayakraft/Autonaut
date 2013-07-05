//
//  IAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

// 1
#import "InAppPurchases.h"
#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

// 2
@interface InAppPurchases () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

// 3
@implementation InAppPurchases {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

+ (InAppPurchases *)sharedInstance {
    static InAppPurchases *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        sharedInstance = [[self alloc] initWithProductIdentifiers:delegate.inAppProductIdentifiers];
    });
    return sharedInstance;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    self = [super init];
    if (self != nil){
        //save the product identifiers
        _productIdentifiers = productIdentifiers;
        
        //check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString *productIdentifier in _productIdentifiers){
            BOOL purchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (purchased){
                [_purchasedProductIdentifiers addObject:productIdentifier];
            }
        }
        
        //set this object as the transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

//- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
//    
//    if ((self = [super init])) {
//        
//        // Store product identifiers
//        _productIdentifiers = productIdentifiers;
//        
//        // Check for previously purchased products
//        _purchasedProductIdentifiers = [NSMutableSet set];
//        for (NSString * productIdentifier in _productIdentifiers) {
//            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
//            if (productPurchased) {
//                [_purchasedProductIdentifiers addObject:productIdentifier];
//                NSLog(@"Previously purchased: %@", productIdentifier);
//            } else {
//                NSLog(@"Not purchased: %@", productIdentifier);
//            }
//        }
//        
//        // Add self as transaction observer
//        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//        
//    }
//    return self;
//    
//}

//-(void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler{
//    
//    NSLog(@"Request Products");
//    if (!_completionHandler) {
//        _completionHandler = [completionHandler copy];
//        
//        _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
//        _productsRequest.delegate=self;
//        [_productsRequest start];
//    }else{
//        NSLog(@"Duplicate call, not requesting products this time");
//    }
//}

//- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
//    
//    // 1
//    _completionHandler = [completionHandler copy];
//    
//    // 2
//    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
//    _productsRequest.delegate = self;
//    [_productsRequest start];
//}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

#pragma mark - SKProductsRequestDelegate

//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    
//    NSLog(@"Loaded list of products...");
//    _productsRequest = nil;
//    
//    NSLog(@"Response.Products: %@",response.products);
//    
//    NSArray * skProducts = response.products;
//    for (SKProduct * skProduct in skProducts) {
//        NSLog(@"Found product: %@ %@ %0.2f",
//              skProduct.productIdentifier,
//              skProduct.localizedTitle,
//              skProduct.price.floatValue);
//    }
//    
//    _completionHandler(YES, skProducts);
//    _completionHandler = nil;
//    
//}

//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
//    
//    NSLog(@"Failed to load list of products.");
//    _productsRequest = nil;
//    
//    _completionHandler(NO, nil);
//    _completionHandler = nil;
//    
//}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end