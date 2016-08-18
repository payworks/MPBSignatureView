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

#import <UIKit/UIKit.h>
#import "MPBSignatureViewControllerConfiguration.h"

typedef void (^MPBCustomStyleSignatureViewControllerContinue)(UIImage *signature);
typedef void (^MPBCustomStyleSignatureViewControllerCancel)();

@interface MPBCustomStyleSignatureViewController : UIViewController

@property (nonatomic, strong) MPBSignatureViewControllerConfiguration *configuration;

@property (nonatomic, copy) MPBCustomStyleSignatureViewControllerContinue continueBlock;
@property (nonatomic, copy) MPBCustomStyleSignatureViewControllerCancel cancelBlock;


@property (nonatomic, strong) IBOutlet UIView *signatureView;
@property (nonatomic, strong) IBOutlet UIImageView *schemeImageView;
@property (nonatomic, strong) IBOutlet UILabel *merchantNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *formattedAmountLabel;
@property (nonatomic, strong) IBOutlet UIImageView *merchantImageView;

@property (nonatomic, strong) IBOutlet UILabel *legalTextLabel;

@property (nonatomic, strong) IBOutlet UIButton *continueButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *clearButton;

- (instancetype)initWithConfiguration:(MPBSignatureViewControllerConfiguration *)configuration;
+ (instancetype)controllerWithConfiguration:(MPBSignatureViewControllerConfiguration *)configuration;

- (void)continueWithSignature;
- (void)cancelSignature;
- (void)clearSignature;

- (void)disableContinueAndClearButtonsAnimated:(BOOL)animated;
- (void)enableContinueAndClearButtons;

- (NSBundle *)resourceBundle;
- (NSString *)localizedString:(NSString *)token;
- (UIImage *)imageWithName:(NSString *)name;

@end


