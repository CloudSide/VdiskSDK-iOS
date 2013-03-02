//
//  VdiskSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Created by Bruce Chen (weibo: @一个开发者) on 12-6-15.
//
//  Copyright (c) 2012 Sina Vdisk. All rights reserved.
//
#import "RecommendViewController.h"
#import "VdiskSDK.h"

@interface RecommendViewController () <VdiskRestClientDelegate> {

    VdiskRestClient *_vdiskRestClient;
    NSArray *_shareList;
}

- (void)onReloadButtonPressed:(id)sender;

@end

@implementation RecommendViewController


- (void)onReloadButtonPressed:(id)sender {


    [_vdiskRestClient loadShareList:kVdiskShareListTypeRecommendListForUser params:@{@"page_size" : @"100"}];
    //[_vdiskRestClient loadShareList:kVdiskShareListTypeShareSearch params:@{@"page_size":@"100", @"query":@"1"}];
    
    [_vdiskRestClient loadSharesCategory:@"0" params:@{@"platform" : @"ios"}];
    
    self.navigationItem.rightBarButtonItem.title = @"Loading...";
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)dealloc {

    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_shareList release];
    
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {
    
        self.title = @"Recommend";
        
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(onReloadButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [rightBtn release];
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    [self onReloadButtonPressed:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_shareList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MetadataCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    VdiskSharesMetadata *metadata = (VdiskSharesMetadata *)[_shareList objectAtIndex:indexPath.row];
    
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
            
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y-MM-dd HH:mm:ss"];
    NSString *lastDateString = [formatter stringFromDate:metadata.lastModifiedDate];
    [formatter release];
    
    cell.textLabel.text = metadata.filename;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", lastDateString, metadata.humanReadableSize];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setUserInteractionEnabled:YES];
    
    cell.detailTextLabel.text = lastDateString;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle;
    
    switch (section) {
            
        case 0:
            sectionTitle = [NSString stringWithFormat:@"%d items", [_shareList count]];
            break;
        default:
            sectionTitle = @"";
            break;
    }
    
    return sectionTitle;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VdiskSharesMetadata *metadata = (VdiskSharesMetadata *)[_shareList objectAtIndex:indexPath.row];
    
    NSLog(@"[metadata cpRef]: %@", metadata.cpRef);
    
    if (metadata) {
        
        [_vdiskRestClient loadSharesMetadata:metadata.cpRef];
        
        NSString *tmpPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingFormat: @"/tmp"], metadata.filename];
        [_vdiskRestClient loadFileWithSharesMetadata:metadata intoPath:tmpPath];
    }
    
}


#pragma mark - VdiskRestClientDelegate

- (void)restClient:(VdiskRestClient *)client loadedSharesMetadata:(VdiskSharesMetadata *)metadata {

    NSLog(@"[restClient:loadedSharesMetadata:]%@", metadata.url);
}

- (void)restClient:(VdiskRestClient *)client loadSharesMetadataFailedWithError:(NSError *)error {

    NSLog(@"[restClient:loadSharesMetadataFailedWithError:]%@", error);
}

- (void)restClient:(VdiskRestClient *)client loadedShareList:(NSArray *)shareList {

    self.navigationItem.rightBarButtonItem.title = @"Reload";
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    if (_shareList != nil) {
        
        [_shareList release], _shareList = nil;
    }
    
    _shareList = [shareList retain];
    
    [self.tableView reloadData];
}


- (void)restClient:(VdiskRestClient *)restClient loadShareListFailedWithError:(NSError *)error {

    self.navigationItem.rightBarButtonItem.title = @"Reload";
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}


- (void)restClient:(VdiskRestClient *)client loadFileFailedWithError:(NSError *)error sharesMetadata:(VdiskSharesMetadata *)sharesMetadata {
    
    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client loadedFile:(NSString *)destPath sharesMetadata:(VdiskSharesMetadata *)sharesMetadata {
    
    NSLog(@"%@ : %@", sharesMetadata.filename, destPath);
}

- (void)restClient:(VdiskRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath sharesMetadata:(VdiskSharesMetadata *)sharesMetadata {
    
    NSLog(@"%@ : %f%%", sharesMetadata.filename, progress * 100);
}


- (void)restClient:(VdiskRestClient *)restClient loadedSharesCategory:(NSArray *)list categoryId:(NSString *)categoryId {

    NSLog(@"loadedSharesCategory: count(%d), categoryId: %@", [list count], categoryId);
    
    for (VdiskSharesCategory *c in list) {
        
        NSLog(@"%@, %@, %@", c.categoryId, c.categoryName, c.categoryPid);
    }
}

- (void)restClient:(VdiskRestClient *)restClient loadSharesCategoryFailedWithError:(NSError *)error categoryId:(NSString *)categoryId {

    NSLog(@"loadSharesCategoryFailedWithError: %@", error);
}

@end
