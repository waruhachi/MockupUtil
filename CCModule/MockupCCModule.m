#import "MockupCCModule.h"
#import "../shared.h"

@implementation MockupCCModule {
    NSUserDefaults *_defaults;
    BOOL _selected;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _defaults = [[NSUserDefaults alloc] initWithSuiteName:kDomain];
        _selected = [_defaults boolForKey:kSelectedKey];
    }
    
    return self;
}

- (UIImage *)iconGlyph {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:24 weight:UIImageSymbolWeightMedium];
    UIImage *image = [UIImage systemImageNamed:@"ladybug.fill" withConfiguration:config];
    return [image imageByApplyingSymbolConfiguration:config];
}

- (UIImage *)selectedIconGlyph {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:24 weight:UIImageSymbolWeightMedium];
    UIImage *image = [UIImage systemImageNamed:@"ladybug.fill" withConfiguration:config];
    return [image imageByApplyingSymbolConfiguration:config];
}

- (UIColor *)selectedColor {
    return [UIColor systemBlueColor];
}

- (BOOL)isSelected {
    return _selected;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;

    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        (__bridge CFStringRef)kSelectedStateDidChangeNotification,
        NULL,
        NULL,
        true
    );

    [_defaults setBool:selected forKey:kSelectedKey];
    [_defaults synchronize];
}

@end