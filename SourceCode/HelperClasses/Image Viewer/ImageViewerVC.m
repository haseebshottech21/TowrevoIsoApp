//
//  ImageViewerVC.m
//  MobileCrm
//
//  Created by ADMIN on 2/5/15.
//  Copyright (c) 2015 Piyush. All rights reserved.
//

#import "ImageViewerVC.h"
#import "UIImageView+WebCache.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#define VIEW_FOR_ZOOM_TAG (1)
#define SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define SCREEN_HEIGHT UIScreen.mainScreen.bounds.size.height

@interface ImageViewerVC ()

@end

@implementation ImageViewerVC
@synthesize strUrlOpen,arrayForAttachments,fileName;
@synthesize tagSelected;
#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self setupNavigationBar];
    NSLog(@"%@",arrayForAttachments);
    
    isPageCalled = FALSE;
    
    self.pageDetailImages.userInteractionEnabled = false;
    self.pageDetailImages.numberOfPages = arrayForAttachments.count;
  //  self.pageDetailImages.numberOfPages = 5;
    
    self->PageControlleractiveImage = [UIImage imageNamed:@"tab bg2"];
    self->PageControllerinactiveImage = [UIImage imageNamed:@"size-box"];
    
       // [self.pageDetailImages setPageIndicatorTintColor:[UIColor lightGrayColor]];
      // [self.pageDetailImages setCurrentPageIndicatorTintColor:[UIColor blackColor]];
    
    
    if (arrayForAttachments.count <= 1) {
       // self.pageDetailImages.hidden = true;
    } else {
      //  self.pageDetailImages.hidden = false;
    }
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupNavigationBar];
}
- (void) setupNavigationBar {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [scrollForDetailImg setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    
    self.navigationController.navigationBar.translucent = false;
    
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];

    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.hidesBackButton = NO;
    
    [self.navigationItem setTitle:_strTitle];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
    NSFontAttributeName:[UIFont fontWithName:@"NunitoSans-Regular" size:17]}];

    UIBarButtonItem *myNavSave = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_arrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackPress:)];
  
    myNavSave.tintColor = [UIColor blackColor];
    
    [myNavSave setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"NunitoSans-Regular" size:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName, nil]  forState:UIControlStateNormal];
    
    UIBarButtonItem *myNavBird = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"birdNavigation"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.navigationItem setRightBarButtonItem:myNavBird];
    [self.navigationItem setLeftBarButtonItem:myNavSave];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    
    if (isPageCalled == FALSE) {
        
        int x=0;
        
        int Xcordinate = 0;
        
        NSString *dataPath;
        for (UIView *v in scrollForDetailImg.subviews) {
            
            [v removeFromSuperview];
        }
        
        
        for (i = 0; i < [arrayForAttachments count]; i++) {
            
            
            if (i == [tagSelected integerValue])
            {
                Xcordinate = x;
            }
            
            scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(x,0,SCREEN_WIDTH,SCREEN_HEIGHT-scrollForDetailImg.frame.origin.y -60)];
            scroll.backgroundColor = [UIColor clearColor];
            scroll.delegate = self;
            
            UIImageView *asyncImg = [[UIImageView alloc] init];
            
            asyncImg.frame=CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-scrollForDetailImg.frame.origin.y-60);
            
            asyncImg.tag=1;
            
            if ([[arrayForAttachments objectAtIndex:i] isKindOfClass:[UIImage class]]) { // UIImages
                
                spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                spinner.frame = CGRectMake(asyncImg.frame.size.width/2-4,asyncImg.frame.size.height/2-5, 10, 10);
                [spinner startAnimating];
                [asyncImg addSubview:spinner];
                
                
                [asyncImg sd_setImageWithURL:nil placeholderImage:[arrayForAttachments objectAtIndex:i]];
                [spinner stopAnimating];
                
                
            }else{ // NSString
                
                NSString *strUrl=[arrayForAttachments objectAtIndex:i];
                
                spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                spinner.frame = CGRectMake(asyncImg.frame.size.width/2-4,asyncImg.frame.size.height/2-5, 10, 10);
                [spinner startAnimating];
                [asyncImg addSubview:spinner];
                
                strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                
                [asyncImg sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:nil  options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [spinner stopAnimating];
                }];
            }
            
            asyncImg.contentMode = UIViewContentModeScaleAspectFit;
            
            if ([[[_arrayForAttachmentsComparision objectAtIndex:i] valueForKey:@"image_type"] integerValue] == 0) {
                
                scroll.minimumZoomScale = scroll.frame.size.width / asyncImg.frame.size.width;
                scroll.maximumZoomScale = 3.0;
                
                [btnPlay setHidden:true];
            }
            else{
                
                scroll.minimumZoomScale = 0.0;
                scroll.maximumZoomScale = 0.0;
                
                [btnPlay setHidden:false];
                
                asyncImg.contentMode = UIViewContentModeScaleAspectFill;
                asyncImg.clipsToBounds = true;
            }
            
            
            [scroll setZoomScale:scroll.minimumZoomScale];
            
            [scroll addSubview:asyncImg];
            [scrollForDetailImg addSubview:scroll];
            
            x+=SCREEN_WIDTH;
        }
        
        [scrollForDetailImg setContentOffset:CGPointMake(Xcordinate, 0) animated:NO];
        
        scrollForDetailImg.contentSize=CGSizeMake(x,SCREEN_HEIGHT-scrollForDetailImg.frame.origin.y - 150);
        
        self.pageDetailImages.currentPage =  [tagSelected integerValue];
        [self updateDots];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
        [scrollForDetailImg addGestureRecognizer:swipe];
        
        isPageCalled = TRUE;
    }
    
   
    
}

//-(IBAction)btnPlayVideo:(id)sender{
//
//    NSString *strVideo = [[_arrayForAttachmentsComparision objectAtIndex:self.pageDetailImages.currentPage] valueForKey:@"video_url"];
//
//    NSURL  *videoURL = [NSURL URLWithString:strVideo];
//    if ([strVideo length] != 0) {
//
//        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
//        AVPlayer *player = [[AVPlayer alloc] initWithURL:videoURL];
//        controller.player = player;
//        [self.navigationController presentViewController:controller animated:true completion:^{
//
//        }];
//    }
//}

-(void)handleSwipeDown : (UISwipeGestureRecognizer *)recognizer{
    [self closeView];
    
}

-(void)closeView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


CGPoint _lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger indexCurrent = scrollView.contentOffset.x/SCREEN_WIDTH;
    NSLog(@"%ld",indexCurrent);
    self.pageDetailImages.currentPage =  indexCurrent;
    
    if ([[[_arrayForAttachmentsComparision objectAtIndex:indexCurrent] valueForKey:@"image_type"] integerValue] == 0) {
        
        [btnPlay setHidden:true];
    }
    else{
        
        [btnPlay setHidden:false];
    }
    
    [self updateDots];
    
    if (_lastContentOffset.x < (int)scrollView.contentOffset.x) {
        NSLog(@"Scrolled Right");
    }
    
    else if (_lastContentOffset.x > (int)scrollView.contentOffset.x) {
        NSLog(@"Scrolled Left");
    }
    
    else if (_lastContentOffset.y < scrollView.contentOffset.y) {
        NSLog(@"Scrolled Down");
    }
    
    else if (_lastContentOffset.y > scrollView.contentOffset.y) {
        NSLog(@"Scrolled Up");
    }
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll1 andUIView:(UIView *)rView {
    CGSize boundsSize = scroll1.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    
    return frameToCenter;
}


#pragma Update UISegment Control Selected Images
-(void) updateDots
{
    for (int i = 0; i < [self.pageDetailImages.subviews count]; i++)
    {
        UIImageView * dot = [self imageViewForSubview:  [self.pageDetailImages.subviews objectAtIndex: i]];
        if (i == self.pageDetailImages.currentPage)
            dot.image = self->PageControlleractiveImage;
        else dot.image = self->PageControllerinactiveImage;
    }
}

- (UIImageView *)imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            
            subview.backgroundColor = [UIColor clearColor];
            
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    
    dot.backgroundColor = [UIColor clearColor];
    dot.tintColor = [UIColor clearColor];
    dot.superview.backgroundColor = [UIColor clearColor];
    dot.superview.tintColor = [UIColor clearColor];
    
    
    return dot;
}


//-(void)downloadWithNsurlconnection:(NSString *)strZipURL
//{
//
//    NSString *post = strZipURL;
//    NSLog(@"@====>>> %@", post);
//
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//
//
//    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@explore.php",MAINURL]]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//
//    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (theConnection)
//    {
//        self.responseData = [NSMutableData data];
//    }
//    else
//        NSLog(@"Connection Failed!");
//
//
//}


//- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//
//     [self.responseData setLength:0];
//
//    progress.hidden = NO;
//
//    expectedBytes = [response expectedContentLength];
//}
//
//- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    [receivedData appendData:data];
//    float progressive = (float)[receivedData length] / (float)expectedBytes;
//    [progress setProgress:progressive];
//
//
//}
//
//- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//
//}
//
//- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:    (NSCachedURLResponse *)cachedResponse {
//    return nil;
//}
//
//- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:[currentURL stringByAppendingString:@".mp3"]];
//    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [receivedData writeToFile:pdfPath atomically:YES];
//    progress.hidden = YES;
//}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView1 {
    return [scrollView1 viewWithTag:VIEW_FOR_ZOOM_TAG];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView1 {
    
    [scrollView1 viewWithTag:VIEW_FOR_ZOOM_TAG].frame = [self centeredFrameForScrollView:scrollView1 andUIView:[scrollView1 viewWithTag:VIEW_FOR_ZOOM_TAG]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

//- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll1 andUIView:(UIView *)rView {
//    CGSize boundsSize = scroll1.bounds.size;
//    CGRect frameToCenter = rView.frame;
//
//    // center horizontally
//    if (frameToCenter.size.width < boundsSize.width) {
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    }
//    else {
//        frameToCenter.origin.x = 0;
//    }
//
//    // center vertically
//    if (frameToCenter.size.height < boundsSize.height) {
//        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
//    }
//    else {
//        frameToCenter.origin.y = 0;
//    }
//
//    return frameToCenter;
//}

- (IBAction)onClickCloseBtn:(id)sender
{
    //  [TblPictureAmenities reloadData];
    
    //isadd=FALSE;
    viewForScroll.hidden=YES;
}

- (NSMutableArray *) listFileAtPath:(NSString *) path
{
    int count;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    NSMutableArray *arrImage = [[NSMutableArray alloc] init];
    
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        if ([[directoryContent objectAtIndex:count] containsString:@".png"] || [[directoryContent objectAtIndex:count] containsString:@".jpeg"] || [[directoryContent objectAtIndex:count] containsString:@".JPG"] || [[directoryContent objectAtIndex:count] containsString:@".JPEG"] || [[directoryContent objectAtIndex:count] containsString:@".jpg"] || [[directoryContent objectAtIndex:count] containsString:@".PNG"]) {
            
            [arrImage addObject:[directoryContent objectAtIndex:count]];
        }
    }
    return arrImage;
}




#pragma mark -
#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    webview.scrollView.maximumZoomScale = 20; // set similar to previous.
}

#pragma mark -
#pragma mark - UIWebView Delegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    theWebView.scrollView.delegate = self; // set delegate method of UISrollView
    theWebView.scrollView.maximumZoomScale = 20; // set as you want.
    theWebView.scrollView.minimumZoomScale = 1; // set as you want.
    
    
    threadProgressView.hidden = YES;
    lblProcessCount.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  //  SHOW_ALERT_WITH_CAUTION(@"Your file is not load successfully")
    
    threadProgressView.hidden = YES;
    lblProcessCount.hidden = YES;
    
    [spinner stopAnimating];
}

#pragma mark -
#pragma mark - Others Methods

-(IBAction)btnBackPress:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - viewWillDisappear Methods

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   
    [spinner stopAnimating];
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
//    NSError *error;
//    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
//    if (success) {
//        NSLog(@"Delete file");
//
//    }
//    else
//    {
//        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
//    }
}

#pragma mark -
#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
