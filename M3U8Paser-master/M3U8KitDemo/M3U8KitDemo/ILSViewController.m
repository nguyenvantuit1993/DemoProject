//
//  ILSViewController.m
//  M3U8KitDemo
//
//  Created by Sun Jin on 4/22/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import "ILSViewController.h"

#import "M3U8Kit.h"

@interface ILSViewController ()

@end

@implementation ILSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8
     http://stackoverflow.com/questions/31700091/extract-record-audio-from-hls-stream-video-while-playing-ios/33038513#33038513
     */
	// Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSTimeInterval begin = [NSDate timeIntervalSinceReferenceDate];
        
        NSString *baseURL = @"http://qthttp.apple.com.edgesuite.net/";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sl" ofType:@"m3u8"];
        NSError *error;
        NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"error: %@", error);
        }
        
        M3U8PlaylistModel *medel = [[M3U8PlaylistModel alloc] initWithString:str baseURL:baseURL error:NULL];
    
        NSLog(@"segments names: %@", [medel segmentNamesForPlaylist:medel.mainMediaPl]);
        
        NSString *m3u8Path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"str.m3u8"];
        error = nil;
        [medel savePlaylistsToPath:m3u8Path error:&error];
        if (error) {
            NSLog(@"playlists save error: %@", error);
        }
        
        NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
        NSLog(@"spend time = %f", end - begin);
        
    });
}
- (void) parseM3u8
{
    NSString *plainString = [self.url m3u8PlanString];
    BOOL isMasterPlaylist = [plainString isMasterPlaylist];
    
    
    NSError *error;
    NSURL *baseURL;
    
    if(isMasterPlaylist)
    {
        
        M3U8MasterPlaylist *masterList = [[M3U8MasterPlaylist alloc] initWithContentOfURL:self.url error:&error];
        self.masterPlaylist = masterList;
        
        M3U8ExtXStreamInfList *xStreamInfList = masterList.xStreamList;
        M3U8ExtXStreamInf *StreamInfo = [xStreamInfList extXStreamInfAtIndex:0];
        
        NSString *URI = StreamInfo.URI;
        NSRange range = [URI rangeOfString:@"dailymotion.com"];
        NSString *baseURLString = [URI substringToIndex:(range.location+range.length)];
        baseURL = [NSURL URLWithString:baseURLString];
        
        plainString = [[NSURL URLWithString:URI] m3u8PlanString];
    }
    
    
    
    M3U8MediaPlaylist *mediaPlaylist = [[M3U8MediaPlaylist alloc] initWithContent:plainString baseURL:baseURL];
    self.mediaPlaylist = mediaPlaylist;
    
    M3U8SegmentInfoList *segmentInfoList = mediaPlaylist.segmentList;
    
    NSMutableArray *segmentUrls = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < segmentInfoList.count; i++)
    {
        M3U8SegmentInfo *segmentInfo = [segmentInfoList segmentInfoAtIndex:i];
        
        NSString *segmentURI = segmentInfo.URI;
        NSURL *mediaURL = [baseURL URLByAppendingPathComponent:segmentURI];
        
        [segmentUrls addObject:mediaURL];
        if(!self.segmentDuration)
            self.segmentDuration = segmentInfo.duration;
    }
    
    self.segmentFilesURLs = segmentUrls;
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
