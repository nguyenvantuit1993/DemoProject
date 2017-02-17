#import <AVFoundation/AVFoundation.h>
#import <VENTouchLockPasscodeViewController.h>

#import "CustomVENTouchLockEnterPasscodeViewController.h"

@interface CustomVENTouchLockEnterPasscodeViewController: VENTouchLockPasscodeViewController

/**
 Resets the number of passcode attempts recorded to 0
 */
+ (void)resetPasscodeAttemptHistory;
-(id)init:(Boolean)isDelete;
@end