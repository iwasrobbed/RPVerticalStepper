RPVerticalStepper
=================

![Stepper Example](https://s3.amazonaws.com/iwasrobbed/open+source/rpverticalstepper.png)

A simple vertical stepper control for iOS that is similar in function to the UIStepper control.  Personally, I think it was short-sighted of Apple to only release a horizontal stepper control, so this was created to remedy that.

Note: **RPVerticalStepper** is a subclass of **UIControl** so it inherits all characteristics of a typical control object.

## Options ##
* Uses floats so your output can be either a float value or you can change the precision (via **NSString**'s `stringWithFormat` method) to show it as whole number.
* Set minimum & maximum values for the stepper.  When the stepper reaches either of these limits, it automatically disables the button and prevents the user from surpassing the limit.
* Turn on auto-repeat to keep incrementing/decrementing the value for as long as the user's pressing on the button.
* Change the auto-repeat interval so that the stepper will change faster or slower.
* You can add the control to a NIB/Storyboard or you can add it to the subview programmatically.

## Public Properties (that you can override) ##
* `value` (CGFloat, defaults to 1) : The current value of the stepper control
* `minimumValue` (CGFloat, defaults to 1) : The minimum value the stepper value can be before the decrement button is disabled
* `maximumValue` (CGFloat, defaults to 99) : The maximum value the stepper value can be before the increment button is disabled
* `stepValue` (CGFloat, defaults to 1) : The amount that the `value` is changed by when the increment or decrement buttons are pressed
* `autoRepeat` (BOOL, defaults to `YES`) : Sets whether the stepper should keep changing the value for as long as the user's finger is pressed down on the control
* `autoRepeatInterval` (CGFloat, defaults to 0.5 seconds) : Sets the interval at which auto-repeat should change the stepper value

## Change Callback Options ##
* Use the control in the standard way and hook up an `IBAction` to the `Value Changed` event in Interface Builder
* Or have your view controller conform to the `RPVerticalStepperDelegate` protocol and then use the `stepperValueDidChange:` method to know when the stepper value has changed 
* Both of the above methods are shown in the example project

## Quick Examples ##

The code base comes with an example project:
* **Example**: A simple example showing how to use use the stepper control in two different ways

And here is a basic example assuming you've added the control to a NIB or Storyboard file:

In the `.h` header file:

```objc
#import <UIKit/UIKit.h>
#import "RPVerticalStepper.h"

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *stepperLabel;
@property (nonatomic, weak) IBOutlet RPVerticalStepper *stepper;

@end
```

In the `.m` implementation file:

```objc
#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set some different defaults
    self.stepper.value = 1.0f;
    self.stepper.minimumValue = -100.0f;
    self.stepper.maximumValue = 100.0f;
    self.stepper.stepValue = 5.0f;
    self.stepper.autoRepeatInterval = 0.1f;
}

// This is called from the control event hooked up to the control in the Storyboard
- (IBAction)stepperDidChange:(RPVerticalStepper *)stepper
{
    self.stepperLabel.text = [NSString stringWithFormat:@"%.f", stepper.value];
}
@end
```

## License ##

Essentially, this code is free to use in commercial and non-commercial projects with no attribution necessary.

See the `LICENSE` file for more details.

## Attribution ##

Inspiration for this control from: [PAStepper](https://github.com/mperovic/PAStepper)
