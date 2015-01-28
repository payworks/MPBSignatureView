/*
 * mPOS SDK Building Blocks: http://www.payworksmobile.com
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
#import "mpos.blocks.signature.h"
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
