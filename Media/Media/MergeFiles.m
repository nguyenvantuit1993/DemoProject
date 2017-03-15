//
//  ViewController.m
//  MergeTSFiles
//
//  Created by Nguyen Van Tu on 3/15/17.
//  Copyright © 2017 Nguyen Van Tu. All rights reserved.
//

#import "MergeFiles.h"
#import "KMMedia.h"
@interface MergeFiles ()

@end

@implementation MergeFiles

- (void)mergeFile:(NSString *)atPath andOutput:(NSString *)output  {
    //    self.infoLabel.text = @"Exporting...";
    __block NSDate *beginDate = [NSDate date];
    NSError *error;
    NSArray *resourceDirectoryPathContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:atPath error:&error];
    
    if(!error)
    {
        NSArray *tsFileList = [resourceDirectoryPathContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.ts'"]];
        __block NSUInteger tsFileCount = [tsFileList count];
        if (tsFileCount > 0)
        {
            NSMutableArray *tsAssetList = [NSMutableArray arrayWithCapacity:tsFileCount];
            for(NSString *tsFileName in tsFileList)
            {
                NSURL *tsFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",atPath, tsFileName]];
                [tsAssetList addObject:[KMMediaAsset assetWithURL:tsFileURL withFormat:KMMediaFormatTS]];
            }
            
            NSURL *mp4FileURL = [NSURL URLWithString:output];
            KMMediaAsset *mp4Asset = [KMMediaAsset assetWithURL:mp4FileURL withFormat:KMMediaFormatMP4];
            
            KMMediaAssetExportSession *tsToMP4ExportSession = [[KMMediaAssetExportSession alloc] initWithInputAssets:tsAssetList];
            tsToMP4ExportSession.outputAssets = @[mp4Asset];
            
            [tsToMP4ExportSession exportAsynchronouslyWithCompletionHandler:^{
                if (tsToMP4ExportSession.status == KMMediaAssetExportSessionStatusCompleted)
                {
                    [self.delegate didFinishMerge];
                    
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




@end
