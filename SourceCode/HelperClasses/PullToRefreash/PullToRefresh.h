//
//  PullToRefresh.h
//  GeneralProject
//
//  Created by HimAnshu on 07/05/18.
//  Copyright © 2018 vrinsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LGRefreshView/LGRefreshView.h>



@interface PullToRefresh : NSObject
{
    UIViewController *getController;
    
}

@property(nonatomic,retain)LGRefreshView *refreshView;
+ (PullToRefresh *)sharedInstance;
@property UIColor * tintColor;

//-(void)addPullToRefreshView:(UIScrollView*)scrollView controller:(UIViewController*)controll withCallBack:(void (^)(BOOL success))callback;
//-(void)EndRefreshview;


-(void)addNewPullToRefreshView:(UIScrollView*)scrollView controller:(UIViewController*)controll withCallBack:(void (^)(BOOL success, LGRefreshView * refreshView))callback;
-(void)EndNewRefreshview:(LGRefreshView *)refreshView;


//-(void)stopRefreshview;

@end

