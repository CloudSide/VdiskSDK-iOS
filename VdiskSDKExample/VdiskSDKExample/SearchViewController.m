//
//  SearchViewController.m
//  VdiskSDKExample
//
//  Created by gaopeng on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "VdiskSDK.h"

@interface SearchViewController () <VdiskRestClientDelegate> {
    
    VdiskRestClient *_vdiskRestClient;
}

@end

@implementation SearchViewController

@synthesize listData = _listData;
@synthesize path = _path;

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {

        if (_path == nil) {
            
            _path = @"/"; //change the value to the path you want to search;
        }
        
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        
        self.listData = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc {
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
        
    [_path release];
    
    [_listData release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    [searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [searchBar sizeToFit];
    [self.tableView setTableHeaderView:searchBar];
    [searchBar release];
    
    self.title = @"Search";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    VdiskMetadata *metadata = (VdiskMetadata *)[self.listData objectAtIndex:indexPath.row];
    
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y-MM-dd HH:mm:ss"];
    NSString *lastDateString = [formatter stringFromDate:metadata.lastModifiedDate];
    [formatter release];
    
    cell.textLabel.text = metadata.filename;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", lastDateString, metadata.humanReadableSize];
        
    [cell setUserInteractionEnabled:NO];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([metadata isDirectory]) {
                
        cell.detailTextLabel.text = lastDateString;
    } 
    
    return cell;
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    [_vdiskRestClient searchPath:_path forKeyword:searchText];
}

#pragma mark - VdiskRestClient delegate

- (void)restClient:(VdiskRestClient *)restClient loadedSearchResults:(NSArray *)results forPath:(NSString *)path keyword:(NSString *)keyword {
    
    self.listData = [NSMutableArray arrayWithArray:results];
    if ([self.listData count] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"No results found" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
    }
    [self.tableView reloadData];
}

- (void)restClient:(VdiskRestClient *)restClient searchFailedWithError:(NSError *)error {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

@end
