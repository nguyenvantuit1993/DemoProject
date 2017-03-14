//
//  ViewController.m
//  MergeTSFiles
//
//  Created by Nguyen Van Tu on 3/15/17.
//  Copyright © 2017 Nguyen Van Tu. All rights reserved.
//

#import "ViewController.h"
#import <FFmpegWrapper.h>
#import "KMMedia.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.infoLabel.text = @"Exporting...";
    __block NSDate *beginDate = [NSDate date];
    NSError *error;
    NSString *resourceDirectoryPath = @"/Users/nguyenvantu/Desktop/testOutput";
    NSArray *resourceDirectoryPathContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourceDirectoryPath error:&error];
    
    if(!error)
    {
        NSArray *tsFileList = [resourceDirectoryPathContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.ts'"]];
        __block NSUInteger tsFileCount = [tsFileList count];
        if (tsFileCount > 0)
        {
            NSMutableArray *tsAssetList = [NSMutableArray arrayWithCapacity:tsFileCount];
            for(NSString *tsFileName in tsFileList)
            {
                NSURL *tsFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",resourceDirectoryPath, tsFileName]];
                [tsAssetList addObject:[KMMediaAsset assetWithURL:tsFileURL withFormat:KMMediaFormatTS]];
            }
            
            NSURL *mp4FileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Result.mp4",resourceDirectoryPath]];
            KMMediaAsset *mp4Asset = [KMMediaAsset assetWithURL:mp4FileURL withFormat:KMMediaFormatMP4];
            
            KMMediaAssetExportSession *tsToMP4ExportSession = [[KMMediaAssetExportSession alloc] initWithInputAssets:tsAssetList];
            tsToMP4ExportSession.outputAssets = @[mp4Asset];
            
            [tsToMP4ExportSession exportAsynchronouslyWithCompletionHandler:^{
                if (tsToMP4ExportSession.status == KMMediaAssetExportSessionStatusCompleted)
                {
                    unsigned int timeUnits = NSMinuteCalendarUnit | NSSecondCalendarUnit;
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDateComponents *dateComponents = [calendar components:timeUnits fromDate:beginDate toDate:[NSDate date] options:0];
//                    self.infoLabel.text = [NSString stringWithFormat:@"Export %d chunks completed in %d:%d",tsFileCount, [dateComponents minute], [dateComponents second]];
                }
                else
                {
//                    self.infoLabel.text = [NSString stringWithFormat:@"Export %d chunks failed: %@",tsFileCount, tsToMP4ExportSession.error];
                }
            }];
        }
        else
        {
//            self.infoLabel.text = [NSString stringWithFormat:@"No TS file found in: %@",resourceDirectoryPath];
        }
    }
    else
    {
//        self.infoLabel.text = [NSString stringWithFormat:@"Cannot retrieve TS files: %@",error];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
