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

#import "MPBCustomStyleSignatureViewController.h"
#import "PPSSignatureView.h"

NSString *const MPBSignatureViewBundleName = @"MPBSignatureViewResources";

@interface MPBCustomStyleSignatureViewController () <PPSSignatureViewDelegate>

@property (nonatomic, weak) UIView *viewToAdd;
@property (nonatomic, strong) PPSSignatureView *signatureViewInternal;

@end

@implementation MPBCustomStyleSignatureViewController

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithConfiguration:(MPBSignatureViewControllerConfiguration *)configuration {
    self = [super init];
    self.configuration = configuration;
    return self;
}

+ (instancetype)controllerWithConfiguration:(MPBSignatureViewControllerConfiguration *)configuration {
    id controller = [[self alloc] initWithConfiguration:configuration];
    return controller;
}

- (void)checkIfRequiredComponentsAreAvailable {
    if (self.configuration == nil) {
        [NSException raise:@"You did not supply a configuration! Assign a configuration with controller.configuration = [MPBSignatureViewControllerConfigurationWithMerchantName:(NSString *)merchantName formattedAmount:(NSString *)formattedAmount]" format:nil];
    }
    
    
    if (self.signatureView == nil) {
        [NSException raise:@"signatureView is nil! Create a UIView in your storyboard and wire it with the property 'signatureView'" format:nil];
    }
    
    if (self.cancelBlock == nil) {
        [NSException raise:@"You did not define a block for when the signature is cancelled! Assign a cancel block with controller.cancelBlock = ^(){ };" format:nil];
    }
    
    if (self.legalTextLabel == nil) {
        [NSException raise:@"legalTextLabel is nil! Create a UILabel in your storyboard and wire it with the property 'legalTextLabel'" format:nil];
    }
    
    if (self.formattedAmountLabel == nil) {
        [NSException raise:@"formattedAmountLabel is nil! Create a UILabel in your storyboard and wire it with the property 'formattedAmountLabel'" format:nil];
    }
    
    if (self.clearButton == nil) {
        [NSException raise: @"clearButton is nil! Create a UIButton in your storyboard and wire it with the property 'clearButton'" format:nil];
    }
    
    if (self.cancelButton == nil) {
        [NSException raise: @"cancelButton is nil! Create a UIButton in your storyboard and wire it with the property 'cancelButton'" format:nil];
    }
    
    if (self.continueButton == nil) {
        [NSException raise: @"continueButton is nil! Create a UIButton in your storyboard and wire it with the property 'continueButton'" format:nil];
    }
    
}


- (void) viewWillAppear:(BOOL)animated {
    [self checkIfRequiredComponentsAreAvailable];
    [self setupSignatureField];
    [self setupViews];
    [self setupTargets];
}

- (void) viewDidLayoutSubviews {
    self.signatureViewInternal.frame = self.signatureView.frame;
}

- (void)setupSignatureField {
    self.signatureViewInternal = [[PPSSignatureView alloc] initWithFrame:self.signatureView.frame context:nil];
    self.signatureViewInternal.signatureDelegate = self;
    self.signatureViewInternal.backgroundColor = self.signatureView.backgroundColor;
    // remove the original view
    [self.view insertSubview:self.signatureViewInternal belowSubview:self.signatureView];
    [self.signatureView removeFromSuperview];
    self.signatureView = self.signatureViewInternal;
}

- (NSString*) legalText {
    if (self.configuration.merchantName != nil) {
        return [NSString stringWithFormat:[self localizedString:@"MPBSignatureViewSignatureTextFormat"], self.configuration.formattedAmount, self.configuration.merchantName];
    } else {
        return [NSString stringWithFormat:[self localizedString:@"MPBSignatureViewSignatureTextFormatWithoutMerchant"], self.configuration.formattedAmount];
    }
}

- (void) setupViews {
    self.merchantNameLabel.text = self.configuration.merchantName;
    self.formattedAmountLabel.text = self.configuration.formattedAmount;
    self.legalTextLabel.text = [self legalText];
    self.merchantImageView.image = self.configuration.merchantImage;
    [self.continueButton  setTitle:[self localizedString:@"MPBSignatureViewContinue"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[self localizedString:@"MPBSignatureViewCancel"] forState:UIControlStateNormal];
    [self.clearButton setTitle:[self localizedString:@"MPBSignatureViewClear"] forState:UIControlStateNormal];
    [self disableContinueAndClearButtonsAnimated:NO];
    self.schemeImageView.image = [self imageForScheme: self.configuration.scheme];
    self.schemeImageView.contentMode = UIViewContentModeCenter;
}

- (UIImage*) imageForScheme: (MPBSignatureViewControllerConfigurationScheme) scheme {
    switch (scheme) {
        case MPBSignatureViewControllerConfigurationSchemeMaestro:
            return [self imageWithName:@"maestro_image"];
        case MPBSignatureViewControllerConfigurationSchemeMastercard:
            return [self imageWithName:@"mastercard_image"];
        case MPBSignatureViewControllerConfigurationSchemeVisa:
        case MPBSignatureViewControllerConfigurationSchemeVpay:
            return [self imageWithName:@"visacard_image"];
        case MPBSignatureViewControllerConfigurationSchemeAmex:
            return [self imageWithName:@"amex"];
        case MPBSignatureViewControllerConfigurationSchemeDinersClub:
            return [self imageWithName:@"diners_image"];
        case MPBSignatureViewControllerConfigurationSchemeDiscover:
            return [self imageWithName:@"discover_image"];
        case MPBSignatureViewControllerConfigurationSchemeJCB:
            return [self imageWithName:@"jcb_image"];
        case MPBSignatureViewControllerConfigurationSchemeUnionPay:
            return [self imageWithName:@"unionpay_image"];
        default:
            return nil;
    }
}

- (void) setupTargets {
    [self.clearButton addTarget:self action:@selector(clearSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.continueButton addTarget:self action:@selector(continueWithSignature) forControlEvents:UIControlEventTouchUpInside];
}


-(void)clearSignature {
    [self.signatureViewInternal erase];
}

- (void)continueWithSignature {
    self.continueBlock([self signature]);
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void) cancelSignature {
    self.cancelBlock();
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void) enableContinueAndClearButtons {
    self.clearButton.enabled = YES;
    self.continueButton.enabled = YES;
}

- (void) disableContinueAndClearButtonsAnimated: (BOOL) animated {
    self.clearButton.enabled = NO;
    self.continueButton.enabled = NO;
}

- (void)signatureAvailable:(BOOL)signatureAvailable {
    if (signatureAvailable) {
        [self enableContinueAndClearButtons];
    } else {
        [self disableContinueAndClearButtonsAnimated: YES];
    }
}

-(UIImage *)signature {
    return [self.signatureViewInternal signatureImage];
}

- (BOOL) shouldAutorotate {
    // we're autorotating only if the app supports landscape mode
    // else we'd get into trouble because of an exception that says 'Don't set autorotate YES if the view controller does not share orientation with the app'
    NSArray *supportedOrientations = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
    if ([supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeLeft"] || [supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeRight"]) {
        return YES;
    } else {
        return NO;
        
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    NSArray *supportedOrientations = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
    // in the special case that the app runs in landscape already, we don't want to change the orientation
    // and force the user to flip the phone.
    if (([supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeLeft"] || [supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeRight"]) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return [UIApplication sharedApplication].statusBarOrientation; // current orientation
    } else {
        return UIInterfaceOrientationLandscapeLeft;
    }
}


- (NSBundle *)resourceBundle{
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
    if (![token isEqualToString:appSpecificLocalizationString])
    {
        return appSpecificLocalizationString;
    }
    
    //second is the app localization with specific table
    NSString *appSpecificLocalizationStringFromTable = NSLocalizedStringFromTable(token, @"MPBSignatureView", @"");
    if (![token isEqualToString:appSpecificLocalizationStringFromTable])
    {
        return appSpecificLocalizationStringFromTable;
    }
    
    //third time is the charm, looking in our resource bundle
    if ([self resourceBundle])
    {
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
    if (!name) return nil;
    
    if ([self resourceBundle])
    {
        NSString *bundleImagePath = [[self resourceBundle] pathForResource:name ofType:@"tiff"];
        UIImage *bundleImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:bundleImagePath] scale:[[UIScreen mainScreen] scale]];
        if (bundleImage != nil) {
            return bundleImage;
        }
        
        bundleImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@", MPBSignatureViewBundleName, name]];
        if (bundleImage != nil) {
            return bundleImage;
        }
    }
    
    NSLog(@"could not find the resource image. please check that you added the resource bundle.");
    return nil;
}

@end
