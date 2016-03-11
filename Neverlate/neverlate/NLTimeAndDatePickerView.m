//
//  NLTimeAndDatePickerView.m
//  neverlate
//
//  Created by Eric Sze on 11/13/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import "NLTimeAndDatePickerView.h"

@interface NLTimeAndDatePickerView()

@property (nonatomic) UIView *lineView;

@end

@implementation NLTimeAndDatePickerView
 
- (void)awakeFromNib {
    [super awakeFromNib];
 
    [self animateViewUp:YES];
    
//    [self.datePicker setMinimumDate:[NSDate date]];

    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.calendarViewContainer.frame.size.width / 1.75, self.calendarViewContainer.frame.size.height)];
//    FSCalendar *calendar = [FSCalendar new];
//    
//    CGFloat widthOfCalendar = calendar.frame.size.width;
//    CGFloat heightOfCalendar = calendar.frame.size.height;
//    
//    CGFloat w = self.calendarViewContainer.frame.size.width;
//    CGFloat h = self.calendarViewContainer.frame.size.height;
    
    
    
//    calendar.frame = self.calendarViewContainer.frame;
    calendar.dataSource = self;
    calendar.delegate = self;
    [self.calendarViewContainer addSubview:calendar];
    self.calendar = calendar;
    self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    
    // set the calendar's current day to display the actual day (current date from pod shows 5 hours ahead (UTC)
    NSTimeInterval timezoneoffset = ([[NSTimeZone systemTimeZone] secondsFromGMT]);
    NSDate *converted = [NSDate dateWithTimeIntervalSinceNow:timezoneoffset];
    calendar.today = converted;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    
    NSLog(@"\n\n\n                                                                TODAY\n                                                                TODAY\n                                                                TODAY %@\n\n\n", [dateFormatter stringFromDate:calendar.today]);
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineView.backgroundColor = [UIColor whiteColor];
    [self.buttonViewContainer addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat lineWidth = 1.5;
    self.lineView.frame = CGRectMake(self.frame.size.width / 2.0, 0, lineWidth, 50.0);
}
//
//- (IBAction)setTimeButtonTapped:(UIButton *)sender {
//    [self didSelectTime];
//}

- (IBAction)setButtonTapped:(UIButton *)sender {
    self.setButtonHandler(self.calendar.selectedDate, self.datePicker.date);
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    self.cancelButtonHandler();
}

- (void)didSelectTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay ) fromDate:self.datePicker.date];
    NSDateComponents *timeComponents = [calendar components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:self.datePicker.date];
    
    [dateComponents setHour:[timeComponents hour]];
    [dateComponents setMinute:[timeComponents minute]];
    [dateComponents setSecond:0.0];
    
    NSDate *newDate = [calendar dateFromComponents:dateComponents];
    
    NSString *dateString =  [NSDateFormatter localizedStringFromDate:newDate
                                                           dateStyle:NSDateFormatterShortStyle
                                                           timeStyle:NSDateFormatterFullStyle];
    
//    NSArray *timeComp = [dateString componentsSeparatedByString:@", "];
//    NSArray <NSString *> *timeWithNoTimeZone = [timeComp[1] componentsSeparatedByString:@" "];
//    NSString *timeWithNoSeconds = [NSString stringWithFormat:@"%@ %@",[timeWithNoTimeZone[0] substringToIndex:timeWithNoTimeZone[0].length-3], timeWithNoTimeZone[1]];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    
    NSString *newTime = [outputFormatter stringFromDate:self.datePicker.date];
    NSDictionary *timeDictionary = @{
                                     @"newTime":newTime
                                     };
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateTimeLabel" object:timeDictionary];
}

#pragma mark - FSCalendar Datasource Method
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    NSTimeInterval timezoneoffset = ([[NSTimeZone systemTimeZone] secondsFromGMT]);
    NSDate *yourMinimumDate = [NSDate dateWithTimeIntervalSinceNow:timezoneoffset];

    NSLog(@"\n\n\n                                                                MINUMUM DATE\n                                                                MINUMUM DATE\n                                                                MINUMUM DATE %@\n\n\n", yourMinimumDate);
    return yourMinimumDate;
}
//
//- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
//{
//    return yourMaximumDate;
//}

- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:dateFormat];
    
    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
    
    return convertedString;
}

#pragma mark - FSCalendar Delegate Method
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
    NSLog(@"FSCalendar didSelectDate: %@", date);

    if (date == calendar.today) {
        [self.datePicker setMinimumDate:[NSDate date]];
    } else {
        [self.datePicker setMinimumDate:nil];
    }

    self.calendar.appearance.todayColor = [UIColor clearColor];
    self.calendar.appearance.titleTodayColor = FSCalendarStandardTodayColor;
}


- (void)animateViewUp:(BOOL) up {
    const int movementDistance = -30; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.frame = CGRectOffset(self.frame, 0, movement);
    
    [UIView commitAnimations];
}

@end
