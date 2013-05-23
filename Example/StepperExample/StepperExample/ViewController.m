//
//  ViewController.m
//  StepperExample
//
//  Created by Rob Phillips on 5/23/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // This sets the delegate for the stepper that uses the delegate method for updating it's value
    self.stepperViaDelegate.delegate = self;
    
    // Set some different defaults for the delegated stepper
    self.stepperViaDelegate.value = 5.0f;
    self.stepperViaDelegate.minimumValue = -100.0f;
    self.stepperViaDelegate.maximumValue = 100.0f;
    self.stepperViaDelegate.stepValue = 5.0f;
    self.stepperViaDelegate.autoRepeatInterval = 0.1f;
    
    // Set some different defaults for the standard stepper
    self.stepper.value = 1.0f;
    self.stepper.autoRepeat = NO;
}

#pragma mark - Delegate Method

// This is the optional delegate callback method
- (void)stepperValueDidChange:(RPVerticalStepper *)stepper
{
    self.stepperViaDelegateLabel.text = [NSString stringWithFormat:@"%.f", stepper.value];
}

#pragma mark - Standard Method

// This is called from the control event hooked up to the control in the Storyboard
- (IBAction)stepperDidChange:(RPVerticalStepper *)stepper
{
    self.stepperLabel.text = [NSString stringWithFormat:@"%.f", stepper.value];
}
@end
