//
//  MPBMposUIStyleSignatureViewController.m
//  mpos.ios.blocks.signatureview
//
//  Created by Korbinian Breu on 29/01/15.
//  Copyright (c) 2015 payworks. All rights reserved.
//

#import "MPBMposUIStyleSignatureViewController.h"

@interface MPBMposUIStyleSignatureViewController()

@property (nonatomic, strong) UIView* signatureLineView;

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
    [self.view addSubview:self.cancelButton];
    self.continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.continueButton];
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.clearButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.clearButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    self.clearButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.clearButton setTitleEdgeInsets:UIEdgeInsetsMake(8.0f, 0.0f, 0.0f, 15.0f)];

    
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
    
    self.signatureView.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - bottomHeight - topHeight);
    
    int legalTextSideMargin = 10;
    int legalTextHeight = 20;
    self.legalTextLabel.frame = CGRectMake(legalTextSideMargin, self.view.bounds.size.height - bottomHeight - legalTextHeight, self.view.bounds.size.width - legalTextSideMargin * 2, legalTextHeight);
    
    self.schemeImageView.frame = CGRectMake(0, 0, 50, topHeight);
    self.formattedAmountLabel.frame = CGRectMake(50, 0, 250, topHeight);
    self.clearButton.frame = CGRectMake(self.view.bounds.size.width - 100, 0, 100, 100);
    self.signatureLineView.frame = CGRectMake(legalTextSideMargin, self.view.bounds.size.height - bottomHeight - legalTextHeight - 1, self.view.bounds.size.width - legalTextSideMargin * 2, 1);
}

@end
