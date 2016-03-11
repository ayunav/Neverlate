//
//  NLTimeAndDatePickerView.h
//  neverlate
//
//  Created by Eric Sze on 11/13/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "NLUser.h"

@interface NLTimeAndDatePickerView : UIView <FSCalendarDelegate, FSCalendarDataSource>

@property (weak, nonatomic) IBOutlet UIView *calendarViewContainer;

@property (weak, nonatomic) IBOutlet UIView *buttonViewContainer;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) void (^setButtonHandler)(NSDate *calendarDate, NSDate *datePickerDate);
@property (nonatomic, strong) void (^cancelButtonHandler)();

@property (nonatomic) NLGoal *goal;

@property (strong, nonatomic) FSCalendar *calendar;

@end
