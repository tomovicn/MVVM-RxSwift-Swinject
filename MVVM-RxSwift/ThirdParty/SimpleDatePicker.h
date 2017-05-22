//
//  SimpleDatePicker.h
//  Sberbank
//
//  Created by Valentin Rep on 13/06/14.
//  Copyright (c) 2014 Igor Bespaljko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimpleDatePickerDelegate <NSObject>

- (void)simpleDatePickerValueChanged:(NSDate *)date;

- (void)simpleDatePickerDidDismissWithDate:(NSDate *)date;
- (void)simpleDatePickerDidDismiss;

@optional
- (NSDate *)simpleDatePickerSelectedDate;
- (void)simpleDatePickerDidDismissWithTime:(NSDate *)date;

@end

@interface SimpleDatePicker : UIView

+ (void)presentInViewController:(UIViewController *)viewController withDelegate:(id<SimpleDatePickerDelegate>)delegate dateMin:(NSDate *)dateMin andDateMax:(NSDate *)dateMax;
+ (void)presentTimePickerInViewController:(UIViewController *)viewController withDelegate:(id<SimpleDatePickerDelegate>)delegate;
@end


@interface SimpleDatePickerOwner : NSObject

@property (nonatomic, weak) IBOutlet SimpleDatePicker *decoupledView;

@end


