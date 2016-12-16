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

#import "MPBViewController.h"
#import "MPBSignatureViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MPBViewController ()

@property BOOL fieldShown;
@property (strong, nonatomic) UIImageView* backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *signatureView;

@end

@implementation MPBViewController

- (id)init {

    self = [super init];
    if (self) {
        self.fieldShown = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.signatureView.contentMode = UIViewContentModeScaleAspectFit;
    self.signatureView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.signatureView.layer.borderWidth = 2.0f;
}


- (IBAction)mposui:(id)sender {

    MPBSignatureViewControllerConfiguration *configuration = [[MPBSignatureViewControllerConfiguration alloc] initWithFormattedAmount:@"421.99 €"];

    static MPBSignatureViewControllerConfigurationScheme scheme = MPBSignatureViewControllerConfigurationSchemeGhLink;
    configuration.scheme = scheme;

    MPBSignatureViewController* signatureViewController = [[MPBSignatureViewController alloc] initWithConfiguration:configuration];

    signatureViewController.modalPresentationStyle = UIModalPresentationFullScreen;

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
}


@end
