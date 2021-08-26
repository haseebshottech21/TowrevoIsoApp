//
//  PullToRefresh.m
//  GeneralProject
//
//  Created by HimAnshu on 07/05/18.
//  Copyright © 2018 vrinsoft. All rights reserved.
//

#import "PullToRefresh.h"
#import "LGRefreshView.h"

#pragma mark - GlobalBlock Here
@implementation PullToRefresh {
    
}
+(PullToRefresh *)sharedInstance{
    static PullToRefresh *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc]init];
    });
    
    return _sharedInstance;
}

-(void)addNewPullToRefreshView:(UIScrollView*)scrollView controller:(UIViewController*)controll withCallBack:(void (^)(BOOL success, LGRefreshView * refreshView))callback{
    LGRefreshView * refreshView;
    
    for (UIView * subview in scrollView.subviews) {
        if ([subview isKindOfClass:[LGRefreshView class]]) {
            refreshView = (LGRefreshView *)subview;
            break;
        }
    }
    
    if (!refreshView) {
        __weak typeof(self) wself = self;
        refreshView = [LGRefreshView refreshViewWithScrollView:scrollView refreshHandler:^(LGRefreshView *refreshView) {
            if (wself) {
                callback(true, refreshView);
            }
        }];
        
        if (self.tintColor) {
            refreshView.tintColor = self.tintColor;
        } else {
            refreshView.tintColor = [UIColor darkGrayColor];
        }
        
        refreshView.backgroundColor = [UIColor clearColor];
    }
}

-(void)EndNewRefreshview:(LGRefreshView *)refreshView  {
    [refreshView endRefreshing];
}
@end

