//
//  LocationService.m
//  GeneralProject
//


#import "LocationService.h"
#import "SourceCode-Bridging-Header.h"

@implementation LocationService
+(LocationService *)shared{
    static LocationService *_shared = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

-(void)startLocationServiceWithParentView:(UIViewController *)parentView UsageType:(LocationUsageType)usageType Accuracy:(LocationAccuracyType)accuracy allowBackgroundChanges:(BOOL)allowBackgroundChanges updateDuration:(float)duration withBlock:(LocationServiceBlock)block {
    
    self.parentView = parentView;
    self.usageType = usageType;
    self.accuracy = accuracy;
    blockLocation = block;
    self.allowBackgroundChanges = allowBackgroundChanges;
    
    if (self.manager) {
        [self.manager stopUpdatingHeading];
        [self.manager stopUpdatingLocation];
        [self.manager stopMonitoringSignificantLocationChanges];
        self.manager = nil;
    }

    if ([self CheckLocationPermissionWithSourceView:parentView]) {
        self.manager = [[CLLocationManager alloc]init];
        CLLocationAccuracy locAccuracy = [self getAccuracyFromSelectedAccuracy:accuracy];
        
        self.manager.activityType = CLActivityTypeAutomotiveNavigation;
        self.manager.desiredAccuracy = locAccuracy;
        
        float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (sysVer >= 8.0) {
            if (usageType == kUsageAccessWhileUsingTheApp) {
                [self.manager requestWhenInUseAuthorization];
                if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [self.manager requestWhenInUseAuthorization];
                }
            } else {
                [self.manager requestAlwaysAuthorization];
                if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                    [self.manager requestAlwaysAuthorization];
                }
            }
        }
        
        if (sysVer >= 9.0) {
            if (allowBackgroundChanges) {
                self.manager.allowsBackgroundLocationUpdates = true;
            } else {
                self.manager.allowsBackgroundLocationUpdates = false;
            }
        }
        
        self.manager.delegate = self;
        
        [self.manager startMonitoringSignificantLocationChanges];
        [self.manager startUpdatingLocation];
        
        if ([CLLocationManager headingAvailable]) {
            self.manager.headingFilter = 5;
            [self.manager startUpdatingHeading];
        }
        
        self.userLocation = self.manager.location.coordinate;
        if (self.userLocation.latitude !=  00.00000 && self.userLocation.latitude !=  00.0000000 ) {
            blockLocation(true, self.userLocation, self.manager.heading.trueHeading);
        }
        
        if (duration > 0) {
            timerObserver = [NSTimer scheduledTimerWithTimeInterval:duration repeats:true block:^(NSTimer * _Nonnull timer) {
                [self getCurrentLocation];
            }];
        } else {
            timerObserver = [NSTimer scheduledTimerWithTimeInterval:10.0 repeats:true block:^(NSTimer * _Nonnull timer) {
                if (self.userLocation.latitude !=  00.00000 && self.userLocation.latitude !=  00.00000) {
                    [self->timerObserver invalidate];
                } else {
                    [self getCurrentLocation];
                }
            }];
        }
    }
}

-(void)getCurrentLocationWithCallback:(LocationServiceBlock)Callback {
    blockLocation = Callback;
    [self getCurrentLocation];
}

- (void)requestWhenInUseAuthorization {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        //Will Show the screen for Enable GPS
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestWhenInUseAuthorization];
    }
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        //Will Show the screen for Enable GPS
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestAlwaysAuthorization];
    }
}

-(CLLocationAccuracy)getAccuracyFromSelectedAccuracy:(LocationAccuracyType)accuracy {
    if (accuracy == kLocationAccuracyBestForNavigation) {
        return kCLLocationAccuracyBestForNavigation;
    } else if (accuracy == kLocationAccuracyBest) {
        return kCLLocationAccuracyBest;
    } else if (accuracy == kLocationAccuracyNearestTenMeters) {
        return kCLLocationAccuracyNearestTenMeters;
    } else if (accuracy == kLocationAccuracyHundredMeters) {
        return kCLLocationAccuracyNearestTenMeters;
    } else if (accuracy == kLocationAccuracyKilometer) {
        return kCLLocationAccuracyKilometer;
    } else if (accuracy == kLocationAccuracyThreeKilometers) {
        return kCLLocationAccuracyThreeKilometers;
    } else {
        return kCLLocationAccuracyBest;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
//    CLLocation *location = [locations lastObject];
//    CLLocationCoordinate2D tempUserLocation = location.coordinate;
//    if (self.userLocation.latitude != tempUserLocation.latitude && self.userLocation.longitude != tempUserLocation.longitude) {
//        self.userLocation = tempUserLocation;
//        blockLocation(true, self.userLocation.latitude, self.userLocation.longitude);
//    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
//    blockLocation(false, CLLocationCoordinate2DMake(-1, -1), newHeading.trueHeading);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //Location Service Fails here
}

-(void)stopLcationService {
    if (self.manager) {
        [self.manager stopUpdatingHeading];
        [self.manager stopUpdatingLocation];
        [self.manager stopMonitoringSignificantLocationChanges];
        self.manager = nil;
    }
    
    [timerObserver invalidate];
    timerObserver = nil;
}

-(void)getCurrentLocation {
    if ([self CheckLocationPermissionWithSourceView:self.parentView]) {
        if (self.manager) {
            [self.manager startUpdatingLocation];
            self.userLocation = self.manager.location.coordinate;
            if (self.userLocation.latitude !=  00.00000 && self.userLocation.latitude !=  00.0000000 ) {
                blockLocation(true, self.userLocation, self.manager.heading.trueHeading);
            } else {
                blockLocation(false, CLLocationCoordinate2DMake(00.00, 00.00), -999);
            }
        } else {
            blockLocation(false, CLLocationCoordinate2DMake(00.00, 00.00), -999);
        }
    }
}

-(NSString *)stepsToInclude {
    return @"Step 1 : Import LocationService Class first. \n\nStep 2 : In Info.plist add location usage permission descripiton for following keys : \n      A) Privacy - Location Always and When In Use Usage Description (When Using Background Changes)\n      B) Privacy - Location Always Usage Description\n      C) Privacy - Location Usage Description\n      D) Privacy - Location When In Use Usage Description \n\nStep 3 : Call InitWithParent view funcitoin with apropriate input parameters. \n\nStep 4 : You may got location coordinate data directly in it's block \n\nStep 5 : If using Background, In Capabilities enables the background mode, inside the background modes chack Location Updates";
}

-(BOOL)CheckLocationPermissionWithSourceView:(UIViewController *)sourceView {
    
    BOOL isValid = FALSE;
    
    if(![CLLocationManager locationServicesEnabled])
    {
        NSString *strLocationAlert = [NSString stringWithFormat:@"Turn On Location Services to Allow \"%@\" to Determine Your Location", @"Location Services"];
        
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Tappoo"
                                     message:strLocationAlert
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Settings"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [sourceView presentViewController:alert animated:YES completion:nil];
        
        isValid = FALSE;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        
        NSString *strMessages = [NSString stringWithFormat:@"If you only allow access to your location while you are using the app, some features may not work while this app is in the background."];
        
        
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:[NSString stringWithFormat:@"Tappoo"]
                                     message:strMessages
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* whileUsingApp = [UIAlertAction
                                        actionWithTitle:@"Only While Using the App"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                        }];
        
        UIAlertAction* AlwaysAllow = [UIAlertAction
                                      actionWithTitle:@"Always Allow"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {
                                          
                                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                      }];
        
        
        UIAlertAction* DoNotAllow = [UIAlertAction
                                     actionWithTitle:@"Don't Allow"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         
                                     }];
        
        
        [alert addAction:whileUsingApp];
        [alert addAction:AlwaysAllow];
        [alert addAction:DoNotAllow];
        
        [sourceView presentViewController:alert animated:YES completion:nil];
        
        isValid = FALSE;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        isValid = true;
    }
    else
    {
        isValid = TRUE;
    }
    
    return isValid;
}


//-(void)findAddressForCoordinate:(CLLocationCoordinate2D)location WithCallback:(void (^) (BOOL success, NSDictionary * dictAddress))callback{
//    NSString * lattitude = [NSString stringWithFormat:@"%f",location.latitude];
//    NSString * longitude = [NSString stringWithFormat:@"%f",location.longitude];
//
//    [APP_DELEGATE.apiManager findAddressUsingLocationCoordinate:location withCallBack:^(BOOL success, NSDictionary *result, NSString *error) {
//        if (success){
//            NSString * title = result[@"title"];
//            NSString * fullAddress = result[@"fullAddress"];
//            callback(true, @{@"title":title,@"fullAddress":fullAddress,@"lattitude":lattitude,@"longitude":longitude});
//        } else {
//            [[GMSGeocoder geocoder] reverseGeocodeCoordinate:location completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
//                if (response.results.count > 0){
//                    GMSAddress* addressObj =  response.firstResult;
//                    NSString * fullAddress = @"";
//                    NSString * titles = addressObj.addressLine1;
//                    for (NSString * title in addressObj.lines){
//                        fullAddress = [fullAddress stringByAppendingString:title];
//                    }
//
//                    callback(true, @{@"title":titles,@"fullAddress":fullAddress,@"lattitude":lattitude,@"longitude":longitude});
//                } else {
//                    callback(false, @{@"title":@"",@"fullAddress":@"",@"lattitude":lattitude,@"longitude":longitude});
//                }
//            }];
//        }
//    }];
//}



-(void)findAdressUsingLocation:(CLLocationCoordinate2D)location withCallback:(void (^) (NSString * localTitle, NSString * localFulladress))callback{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:[[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
            callback(@"", @"");
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            
            NSString * title = @"";
            NSString * fullAdress = @"";
            if (placemark.name) {
                if (fullAdress.length > 0) {
                    fullAdress = [NSString stringWithFormat:@"%@, %@", fullAdress, placemark.name];
                } else {
                    fullAdress = placemark.name;
                }
                
                if (title.length > 0) {
                    title = [NSString stringWithFormat:@"%@, %@", title, placemark.name];
                } else {
                    title = placemark.name;
                }
            }
            if (placemark.thoroughfare) {
                if (fullAdress.length > 0) {
                    fullAdress = [NSString stringWithFormat:@"%@, %@", fullAdress, placemark.thoroughfare];
                } else {
                    fullAdress = placemark.thoroughfare;
                }
            }
            if (placemark.subLocality) {
                if (fullAdress.length > 0) {
                    fullAdress = [NSString stringWithFormat:@"%@, %@", fullAdress, placemark.subLocality];
                } else {
                    fullAdress = placemark.subLocality;
                }
                
                if (title.length > 0) {
                    title = [NSString stringWithFormat:@"%@, %@", title, placemark.subLocality];
                } else {
                    title = placemark.subLocality;
                }
            }
            if (placemark.locality) {
                if (fullAdress.length > 0) {
                    fullAdress = [NSString stringWithFormat:@"%@, %@", fullAdress, placemark.locality];
                } else {
                    fullAdress = placemark.locality;
                }
                
                if (title.length > 0) {
                    title = [NSString stringWithFormat:@"%@, %@", title, placemark.locality];
                } else {
                    title = placemark.locality;
                }
            }
            if (placemark.administrativeArea) {
                if (fullAdress.length > 0) {
                    fullAdress = [NSString stringWithFormat:@"%@, %@", fullAdress, placemark.administrativeArea];
                } else {
                    fullAdress = placemark.administrativeArea;
                }
            }
            if (placemark.country) {
                if (fullAdress.length > 0) {
                    fullAdress = [NSString stringWithFormat:@"%@, %@", fullAdress, placemark.country];
                } else {
                    fullAdress = placemark.country;
                }
                
            }
            if (placemark.postalCode) {
                if (fullAdress.length > 0) {
                    fullAdress = [NSString stringWithFormat:@"%@, %@", fullAdress, placemark.postalCode];
                } else {
                    fullAdress = placemark.postalCode;
                }
            }
            
            callback(title, fullAdress);
        }
    }];
}

-(double)findeDistanceFromPickup:(CLLocationCoordinate2D)pick Destination:(CLLocationCoordinate2D)dest {
    MKMapPoint point1 = MKMapPointForCoordinate(pick);
    MKMapPoint point2 = MKMapPointForCoordinate(dest);
    float distance = MKMetersBetweenMapPoints(point1, point2);
    return distance;
}

@end
