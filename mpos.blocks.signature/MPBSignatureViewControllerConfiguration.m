//
//  MPBSignatureViewControllerConfiguration.m
//  mpos.ios.blocks.signatureview
//
//  Created by Korbinian Breu on 26/01/15.
//  Copyright (c) 2015 payworks. All rights reserved.
//

#import "MPBSignatureViewControllerConfiguration.h"

@implementation MPBSignatureViewControllerConfiguration

- (instancetype)initWithMerchantName:(NSString *)merchantName formattedAmount:(NSString *)formattedAmount {
    self = [self init];
    if (self) {
        self.merchantName = merchantName;
        self.formattedAmount = formattedAmount;
    }
    return self;
}

+ (instancetype)configurationWithMerchantName:(NSString *)merchantName formattedAmount:(NSString *)formattedAmount {
    return [[MPBSignatureViewControllerConfiguration alloc] initWithMerchantName:merchantName formattedAmount:formattedAmount];
}

@end
