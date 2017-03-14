//
//  ILSViewController.m
//  M3U8KitDemo
//
//  Created by Sun Jin on 4/22/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import "ILSViewController.h"
#import "KMMedia.h"
#import "M3U8Kit.h"

@interface ILSViewController ()
@property (nonatomic, strong) NSURL *url;
@end

@implementation ILSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    /*
//     http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8
//     http://stackoverflow.com/questions/31700091/extract-record-audio-from-hls-stream-video-while-playing-ios/33038513#33038513
//     */
//    // Do any additional setup after loading the view, typically from a nib.
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        NSTimeInterval begin = [NSDate timeIntervalSinceReferenceDate];
//        
//        NSString *baseURLString = @"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8";
//        M3U8PlaylistModel *model = [[M3U8PlaylistModel alloc] initWithURL:baseURLString error:NULL];
//        
//        M3U8ExtXStreamInfList *xStreamInfList = model.masterPlaylist.xStreamList;
//        
//        M3U8ExtXStreamInf *StreamInfo = [xStreamInfList xStreamInfAtIndex:0];
//        
//        baseURLString = [baseURLString stringByDeletingLastPathComponent];
//        NSURL *baseURL = [NSURL URLWithString:baseURLString];
//        
//        M3U8SegmentInfoList *segmentInfoList = model.mainMediaPl.segmentList;
//        
//        NSMutableArray *segmentUrls = [[NSMutableArray alloc] init];
//        
//        for (int i = 0; i < segmentInfoList.count; i++)
//        {
//            M3U8SegmentInfo *segmentInfo = [segmentInfoList segmentInfoAtIndex:i];
//            
//            NSString *segmentURI = segmentInfo.URI;
//            NSURL *mediaURL = [baseURL URLByAppendingPathComponent:segmentURI];
//            NSLog(@"%@", segmentURI);
//                        [segmentUrls addObject:mediaURL];
//            //            if(!self.segmentDuration)
//            //                self.segmentDuration = segmentInfo.duration;
//        }
//        
//        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//        queue.maxConcurrentOperationCount = 4;
//        
//        NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [self callBack];
//            }];
//        }];
//        
//        for (NSURL* url in segmentUrls)
//        {
//            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//                NSData *data = [NSData dataWithContentsOfURL:url];
//                NSString *filename = [@"/Users/nguyenvantu/Desktop/testOutput/" stringByAppendingString:[url lastPathComponent]];
//                [data writeToFile:filename atomically:YES];
//            }];
//            [completionOperation addDependency:operation];
//        }
//        
//        [queue addOperations:completionOperation.dependencies waitUntilFinished:NO];
//        [queue addOperation:completionOperation];
//        //        self.segmentFilesURLs = segmentUrls;
//    });
}
- (void)callBack
{
    self.infoLabel.text = @"Exporting...";
    __block NSDate *beginDate = [NSDate date];
    NSError *error;
    NSString *resourceDirectoryPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0] path];
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
                    self.infoLabel.text = [NSString stringWithFormat:@"Export %d chunks completed in %d:%d",tsFileCount, [dateComponents minute], [dateComponents second]];
                }
                else
                {
                    self.infoLabel.text = [NSString stringWithFormat:@"Export %d chunks failed: %@",tsFileCount, tsToMP4ExportSession.error];
                }
            }];
        }
        else
        {
            self.infoLabel.text = [NSString stringWithFormat:@"No TS file found in: %@",resourceDirectoryPath];
        }
    }
    else
    {
        self.infoLabel.text = [NSString stringWithFormat:@"Cannot retrieve TS files: %@",error];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
