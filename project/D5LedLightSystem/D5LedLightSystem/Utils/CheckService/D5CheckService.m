//
//  D5CheckService.m
//  D5Home_new
//
//  Created by 黄斌 on 15/12/16.
//  Copyright © 2015年 com.pangdou.d5home. All rights reserved.
//

#import "D5CheckService.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

#define TIP CUSTOMLOCAL_STRING_NORMAL(@"Tip")
#define CANCEL CUSTOMLOCAL_STRING_NORMAL(@"Cancel")
#define SET CUSTOMLOCAL_STRING_NORMAL(@"Set")
#define OPEN_LOCATION_SERVICE_TIP CUSTOMLOCAL_STRING_CHECKSERVICE(@"Open_location_service_tip")
#define OPEN_ALBUM_SERVICE_TIP CUSTOMLOCAL_STRING_CHECKSERVICE(@"Open_album_service_tip")
#define OPEN_VOICE_SERVICE_TIP CUSTOMLOCAL_STRING_CHECKSERVICE(@"Open_voice_service_tip")
#define OPEN_CAMERA_SERVICE_TIP CUSTOMLOCAL_STRING_CHECKSERVICE(@"Open_camera_service_tip")
#define OPEN_CONTACT_SERVICE_TIP CUSTOMLOCAL_STRING_CHECKSERVICE(@"Open_contact_service_tip")

@implementation D5CheckService

//+ (BOOL)checkLocationService:(UIViewController *)vc {
//    @autoreleasepool {
//        CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
//        if (locationStatus == kCLAuthorizationStatusNotDetermined || locationStatus == kCLAuthorizationStatusRestricted || locationStatus == kCLAuthorizationStatusDenied) {
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:TIP  message:OPEN_LOCATION_SERVICE_TIP preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:CANCEL style:UIAlertActionStyleDefault handler:nil]];
//                [alert addAction:[UIAlertAction actionWithTitle:SET style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    [[UIApplication sharedApplication] openURL:url];
//                }]];
//                [vc presentViewController:alert animated:YES completion:nil];
//            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TIP message:OPEN_LOCATION_SERVICE_TIP delegate:self cancelButtonTitle:CANCEL otherButtonTitles:SET, nil];
//                [alert show];
//            }
//            return NO;
//        }
//        return YES;
//    }
//}
//
//+ (BOOL)checkAlbumService:(UIViewController *)vc {
//    @autoreleasepool {
//        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
//        if(authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted){
//            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f){
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:TIP  message:OPEN_ALBUM_SERVICE_TIP preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:CANCEL style:UIAlertActionStyleDefault handler:nil]];
//                [alert addAction:[UIAlertAction actionWithTitle:SET style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    [[UIApplication sharedApplication] openURL:url];
//                }]];
//                [vc presentViewController:alert animated:YES completion:nil];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TIP message:OPEN_ALBUM_SERVICE_TIP delegate:self cancelButtonTitle:CANCEL otherButtonTitles:SET, nil];
//                [alert show];
//            }
//            
//            return NO;
//        }
//        return YES;
//    }
//}
//
//+ (BOOL)checkVoiceService:(UIViewController *)vc {
//    @autoreleasepool {
//        __block BOOL isAllow = YES;
//        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
//            [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
//                isAllow = granted;
//                if (!granted) {
//                    NSLog(@"Microphone is disabled..");
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f){
//                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:TIP message:OPEN_VOICE_SERVICE_TIP preferredStyle:UIAlertControllerStyleAlert];
//                            [alert addAction:[UIAlertAction actionWithTitle:CANCEL style:UIAlertActionStyleDefault handler:nil]];
//                            [alert addAction:[UIAlertAction actionWithTitle:SET style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                                [[UIApplication sharedApplication] openURL:url];
//                            }]];
//                            [vc presentViewController:alert animated:YES completion:nil];
//                        }else{
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TIP message:OPEN_VOICE_SERVICE_TIP delegate:self cancelButtonTitle:CANCEL otherButtonTitles:SET, nil];
//                            [alert show];
//                        }
//                        
//                    });
//                }
//            }];
//        }
//        return isAllow;
//    }
//}
//
//+ (BOOL)checkCameraService:(UIViewController *)vc {
//    @autoreleasepool {
//        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f){
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:TIP  message:OPEN_CAMERA_SERVICE_TIP preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:CANCEL style:UIAlertActionStyleDefault handler:nil]];
//                [alert addAction:[UIAlertAction actionWithTitle:SET style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    [[UIApplication sharedApplication] openURL:url];
//                }]];
//                [vc presentViewController:alert animated:YES completion:nil];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TIP message:OPEN_CAMERA_SERVICE_TIP delegate:self cancelButtonTitle:CANCEL otherButtonTitles:SET, nil];
//                [alert show];
//            }
//            
//            return NO;
//        }
//        return YES;
//    }
//}
//
//+ (BOOL)checkAddressService:(UIViewController *)vc {
//    @autoreleasepool {
//        ABAddressBookRef addressBooks = ABAddressBookCreate();
//        __block BOOL accessGranted = NO;
//        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
//            ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
//                // First time access has been granted, add the contact accessGranted = granted;
//                accessGranted = granted;
//            });
//        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
//            accessGranted = YES;
//        } else {
//            accessGranted = NO;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f){
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TIP  message:OPEN_CONTACT_SERVICE_TIP preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    [alert addAction:[UIAlertAction actionWithTitle:CANCEL style:UIAlertActionStyleDefault handler:nil]];
//                    [alert addAction:[UIAlertAction actionWithTitle:SET style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        [[UIApplication sharedApplication] openURL:url];
//                    }]];
//                    [vc presentViewController:alert animated:YES completion:nil];
//                }else{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TIP message:OPEN_CONTACT_SERVICE_TIP delegate:self cancelButtonTitle:CANCEL otherButtonTitles:SET, nil];
//                    [alert show];
//                }
//                
//            });
//        }
//        return accessGranted;
//    }
//}
@end
