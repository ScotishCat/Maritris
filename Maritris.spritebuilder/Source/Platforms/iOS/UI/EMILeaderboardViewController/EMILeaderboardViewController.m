//
//  EMILeaderboardViewController.m
//  Maritris
//
//  Created by Marina Butovich on 12/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMILeaderboardViewController.h"

#import "EMILeaderboardView.h"
#import "EMIArrayModel.h"

#import "EMIMacros.h"

EMIViewControllerMainViewProperty(EMILeaderboardViewController, leaderboardView, EMILeaderboardView);

static NSString * const kEMITableViewTitle  =    @"Leaderboard";

@interface EMILeaderboardViewController ()
@property (nonatomic, strong) EMIArrayModel   *players;

- (void)setupNavigationItems;

@end

@implementation EMILeaderboardViewController

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.players = nil;
}

#pragma mark - 
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItems];
    
    self.players = [@[@"Player1", @"Player2", @"Player3", @"Player4", @"Player5", @"Player6", @"Player7", @"Player8", @"Player9", @"Player10", @"Player11", @"Player12", @"Player13", @"Player14", @"Player15", @"Player16"] mutableCopy];
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
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.players.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying
// for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseID = @"LeaderboardsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseID];
    }
    
    cell.textLabel.text = self.players[indexPath.row];
    cell.detailTextLabel.text = @"103112";
    return cell;
}

#pragma mark -
#pragma mark Private

- (void)setupNavigationItems {
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = kEMITableViewTitle;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
