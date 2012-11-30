

#import "AppDelegate.h"

#import "ViewController.h"
// #import <AudioToolbox/AudioToolbox.h> // not any more! iOS 6 deprecates
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate () <UIApplicationDelegate, AVAudioSessionDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: NULL];
    // iOS 6, delegate deprecated, use notifications instead
    // [[AVAudioSession sharedInstance] setDelegate: self];
    // iOS 6, AudioToolbox C interface deprecated, use new Objective-C capabilities instead
    //AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
    //                                routeChangeCallback, NULL);
    
    // new in iOS 6, we can sign up for notifications
    // I am intentionally leaking the observers and self, no harm done
    [[NSNotificationCenter defaultCenter]
     addObserverForName:AVAudioSessionRouteChangeNotification
     object:nil queue:nil
     usingBlock:^(NSNotification *note) {
         NSLog(@"change %@", note.userInfo);
     }];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:AVAudioSessionInterruptionNotification
     object:nil queue:nil
     usingBlock:^(NSNotification *note) {
         NSLog(@"interruption %@", note.userInfo);
         int which = [note.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
         NSLog(@"interruption %@", which ? @"began" : @"ended");
     }];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setActive: YES error: NULL];
}


@end
