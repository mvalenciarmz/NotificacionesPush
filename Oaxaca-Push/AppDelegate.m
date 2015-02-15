//
//  AppDelegate.m
//  Oaxaca-Push
//
//  Created by Walter Gonzalez Domenzain on 06/02/15.
//  Copyright (c) 2015 Smartplace. All rights reserved.
//
//  Marcos Antonio Valencia Ramírez: Se adicionaron comentarios para entender mejor el proceso
//
// Este código tiene los datos del ejemplo que usó el maestro en clase.   Toda vez que no corre en el emulador y nos dijo que tenía que registrarse el dispositivo apple, simplemente se comenta para futuras referencias.
// Ejemplo desarrollado usando el servciio de pushwoosh

#import "AppDelegate.h"

// Después de agregar el framework para las notificaciones push, incluimos èste archivo de definiciones
#import <Pushwoosh/PushNotificationManager.h>

#define LOCATIONS_FILE @"PWLocationTracking"
#define LOCATIONS_FILE_TYPE @"log"

@interface AppDelegate ()<PushNotificationDelegate> {
    PushNotificationManager *pushManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
// Menciona el profe que hay que separar ésta parte del código para que funcionen correctamente las noitficaciones en IOS  8
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        // use registerUserNotificationSettings
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    } else
    {
        // use registerForRemoteNotifications
    }
#else
    // use registerForRemoteNotifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#endif
    
    pushManager = [PushNotificationManager pushManager];
    pushManager.delegate = self;
    [pushManager handlePushReceived:launchOptions];
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        
        [pushManager startLocationTracking];
    }
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Push Notification Manager

- (void)onDidRegisterForRemoteNotificationsWithDeviceToken:(NSString *)token
{
    NSLog(@"El token push que estamos usando es : %@", token);
}

- (void)onDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error al regisrtar : %@", [error description]);
}

- (void)onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification
{
    [PushNotificationManager clearNotificationCenter];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSLog(@"Recibimos push notification : %@", pushNotification);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [pushManager handlePushReceived:userInfo];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [pushManager handlePushRegistration:deviceToken];
    NSString *mstrUserPushToken;
    mstrUserPushToken   = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    mstrUserPushToken   = [mstrUserPushToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"mstrUserPushToken %@", mstrUserPushToken);
}

@end
