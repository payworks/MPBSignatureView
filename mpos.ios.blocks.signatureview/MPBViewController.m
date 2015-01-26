//
//  PWSVViewController.m
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 01.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import "MPBViewController.h"
#import "MPBDefaultStyleSignatureViewController.h"
#import "MPBCustomStyleSignatureViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MPBViewController ()

@property BOOL fieldShown;
@property (strong, nonatomic) UIImageView* backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *signatureView;

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
    MPBCustomStyleSignatureViewController *vc = (MPBCustomStyleSignatureViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"signature"];
    MPBSignatureViewControllerConfiguration* config = [MPBSignatureViewControllerConfiguration configurationWithMerchantName:@"Antiques + Valuables GmbH" formattedAmount:@"421.99 €"];
    config.scheme = MPBSignatureViewControllerConfigurationSchemeMaestro;
    vc.configuration = config;
    vc.continueBlock = ^(UIImage *signature) {
        [self showImage: signature];
    };
    vc.cancelBlock =^{};

    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showModal:(UIModalPresentationStyle) style
{
    
    MPBDefaultStyleSignatureViewController* signatureViewController = [[MPBDefaultStyleSignatureViewController alloc]initWithConfiguration:[MPBSignatureViewControllerConfiguration configurationWithMerchantName:@"Antiques + Valuables GmbH" formattedAmount:@"421.99 €"]];
    signatureViewController.modalPresentationStyle = style;
    signatureViewController.preferredContentSize = CGSizeMake(800, 500);
            
    signatureViewController.continueBlock = ^(UIImage *signature) {
        [self showImage: signature];
    };
    signatureViewController.cancelBlock = ^ {
        
    };
    

    
    [self presentViewController:signatureViewController animated:YES completion:nil];
}

- (void) showImage: (UIImage*) signature {
    self.signatureView.image = signature;
    self.signatureView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.signatureView.layer.borderColor = [UIColor yellowColor].CGColor;
    self.signatureView.layer.borderWidth = 2.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
