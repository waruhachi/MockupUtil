#import "Tweak.h"
#import "shared.h"

NSUserDefaults *defaults;
BOOL isSelected = NO;

void handler(void) {
    isSelected = [defaults boolForKey:kSelectedKey];

    SBStatusBarStateAggregator *aggregator = [%c(SBStatusBarStateAggregator) mu_sharedInstance];

    [aggregator setShowsOverridesForRecording:isSelected];
}

%hook SBStatusBarDefaults

- (BOOL)showOverridesForRecording {
    if (isSelected) {
        return YES;
    }

    return %orig;
}

%end

%hook SBStatusBarStateAggregator

%new
+ (SBStatusBarStateAggregator *)mu_sharedInstance {
    if ([self respondsToSelector:@selector(sharedInstance)]) {
        return [%c(SBStatusBarStateAggregator) sharedInstance];
    }
    
    static SBStatusBarStateAggregator *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        SpringBoard *springboard = (SpringBoard *)[UIApplication sharedApplication];

        sharedInstance = [springboard statusBarStateAggregator];
    });

    return sharedInstance;
}

%end

%ctor {
    defaults = [[NSUserDefaults alloc] initWithSuiteName:kDomain];
    isSelected = [defaults boolForKey:kSelectedKey];

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        (CFNotificationCallback)handler,
        (__bridge CFStringRef)kSelectedStateDidChangeNotification,
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );
}
