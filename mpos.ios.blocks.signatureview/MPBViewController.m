//
//  PWSVViewController.m
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 01.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import "MPBViewController.h"
#import "MPBSignatureViewController.h"
#import "MPBTestViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MPBViewController ()

@property BOOL fieldShown;
@property (strong, nonatomic) UIImageView* backgroundView;

@end

@implementation MPBViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.fieldShown = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)modal:(id)sender {
    [self showModal:UIModalPresentationFormSheet];
}

- (IBAction)showPredefinedScreen:(id)sender {
    [self showModal:UIModalPresentationFullScreen];
}

- (IBAction)showCustomScreen:(id)sender {
    MPBTestViewController *vc = (MPBTestViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"signature"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showModal:(UIModalPresentationStyle) style
{
    
    MPBSignatureViewController* signatureViewController = [[MPBSignatureViewController alloc]init];
    signatureViewController.modalPresentationStyle = style;
    signatureViewController.preferredContentSize = CGSizeMake(800, 500);
        
    signatureViewController.merchantName = @"Fruit Shop";
    signatureViewController.amountText = @"5.99 €";
        
    [signatureViewController registerOnPay:^{
            
        UIImage* signature = [signatureViewController signature];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(66, 200, 200, 100)];
        imageView.image = signature;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
            
        imageView.layer.borderColor = [UIColor yellowColor].CGColor;
        imageView.layer.borderWidth = 2.0f;
            
        
    } onCancel:^{
            
    }];
    
    [self presentViewController:signatureViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
