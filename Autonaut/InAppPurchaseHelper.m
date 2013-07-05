//
//  InAppPurchaseHelper.m
//  WordLearner
//
//  Created by Brian Love on 12/18/12.
//  Copyright (c) 2012 Webucator. All rights reserved.
//

#import "InAppPurchaseHelper.h"
#import "AppDelegate.h"


@implementation InAppPurchaseHelper {
	SKProductsRequest *_productsRequest;
	RequestProductsOnCompleteBlock _onCompleteBlock;
	NSSet *_productIdentifiers;
	NSMutableSet *_purchasedProductIdentifiers;
}

@synthesize viewController;

NSString *const InAppPurchaseHelperProductPurchasedNotification = @"InAppPurchaseHelperProductPurchasedNotification";

+ (InAppPurchaseHelper *)sharedInstance {
	static InAppPurchaseHelper *sharedInstance;
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
        NSLog(@"IVARS set up: _productIdentifiers:(%@) ------- and _purchasedProductIdentifiers:(%@)",_productIdentifiers, _purchasedProductIdentifiers);
		
		//set this object as the transaction observer
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	return self;
}

- (void)requestProductsWithOnCompleteBock:(RequestProductsOnCompleteBlock)onCompleteBlock {
	//keep a copy of the onComplete block to call later
	_onCompleteBlock = [onCompleteBlock copy];
	
	//request information about in-app purchases using product identifiers
	_productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
	[_productsRequest setDelegate:self];
    NSLog(@"about to run START using: %@",_productIdentifiers);
	[_productsRequest start];
}

- (void)buyProduct:(SKProduct *)product {
	NSLog(@"Performing in-app purchase: %@", product.productIdentifier);
	//add to payment queue
	SKPayment *payment = [SKPayment paymentWithProduct:product];
	[[SKPaymentQueue defaultQueue] addPayment:payment];

	[viewController startPurchase];
}

- (BOOL)productPurchasedWithProductIdentifier:(NSString *)productIdentifier {
	return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
	NSLog(@"Completing transaction.");
	[self provideContentForProductIdentifier:transaction.payment.productIdentifier];
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [viewController finishPurchase];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
	NSLog(@"Failed transaction.");
	if (transaction.error.code != SKErrorPaymentCancelled){
		NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
	}
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [viewController finishPurchase];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
	NSLog(@"Restoring transaction.");
	[self provideContentForProductIdentifier:transaction.payment.productIdentifier];
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [viewController finishPurchase];
}

- (void)restoreCompletedTransactions {
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [viewController finishPurchase];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
	//add the product identifier to the set of purchased identifiers
	[_purchasedProductIdentifiers addObject:productIdentifier];
	
	//set the NSUserDefault value to YES
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
	[viewController finishPurchase];
    
	//send out notification that the purchase went through for the in-app product
	[[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchaseHelperProductPurchasedNotification object:productIdentifier];
}

#pragma mark - Implement SKProductsRequestDelegate protocol

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSLog(@"Received list of products.");
	for (SKProduct *product in response.products){
		NSLog(@"Found product: %@ %@ %0.2f", product.productIdentifier, product.localizedTitle, product.price.floatValue);
	}
	
	_productsRequest = nil;
	
	//call the onComplete block
	_onCompleteBlock(YES, response.products);
	_onCompleteBlock = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"Failed to load list of products, Error:%@",error.description);
	_productsRequest = nil;
	_onCompleteBlock(NO, nil);
	_onCompleteBlock = nil;
}

- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"SKProductsRequestDelegate requestDidFinish");
}

# pragma mark - Implement SKPaymentTransactionObserver protocol

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions){
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
				break;
			default:
				break;
		}
	}
}

@end
