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

#import "MPBMposUIStyleSignatureViewController.h"

@interface MPBMposUIStyleSignatureViewController()

@property (nonatomic, strong) UIView *signatureLineView;

@end

@implementation MPBMposUIStyleSignatureViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signatureView = [[UIView alloc] init];
    self.signatureView.backgroundColor = [UIColor clearColor];

    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 16, 0)];
    [self.cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.cancelButton setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];

    [self.view addSubview:self.cancelButton];
    self.continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.continueButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.continueButton setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [self.continueButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 16, 16)];

    [self.view addSubview:self.continueButton];
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.clearButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.clearButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    self.clearButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.clearButton setTitleEdgeInsets:UIEdgeInsetsMake(8.0f, 0.0f, 0.0f, 15.0f)];
    [self.clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.clearButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    
    self.schemeImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.schemeImageView];
    self.formattedAmountLabel = [[UILabel alloc] init];
    [self.view addSubview:self.formattedAmountLabel];
    self.legalTextLabel = [[UILabel alloc] init];
    self.legalTextLabel.font = [UIFont systemFontOfSize:12];
    self.legalTextLabel.adjustsFontSizeToFitWidth = YES;
    self.legalTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.legalTextLabel];
    self.legalTextLabel.textColor = [UIColor darkTextColor];
    
    self.signatureLineView = [[UIView alloc] init];
    self.signatureLineView.backgroundColor = [UIColor darkTextColor];
    [self.view addSubview:self.signatureLineView];
    
    // front
    [self.view addSubview:self.signatureView];
    // even fronter
    [self.view addSubview:self.clearButton];

    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // overwrite the text of the 'clear button'
    [self.clearButton setTitle:@"x" forState:UIControlStateNormal];
}

- (void)viewWillLayoutSubviews {
    int topHeight = 40;
    int bottomHeight = 50;
    
    self.cancelButton.frame = CGRectMake(0, self.view.bounds.size.height - bottomHeight, 200, bottomHeight);
    self.continueButton.frame = CGRectMake(self.view.bounds.size.width - 200, self.view.bounds.size.height - bottomHeight, 200, bottomHeight);
    
    self.signatureView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bottomHeight);
    
    int legalTextSideMargin = 10;
    int legalTextHeight = 20;
    self.legalTextLabel.frame = CGRectMake(legalTextSideMargin, self.view.bounds.size.height - bottomHeight - legalTextHeight, self.view.bounds.size.width - legalTextSideMargin * 2, legalTextHeight);
    
    self.schemeImageView.frame = CGRectMake(0, 0, 50, topHeight);
    self.formattedAmountLabel.frame = CGRectMake(50, 0, 250, topHeight);
    self.clearButton.frame = CGRectMake(self.view.bounds.size.width - 100, 0, 100, 100);
    self.signatureLineView.frame = CGRectMake(legalTextSideMargin, self.view.bounds.size.height - bottomHeight - legalTextHeight - 1, self.view.bounds.size.width - legalTextSideMargin * 2, 1);
}

@end
