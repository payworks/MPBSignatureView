![signature view](https://bitbucket.org/payworks/mpos.ios.blocks.signatureview/raw/b9bb9a553242d9a5150f4b20cda018abaf04644d/screen.png "Signature View")

The payment blocks are made available on our CocoaPod podspec repository. To use the payment blocks, add 
http://pods.mpymnt.com/mpymnt/io.mpymnt.repo.pods.git
as a custom pod repository. If you want to add it using the name 'mpymnt', you could just execute

    pod repo add mpymnt http://pods.mpymnt.com/io.mpymnt.repo.pods.git

## SignatureView

The SignatureView enables you to capture a customer's signature drawn on the touch screen of an iOS device and receive it as an UIImage. The SignatureView can either be integrated as an UIView in your existing controller or presented modally using the predefined signature controller.

### Prepare your project

To use the SignatureView in your project, you should have an Xcode project with CocoaPods (http://cocoapods.org) available. Make sure you have added the mpos payment blocks specs repository. Then, create your podfile for the dependencies 

    platform :ios, '6.1'
    pod 'mpos.blocks.signature', '~> 1.2.0'

Running `pod install` might take a while, since the Cocos2d framework, on which the signature view depends has about 450 MB which have to be downloaded. Don't worry, this will not all be compiled into your app.

### Use the predefined signature screen

To start right away, you can use the predefined view controller which shows a signature screen with some information to the user. To capture a signature, create a PWBSignatureViewController instance first.

```objectivec
MPBSignatureViewController* signatureViewController = [[MPBSignatureViewController alloc]init];
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