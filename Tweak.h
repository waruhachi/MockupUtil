#import <UIKit/UIKit.h>

@interface SBStatusBarStateAggregator : NSObject
+ (instancetype)sharedInstance;
- (void)setShowsOverridesForRecording:(BOOL)showing;
@end

@interface SBStatusBarStateAggregator (MockupUtil)
+ (instancetype)mu_sharedInstance;
@end

@interface SpringBoard : UIApplication
@property (readonly, nonatomic) SBStatusBarStateAggregator *statusBarStateAggregator;
@end
