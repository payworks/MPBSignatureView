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

#import "MPBDefaultStyleSignatureViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface MPBDefaultStyleSignatureViewController ()

@property (nonatomic, assign) CGRect signatureFrame;
@property (nonatomic, assign) CGRect bounds;

// UI Components
@property (nonatomic, strong) UIView *topBackground;
@property (nonatomic, strong) UIView *bottomBackground;
@property (nonatomic, strong) UIView *signatureLineView;

@end

@implementation MPBDefaultStyleSignatureViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) setDefaults {
    self.buttonColor = [UIColor colorWithRed:21.0f/255.0f green:126.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
    self.lineColor = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1.0];
    self.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.largeFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:32];
    self.mediumFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.smallFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    
}


- (void) disableContinueAndClearButtonsAnimated:(BOOL)animated {
    self.continueButton.enabled = NO;
    if (!animated) {
        self.clearButton.alpha = 0;
        self.continueButton.backgroundColor = [UIColor grayColor];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            self.clearButton.alpha = 0;
            self.continueButton.backgroundColor = [UIColor grayColor];
        }];
    }
}

- (void)enableContinueAndClearButtons {
    self.continueButton.enabled = YES;
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.clearButton.alpha = 1;
        self.continueButton.backgroundColor = [self buttonColor];
    } completion:NULL];
}




- (void)viewWillLayoutSubviews {
    self.bounds = self.view.bounds;
    
    int backgroundsHeight = 46;
    
    self.topBackground.frame=CGRectMake(0, 0, self.bounds.size.width,backgroundsHeight);
    self.bottomBackground.frame =CGRectMake(0, self.bounds.size.height-backgroundsHeight, self.bounds.size.width,backgroundsHeight);
    
    self.merchantNameLabel.frame = CGRectMake(10, 0, self.bounds.size.width * 3 / 5, backgroundsHeight);
    self.formattedAmountLabel.frame = CGRectMake(self.bounds.size.width * 3.0/ 5.0, 0, self.bounds.size.width * 2.0 / 5.0 - 12, backgroundsHeight);
    
    [self.legalTextLabel sizeToFit];
    self.legalTextLabel.frame = CGRectMake(10, self.bounds.size.height-backgroundsHeight - 25, self.bounds.size.width-20, self.legalTextLabel.frame.size.height);
    self.signatureLineView.frame =CGRectMake(22,self.legalTextLabel.frame.origin.y - 5, self.bounds.size.width-44, 0.5f);

    self.continueButton.frame = CGRectMake(0.382*self.bounds.size.width, self.bounds.size.height-backgroundsHeight, 0.618*self.bounds.size.width, backgroundsHeight);
    self.cancelButton.frame = CGRectMake(0, self.bounds.size.height-backgroundsHeight, 0.382*self.bounds.size.width, backgroundsHeight);
    self.clearButton.frame = CGRectMake(self.bounds.size.width-200, backgroundsHeight, 200, 80);
    
    self.signatureView.frame = CGRectMake(0, backgroundsHeight, self.bounds.size.width, self.bounds.size.height - backgroundsHeight * 2);
    
    [self.view bringSubviewToFront:self.clearButton];
}

- (void)setupBackgroundElements {
    self.signatureLineView = [[UIView alloc] init];
    self.signatureLineView.backgroundColor = self.lineColor;
    
    self.topBackground = [[UIView alloc]init ];
    self.bottomBackground = [[UIView alloc]init];
    
    self.topBackground.backgroundColor = self.backgroundColor;
    [self.topBackground.layer setBorderWidth:0.5f];
    [self.topBackground.layer setBorderColor:self.lineColor.CGColor];
    
    self.bottomBackground.backgroundColor = self.backgroundColor;
    [self.bottomBackground.layer setBorderWidth:0.7f];
    [self.bottomBackground.layer setBorderColor:self.lineColor.CGColor];
    
    [self.view addSubview:self.topBackground];
    [self.view addSubview:self.bottomBackground];
    [self.view addSubview:self.signatureLineView];
}
- (void)setupMerchantNameLabel {
    self.merchantNameLabel = [[UILabel alloc]init ];
    self.merchantNameLabel.backgroundColor = [UIColor clearColor];
    [self.merchantNameLabel setFont:self.largeFont];
    self.merchantNameLabel.numberOfLines = 1;
    self.merchantNameLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.view addSubview:self.merchantNameLabel];
}
- (void)setupAmountLabel {
    self.formattedAmountLabel = [[UILabel alloc]init ];
    self.formattedAmountLabel.backgroundColor = [UIColor clearColor];
    self.formattedAmountLabel.textAlignment = NSTextAlignmentRight;
    [self.formattedAmountLabel setFont:self.largeFont];
    self.formattedAmountLabel.numberOfLines = 1;
    self.formattedAmountLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.view addSubview:self.formattedAmountLabel];
}
- (void)setupSignatureTextLabel {
    self.legalTextLabel = [[UILabel alloc]init ];
    [self.legalTextLabel setFont:self.smallFont];
    self.legalTextLabel.textColor = self.lineColor;
    self.legalTextLabel.numberOfLines = 1;
    self.legalTextLabel.textAlignment = NSTextAlignmentCenter;
    self.legalTextLabel.backgroundColor = [UIColor clearColor];
    self.legalTextLabel.adjustsFontSizeToFitWidth = YES;
    self.legalTextLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    [self.view addSubview:self.legalTextLabel];
}
- (void)setupPayButton {
    self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[self.continueButton titleLabel] setFont:self.mediumFont];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.continueButton setBackgroundColor:self.buttonColor];
    
    [self.view addSubview:self.continueButton];
}
- (void)setupCancelButton {
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[self.cancelButton titleLabel] setFont:self.mediumFont];
    [self.cancelButton setTitleColor:self.buttonColor forState:UIControlStateNormal];
    
    [self.view addSubview:self.cancelButton];
}
- (void)setupClearButton {
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [[self.clearButton titleLabel] setFont:self.mediumFont];
    [self.clearButton setBackgroundColor:[UIColor clearColor]];
    [self.clearButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.clearButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    
    //move text 10 pixels down and right
    [self.clearButton setTitleEdgeInsets:UIEdgeInsetsMake(8.0f, 0.0f, 0.0f, 10.0f)];
    
    [self.view addSubview:self.clearButton];
}

- (void)setupComponents {
    [self setDefaults];
    [self setupBackgroundElements];
    [self setupMerchantNameLabel];
    [self setupAmountLabel];
    [self setupSignatureTextLabel];
    [self setupPayButton];
    [self setupCancelButton];
    [self setupClearButton];
    self.signatureView = [[UIView alloc]init];
    self.signatureView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.signatureView];

   // TODO?!!?! [self noSignatureAnimated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponents];
}


@end
