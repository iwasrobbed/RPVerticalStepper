//
//  RPVerticalStepper.h
//  RPVerticalStepper
//
//  Created by Rob Phillips on 2/25/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// These constants define the control frame of 35.0 width and 63.0 height
float const kRPStepperWidth = 35.0;
float const kRPStepperTopButtonHeight = 31.0;
float const kRPStepperBottomButtonHeight = 32.0;
float const kRPStepperHeight = kRPStepperTopButtonHeight + kRPStepperBottomButtonHeight;

#import "RPVerticalStepper.h"

@interface RPVerticalStepper () {
	UIButton *incrementButton;
	UIButton *decrementButton;
}
@end

@implementation RPVerticalStepper

#pragma mark - Control Lifecycle

// Called when the RPVerticalStepper control is set up programmatically
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kRPStepperWidth, kRPStepperHeight)];
    if (self) [self setDefaultState];
    return self;
}

// Called when a control subclass of RPVerticalStepper is placed in a NIB file
- (void)awakeFromNib
{
    [self setDefaultState];
}

// Don't allow the control frame to change sizes
- (void)setFrame:(CGRect)frame
{
	[super setFrame:CGRectMake(frame.origin.x, frame.origin.y, kRPStepperWidth, kRPStepperHeight)];
}

// Sets up the default state of the stepper control
- (void)setDefaultState
{
    // Setup defaults for the public properties
	_value = 1;
	_minimumValue = 1;
	_maximumValue = 99;
	_stepValue = 1;
	self.autoRepeat = YES;
	_autoRepeatInterval = 0.5;
    
    // Set background color for the control area
    self.backgroundColor = [UIColor clearColor];
    
    // Init the increment button
    incrementButton = [self stepperButtonWithFrame:CGRectMake(0.0, 0.0, kRPStepperWidth, kRPStepperTopButtonHeight)
                                      bgImageNamed:@"stepperTopButton.png"
                                        imageNamed:@"stepperPlusSymbol"];
	[self addSubview:incrementButton];
    
	// Init the decrement button
    decrementButton = [self stepperButtonWithFrame:CGRectMake(0.0, kRPStepperTopButtonHeight, kRPStepperWidth, kRPStepperBottomButtonHeight)
                                      bgImageNamed:@"stepperBottomButton.png"
                                        imageNamed:@"stepperMinusSymbol"];
	[self addSubview:decrementButton];
    
    // Check if we need to enable/disable a button
    [self checkButtonInteraction];
}

#pragma mark - Buttons

// Creates a stepper button
- (UIButton *)stepperButtonWithFrame:(CGRect)frame bgImageNamed:(NSString *)bgImageName imageNamed:(NSString *)imageName
{
    UIButton *stepperButton = [[UIButton alloc] initWithFrame:frame];
    [stepperButton setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
	[stepperButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	[stepperButton setAutoresizingMask:UIViewAutoresizingNone];
    [stepperButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchDown];
    [stepperButton addTarget:self action:@selector(didEndButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    return stepperButton;
}

#pragma mark - Custom Property Setters

- (void)setMinimumValue:(CGFloat)minValue
{
	if (minValue > _maximumValue) {
		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
												  reason:@"RPVerticalStepper: Minimum value cannot be greater than the maximum value."
												userInfo:nil];
		@throw ex;
	}
	
	_minimumValue = minValue;
}

- (void)setStepValue:(CGFloat)stepValue
{
	if (stepValue <= 0) {
		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
												  reason:@"RPVerticalStepper: Step value cannot be less than or equal to zero."
												userInfo:nil];
		@throw ex;
	}
	
	_stepValue = stepValue;
}

- (void)setMaximumValue:(CGFloat)maxValue
{
	if (maxValue < _minimumValue) {
		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
												  reason:@"RPVerticalStepper: Maximum value cannot be less than the minimum value."
												userInfo:nil];
		@throw ex;
	}
	
	_maximumValue = maxValue;
}

- (void)setValue:(CGFloat)val
{
    if (val < _minimumValue)
        val = _minimumValue;
    else if (val > _maximumValue)
        val = _maximumValue;
	_value = val;
    
    // Check if we need to enable/disable a button
    [ self checkButtonInteraction];
    
    // Send out a change notification and call the delegate method
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if ([self.delegate respondsToSelector:@selector(stepperValueDidChange:)])
        [self.delegate stepperValueDidChange:self];
}

- (void)setAutoRepeatInterval:(CGFloat)autoRepeatInterval
{
	if (autoRepeatInterval > 0.0)
		_autoRepeatInterval = autoRepeatInterval;
	else if (autoRepeatInterval == 0) {
		_autoRepeatInterval = autoRepeatInterval;
		self.autoRepeat = NO;
	}
}

#pragma mark - Button Actions & States

// Handles updating stepper value and checking if we should auto-repeat or not
- (void)didPressButton:(UIButton *)button
{
    [self changeValueForButton:button];
    
    if (self.autoRepeat)
        [self performSelector:@selector(didPressButton:) withObject:button afterDelay:self.autoRepeatInterval];
}

// Cancels any auto-repeat requests
- (void)didEndButtonPress:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

// Check if new value would exceed max or min; if it doesn't, set the new value
- (void)changeValueForButton:(UIButton *)button
{
	double changeValue = (button == decrementButton) ? -1 * _stepValue : _stepValue;
	double newValue = _value + changeValue;
	if (newValue < _minimumValue || newValue > _maximumValue) return;
	[self setValue:newValue];
}

// Check if values are at a max or min and show a "disabled" state if necessary
- (void)checkButtonInteraction
{
    BOOL atMax = (_value == _maximumValue);
    BOOL atMin = (_value == _minimumValue);
    
    [incrementButton setUserInteractionEnabled:!atMax];
    [incrementButton setAlpha:(atMax ? 0.5 : 1.0)];
    [decrementButton setUserInteractionEnabled:!atMin];
    [decrementButton setAlpha:(atMin ? 0.5 : 1.0)];
}

@end
