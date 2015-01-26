/*
 * mPOS SKD Building Blocks: http://www.payworksmobile.com
 *
 * Copyright (c) 2013 payworks GmbH
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

@interface MPBCustomStyleSignatureViewController () <PPSSignatureViewDelegate>

@property (nonatomic, weak) UIView *viewToAdd;

@property (nonatomic, strong) PPSSignatureView* signatureViewInternal;


@end

@implementation MPBCustomStyleSignatureViewController

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithConfiguration:(MPBSignatureViewControllerConfiguration*)configuration {
    self = [super init];
    self.configuration = configuration;
    return self;
}

+ (instancetype)controllerWithConfiguration:(MPBSignatureViewControllerConfiguration*)configuration {
    id controller = [[MPBCustomStyleSignatureViewController alloc] initWithConfiguration: configuration];
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

- (void) setupViews {
    self.merchantNameLabel.text = self.configuration.merchantName;
    self.formattedAmountLabel.text = self.configuration.formattedAmount;
    self.legalTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"signatureTextFormat", @""), self.configuration.formattedAmount, self.configuration.merchantName];
    self.merchantImageView.image = self.configuration.merchantImage;
    [self.continueButton  setTitle:NSLocalizedString(@"continue", nil) forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [self.clearButton setTitle:NSLocalizedString(@"clear", nil) forState:UIControlStateNormal];
    [self disableContinueAndClearButtonsAnimated:NO];
    self.schemeImageView.image = [self imageForScheme: self.configuration.scheme];
    self.schemeImageView.contentMode = UIViewContentModeCenter;
}

- (UIImage*) imageForScheme: (MPBSignatureViewControllerConfigurationScheme) scheme {
    switch (scheme) {
        case MPBSignatureViewControllerConfigurationSchemeMaestro:
            return [UIImage imageNamed:@"maestro_image.png"];
        case MPBSignatureViewControllerConfigurationSchemeMastercard:
            return [UIImage imageNamed:@"mastercard_image.png"];
        case MPBSignatureViewControllerConfigurationSchemeVisa:
        case MPBSignatureViewControllerConfigurationSchemeVpay:
            return [UIImage imageNamed:@"visacard_image.png"];
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



@end
