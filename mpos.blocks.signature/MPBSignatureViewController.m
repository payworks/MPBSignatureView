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

#import "MPBSignatureViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface MPBSignatureViewController ()

@property CGRect signatureFrame;

// UI Components
@property (nonatomic, strong) UILabel* merchantNameLabel;
@property (nonatomic, strong) UILabel* amountTextLabel;
@property (nonatomic, strong) UILabel* signatureTextLabel;
@property (nonatomic, strong) UIView* signatureLineView;
@property (nonatomic, strong) UIButton* payButton;
@property (nonatomic, strong) UIButton* cancelButton;
@property (nonatomic, strong) UIButton* clearButton;
@property (nonatomic, strong) UIView* topBackground;
@property (nonatomic, strong) UIView* bottomBackground;



// Callback Blocks
@property (nonatomic, copy) void (^payCallback)(void);
@property (nonatomic, copy) void (^cancelCallback)(void);

@property CGRect bounds;

@end

@implementation MPBSignatureViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) setDefaults {
    self.merchantName = @"Merchant";
    self.amountText = @"1.00 €";
    self.signatureText = @"Signature";
    self.signatureColor = [UIColor blueColor];
    self.payButtonText = @"Pay";
    self.cancelButtonText = @"Cancel";
    
    self.buttonColor = [UIColor colorWithRed:21.0f/255.0f green:126.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
    self.colorLine = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1.0];
    self.colorBackground = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.largeFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:32];
    self.mediumFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.smallFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    
}

- (void)setMerchantName:(NSString *)merchantName {
    _merchantName = merchantName;
    self.merchantNameLabel.text = merchantName;
}

- (void)setAmountText:(NSString *)amountText {
    _amountText = amountText;
    self.amountTextLabel.text = amountText;
}

- (void)setSignatureText:(NSString *)signatureText {
    _signatureText = signatureText;
    self.signatureTextLabel.text = signatureText;
}

- (void)setPayButtonText:(NSString *)payButtonText {
    _payButtonText = payButtonText;
    [self.payButton setTitle:payButtonText forState:UIControlStateNormal];
}

- (void)setCancelButtonText:(NSString *)cancelButtonText {
    _cancelButtonText = cancelButtonText;
    [self.cancelButton setTitle:cancelButtonText forState:UIControlStateNormal];
}

- (void) signatureAvailable:(BOOL)signatureAvailable {
    if (signatureAvailable) {
        [self hasSignature];
    } else {
        [self noSignatureAnimated:YES];
    }
}

- (void) noSignatureAnimated:(BOOL)animated {
    self.payButton.enabled = NO;
    if (!animated) {
        self.clearButton.alpha = 0;
        self.payButton.backgroundColor = [UIColor grayColor];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            self.clearButton.alpha = 0;
            self.payButton.backgroundColor = [UIColor grayColor];
        }];
    }
}


- (void) hasSignature {
    self.payButton.enabled = YES;
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.clearButton.alpha = 1;
        self.payButton.backgroundColor = [self buttonColor];
    } completion:NULL];

}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}


- (void)registerOnPay:(void (^)(void))payBlock onCancel:(void (^)(void))cancelBlock {
    self.payCallback = payBlock;
    self.cancelCallback = cancelBlock;
}

- (void)setupSignatureFieldComponents {
    [self setDefaults];
    [self setupBackgroundElements];
    [self setupMerchantNameLabel];
    [self setupAmountLabel];
    [self setupSignatureTextLabel];
    [self setupPayButton];
    [self setupCancelButton];
    [self setupClearButton];
    [self noSignatureAnimated:NO];
}

- (void)viewWillLayoutSubviews {
    self.bounds = self.view.bounds;
    
    int backgroundsHeight = 46;
    
    self.topBackground.frame=CGRectMake(0, 0, self.bounds.size.width,backgroundsHeight);
    self.bottomBackground.frame =CGRectMake(0, self.bounds.size.height-backgroundsHeight, self.bounds.size.width,backgroundsHeight);
    
    self.merchantNameLabel.frame = CGRectMake(10, 0, self.bounds.size.width / 2, backgroundsHeight);
    self.amountTextLabel.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width / 2 - 12, backgroundsHeight);
    
    self.signatureTextLabel.frame = CGRectMake(0, self.bounds.size.height-backgroundsHeight - 25, self.bounds.size.width, self.signatureTextLabel.frame.size.height);
    self.signatureLineView.frame =CGRectMake(22,self.signatureTextLabel.frame.origin.y - 5, self.bounds.size.width-44, 0.5f);

    self.payButton.frame = CGRectMake(0.382*self.bounds.size.width, self.bounds.size.height-backgroundsHeight, 0.618*self.bounds.size.width, backgroundsHeight);
    self.cancelButton.frame = CGRectMake(0, self.bounds.size.height-backgroundsHeight, 0.382*self.bounds.size.width, backgroundsHeight);
    self.clearButton.frame = CGRectMake(self.bounds.size.width-80, backgroundsHeight, 80, 80);
    
    self.signatureView.frame = CGRectMake(0, backgroundsHeight, self.bounds.size.width, self.bounds.size.height - backgroundsHeight * 2);
    
    // get them into the correct order
    [self.view bringSubviewToFront:self.signatureView];
    [self.view bringSubviewToFront:self.clearButton];
}

- (void)setupBackgroundElements {
    self.signatureLineView = [[UIView alloc] init];
    self.signatureLineView.backgroundColor = self.colorLine;
    
    self.topBackground = [[UIView alloc]init ];
    self.bottomBackground = [[UIView alloc]init];
    
    self.topBackground.backgroundColor = self.colorBackground;
    [self.topBackground.layer setBorderWidth:0.5f];
    [self.topBackground.layer setBorderColor:self.colorLine.CGColor];
    
    self.bottomBackground.backgroundColor = self.colorBackground;
    [self.bottomBackground.layer setBorderWidth:0.7f];
    [self.bottomBackground.layer setBorderColor:self.colorLine.CGColor];
    
    [self.view addSubview:self.topBackground];
    [self.view addSubview:self.bottomBackground];
    [self.view addSubview:self.signatureLineView];
}
- (void)setupMerchantNameLabel {
    self.merchantNameLabel = [[UILabel alloc]init ];
    self.merchantNameLabel.backgroundColor = [UIColor clearColor];
    [self.merchantNameLabel setText:self.merchantName];
    [self.merchantNameLabel setFont:self.largeFont];
    
    [self.view addSubview:self.merchantNameLabel];
}
- (void)setupAmountLabel {
    self.amountTextLabel = [[UILabel alloc]init ];
    self.amountTextLabel.backgroundColor = [UIColor clearColor];
    [self.amountTextLabel setText:self.amountText];
    self.amountTextLabel.textAlignment = NSTextAlignmentRight;
    [self.amountTextLabel setFont:self.largeFont];
    
    [self.view addSubview:self.amountTextLabel];
}
- (void)setupSignatureTextLabel {
    self.signatureTextLabel = [[UILabel alloc]init ];
    [self.signatureTextLabel setText:self.signatureText];
    [self.signatureTextLabel setFont:self.smallFont];
    self.signatureTextLabel.textColor = self.colorLine;
    self.signatureTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.signatureTextLabel.numberOfLines = 0;
    [self.signatureTextLabel sizeToFit];
    self.signatureTextLabel.textAlignment = NSTextAlignmentCenter;
    self.signatureTextLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.signatureTextLabel];
}
- (void)setupPayButton {
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setTitle:self.payButtonText forState:UIControlStateNormal];
    [[self.payButton titleLabel] setFont:self.mediumFont];
    [self.payButton addTarget:self
                       action:@selector(btnPay)
             forControlEvents:UIControlEventTouchUpInside];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payButton setBackgroundColor:self.buttonColor];
    
    [self.view addSubview:self.payButton];
}
- (void)setupCancelButton {
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:self.cancelButtonText forState:UIControlStateNormal];
    [[self.cancelButton titleLabel] setFont:self.mediumFont];
    [self.cancelButton addTarget:self
                          action:@selector(btnCancel)
                forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitleColor:self.buttonColor forState:UIControlStateNormal];
    
    [self.view addSubview:self.cancelButton];
}
- (void)setupClearButton {
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setTitle:@"X" forState:UIControlStateNormal];
    [[self.clearButton titleLabel] setFont:self.mediumFont];
    [self.clearButton addTarget:self
                       action:@selector(clearSignature)
             forControlEvents:UIControlEventTouchUpInside];
    [self.clearButton setTitleColor:self.colorLine forState:UIControlStateNormal];
    [self.clearButton setBackgroundColor:[UIColor clearColor]];
    [self.clearButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.clearButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    
    //move text 10 pixels down and right
    [self.clearButton setTitleEdgeInsets:UIEdgeInsetsMake(8.0f, 0.0f, 0.0f, 10.0f)];
    
    [self.view addSubview:self.clearButton];
}

- (void)btnPay {
    self.payCallback();
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)btnCancel {
    self.cancelCallback();
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
