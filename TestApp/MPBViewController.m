/*
 * Payment Signature View: http://www.payworksmobile.com
 *
 * Copyright (c) 2015 payworks GmbH
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

#import "MPBViewController.h"
#import "MPBSignatureViewController.h"
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
    [self showModal:UIModalPresentationFormSheet style:[MPBDefaultStyleSignatureViewController alloc]];
}

- (IBAction)showPredefinedScreen:(id)sender {
    [self showModal:UIModalPresentationFullScreen style:[MPBDefaultStyleSignatureViewController alloc]];
}

- (IBAction)showCustomScreen:(id)sender {
    [self showCustomScreenWithIdentifier:@"signature"];
}
- (IBAction)showPayButtonStyleSignatureView:(id)sender {
    [self showCustomScreenWithIdentifier:@"paybutton"];
}

- (void) showCustomScreenWithIdentifier:(NSString*) identifier {
    MPBCustomStyleSignatureViewController *vc = (MPBCustomStyleSignatureViewController *)[self.storyboard instantiateViewControllerWithIdentifier:identifier];
    MPBSignatureViewControllerConfiguration* config = [MPBSignatureViewControllerConfiguration configurationWithMerchantName:@"Antiques + Valuables GmbH" formattedAmount:@"421.99 €"];
    config.scheme = MPBSignatureViewControllerConfigurationSchemeAmex;
    vc.configuration = config;
    vc.continueBlock = ^(UIImage *signature) {
        [self showImage: signature];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    vc.cancelBlock =^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)mposui:(id)sender {
        [self showModal:UIModalPresentationFullScreen style:[MPBMposUIStyleSignatureViewController alloc]];
}

- (void)showModal:(UIModalPresentationStyle) style style:(MPBCustomStyleSignatureViewController*) controller
{
    
    MPBCustomStyleSignatureViewController* signatureViewController = [controller initWithConfiguration:[MPBSignatureViewControllerConfiguration configurationWithFormattedAmount:@"421.99 €"]];
    signatureViewController.modalPresentationStyle = style;
    signatureViewController.preferredContentSize = CGSizeMake(800, 500);
    signatureViewController.configuration.scheme = MPBSignatureViewControllerConfigurationSchemeAmex;
    
    signatureViewController.continueBlock = ^(UIImage *signature) {
        [self showImage: signature];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    signatureViewController.cancelBlock = ^ {
        [self dismissViewControllerAnimated:YES completion:nil];
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
