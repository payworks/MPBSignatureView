/*
 * Payment Signature View: http://www.payworks.com
 *
 * Copyright (c) 2015 Payworks GmbH
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "MPBSignatureViewControllerConfiguration.h"

NSString * const MPBSignatureViewBundleName = @"MPBSignatureViewResources";

@implementation MPBSignatureViewControllerConfiguration

- (instancetype)initWithFormattedAmount:(NSString *)formattedAmount {

    self = [self init];

    if (!self) {
        return nil;
    }

    self.formattedAmount = formattedAmount;
    self.legalText = [NSString stringWithFormat:[self localizedString:@"MPBSignatureViewSignatureTextFormat"], self.formattedAmount];
    self.clearButtonTitle = @"X";
    self.cancelButtonTitle = [self localizedString:@"MPBSignatureViewCancel"];
    self.continueButtonTitle = [self localizedString:@"MPBSignatureViewContinue"];

    return self;
}


- (UIImage*)imageForScheme {

    switch (self.scheme) {

        case MPBSignatureViewControllerConfigurationSchemeMaestro:
            return [self imageWithName:@"maestro_image"];

        case MPBSignatureViewControllerConfigurationSchemeMastercard:
            return [self imageWithName:@"mastercard_image"];

        case MPBSignatureViewControllerConfigurationSchemeVisa:
        case MPBSignatureViewControllerConfigurationSchemeVpay:
            return [self imageWithName:@"visacard_image"];

        case MPBSignatureViewControllerConfigurationSchemeAmex:
            return [self imageWithName:@"amex_image"];

        case MPBSignatureViewControllerConfigurationSchemeDinersClub:
            return [self imageWithName:@"diners_image"];

        case MPBSignatureViewControllerConfigurationSchemeDiscover:
            return [self imageWithName:@"discover_image"];

        case MPBSignatureViewControllerConfigurationSchemeJCB:
            return [self imageWithName:@"jcb_image"];

        case MPBSignatureViewControllerConfigurationSchemeUnionPay:
            return [self imageWithName:@"unionpay_image"];

        case MPBSignatureViewControllerConfigurationSchemeGhLink:
             return [self imageWithName:@"ghlink_image"];

        case MPBSignatureViewControllerConfigurationSchemeUnknown:
            return nil;
    }

    return nil;
}

#pragma mark - Bundle

- (NSBundle *)resourceBundle {

    static NSBundle *MPSignatureViewBundle = nil;
    static dispatch_once_t MPSignatureViewBundleOnce;
    dispatch_once(&MPSignatureViewBundleOnce, ^{
        NSString *mainBundleResourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *signatureViewBundlePath = [mainBundleResourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle", MPBSignatureViewBundleName]];
        MPSignatureViewBundle = [NSBundle bundleWithPath:signatureViewBundlePath];
        NSLog(@"bundle path: %@", signatureViewBundlePath);
    });
    return MPSignatureViewBundle;
}


- (NSString *)localizedString:(NSString *)token{
    if (!token) return @"";

    //here we check for three different occurances where it can be found

    //first up is the app localization
    NSString *appSpecificLocalizationString = NSLocalizedString(token, @"");
    if (![token isEqualToString:appSpecificLocalizationString]) {
        return appSpecificLocalizationString;
    }

    //second is the app localization with specific table
    NSString *appSpecificLocalizationStringFromTable = NSLocalizedStringFromTable(token, @"MPBSignatureView", @"");
    if (![token isEqualToString:appSpecificLocalizationStringFromTable]) {
        return appSpecificLocalizationStringFromTable;
    }

    //third time is the charm, looking in our resource bundle
    if ([self resourceBundle]) {
        NSString *bundleSpecificLocalizationString = NSLocalizedStringFromTableInBundle(token, @"MPBSignatureView", [self resourceBundle], @"");
        if (![token isEqualToString:bundleSpecificLocalizationString])
        {
            return bundleSpecificLocalizationString;
        }
    }

    //and as a fallback, we just return the token itself
    NSLog(@"could not find any localization files. please check that you added the resource bundle and/or your own localizations");
    return token;
}


- (UIImage *)imageWithName:(NSString *)name{

    if (!name) {
        return nil;
    }

    UIImage *img = [UIImage imageNamed:name inBundle:[self resourceBundle] compatibleWithTraitCollection:nil];

    if (!img) {
        NSLog(@"could not find the resource image. please check that you added the resource bundle.");
    }

    return img;
}


@end
