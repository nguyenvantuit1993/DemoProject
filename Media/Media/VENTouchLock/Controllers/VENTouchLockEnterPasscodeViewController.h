#import "VENTouchLockPasscodeViewController.h"

@interface VENTouchLockEnterPasscodeViewController : VENTouchLockPasscodeViewController

/**
 Resets the number of passcode attempts recorded to 0
 */
@property (nonatomic, assign) BOOL isSettingsView;
+ (void)resetPasscodeAttemptHistory;

-(id)init:(Boolean)isDelete;
@end
