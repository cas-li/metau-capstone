//
//  ProfileViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <Parse/Parse.h>

#import "ProfileViewController.h"
#import "Vent.h"
#import "VentCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Vent *> *arrayOfVents;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameLabel.text = [PFUser currentUser].username;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadData];
}

- (void)loadData {
    PFQuery *vaQuery = [Vent query];
    [vaQuery orderByDescending:@"createdAt"];
    [vaQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [vaQuery includeKey:@"author"];
    
    vaQuery.limit = 20;
    
    __weak typeof(self) weakSelf = self;
    [vaQuery findObjectsInBackgroundWithBlock:^(NSArray<Vent *> * _Nullable vents, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (vents) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            strongSelf.arrayOfVents = vents.mutableCopy;
            
            [strongSelf.tableView reloadData];
            
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);

        }

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfVents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VentCell" forIndexPath:indexPath];

    cell.vent = self.arrayOfVents[indexPath.row];

    return cell;
}

@end
