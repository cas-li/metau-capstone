//
//  SongPickerViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import <SpotifyiOS/SpotifyiOS.h>

#import "SongPickerViewController.h"
#import "SpotifyTrack.h"
#import "TrackCell.h"
#import "VWHelpers.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "SpotifyAPIManager.h"
#import "AudioSegmentPickerViewController.h"


@interface SongPickerViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AudioSegmentPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTracks;
@property (strong, nonatomic) SpotifyTrack *selectedTrack;
@property (strong, nonatomic) NSNumber *selectedTrackRow;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SongPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.allowsMultipleSelection = NO;
    
    [self getSearchResults:@"ur mom"];
    [self.tableView reloadData];
    
    self.searchBar.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [self.delegate passSelectedTrack:self.selectedTrack];
}

- (void)getSearchResults:(NSString *)searchString {
    __weak typeof(self) weakSelf = self;
    [[SpotifyAPIManager shared] getTracks:searchString withCompletion:^(NSMutableArray * _Nullable results, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            typeof(self) strongSelf = weakSelf;
            if (!strongSelf) {
                NSLog(@"I got killed!");
                return;
            }
            if (results) {
                strongSelf.arrayOfTracks = results;
                [strongSelf.tableView reloadData];
            }
            else {
                NSLog(@"there was an error, u suck %@", error.localizedDescription);
            }
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell" forIndexPath:indexPath];

    cell.track = self.arrayOfTracks[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:[self.selectedTrackRow longValue] inSection:0];
                      
    UITableViewCell *oldTableViewCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    oldTableViewCell.accessoryView.hidden = YES;
    oldTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedTrack = self.arrayOfTracks[indexPath.row];
    self.selectedTrackRow = [NSNumber numberWithLong:indexPath.row];
    
    [[SpotifyAPIManager shared] playTrack:self.selectedTrack.uriString];
    [self.delegate passSelectedTrack:self.selectedTrack];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"segmentPickerSegue"]) {
         AudioSegmentPickerViewController *aspVC = [segue destinationViewController];
         aspVC.selectedTrack = self.selectedTrack;
         aspVC.delegate = self;
     }
 }

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self getSearchResults:searchText];
}
    

 

- (void)passSelectedTrack:(SpotifyTrack *)selectedTrack withStartTimestamp:(NSNumber *)startTimeStamp withEndTimestamp:(NSNumber *)endTimestamp {
    self.selectedTrack = selectedTrack;
    self.selectedTrack.startTimestamp = startTimeStamp;
    self.selectedTrack.endTimestamp = endTimestamp;
}


@end
