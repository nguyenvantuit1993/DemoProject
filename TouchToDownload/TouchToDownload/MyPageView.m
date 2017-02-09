//
//  MyPageView.m
//  HGPageScrollViewSample
//
//  Created by Rotem Rubnov on 15/3/2011.
//  Copyright 2011 TomTom. All rights reserved.
//

#import "MyPageView.h"


@implementation MyPageView

@synthesize isInitialized;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code.
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_button addTarget:self
                    action:@selector(myAction)
          forControlEvents:UIControlEventTouchUpInside];
        [_button setBackgroundColor:[UIColor greenColor]];
        [self addSubview:_button];
    }
    return self;
}
- (void)myAction
{
    NSLog(@"action");
}


@end
