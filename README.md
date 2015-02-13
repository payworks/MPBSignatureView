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
// some styles display the scheme and merchant name
config.merchantName = @"Antiques + Valuables GmbH";
config.scheme = MPBSignatureViewControllerConfigurationSchemeMaestro;
MPBMposUIStyleSignatureViewController *vc = [[MPBMposUIStyleSignatureViewController alloc] initWithConfiguration: config];
vc.continueBlock = ^(UIImage *signature) {
   // if you use the payworks mPOS SDK, continue the transaction with
   // [paymentProcess continueWithCustomerSignature:signature verified:YES];
};
vc.cancelBlock =^{
   // if you use the payworks mPOS SDK, continue the transaction with
   // [paymentProcess continueWithCustomerSignature: nil verified: NO];
};
    
[self presentViewController:vc animated:YES completion:nil];
```

## Styles

* `MPBMposUIStyleSignatureViewController`

![signature view](https://bytebucket.org/payworks/mpos.ios.blocks.signatureview/raw/bc411f7f2cb451ebf61736a82ac8034e4388801a/screen3.png "Signature View")


* `MPBDefaultStyleSignatureViewController`

![signature view](https://bytebucket.org/payworks/mpos.ios.blocks.signatureview/raw/bc411f7f2cb451ebf61736a82ac8034e4388801a/screen1.png "Signature View")


## Display as a modal on the iPad

![signature view modal](https://bytebucket.org/payworks/mpos.ios.blocks.signatureview/raw/bc411f7f2cb451ebf61736a82ac8034e4388801a/screen2.png "Signature View Modal")

```objectivec
self.signatureViewController.modalPresentationStyle = UIModalPresentationFormSheet;
// to adjust the size, use self.signatureViewController.preferredContentSize = CGSizeMake(800, 500);
```

## Custom Style

You can also create a custom style in your storyboard:

![storyboard](https://bytebucket.org/payworks/mpos.ios.blocks.signatureview/raw/bc411f7f2cb451ebf61736a82ac8034e4388801a/screen4.png "Storyboard")


1. Create a View Controller in your storyboard.
2. Enter `MPBCustomStyleSignatureViewController` as Custom Class.
3. Create the following UI elements in your view controller and wire it with the respective properties:
	- A 'continue' button (`continueButton`) to continue with the signature
	- A 'cancel' button (`cancelButton`) to cancel the transaction
	- A 'clear' button (`clearButton`) that allows the shopper to enter a new signature
	- A label that shows the amount that is due (`formattedAmountLabel`)
	- A label that shows legal text ("I hereby authorize...") (`legalTextLabel`)
	- A UIView where the shopper should enter his/her signature (`signatureView`)
	- Optional: A label that shows the merchant name (`merchantNameLabel`)
	- Optional: An image view that shows the merchant's logo (`merchantImageView`)
	- Optional: An image view that displays the scheme used (`schemeImageView`)
4. Give this view a Storyboard ID. Use this storyboard id to instantiate your view controller:

```objectivec
MPBCustomStyleSignatureViewController *vc = (MPBCustomStyleSignatureViewController *)[self.storyboard instantiateViewControllerWithIdentifier:identifier];
// ... continue as with the other examples
```

## Credits

Thanks for [Jason Harwig](https://github.com/jharwig) for his great [PPSSignatureView](https://github.com/jharwig/PPSSignatureView).
