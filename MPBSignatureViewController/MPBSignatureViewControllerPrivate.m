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
#import "MPBSignatureViewControllerPrivate.h"

NSBundle *MPBSignatureViewBundle(void) {
    static NSBundle *bundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:MPBSIGNATUREVIEW_BUNDLE];
        bundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return bundle;
}

NSString *MPBSignatureViewLocalizedString(NSString *stringToken) {
    if (!stringToken) return @"";
    
    NSString *appSpecificLocalizationString = NSLocalizedString(stringToken, @"");
    NSString *appSpecificLocalizationString2 = NSLocalizedStringFromTable(stringToken, @"MPBSignatureView", nil);
    if (appSpecificLocalizationString && ![stringToken isEqualToString:appSpecificLocalizationString]) {
        return appSpecificLocalizationString;
    } else if(appSpecificLocalizationString2 && ![stringToken isEqualToString:appSpecificLocalizationString2]) {
        return appSpecificLocalizationString2;
    } else if (MPBSignatureViewBundle()) {
        NSString *bundleSpecificLocalizationString = NSLocalizedStringFromTableInBundle(stringToken, @"MPBSignatureView", MPBSignatureViewBundle(), @"");
        if (bundleSpecificLocalizationString)
            return bundleSpecificLocalizationString;
        return stringToken;
    } else {
        return stringToken;
    }
}

UIImage *MPBimageWithContentsOfResolutionIndependentFile(NSString * path) {
    NSString* extension = @"";
    if ([UIScreen instancesRespondToSelector:@selector(scale)] && (int)[[UIScreen mainScreen] scale] == 2.0) {
        extension = @"%@@2x.%@";
    } else if([UIScreen instancesRespondToSelector:@selector(scale)] && (int)[[UIScreen mainScreen] scale] == 3.0) {
        extension = @"%@@3x.%@";
    } else {
        extension = @"";
    }
    NSString* nPath = [[path stringByDeletingLastPathComponent]
                       stringByAppendingPathComponent:[NSString stringWithFormat:extension,
                                                       [[path lastPathComponent] stringByDeletingPathExtension],
                                                       [path pathExtension]]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nPath]) {
        return [[UIImage alloc] initWithContentsOfFile:nPath];
    } else {
        return [[UIImage alloc] initWithContentsOfFile:path];
        
    }
}

UIImage *MPBImageNamed(NSString *imageName) {
    if(MPBSignatureViewBundle()) {
        NSBundle *bundle = MPBSignatureViewBundle();
        NSString *imagePath = [[bundle resourcePath] stringByAppendingPathComponent:imageName];
        return MPBimageWithContentsOfResolutionIndependentFile(imagePath);
    } else {
        return [UIImage imageNamed:imageName];
    }
}
