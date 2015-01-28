## Simple, beautiful payment signatures on iOS

![signature view](https://bytebucket.org/payworks/mpos.ios.blocks.signatureview/raw/aebcac7eb49056e7da8e6fcd6138c233ed3d1830/screen1.png "Signature View")

Works perfectly with the mPOS SDK by [payworks](http://www.payworksmobile.com). Learn how to integrate a card reader in your app at [payworks.mpymnt.com](http://www.payworks.mpymnt.com).

## Install

    pod repo add mpymnt http://pods.mpymnt.com/io.mpymnt.repo.pods.git

In your podfile:

    pod 'mpos.blocks.signature'

## Use

Import the header

    #import <mpos.blocks.signature/MPBSignatureViewController.h>

Show it and register callbacks

```objectivec
MPBDefaultStyleSignatureViewController* signatureViewController =
    [[MPBDefaultStyleSignatureViewController alloc]initWithConfiguration:[MPBSignatureViewControllerConfiguration configurationWithMerchantName:@"Fruit Shop" formattedAmount:@"5.99 €"]];
[self presentViewController:signatureViewController animated:YES completion:nil];
[signatureViewController registerOnPay:^{
    UIImage* signature = [signatureViewController signature];  
   // if you use the payworks mPOS SDK, continue the transaction with
   // [paymentProcess continueWithCustomerSignature:signature verified:YES];
} onCancel:^{
   // if you use the payworks mPOS SDK, continue the transaction with
   // [paymentProcess continueWithCustomerSignature: nil verified: NO];
}];
```

## Display as a modal on the iPad

![signature view modal](https://bytebucket.org/payworks/mpos.ios.blocks.signatureview/raw/aebcac7eb49056e7da8e6fcd6138c233ed3d1830/screen2.png "Signature View Modal")

```objectivec
self.signatureViewController.modalPresentationStyle = UIModalPresentationFormSheet;
// to adjust the size, use self.signatureViewController.preferredContentSize = CGSizeMake(800, 500);
```

## Credits

Thanks for [Jason Harwig](https://github.com/jharwig) for his great [PPSSignatureView](https://github.com/jharwig/PPSSignatureView).