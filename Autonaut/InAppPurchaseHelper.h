//
//  InAppPurchaseHelper.h
//  WordLearner
//
//  Created by Brian Love on 12/18/12.
//  Copyright (c) 2012 Webucator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "ViewController.h"

UIKIT_EXTERN NSString *const InAppPurchaseHelperProductPurchasedNotification;
typedef void(^RequestProductsOnCompleteBlock)(BOOL success, NSArray *products);

@interface InAppPurchaseHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, weak) ViewController *viewController;

+ (InAppPurchaseHelper *)sharedInstance;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithOnCompleteBock:(RequestProductsOnCompleteBlock)onCompleteBlock;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchasedWithProductIdentifier:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;

@end
