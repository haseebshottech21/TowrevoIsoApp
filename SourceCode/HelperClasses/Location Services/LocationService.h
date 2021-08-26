//
//  LocationService.h
//  GeneralProject
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef void (^LocationServiceBlock)(BOOL success, CLLocationCoordinate2D userLocation, CLLocationDirection trueHeading);

typedef enum LOCATION_USAGE_TYPE{
    kUsageAccessWhileUsingTheApp,
    kUsageAccessAlways
}LocationUsageType;

typedef enum LOCATION_ACCURACY_TYPE{
    kLocationAccuracyBestForNavigation,
    kLocationAccuracyBest,
    kLocationAccuracyNearestTenMeters,
    kLocationAccuracyHundredMeters,
    kLocationAccuracyKilometer,
    kLocationAccuracyThreeKilometers
}LocationAccuracyType;

@interface LocationService : NSObject <CLLocationManagerDelegate>{
    LocationServiceBlock blockLocation;
    NSTimer * timerObserver;
}

+ (LocationService *)shared;

@property CLLocationManager * manager;
@property CLLocationCoordinate2D userLocation;

@property UIViewController *parentView;
@property LocationUsageType usageType;
@property LocationAccuracyType accuracy;
@property BOOL allowBackgroundChanges;

@property (readonly) NSString * stepsToInclude;

-(void)getCurrentLocation;

-(void)startLocationServiceWithParentView:(UIViewController *)parentView UsageType:(LocationUsageType)usageType Accuracy:(LocationAccuracyType)accuracy allowBackgroundChanges:(BOOL)allowBackgroundChanges updateDuration:(float)duration withBlock:(LocationServiceBlock)block;

-(void)stopLcationService;

-(void)findAdressUsingLocation:(CLLocationCoordinate2D)location withCallback:(void (^) (NSString * localTitle, NSString * localFulladress))callback;

-(double)findeDistanceFromPickup:(CLLocationCoordinate2D)pick Destination:(CLLocationCoordinate2D)dest;
-(void)getCurrentLocationWithCallback:(LocationServiceBlock)Callback;
-(BOOL)CheckLocationPermissionWithSourceView:(UIViewController *)sourceView;
@end
