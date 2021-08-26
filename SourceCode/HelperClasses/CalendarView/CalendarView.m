
#import "CalendarView.h"


#define WIDTH (SCREEN_WIDTH * 0.13)

NSInteger previousTag;


@interface CalendarView()

{
    
    NSCalendar *gregorian;

    
    
    
    NSInteger _UserselectedDate;
    NSInteger _UserselectedMonth;
    NSInteger _UserselectedYear;
    
    UIButton *button;
    
    BOOL isDateClicked;
    UIButton *btnLeftArrow;
    
     NSInteger TempCurrentDate, TempCurrentMonth, TempCurrentYear;
    
    BOOL isFirstTime;
    
}

@end
@implementation CalendarView
@synthesize CurrentDate;
@synthesize CurrentMonth;
@synthesize CurrentYear;
@synthesize arrCalanderData;
@synthesize _selectedMonth;
@synthesize _selectedYear;
@synthesize _selectedDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self layoutIfNeeded];
        gregorian = [NSCalendar currentCalendar];
        self.frame =CGRectMake(0, 0,self.frame.size.width , self.frame.size.height);
        
        self.center = CGPointMake(self.frame.size.width / 2, self.center.y);
        
        _UserselectedDate = 0;
        _UserselectedMonth = 0;
        _UserselectedYear = 0;
        
        isFirstTime = TRUE;
        
        isSelectDate = FALSE;
        self.backgroundColor = [UIColor clearColor];;
    }
    return self;
}

-(IBAction)OnClickDaily:(id)sender
{
    
}

- (void)drawRect:(CGRect)rect
{
    [self setCalendarParameters];
    _weekNames = @[@"M",@"T",@"W",@"T",@"F",@"S",@"S"];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    _selectedDate  =components.day;
    
    previousTag = _selectedDate;
    
    components.day = 1;
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:firstDayOfMonth];
    NSInteger weekday = [comps weekday];
    weekday  = weekday - 2;
    
    if(weekday < 0)
        weekday += 7;
    
    NSInteger columns = 7;
       
    NSInteger width = self.frame.size.width * 0.14;
    NSInteger originX = 10;
    NSInteger originY = 0;
    
    UIImageView *imgBackground = [[UIImageView alloc] init];
    imgBackground.backgroundColor = [UIColor whiteColor];
    imgBackground.frame = CGRectMake(0,0, self.frame.size.width, 40);
    imgBackground.tag = 1001;
    imgBackground.layer.borderWidth = 1.0;
    imgBackground.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    [self addSubview:imgBackground];
    
    
    
    UILabel *titleText = [[UILabel alloc]init];
    titleText.frame= imgBackground.frame;
    titleText.center = imgBackground.center;
    titleText.textAlignment = NSTextAlignmentCenter;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM, yyyy"];
    NSString *dateString = [format stringFromDate:self.calendarDate];
    [titleText setText:dateString];
    [titleText setFont:[UIFont fontWithName:@"Poppins-Regular" size:13.0]];
    [titleText setTextColor:[UIColor blackColor]];
    titleText.tag = 1002;
    [self addSubview:titleText];
    
    
    
    isDateClicked = FALSE;
    btnLeftArrow =[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeftArrow.frame =  CGRectMake(0, 7, 50, 30);
    [btnLeftArrow setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [btnLeftArrow addTarget:self action:@selector(swipeleft:) forControlEvents:UIControlEventTouchUpInside];
    btnLeftArrow.tag = 1003;
    [self addSubview:btnLeftArrow];
    
//        UIButton *btnrightArrow =[UIButton buttonWithType:UIButtonTypeCustom];
//        btnrightArrow.frame = CGRectMake(SCREEN_WIDTH - 70, 10, 50, 40);
//        [btnrightArrow setImage:[UIImage imageNamed:@"calender-right-arrow"] forState:UIControlStateNormal];
//        [btnrightArrow addTarget:self action:@selector(swiperight:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnrightArrow];
    
    
    for (int i =0; i<_weekNames.count; i++)
    {
        UIButton *weekNameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        weekNameLabel.titleLabel.text = [_weekNames objectAtIndex:i];
        [weekNameLabel setTitle:[_weekNames objectAtIndex:i] forState:UIControlStateNormal];
      [weekNameLabel setFrame:CGRectMake(originX+(width*(i%columns)), 28, width, width)];
        [weekNameLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [weekNameLabel.titleLabel setFont:[UIFont fontWithName:@"Poppins-Regular" size:15.00]];
        weekNameLabel.tag = 1004;
        weekNameLabel.userInteractionEnabled = NO;
        [self addSubview:weekNameLabel];
        
        
        
        if (i == _weekNames.count -1)
        {
            UIButton *btnrightArrow =[UIButton buttonWithType:UIButtonTypeCustom];
            btnrightArrow.frame = CGRectMake(originX+(width*(i%columns)), 7, 50, 30);
            [btnrightArrow setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
            [btnrightArrow addTarget:self action:@selector(swiperight:) forControlEvents:UIControlEventTouchUpInside];
             btnrightArrow.tag = 1005;
            [self addSubview:btnrightArrow];
        }
        
    }
    
    if (isFirstTime) {
        CurrentDate = _selectedDate;
     
        
        CurrentMonth = components.month;
        CurrentYear = components.year;
        
        

        TempCurrentDate = CurrentDate;
        TempCurrentMonth = CurrentMonth;
        TempCurrentYear = CurrentYear;
        
        isFirstTime = FALSE;
    }
    
   
    
    
    [self SetCalenderData];
  
   
    
    
}


-(void)SetCalenderData{
//    self->arrCalanderData = [[NSMutableArray alloc] init];

    
//    NSMutableDictionary *dictdata  = [[NSMutableDictionary alloc] init];
//    [dictdata setValue:@"2020-07-18" forKey:@"date"];
//    [dictdata setValue:@"0" forKey:@"trip_count"];
//    [dictdata setValue:@"1" forKey:@"event_count"];
//    [arrCalanderData addObject:dictdata];
//
//
//    NSMutableDictionary *dictdata1 = [[NSMutableDictionary alloc] init];
//    [dictdata1 setValue:@"2020-07-20" forKey:@"date"];
//    [dictdata1 setValue:@"2" forKey:@"trip_count"];
//    [dictdata1 setValue:@"1" forKey:@"event_count"];
//    [arrCalanderData addObject:dictdata1];
//
//
//
//    NSMutableDictionary *dictdata2  = [[NSMutableDictionary alloc] init];
//    [dictdata2 setValue:@"2020-07-23" forKey:@"date"];
//    [dictdata2 setValue:@"0" forKey:@"trip_count"];
//    [dictdata2 setValue:@"1" forKey:@"event_count"];
//    [arrCalanderData addObject:dictdata2];
//
//
//
//    NSMutableDictionary *dictdata3 = [[NSMutableDictionary alloc] init];
//    [dictdata3 setValue:@"2020-07-24" forKey:@"date"];
//    [dictdata3 setValue:@"3" forKey:@"trip_count"];
//    [dictdata3 setValue:@"0" forKey:@"event_count"];
//    [arrCalanderData addObject:dictdata3];
//
//
//    NSMutableDictionary *dictdata4  = [[NSMutableDictionary alloc] init];
//      [dictdata4 setValue:@"2020-07-25" forKey:@"date"];
//      [dictdata4 setValue:@"0" forKey:@"trip_count"];
//      [dictdata4 setValue:@"1" forKey:@"event_count"];
//      [arrCalanderData addObject:dictdata4];
//
//      NSMutableDictionary *dictdata5 = [[NSMutableDictionary alloc] init];
//      [dictdata5 setValue:@"2020-07-30" forKey:@"date"];
//      [dictdata5 setValue:@"2" forKey:@"trip_count"];
//      [dictdata5 setValue:@"0" forKey:@"event_count"];
//      [arrCalanderData addObject:dictdata5];

      [self viewCalanderLayout];

}


-(void)viewCalanderLayout
{
    
    for (UIView *viewRemove in [self subviews]) {
        if (viewRemove.tag != 1001 && viewRemove.tag != 1002 && viewRemove.tag != 1003 && viewRemove.tag != 1004 && viewRemove.tag != 1005) {
            [viewRemove removeFromSuperview];
        }
    }
    
    
    [self setCalendarParameters];
      _weekNames = @[@"M",@"T",@"W",@"T",@"F",@"S",@"S"];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    
    components.day = 1;
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:firstDayOfMonth];
    NSInteger weekday = [comps weekday];
    weekday  = weekday - 2;
    
    if(weekday < 0)
        weekday += 7;
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:self.calendarDate];
    
    NSInteger columns = 7;
    
    NSInteger width = self.frame.size.width * 0.14;
    NSInteger originX = 10;
    NSInteger originY = 40;
    NSInteger monthLength = days.length;
    
    
    BOOL isCurrentDateFound = FALSE;
    
    for (NSInteger i= 0; i<monthLength; i++)
    {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+1;
        button.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)i+1];
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)i+1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Poppins-Regular" size:15]];
        [button addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger offsetX = (width*((i+weekday)%columns));
        NSInteger offsetY = (width *((i+weekday)/columns));
        [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
        
        
        UIImageView *imgDateDg =[[UIImageView alloc]initWithFrame:CGRectMake(originX+offsetX+2, originY+40+offsetY+2, width-4, width-4)];
        // imgDateDg.image =[UIImage imageNamed:@"datecell"];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor clearColor];
        if(((i+weekday)/columns)==0)
        {
            [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 4)];
            [button addSubview:lineView];
        }
        
        if(((i+weekday)/columns)==((monthLength+weekday-1)/columns))
        {
            [lineView setFrame:CGRectMake(0, button.frame.size.width-4, button.frame.size.width, 4)];
            [button addSubview:lineView];
        }
        
        UIView *columnView = [[UIView alloc]init];
        [columnView setBackgroundColor:[UIColor clearColor]];
        if((i+weekday)%7==0)
        {
            [columnView setFrame:CGRectMake(0, 0, 4, button.frame.size.width)];
            [button addSubview:columnView];
        }
        else if((i+weekday)%7==6)
        {
            [columnView setFrame:CGRectMake(button.frame.size.width-4, 0, 4, button.frame.size.width)];
            [button addSubview:columnView];
        }
        
        //        NSString *strDate =[NSString stringWithFormat:@"%ld-%ld-%ld",(long)i+1,(long)components.month,(long)components.year];
        
        
        NSString *strDate;
        
        if (i<9)
        {
            
            if (components.month == 10 || components.month == 11 || components.month == 12)
            {
                strDate =[NSString stringWithFormat:@"%ld-%ld-0%ld",(long)components.year,(long)components.month,(long)i+1];
            }
            else
            {
                strDate =[NSString stringWithFormat:@"%ld-0%ld-0%ld",(long)components.year,(long)components.month,(long)i+1];
            }
        }
        else
        {
            
            if (components.month == 10 || components.month == 11 || components.month == 12)
            {
                strDate =[NSString stringWithFormat:@"%ld-%ld-%ld",(long)components.year,(long)components.month,(long)i+1];
            }
            else
            {
                strDate =[NSString stringWithFormat:@"%ld-0%ld-%ld",(long)components.year,(long)components.month,(long)i+1];
            }
            
        }
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"white-circle"] forState:UIControlStateNormal];

        
        if(i+1 ==_selectedDate && components.month == _selectedMonth && components.year == _selectedYear)
        {
            
           // [button setBackgroundImage:[UIImage imageNamed:@"calender-blue-ring"] forState:UIControlStateNormal];
            
            UIImage *img = [UIImage imageNamed:@"cal-Transperant"];
            [button setBackgroundImage: img forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
          
            if (_UserselectedDate ==0 && _UserselectedMonth ==0 && _UserselectedYear==0)
            {
                isCurrentDateFound = TRUE;
                
                NSDictionary *dictTimeSlot = @{@"selectedDate": strDate};
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"forTimeSlotAPI" object:dictTimeSlot];
                
            }
            
        }
        
        NSDateComponents *componentsTodayDate = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];

        if (i+1 == componentsTodayDate.day && components.month == componentsTodayDate.month && components.year == componentsTodayDate.year) {

            [button setEnabled:true];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        if (components.month == TempCurrentMonth && _selectedYear != TempCurrentYear)
        {
            btnLeftArrow.hidden = NO;
        }
        if (components.month != TempCurrentMonth && _selectedYear == TempCurrentYear)
        {
            btnLeftArrow.hidden = NO;
        }
        else if (components.month == TempCurrentMonth && _selectedYear == TempCurrentYear)
        {
            btnLeftArrow.hidden = NO;
        }
        
        
        BOOL isPrevisousSelected = FALSE;
        
        if (i+1 < CurrentDate && components.month == CurrentMonth && components.year == CurrentYear) {
            
            isPrevisousSelected = TRUE;
            
            [button setEnabled:true];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        
       for (int j=0; j<self->arrCalanderData.count; j++)
                 {
                     
                     NSString *strCheckDate = [[self->arrCalanderData objectAtIndex:j] valueForKey:@"date"];
                     if (([strDate isEqualToString:strCheckDate]) && (([[[self->arrCalanderData objectAtIndex:j] valueForKey:@"event_count"] intValue] > 0) || ([[[self->arrCalanderData objectAtIndex:j] valueForKey:@"trip_count"] intValue] > 0)))
                     {
                         [self->button setBackgroundImage:nil forState:UIControlStateNormal];
                         [self->button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                         
                         UILabel *lblCount =[[UILabel alloc]initWithFrame:CGRectMake(self->button.frame.size.width - 17, 5, 5, 5)];
//                         lblCount.text = [NSString stringWithFormat:@"%@",[[self->arrCalanderData objectAtIndex:j] valueForKey:@"event_count"]];
//                         lblCount.textColor = [UIColor whiteColor];
//                         lblCount.font =[UIFont fontWithName:@"ProximaNova-Regular" size:10];
                         lblCount.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:130.0/255.0 blue:242.0/255.0 alpha:1.0];
                         
                         
                         lblCount.layer.cornerRadius = lblCount.frame.size.width/2;
                         lblCount.layer.masksToBounds = YES;
                         lblCount.textAlignment =NSTextAlignmentCenter;
                         
//                         lblCount.layer.borderColor = [[UIColor whiteColor] CGColor];
//                         lblCount.layer.borderWidth = 1.5;
                         
                         
                         [self->button addSubview:lblCount];
                     }
                     
                     
//                     if (([strDate isEqualToString:strCheckDate]) && ([[[self->arrCalanderData objectAtIndex:j] valueForKey:@"trip_count"] intValue] > 0))
//                                          {
//                                              [self->button setBackgroundImage:nil forState:UIControlStateNormal];
//                                              [self->button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//                                              UILabel *lblCount =[[UILabel alloc]initWithFrame:CGRectMake(self->button.frame.size.width - 17, 8, 5, 5)];
//                     //                         lblCount.text = [NSString stringWithFormat:@"%@",[[self->arrCalanderData objectAtIndex:j] valueForKey:@"event_count"]];
//                     //                         lblCount.textColor = [UIColor whiteColor];
//                     //                         lblCount.font =[UIFont fontWithName:@"ProximaNova-Regular" size:10];
//                                              lblCount.backgroundColor = [UIColor redColor];
//
//
//                                              lblCount.layer.cornerRadius = lblCount.frame.size.width/2;
//                                              lblCount.layer.masksToBounds = YES;
//                                              lblCount.textAlignment =NSTextAlignmentCenter;
//
////                                              lblCount.layer.borderColor = [[UIColor whiteColor] CGColor];
////                                              lblCount.layer.borderWidth = 1.5;
//
//
//                                              [self->button addSubview:lblCount];
//                                          }
                     
                 }
                 
                 
                 [self->button setEnabled:YES];
//            for (int j=0; j<arrCalanderData.count; j++)
//            {
//
//                NSString *strCheckDate = [[arrCalanderData objectAtIndex:j] valueForKey:@"date"];
//                if ([strDate isEqualToString:strCheckDate])
//                {
//                    //[button setBackgroundImage:[UIImage imageNamed:@"calender-grey-round"] forState:UIControlStateNormal];
//
//                    if (isPrevisousSelected == FALSE) {
//                         UILabel *lblCount =[[UILabel alloc]initWithFrame:CGRectMake(self->button.frame.size.width - 17, 2, 15, 15)];
//
//
//                        lblCount.text = [NSString stringWithFormat:@"%@",[[self->arrCalanderData objectAtIndex:j] valueForKey:@"total_job"]];
//                        lblCount.textColor = [UIColor whiteColor];
//                        lblCount.font =[UIFont fontWithName:AppFont_Regular size:10];
//                        lblCount.backgroundColor = APP_COLOR;
//                        lblCount.layer.cornerRadius = lblCount.frame.size.width/2;
//                        lblCount.layer.masksToBounds = YES;
//                        lblCount.textAlignment =NSTextAlignmentCenter;
//                        lblCount.layer.borderColor = [[UIColor whiteColor] CGColor];
//                        lblCount.layer.borderWidth = 1.5;
//                        if (isSelectDate == false){
//                            [self->button addSubview:lblCount];
//                        } else {
//                            if (![[[arrCalanderData objectAtIndex:j] valueForKey:@"date"] isEqualToString:[[arrCalanderData objectAtIndex:Index] valueForKey:@"date"]]){
//                                [self->button addSubview:lblCount];
//                            }
//                        }
//
//                        if ([[[self->arrCalanderData objectAtIndex:j] valueForKey:@"date"] isEqualToString:[Singleton getCurrentDateCalender]]){
//                            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//                        } else {
//
//                            [button setTitleColor:APP_COLOR forState:UIControlStateNormal];
//                        }
//
//
//                    }
//                }
//            }
        
        
        if(i+1 ==_UserselectedDate && components.month == _UserselectedMonth && components.year == _UserselectedYear)
        {
            
            NSString *strDate1 = [NSString stringWithFormat:@"%ld",(long)_UserselectedDate];
            if ([strDate1 length] == 1)
            {
                strDate1 = [NSString stringWithFormat:@"0%@",strDate1];
            }
            
            
            NSString *strMonth = [NSString stringWithFormat:@"%ld",(long)_UserselectedMonth];
            if ([strMonth length] == 1)
            {
                strMonth = [NSString stringWithFormat:@"0%@",strMonth];
            }
            
            
            NSString *strFinalString = [NSString stringWithFormat:@"%ld-%@-%@",(long)_UserselectedYear,strMonth,strDate1];
            
            NSDictionary *dictTimeSlot = @{@"selectedDate": strFinalString};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"forTimeSlotAPI" object:dictTimeSlot];
          
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setBackgroundImage:[UIImage imageNamed:@"CalenderSelect"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            UILabel *lblCount =[[UILabel alloc]initWithFrame:CGRectMake(8, self->button.frame.size.height - 12, width - 16, 4)];
            lblCount.textColor = [UIColor blackColor];
           // lblCount.backgroundColor = [UIColor blackColor];
            [self->button addSubview:lblCount];
            
        }
        
        
        [self addSubview:imgDateDg];
        [self addSubview:button];
        
    }
    
//    if (isDateClicked == FALSE)
//    {
//        if (isCurrentDateFound == FALSE)
//        {
//            NSDictionary *dictTimeSlot = @{@"selectedDate": @"",
//                                           @"date" : @""};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"forTimeSlotAPI" object:dictTimeSlot];
//
//        }
//
//        isDateClicked = FALSE;
//    }
//
    
    NSDictionary *dictData = @{@"CalHeight" : [NSString stringWithFormat:@"%f",button.frame.origin.y + button.frame.size.height]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalender" object:dictData];
    
    
    NSDateComponents *previousMonthComponents = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    previousMonthComponents.month -=1;
    NSDate *previousMonthDate = [gregorian dateFromComponents:previousMonthComponents];
    NSRange previousMonthDays = [c rangeOfUnit:NSCalendarUnitDay
                                        inUnit:NSCalendarUnitMonth
                                       forDate:previousMonthDate];
    NSInteger maxDate = previousMonthDays.length - weekday;
    
    
    for (int i=0; i<weekday; i++) {
        UIButton *buttonDay = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonDay.titleLabel.text = [NSString stringWithFormat:@"%d",maxDate+i+1];
        [buttonDay setTitle:[NSString stringWithFormat:@"%d",maxDate+i+1] forState:UIControlStateNormal];
        NSInteger offsetX = (width*(i%columns));
        NSInteger offsetY = (width *(i/columns));
        [buttonDay setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
        //        [button.layer setBorderWidth:2.0];
        //        [button.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
        UIView *columnView = [[UIView alloc]init];
        [columnView setBackgroundColor:[UIColor clearColor]];
        if(i==0)
        {
            [columnView setFrame:CGRectMake(0, 0, 4, buttonDay.frame.size.width)];
            [buttonDay addSubview:columnView];
        }
        
        UIView *lineView = [[UIView alloc]init];
        [lineView setBackgroundColor:[UIColor clearColor]];
        [lineView setFrame:CGRectMake(0, 0, buttonDay.frame.size.width, 4)];
        [buttonDay addSubview:lineView];
        [buttonDay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [buttonDay.titleLabel setFont:[UIFont fontWithName:@"Poppins-Regular" size:13]];
        [buttonDay setEnabled:NO];
        [self addSubview:buttonDay];
    }
    
    NSInteger remainingDays = (monthLength + weekday) % columns;
    CGFloat Ycount = 0;
    
    if(remainingDays >0){
        for (NSInteger i=remainingDays; i<columns; i++) {
            UIButton *buttonRemainDays = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonRemainDays.titleLabel.text = [NSString stringWithFormat:@"%d",(i+1)-remainingDays];
            [buttonRemainDays setTitle:[NSString stringWithFormat:@"%d",(i+1)-remainingDays] forState:UIControlStateNormal];
            NSInteger offsetX = (width*((i) %columns));
            NSInteger offsetY = (width *((monthLength+weekday)/columns));
            [buttonRemainDays setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
            //            [button.layer setBorderWidth:2.0];
            //            [button.layer setBorderColor:[[UIColor redColor] CGColor]];
            UIView *columnView = [[UIView alloc]init];
            [columnView setBackgroundColor:[UIColor clearColor]];
            if(i==columns - 1)
            {
                [columnView setFrame:CGRectMake(buttonRemainDays.frame.size.width-4, 0, 4, buttonRemainDays.frame.size.width)];
                [buttonRemainDays addSubview:columnView];
            }
            UIView *lineView = [[UIView alloc]init];
            [lineView setBackgroundColor:[UIColor clearColor]];
            [lineView setFrame:CGRectMake(0, buttonRemainDays.frame.size.width-4, buttonRemainDays.frame.size.width, 4)];
            [buttonRemainDays addSubview:lineView];
            [buttonRemainDays setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonRemainDays.titleLabel setFont:[UIFont fontWithName:@"Poppins-Regular" size:13]];
            [buttonRemainDays setEnabled:NO];
            [self addSubview:buttonRemainDays];
            
            Ycount = Ycount + buttonRemainDays.frame.size.height;
            
        }
        
    }
    
}

- (void)selectDateClick: (NSDate *)dateToBeSelected{

    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekdayOrdinal) fromDate:dateToBeSelected];
    
     _selectedDate = components.day;
        _selectedMonth = components.month;
        _selectedYear = components.year;
        
        _UserselectedDate = components.day;
        _UserselectedMonth = components.month;
        _UserselectedYear = components.year;
        NSString *strFinalString;
        if(_UserselectedMonth == 10 || _UserselectedMonth == 11 || _UserselectedMonth == 12)
        {
            NSString *inStr = [NSString stringWithFormat: @"%ld", (long)_UserselectedDate];
            if (inStr.length == 1){
                strFinalString = [NSString stringWithFormat:@"%ld-%ld-0%ld",(long)_UserselectedYear,(long)_UserselectedMonth,(long)_UserselectedDate];
            } else {
                strFinalString = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)_UserselectedYear,(long)_UserselectedMonth,(long)_UserselectedDate];
            }
            
        } else
        {
         
            NSString *inStr = [NSString stringWithFormat: @"%ld", (long)_UserselectedDate];
            if (inStr.length == 1){
                 strFinalString = [NSString stringWithFormat:@"%ld-0%ld-0%ld",(long)_UserselectedYear,(long)_UserselectedMonth,(long)_UserselectedDate];
            } else {
                 strFinalString = [NSString stringWithFormat:@"%ld-0%ld-%ld",(long)_UserselectedYear,(long)_UserselectedMonth,(long)_UserselectedDate];
            }
           
        }

  
        
        isDateClicked = TRUE;
        [self viewCalanderLayout];
}

-(IBAction)tappedDate:(UIButton *)sender {
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    _selectedDate = sender.tag;
    
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekdayOrdinal) fromDate:self.calendarDate];
    components.day = _selectedDate;
 
    _selectedMonth = components.month;
    _selectedYear = components.year;
    
    _UserselectedDate = sender.tag;
    _UserselectedMonth = components.month;
    _UserselectedYear = components.year;
    NSString *strFinalString;
    if(_UserselectedMonth == 10 || _UserselectedMonth == 11 || _UserselectedMonth == 12)
    {
        NSString *inStr = [NSString stringWithFormat: @"%ld", (long)_UserselectedDate];
        if (inStr.length == 1){
            strFinalString = [NSString stringWithFormat:@"%ld-%ld-0%ld",(long)_UserselectedYear,(long)_UserselectedMonth,(long)_UserselectedDate];
        } else {
            strFinalString = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)_UserselectedYear,(long)_UserselectedMonth,(long)_UserselectedDate];
        }
        
    } else
    {
     
        NSString *inStr = [NSString stringWithFormat: @"%ld", (long)_UserselectedDate];
        if (inStr.length == 1){
             strFinalString = [NSString stringWithFormat:@"%ld-0%ld-0%ld",(long)_UserselectedYear,(long)_UserselectedMonth,(long)_UserselectedDate];
        } else {
             strFinalString = [NSString stringWithFormat:@"%ld-0%ld-%ld",(long)_UserselectedYear,(long)_UserselectedMonth,(long)_UserselectedDate];
        }
       
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"calendarDateIsChanged" object:nil];

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:strFinalString];
//
//    NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
//    [weekDay setDateFormat:@"EEE"];
//
//    NSDateFormatter *finaldateformat = [[NSDateFormatter alloc] init];
//    [finaldateformat setDateFormat:@"yyyy-MM-dd"];
//    NSString *finalString = [finaldateformat stringFromDate:date];
//    NSLog(@"%@ %@",finalString,[weekDay stringFromDate:date]);
    
    isDateClicked = TRUE;
//    NSString *currentDate = [self getCurrentDateCalender];
//    if (![currentDate isEqualToString:finalString]){
        [self viewCalanderLayout];
//    }
//    NSString *final = [NSString stringWithFormat:@"%@ %@",[weekDay stringFromDate:date],finalString];
//
//     NSString *temp = [NSString stringWithFormat:@"%ld-0%ld-%ld",(long)_UserselectedYear,(long)_UserselectedMonth,(long)_UserselectedDate+1];
//    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date1 = [dateFormatter1 dateFromString:temp];
//    NSInteger getIndex = [[arrCalanderData valueForKey:@"date"] indexOfObject:strFinalString];
//    Index = [[arrCalanderData valueForKey:@"date"] indexOfObject:strFinalString];
//    if (getIndex == NSNotFound) {
//        isSelectDate = FALSE;
//       [_delegate tappedOnDate:final date:date1 countAvaliable:@"NOCOUNT" jobsCount:@""];
//    } else {
//        if ([_isData isEqualToString:@"true"]){
//            NSString * count = [[arrCalanderData objectAtIndex:getIndex] valueForKey:@"total_job"];
//            NSLog(@"COUNT%@",count);
//            isSelectDate = TRUE;
//            [_delegate tappedOnDate:final date:date1 countAvaliable:@"COUNT" jobsCount:count];
//        } else{
//            isSelectDate = FALSE;
//            [_delegate tappedOnDate:final date:date1 countAvaliable:@"NOCOUNT" jobsCount:@""];
//        }
//    }
//
    

}


- (NSString *) getCurrentDateCalender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dt = [NSDate date];
    NSString * strCurrentTime = [formatter stringFromDate:dt];
    return strCurrentTime;
    
}

-(IBAction)swipeleft:(id)sender
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = 1;
    components.month -= 1;
    
    if (components.month == TempCurrentMonth && components.year == TempCurrentYear) {
        
        
        CurrentDate = TempCurrentDate;
        CurrentMonth = TempCurrentMonth;
        CurrentYear = TempCurrentYear;
    }
    
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
    
    CurrentMonth = components.month;
    CurrentYear = components.year;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCalenderMonthList" object:nil];

    
    
}

-(IBAction)swiperight:(id)sender
{
    
//    CurrentDate = 0;
//    CurrentMonth = 0;
//    CurrentYear = 0;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    
    
    
    components.day = 1;
    components.month += 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
    
    CurrentMonth = components.month;
    CurrentYear = components.year;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCalenderMonthList" object:nil];

    
}


-(void)setCalendarParameters
{
    if(gregorian == nil)
    {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        _selectedDate  = components.day;
        _selectedMonth = components.month;
        _selectedYear = components.year;
    }
}

@end
