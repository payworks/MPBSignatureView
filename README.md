![signature view](https://bitbucket.org/payworks/mpos.ios.blocks.signatureview/raw/b9bb9a553242d9a5150f4b20cda018abaf04644d/screen.png "Signature View")

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
MPBSignatureViewController* signatureViewController = [[MPBSignatureViewController alloc]init];
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

Customize merchant name, amount and approval text:

```objectivec
signatureViewController.merchantName = @"Fruit Shop";
signatureViewController.amountText = @"5.99 €";
signatureViewController.signatureText = @"I hereby authorize the payment of 5.99 € to Fruit Shop.";
```