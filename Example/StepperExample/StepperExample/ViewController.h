//
//  ViewController.h
//  StepperExample
//
//  Created by Rob Phillips on 5/23/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPVerticalStepper.h"

@interface ViewController : UIViewController <RPVerticalStepperDelegate>

@property (nonatomic, weak) IBOutlet UILabel *stepperViaDelegateLabel;
@property (nonatomic, weak) IBOutlet RPVerticalStepper *stepperViaDelegate;

@property (nonatomic, weak) IBOutlet UILabel *stepperLabel;
@property (nonatomic, weak) IBOutlet RPVerticalStepper *stepper;

@end
