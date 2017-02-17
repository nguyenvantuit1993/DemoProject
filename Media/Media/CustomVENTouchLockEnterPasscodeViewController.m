#import "CustomVENTouchLockEnterPasscodeViewController.h"
#import "VENTouchLockPasscodeView.h"
#import "VENTouchLock.h"

NSString *const VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttemptsCustom = @"VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttempts";
@interface CustomVENTouchLockEnterPasscodeViewController()
@property (nonatomic, assign) Boolean isDelete;
@end
@implementation CustomVENTouchLockEnterPasscodeViewController

#pragma mark - Class Methods

+ (void)resetPasscodeAttemptHistory
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults removeObjectForKey:VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttemptsCustom];
    [standardDefaults synchronize];
}


#pragma mark - Instance Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = [self.touchLock appearance].enterPasscodeViewControllerTitle;
    }
    return self;
}
-(id)init:(Boolean)isDelete {
    if ( self = [super init] ) {
        self.title = [self.touchLock appearance].enterPasscodeViewControllerTitle;
        self.isDelete = isDelete;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passcodeView.title = [self.touchLock appearance].enterPasscodeInitialLabelText;
}

- (void)enteredPasscode:(NSString *)passcode
{
    [super enteredPasscode:passcode];
    if ([self.touchLock isPasscodeValid:passcode]) {
        [[self class] resetPasscodeAttemptHistory];
        [self finishWithResult:YES animated:YES];
        if(self.isDelete)
        {
            [[VENTouchLock sharedInstance] deletePasscode];
        }
    }
    else {
        [self.passcodeView shakeAndVibrateCompletion:^{
            self.passcodeView.title = [self.touchLock appearance].enterPasscodeIncorrectLabelText;
            [self clearPasscode];
            if ([self parentSplashViewController]) {
                [self recordIncorrectPasscodeAttempt];
            }
        }];

    }
}

- (void)recordIncorrectPasscodeAttempt
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger numberOfAttemptsSoFar = [standardDefaults integerForKey:VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttemptsCustom];
    numberOfAttemptsSoFar ++;
    [standardDefaults setInteger:numberOfAttemptsSoFar forKey:VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttemptsCustom];
    [standardDefaults synchronize];
    if (numberOfAttemptsSoFar >= [self.touchLock passcodeAttemptLimit]) {
        [self callExceededLimitActionBlock];
    }
}

- (void)callExceededLimitActionBlock
{
    [[self parentSplashViewController] dismissWithUnlockSuccess:NO
                                                     unlockType:VENTouchLockSplashViewControllerUnlockTypeNone
                                                       animated:NO];
}

- (VENTouchLockSplashViewController *)parentSplashViewController
{
    VENTouchLockSplashViewController *splashViewController = nil;
    UIViewController *presentingViewController = self.presentingViewController;
    if (self.touchLock.appearance.splashShouldEmbedInNavigationController) {
        UIViewController *rootViewController = ([presentingViewController isKindOfClass:[UINavigationController class]]) ? [((UINavigationController *)presentingViewController).viewControllers firstObject] : nil;
        if ([rootViewController isKindOfClass:[VENTouchLockSplashViewController class]]) {
            splashViewController = (VENTouchLockSplashViewController *)rootViewController;
        }
    }
    else if ([presentingViewController isKindOfClass:[VENTouchLockSplashViewController class]]) {
        splashViewController = (VENTouchLockSplashViewController *)presentingViewController;
    }
    return splashViewController;
}

@end
