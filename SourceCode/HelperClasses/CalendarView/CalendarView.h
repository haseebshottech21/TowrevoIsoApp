

#import <UIKit/UIKit.h>

@protocol CalendarDelegate <NSObject>

@optional
-(void)tappedOnDate:(NSString *)selectedDate date:(NSDate *)Date countAvaliable:(NSString *)Count jobsCount:(NSString *)datecount;
-(void)dataNofound:(NSString *)data;
@end

@interface CalendarView : UIView
{
    
    NSArray *_weekNames;
    
    BOOL isAdvanceBookDate;
    BOOL isSelectDate;
    NSInteger Index;
    UIButton *imgUpperBlack;
    
    
    
}
@property NSString *isRedirect, *isData;
+ (NSString *) getCurrentDateCalender;
@property (nonatomic,strong) NSDate *calendarDate;
@property (nonatomic,weak) id<CalendarDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *arrCalanderData;

@property NSInteger CurrentDate, CurrentMonth, CurrentYear,  _selectedMonth, _selectedYear, _selectedDate;


- (void)selectDateClick: (NSDate *)dateToBeSelected;
-(void)SetCalenderData;

@end
