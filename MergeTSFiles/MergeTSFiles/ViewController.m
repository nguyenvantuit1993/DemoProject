//
//  ViewController.m
//  MergeTSFiles
//
//  Created by Nguyen Van Tu on 3/15/17.
//  Copyright © 2017 Nguyen Van Tu. All rights reserved.
//

#import "ViewController.h"
#import <FFmpegWrapper.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *resourceDirectoryPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0] path];
//    NSArray *resourceDirectoryPathContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourceDirectoryPath error:&error];
//    
    FFmpegWrapper *wrapper = [[FFmpegWrapper alloc] init];
    [wrapper convertInputPath:@"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8" outputPath:@"/Users/nguyenvantu/Desktop/testOutput.mp4" options:nil progressBlock:^(NSUInteger bytesRead, uint64_t totalBytesRead, uint64_t totalBytesExpectedToRead) {
    } completionBlock:^(BOOL success, NSError *error) {
        success?NSLog(@"Success...."):NSLog(@"Error : %@",error.localizedDescription);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
