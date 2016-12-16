## Simple, beautiful payment signatures on iOS

![signature view](https://bytebucket.org/payworks/mpos.ios.blocks.signatureview/raw/bc411f7f2cb451ebf61736a82ac8034e4388801a/screen3.png "Signature View")

Works perfectly with the mPOS SDK by [payworks](http://www.payworksmobile.com). Learn how to integrate a card reader in your app at [payworks.mpymnt.com](http://www.payworks.mpymnt.com).

## Install

In your podfile:

	source 'https://bitbucket.org/mpymnt/io.mpymnt.repo.pods.git'
	pod 'MPBSignatureViewController'

## Use

Import the header

    #import <MPBSignatureViewController/MPBSignatureViewController.h>

Show it and register callbacks

```objectivec
MPBSignatureViewControllerConfiguration* config = [MPBSignatureViewControllerConfiguration 
    configurationWithFormattedAmount:@"421.99 €"];

config.scheme = MPBSignatureViewControllerConfigurationSchemeMaestro;
MPBSignatureViewController *vc = [[MPBSignatureViewController alloc] initWithConfiguration: config];
vc.continueBlock = ^(UIImage *signature) {
   // if you use the payworks mPOS SDK, continue the transaction with
   // [paymentProcess continueWithCustomerSignature:signature verified:YES];
   [self dismissViewControllerAnimated:YES completion:nil];
};
vc.cancelBlock =^{
   // if you use the payworks mPOS SDK, continue the transaction with
   // [paymentProcess continueWithCustomerSignature: nil verified: NO];

   [self dismissViewControllerAnimated:YES completion:nil];
};
    
[self presentViewController:vc animated:YES completion:nil];
```




## Credits

Thanks for [Jason Harwig](https://github.com/jharwig) for his great [PPSSignatureView](https://github.com/jharwig/PPSSignatureView).