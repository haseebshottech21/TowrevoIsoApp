//
//  NoNetworkViewController.m
//  ShareBite
//
//  Created by William Falcon on 1/15/15.
//  Copyright (c) 2015 HACStudios. All rights reserved.
//

#import "NoNetworkViewController.h"
#import "Reachability.h"

@interface NoNetworkViewController()
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (assign) BOOL originalNavigationBarState;
@end

@implementation NoNetworkViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
            
    _spinnerForNoInternet = [[UIActivityIndicatorView alloc] init];
    _spinnerForNoInternet.frame = CGRectMake(30, 10, 20, 20);
    [_spinnerForNoInternet setColor:[UIColor whiteColor]];
    
    //[self blurBackground];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //hide nav bar
    self.originalNavigationBarState = self.navigationController.navigationBar.hidden;
    self.navigationController.navigationBar.hidden = YES;
    _lblNoNetwork.text = @"Oops It seems you are not connected to the internet";
    
}

-(void)viewDidAppear:(BOOL)animated
{
   // [APP_DELEGATE.alertControllerGlobal dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    BOOL isFound = NO;
    
    for (UIViewController *viewC in self.navigationController.viewControllers) {
        
//        if ([viewC isKindOfClass:[ConversationListVC class]]) {
//
//            isFound = YES;
//        }
    }
    
    if (!isFound) {
        
//        [APP_DELEGATE ]
//        [APP_DELEGATE createSlideView];
    }
    
    //show nav bar
    self.navigationController.navigationBar.hidden = self.originalNavigationBarState;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mainActionPressed:(UIButton *)sender
{
    [sender addSubview:_spinnerForNoInternet];
    
    Reachability* reachability;
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus != NotReachable)
    {
        self.navigationController.navigationBar.hidden = self.originalNavigationBarState;
    }
    [_spinnerForNoInternet startAnimating];
    [sender setTitle:@"Wait..." forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self performSelector:@selector(waitIsOverForRefreshBtn:) withObject:sender afterDelay:4];
}

-(void) waitIsOverForRefreshBtn:(UIButton *) sender
{
    //[sender setTitle:@"Retry" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_spinnerForNoInternet stopAnimating];
}

#pragma mark - UI Utils
- (void)blurBackground {
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:effect];
    blurView.frame = self.view.bounds;
    [self.view insertSubview:blurView atIndex:0];
}

#pragma mark - Statusbar Style;

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
      return UIStatusBarStyleDefault;
}


@end






