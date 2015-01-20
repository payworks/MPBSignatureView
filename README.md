![signature view](https://bitbucket.org/payworks/mpos.ios.blocks.signatureview/raw/b9bb9a553242d9a5150f4b20cda018abaf04644d/screen.png "Signature View")

Works perfectly with the mPOS SDK by [payworks](http://www.payworksmobile.com)  Learn how to integrate a card reader in your app at [payworks.mpymnt.com](http://www.payworks.mpymnt.com).

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
    } onCancel:^{
    }];
```

Now, customize logo, title, amount and text beneath the signature line to match your application.

```objectivec
signatureViewController.merchantName = @"Fruit Shop";
signatureViewController.amountText = @"5.99 €";
signatureViewController.signatureText = @"Signature";
signatureViewController.signatureColor = [UIColor darkGrayColor];
signatureViewController.payButtonText = @"Pay now";
signatureViewController.cancelButtonText = @"Cancel";
```

You can even further customize the colors and fonts of the view, take a look at the properties `largeFont`, `mediumFont`, `smallFont` as well as `colorLine` and `colorBackground`.

Now, register blocks to be executed once the pay or cancel buttons are pressed. You can access the user's signature by calling the signature method of the view controller.

```objectivec
[signatureViewController registerOnPay:^{  
    UIImage* signature = [signatureViewController signature];
    [signatureViewController dismissViewControllerAnimated:YES completion:nil];
} onCancel:^{
    [signatureViewController dismissViewControllerAnimated:YES completion:nil]; 
}];
```

To capture the signature, you just have to present the view controller

```objectivec
[self presentViewController:signatureViewController animated:YES completion:nil];
```

### Use the signature field in a custom controller

If you only want to use the field which captures the signature without any of the additional UI components of the predefined signature view, you have to proceed as follows.

First, open the header file of the controller which should hold the signature field and make your view controller extend MPBSignatureFieldViewController

```objectivec
@interface MyViewController : MPBSignatureFieldViewController
```

Since the smooth displaying of the drawn signature depends on OpenGL, code has to be executed in your controller and the signature field cannot be added as a simple UIView. But we still tried to make it as convenient as possible!

Next, you have to specify the location where your signature field is supposed to be created on the view. In your view controller's implementation file, create the signature field in the viewDidLoad method, you can either use a UIView from your storyboard connected to the controller using an IBOutlet

```objectivec
@property (weak, nonatomic) IBOutlet UIView *mySigView;

// ...

 - (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSignatureFieldWithView:self.mySigView];
}
```

or specify the signature field's location using a CGRect frame.

```objectivec
 - (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSignatureFieldWithView:CGRectMake(0,0,100,100)];
}
```

By extending MPBSignatureFieldViewController, you can now access the following methods in your view controller:

```objectivec
 - (void)clearSignature;
 - (UIImage*)signature;
 - (void)tearDownSignatureField;
```

The clearSignature method removes all current lines on the signature field and leaves an white empty signature field to the user.

The additional tearDownSignatureField method should be called whenever the controller containing the signature field is finally destroyed to release all resources used by the drawing framework.

## Credits

The OpenGL graphics for displaying the signature in real time are handled by the Cocos2d framework. (http://www.cocos2d-iphone.org)

The signature drawing heavily depends on Krzysztof Zablockis smooth drawing library for Cocos2d and his CCNode+SFGestureRecognizer category. Credits for the drawing go to him. Check out his blog at http://merowing.info and the github project of the smooth drawing library at https://github.com/krzysztofzablocki/smooth-drawing

Also, thanks to Alexander Mack for his contributions concerning the line drawer events.