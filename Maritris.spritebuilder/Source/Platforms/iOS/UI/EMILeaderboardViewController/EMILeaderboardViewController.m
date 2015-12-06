//
//  EMILeaderboardViewController.m
//  Maritris
//
//  Created by Marina Butovich on 12/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMILeaderboardViewController.h"

@interface EMILeaderboardViewController ()

@property (nonatomic, strong) NSMutableArray *players;

@end

@implementation EMILeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.players = [@[@"Player1", @"Player2", @"Player3", @"Player4", @"Player5", @"Player6", @"Player7", @"Player8", @"Player9", @"Player10", @"Player11", @"Player12", @"Player13", @"Player14", @"Player15", @"Player16"] mutableCopy];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark -
#pragma mark - UITableView support
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.players count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseID = @"LeaderboardsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    
    cell.textLabel.text = self.players[indexPath.row];
    cell.detailTextLabel.text = @"103112";
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
