//
//  ImageViewerVC.h
//  MobileCrm
//
//  Created by ADMIN on 2/5/15.
//  Copyright (c) 2015 Piyush. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>


@interface ImageViewerVC : UIViewController<UIWebViewDelegate, UIScrollViewDelegate>
{
    
    IBOutlet UIScrollView *scrollView,*scrollForDetailImg;
    UIScrollView *scroll;
    IBOutlet UILabel *lblTitle;
    
    IBOutlet UIWebView *webview;
    
    int i;
    
    NSMutableData *receivedData;
    NSString *fileName;
    NSURL *baseURL;
    NSString *savedFilePath;
    
    UIProgressView *threadProgressView;

    int currentSelectedPhto;
    UIImageView *imgViewSlideImages;
    UIButton *btnForIndicator;
    NSMutableArray *arrayForSliderIndicator;
    NSMutableArray *arrayForTitle;
    
    UILabel *lblProcessCount;
    UIActivityIndicatorView *spinner;
    
    IBOutlet UIView *viewForScroll;
    
   // long *expectedBytes;
    
    UIImage *PageControlleractiveImage;
    UIImage *PageControllerinactiveImage;
    
    IBOutlet UIButton *btnPlay;
    
    BOOL isPageCalled;
}

@property (strong, nonatomic) IBOutlet UIPageControl *pageDetailImages;

@property (readonly) int64_t expectedBytes;

@property (strong, nonatomic) NSMutableData *responseData;

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic,retain) NSString *strUrlOpen;
@property (nonatomic, strong) NSMutableArray *arrayForAttachments;

@property (nonatomic, strong) NSMutableArray *arrayForAttachmentsComparision;


@property (nonatomic,retain) NSString *tagSelected;
@property (nonatomic,retain) NSString *strTitle;



-(IBAction)btnBackPress:(id)sender;

@end
