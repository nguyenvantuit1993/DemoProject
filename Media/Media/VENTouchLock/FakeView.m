//
//  FakeView.m
//  Media
//
//  Created by Tuuu on 3/18/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

#import "FakeView.h"
#import "FakeCell.h"
@interface FakeView () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, copy) NSArray *contents;
@end

@implementation FakeView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contents = [NSArray arrayWithObjects:@"funny1",@"funny2",@"funny3",nil];
    UINib *cellNib = [UINib nibWithNibName:@"FakeCell" bundle:nil];
    [self.fakeTableView registerNib:cellNib forCellReuseIdentifier:@"FakeCell"];
    self.fakeTableView.delegate = self;
    self.fakeTableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.contents.count;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FakeCell";
    
    // Similar to UITableViewCell, but
    FakeCell *cell = (FakeCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FakeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Just want to test, so I hardcode the data
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.contents[indexPath.row]]];
    cell.lbl_Content.text = self.contents[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %d row", indexPath.row);
}

@end
