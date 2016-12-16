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

#import "MPBSignatureViewController.h"
#import "MPPPSSignatureView.h"


NSString * const MPExceptionNilParam = @"MPNilParam";

@interface MPBSignatureViewController () <MPPPSSignatureViewDelegate>

@property (nonatomic, strong) MPBSignatureViewControllerConfiguration *configuration;

@property (nonatomic, strong) MPPPSSignatureView *signatureView;
@property (nonatomic, strong) UIImageView *schemeImageView;
@property (nonatomic, strong) UILabel *formattedAmountLabel;

@property (nonatomic, strong) UILabel *legalTextLabel;

@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, weak) UIView *viewToAdd;
@property (nonatomic, strong) UIView *signatureLineView;

@end



@implementation MPBSignatureViewController



- (instancetype)initWithConfiguration:(MPBSignatureViewControllerConfiguration *)configuration {

    self = [super init];

    if (!self) {
        return nil;
    }

    self.configuration = configuration;

    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.signatureView =  [[MPPPSSignatureView alloc] initWithFrame:self.signatureView.frame context:[EAGLContext currentContext]]; //(MPPPSSignatureView*)[[UIView alloc] init];//
    self.signatureView.signatureDelegate = self;
    self.signatureView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.signatureView];

    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton addTarget:self action:@selector(cancelSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:self.configuration.cancelButtonTitle forState:UIControlStateNormal];
    [self.view addSubview:self.cancelButton];


    self.continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.continueButton addTarget:self action:@selector(continueWithSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.continueButton  setTitle:self.configuration.continueButtonTitle forState:UIControlStateNormal];
    [self.view addSubview:self.continueButton];


    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.clearButton addTarget:self action:@selector(clearSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.clearButton setTitle:self.configuration.clearButtonTitle forState:UIControlStateNormal];
    [self.view addSubview:self.clearButton];


    self.schemeImageView = [[UIImageView alloc] init];
    self.schemeImageView.image = self.configuration.imageForScheme;
    self.schemeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.schemeImageView];

    self.formattedAmountLabel = [[UILabel alloc] init];
    self.formattedAmountLabel.text = self.configuration.formattedAmount;
    [self.view addSubview:self.formattedAmountLabel];


    self.legalTextLabel = [[UILabel alloc] init];
    self.legalTextLabel.font = [UIFont systemFontOfSize:12];
    self.legalTextLabel.adjustsFontSizeToFitWidth = YES;
    self.legalTextLabel.textAlignment = NSTextAlignmentCenter;
    self.legalTextLabel.textColor = [UIColor darkTextColor];
    self.legalTextLabel.text =  self.configuration.legalText;
    [self.view addSubview:self.legalTextLabel];


    self.signatureLineView = [[UIView alloc] init];
    self.signatureLineView.backgroundColor = [UIColor darkTextColor];
    [self.view addSubview:self.signatureLineView];


    [self setContinueAndClearButtonsEnabled:NO];

    self.view.backgroundColor = [UIColor whiteColor];

    [self addLayoutConstraints];
}


- (void)addLayoutConstraints {

    for (UIView *view in self.view.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    NSDictionary *views = @{@"cancelButton"  : self.cancelButton,
                            @"continueButton": self.continueButton,
                            @"signatureView" : self.signatureView,
                            @"legalTextLabel":self.legalTextLabel,
                            @"signatureLineView" : self.signatureLineView,
                            @"schemeImageView" : self.schemeImageView,
                            @"formattedAmountLabel" : self.formattedAmountLabel,
                            @"clearButton" : self.clearButton };

    NSDictionary *metrics = @{@"margin" : @10.0,
                              @"topHeight" : @48.0,
                              @"bottomHeight" : @50.0};


    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[cancelButton(==continueButton)][continueButton]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton(bottomHeight)]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[continueButton(bottomHeight)]|" options:0 metrics:metrics views:views]];


    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[signatureView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[signatureView][cancelButton]" options:0 metrics:metrics  views:views]];


    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[legalTextLabel]-margin-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[legalTextLabel(20)][cancelButton]" options:0 metrics:metrics views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[signatureLineView]-margin-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[signatureLineView(1)][legalTextLabel]" options:0 metrics:metrics views:views]];


    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[schemeImageView(topHeight)]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[schemeImageView(topHeight)]" options:0 metrics:metrics views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[schemeImageView][formattedAmountLabel(250)]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[formattedAmountLabel(topHeight)]" options:0 metrics:metrics views:views]];


    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[clearButton(100)]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[clearButton(topHeight)]" options:0 metrics:metrics views:views]];
}




- (void)checkIfRequiredComponentsAreAvailable {

    if (self.configuration == nil) {
        [NSException raise:MPExceptionNilParam format:@"You did not supply a configuration! Assign a configuration for controller.configuration"];
    }
}




- (void)clearSignature {
    [self.signatureView erase];
}


- (void)continueWithSignature {

    if (!self.continueBlock) {
        return;
    }

    self.continueBlock([self.signatureView signatureImage]);
}

- (void)cancelSignature {

    if (!self.cancelBlock) {
        return;
    }

    self.cancelBlock();
}

- (void)setContinueAndClearButtonsEnabled:(BOOL)enabled {

    self.clearButton.enabled = enabled;
    self.continueButton.enabled = enabled;
}


- (void)signatureAvailable:(BOOL)signatureAvailable {

    [self setContinueAndClearButtonsEnabled:signatureAvailable];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}



@end
