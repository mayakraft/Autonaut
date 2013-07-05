//
//  InAppPurchases.h
//  Autonaut
//
//  Created by Robby on 6/11/13.
//  Copyright (c) 2013 robbykraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface InAppPurchases : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (strong, nonatomic) NSString *purchaseColorsProductIdentifier;

+ (InAppPurchases *) sharedInstance;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)RequestProductsOnCompleteBlock:(RequestProductsCompletionHandler)completionHandler;

//- (void)buyProduct:(SKProduct *)product;
//- (BOOL)productPurchased:(NSString *)productIdentifier;
//- (void)restoreCompletedTransactions;
@end