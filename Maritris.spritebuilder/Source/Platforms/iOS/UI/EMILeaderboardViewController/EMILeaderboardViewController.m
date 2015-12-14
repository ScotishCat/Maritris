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

#import "EMIGameCenter.h"
#import <GameKit/GameKit.h>

EMIViewControllerMainViewProperty(EMILeaderboardViewController, leaderboardView, EMILeaderboardView);

static NSString * const kEMITableViewTitle  =    @"Leaderboard";

@interface EMILeaderboardViewController ()
@property (nonatomic, strong)   EMIArrayModel                       *scores;
@property (nonatomic, readonly) UITableView                         *scoresTableView;
@property (nonatomic, strong)   IBOutlet UIActivityIndicatorView    *progressView;

- (void)setupNavigationItems;
- (void)loadScores;

@end

@implementation EMILeaderboardViewController

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.scores = nil;
}

#pragma mark - 
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItems];
    [self loadScores];
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
    return self.scores.count;
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
    
    GKScore *score = self.scores[indexPath.row];
    cell.textLabel.text = score.player.displayName;
    cell.detailTextLabel.text = score.formattedValue;
    return cell;
}

#pragma mark -
#pragma mark Private
//
//- (UITableView *)scoresTableView {
//    return (UITableView *)self.view;
//}

- (void)setupNavigationItems {
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = kEMITableViewTitle;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadScores {
    self.scores = [EMIArrayModel new];
    EMIGameCenter *gameCenter = [EMIGameCenter sharedCenter];
    [gameCenter authenticateLocalPlayerWithCompletion:^(BOOL authenticated, NSError *error) {
        if (authenticated) {
            [[EMIGameCenter sharedCenter] loadLeaderboardWithCompletion:^(NSArray *scores) {
                EMIArrayModel *scoresModel = self.scores;
                for (GKScore *currentScore in scores) {
                    [scoresModel addModel:currentScore];
                }
                
                [self.progressView stopAnimating];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.leaderboardView.tableView reloadData];
                });
            }];
        }
    }];
}

@end
