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

- (id)init {
    self = [super init];
    if (self) {
        [self setDefaultText];
        
        self.buttonColor = [UIColor colorWithRed:21.0f/255.0f green:126.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
        self.colorLine = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1.0];
        self.colorBackground = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.bounds = [[UIScreen mainScreen]bounds];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        // iOS 7+
        self.bounds = CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height);
        self.signatureFrame = CGRectMake(0, 64, self.bounds.size.height, self.bounds.size.width-108);
#else
        // pre iOS 7
        self.bounds = CGRectMake(0, 0, self.bounds.size.width-20, self.bounds.size.height);
        self.signatureFrame = CGRectMake(0, 44, self.bounds.size.height, self.bounds.size.width-88);
#endif
        
        self.largeFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
        self.mediumFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
        self.smallFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16];
        
        [self setupSignatureFieldWithFrame:self.signatureFrame];
    }
    return self;
}

- (void) setDefaultText {
    self.merchantName = @"Merchant";
    self.amountText = @"1.00 €";
    self.signatureText = @"Signature";
    self.signatureColor = [UIColor blueColor];
    self.payButtonText = @"Pay";
    self.cancelButtonText = @"Cancel";
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (void)registerOnPay:(void (^)(void))payBlock onCancel:(void (^)(void))cancelBlock {
    self.payCallback = payBlock;
    self.cancelCallback = cancelBlock;
}

- (void)setupSignatureFieldComponents {
    [self setupBackgroundElements];
    [self setupMerchantNameLabel];
    [self setupAmountLabel];
    [self setupSignatureTextLabel];
    [self setupPayButton];
    [self setupCancelButton];
    [self setupClearButton];
}

- (void)setupBackgroundElements {
    self.signatureLineView = [[UIView alloc] initWithFrame:CGRectMake(0.382*self.bounds.size.height, self.bounds.size.width-44, 0.5f, 46)];
    self.signatureLineView.backgroundColor = self.colorLine;
    
    self.topBackground = [[UIView alloc]initWithFrame:CGRectMake(-2, -2, self.bounds.size.height+4,self.bounds.origin.y+46)];
    self.bottomBackground = [[UIView alloc]initWithFrame:CGRectMake(-2, self.bounds.size.width-44, self.bounds.size.height+4,46)];
    
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
    self.merchantNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bounds.origin.y+5, self.bounds.size.height/2-10, 34)];
    self.merchantNameLabel.backgroundColor = [UIColor clearColor];
    [self.merchantNameLabel setText:self.merchantName];
    [self.merchantNameLabel setFont:self.largeFont];
    
    [self.view addSubview:self.merchantNameLabel];
}
- (void)setupAmountLabel {
    self.amountTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.height/2, self.bounds.origin.y+5, self.bounds.size.height/2-10, 34)];
    self.amountTextLabel.backgroundColor = [UIColor clearColor];
    [self.amountTextLabel setText:self.amountText];
    self.amountTextLabel.textAlignment = NSTextAlignmentRight;
    [self.amountTextLabel setFont:self.largeFont];
    
    [self.view addSubview:self.amountTextLabel];
}
- (void)setupSignatureTextLabel {
    self.signatureTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.width-88, self.bounds.size.height, 44)];
    [self.signatureTextLabel setText:self.signatureText];
    [self.signatureTextLabel setFont:self.smallFont];
    self.signatureTextLabel.textColor = self.colorLine;
    self.signatureTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.signatureTextLabel.numberOfLines = 0;
    [self.signatureTextLabel sizeToFit];
    self.signatureTextLabel.frame = CGRectMake(0, self.bounds.size.width-44-10-self.signatureTextLabel.frame.size.height, self.bounds.size.height, self.signatureTextLabel.frame.size.height);
    self.signatureTextLabel.textAlignment = NSTextAlignmentCenter;
    self.signatureTextLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.signatureTextLabel];
}
- (void)setupPayButton {
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame = CGRectMake(0.382*self.bounds.size.height, self.bounds.size.width-44, 0.618*self.bounds.size.height, 44);
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
    self.cancelButton.frame = CGRectMake(0, self.bounds.size.width-44, 0.382*self.bounds.size.height, 44);
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
    self.clearButton.frame = CGRectMake(self.signatureFrame.size.width-44, self.signatureFrame.origin.y, 44, 44);
    [self.clearButton setTitle:@"X" forState:UIControlStateNormal];
    [[self.clearButton titleLabel] setFont:self.mediumFont];
    [self.clearButton addTarget:self
                       action:@selector(clearSignature)
             forControlEvents:UIControlEventTouchUpInside];
    [self.clearButton setTitleColor:self.colorLine forState:UIControlStateNormal];
    [self.clearButton setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.clearButton];
}

- (void)btnPay {
    self.payCallback();
}
- (void)btnCancel {
    self.cancelCallback();
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
