//
//  SimpleDatePicker.m
//  Sberbank
//
//  Created by Valentin Rep on 13/06/14.
//  Copyright (c) 2014 Igor Bespaljko. All rights reserved.
//

#import "SimpleDatePicker.h"


static const float ANIMATION_DURATION	= 0.25;
static const float ANIMATION_DELAY		= 0.0;


@interface SimpleDatePicker ()

@property (nonatomic, weak) UIViewController *holderViewController;
@property (nonatomic, weak) id<SimpleDatePickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnOK;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, assign) NSInteger pointStartY;
@property (nonatomic, assign) NSInteger pointEndY;

@end


@implementation SimpleDatePicker

# pragma mark - Init

+ (void)presentInViewController:(UIViewController *)viewController withDelegate:(id<SimpleDatePickerDelegate>)delegate dateMin:(NSDate *)dateMin andDateMax:(NSDate *)dateMax
{
	SimpleDatePickerOwner *owner = [SimpleDatePickerOwner new];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:owner options:nil];
    
	
	owner.decoupledView.frame = CGRectZero;
    owner.decoupledView.holderViewController = viewController;
    owner.decoupledView.delegate = delegate;
	
	if ( dateMin )
	{
		owner.decoupledView.datePicker.minimumDate = dateMin;
	}
	
	if ( dateMax )
	{
		owner.decoupledView.datePicker.maximumDate = dateMax;
	}
	
    [viewController.view addSubview:owner.decoupledView];
	
	[owner.decoupledView loadView];
}

+ (void)presentTimePickerInViewController:(UIViewController *)viewController withDelegate:(id<SimpleDatePickerDelegate>)delegate
{
    SimpleDatePickerOwner *owner = [SimpleDatePickerOwner new];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:owner options:nil];
    
    
    owner.decoupledView.frame = CGRectZero;
    owner.decoupledView.holderViewController = viewController;
    owner.decoupledView.delegate = delegate;
    owner.decoupledView.datePicker.datePickerMode = UIDatePickerModeTime;
    owner.decoupledView.datePicker.timeZone = [NSTimeZone localTimeZone];
    
    [viewController.view addSubview:owner.decoupledView];
    
    [owner.decoupledView loadView];
}


# pragma mark - Setup TableViewCell from nib

- (void)loadView
{
	float viewHeight = _datePicker.frame.size.height + _toolbar.frame.size.height;
	float viewWidth = _holderViewController.view.frame.size.width;
	
	_pointStartY	= _holderViewController.view.frame.size.height;
	_pointEndY		= _pointStartY - viewHeight;
	
	self.frame = (CGRect){ 0, _pointStartY, viewWidth, viewHeight };
	
	
	_btnCancel.title = @"Cancel";
	_btnOK.title = @"OK";
	
    
//    NSString *localeIdentifier = [[Localized prefferedLocalization] isEqualToString:@"sr"] ? @"sr-Latn" : [Localized prefferedLocalization];
//    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
	
	[self slideIn];
}


# pragma mark - Slide animations

- (void)slideIn
{
	[UIView
	 animateWithDuration:ANIMATION_DURATION
	 delay:ANIMATION_DELAY
	 options:UIViewAnimationOptionBeginFromCurrentState
	 animations:^
	 {
         self.frame = CGRectMake(self.frame.origin.x, _pointEndY, self.frame.size.width, self.frame.size.height);
	 }
	 completion:^(BOOL finished)
	 {
		 [self datePickerDidShow];
	 }
	];
}

- (void)slideOut
{
	[UIView
	 animateWithDuration:ANIMATION_DURATION
	 delay:ANIMATION_DELAY
	 options:UIViewAnimationOptionBeginFromCurrentState
	 animations:^
	 {
         self.frame = CGRectMake(self.frame.origin.x, _pointStartY, self.frame.size.width, self.frame.size.height);
	 }
	 completion:^(BOOL finished)
	 {
		 [self removeFromSuperview];
	 }
	];
}


# pragma mark - SimpleDatePicker Delegate

- (void)datePickerDidShow
{
	if ( [_delegate respondsToSelector:@selector(simpleDatePickerSelectedDate)] )
	{
		NSDate *date = [_delegate simpleDatePickerSelectedDate];
		_datePicker.date = date;
	}
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender
{
	if ( [_delegate respondsToSelector:@selector(simpleDatePickerValueChanged:)] )
	{
		[_delegate simpleDatePickerValueChanged:sender.date];
	}
}

- (IBAction)actionBtnCancel:(UIBarButtonItem *)sender
{
	if ( [_delegate respondsToSelector:@selector(simpleDatePickerDidDismiss)] )
	{
		[_delegate simpleDatePickerDidDismiss];
	}
	
	[self slideOut];
}

- (IBAction)actionBtnOK:(UIBarButtonItem *)sender
{
    if (_datePicker.datePickerMode == UIDatePickerModeTime && [_delegate respondsToSelector:@selector(simpleDatePickerDidDismissWithTime:)]) {
        [_delegate simpleDatePickerDidDismissWithTime:_datePicker.date];
    }
    else if ( [_delegate respondsToSelector:@selector(simpleDatePickerDidDismissWithDate:)] )
	{
		[_delegate simpleDatePickerDidDismissWithDate:_datePicker.date];
	}
	
	[self slideOut];
}

@end


@implementation SimpleDatePickerOwner
@end
