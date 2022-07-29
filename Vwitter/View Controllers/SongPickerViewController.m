//
//  SongPickerViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/28/22.
//

#import "SongPickerViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFURLRequestSerialization.h>
#import <AFNetworking/AFHTTPSessionManager.h>

#import "SpotifyTrack.h"
#import "TrackCell.h"
#import "VWHelpers.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import <SpotifyiOS/SpotifyiOS.h>

@interface SongPickerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTracks;
@property (strong, nonatomic) SpotifyTrack *selectedTrack;
@property (strong, nonatomic) NSNumber *selectedTrackRow;

@end

@implementation SongPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = CAST_TO_CLASS_OR_NIL(UIApplication.sharedApplication.delegate, AppDelegate);
    
//    [appDelegate.appRemote.playerAPI play:@"1NhCTXyj2XjiUXpjpDNoaF" callback:^(id  _Nullable result, NSError * _Nullable error) {
//        if (!error) {
//            NSLog(@"track playing");
//        }
//        else {
//            NSLog(@"track playing failed");
//        }
//    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.allowsMultipleSelection = NO;

    // Do any additional setup after loading the view.
    
//    NSString *bearerToken = [[NSString alloc] initWithFormat:@"Bearer %@",@"BQAX1sqW5xZO5DXjVMOaCFJl5pxYVzPFJoM7In8qvuVSgKFSvEDsuXVczNL7Cee_7OWyYrj5Cs_pcnvKDW4ivZGQ1hDJpN3Ij9JRlbBK_9tYf0lPMXah6BoqF7iVUxcbJ-Q84QHkqy-jA3INO3u7xBfiTNa2MvO31CTAg5SHOczeErm6-kma"];
    NSString *bearerToken = [[NSString alloc] initWithFormat:@"Bearer %@", appDelegate.appRemote.connectionParameters.accessToken];
//
//    AFHTTPSessionManager *manager =
//    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.spotify.com/v1"]];
//
//    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//
//    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [requestSerializer setValue:bearerToken forHTTPHeaderField:@"Authorization"];
//
//    manager.requestSerializer = requestSerializer;

//    [manager GET:@"/search" parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSLog(@"JSON: %@ ", responseObject);
//    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
//    [manager GET:@"/search" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    NSURL *url = [NSURL URLWithString:@"https://api.spotify.com/v1/search?q=someone%20like%20you&type=track"];

//    [request setValue:@"Bearer BQC470ZJMQ9fAdGbVbgEPVdzWOIhaJJC6w-x2YMDPQ8DnsGKUqAHFGFRNftnPITx9sXe4jvajVKIegWW5EO-zVjKhOot3H3HA0HRvQDedGrtSltCd2SeBfd7zQ0XcwryREPpyGlmWipmEeGwOWxH_7P7I6P8yYxr7bEVKH8E2dvWgfs" forHTTPHeaderField:@"Authorization"];
    [request setValue:bearerToken forHTTPHeaderField:@"Authorization"];
    [request setURL:url];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
      [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // JSON with song is here
            NSLog(@"JSON: %@", json);
            NSArray *tracksArray = json[@"tracks"][@"items"];
            NSArray *castedTracksArray = CAST_TO_CLASS_OR_NIL(tracksArray, NSArray);
            NSMutableArray *spotifyTracksArray = [[NSMutableArray alloc] init];
            for (id track in castedTracksArray) {
                SpotifyTrack *currentTrack = [[SpotifyTrack alloc] initWithDictionary:track];
                [spotifyTracksArray addObject:currentTrack];
            }
            self.arrayOfTracks = spotifyTracksArray;

            [self.tableView reloadData];
            });
            
        }
    }] resume];

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
    
    AppDelegate *appDelegate = CAST_TO_CLASS_OR_NIL(UIApplication.sharedApplication.delegate, AppDelegate);
    
    [appDelegate.appRemote.playerAPI play:self.selectedTrack.uriString callback:^(id  _Nullable result, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"track playing");
        }
        else {
            NSLog(@"cell track failed to play %@", error.localizedDescription);
        }
    }];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"postSongChoiceSegue"]) {
         
         ComposeViewController *composeVC = [segue destinationViewController];
         composeVC.selectedTrack = self.selectedTrack;
         
     }
 }

-(IBAction)unwindToCompose:(UIStoryboardSegue *)segue
{
    ComposeViewController *source = (ComposeViewController *)segue.sourceViewController;
    source.selectedTrack = self.selectedTrack;
}
 

@end
