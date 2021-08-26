//
//  NoNetworkViewController.h
//  ShareBite
//
//  Created by William Falcon on 1/15/15.
//  Copyright (c) 2015 HACStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoNetworkViewController : UIViewController
@property (strong, nonatomic) UIActivityIndicatorView *spinnerForNoInternet;
@property (strong, nonatomic) IBOutlet UILabel *lblNoNetwork;


@end
