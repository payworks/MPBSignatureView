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

#import "MPBSignatureFieldViewController.h"

@interface MPBSignatureFieldViewController () <PPSSignatureViewDelegate>

@property (nonatomic, weak) UIView *viewToAdd;

@property CGRect frame;

@end

@implementation MPBSignatureFieldViewController

- (id)init {
    self = [super init];
    if (self) {
        self.frame = self.view.frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSignatureFieldBackground];
    [self setupSignatureField];
    [self setupSignatureFieldComponents];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setupSignatureFieldBackground {
    // method can be overwritten by user to add background components to the signature field
}
- (void)setupSignatureFieldComponents {
    // method can be overwritten by user to add frontend components to the signature field
}

- (void)setupSignatureFieldWithView:(UIView*)view {
    self.frame = view.frame;
    self.viewToAdd = view;
}

- (void)setupSignatureFieldWithFrame:(CGRect)frame {
    self.frame = frame;
    self.viewToAdd = self.view;
}

- (void)setupSignatureField {
    self.signatureView = [[PPSSignatureView alloc] initWithFrame:self.frame context:nil];
    self.signatureView.signatureDelegate = self;
    self.signatureView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.signatureView];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}



-(void)clearSignature {
    [self.signatureView erase];
}

-(UIImage *)signature {
    return [self.signatureView signatureImage];
}

- (void)signatureAvailable:(BOOL)signatureAvailable {
    // method can be overwritte by user to enable/disable frontend components
}


@end
