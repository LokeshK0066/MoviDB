//
//  GridMovieViewClassVC.m
//  MovieDBProject
//
//  Created by iOS Dev on 11/3/17.
//  Copyright © 2017 Snsepro. All rights reserved.
//

#import "GridMovieViewClassVC.h"
#import "SearchMovieClassVC.h"
#import "DetailsMovieCellClassVC.h"
#import <UIImageView+AFNetworking.h>
#import <JLTMDbClient.h>
#import "DetailsMovieClassVC.h"

@interface GridMovieViewClassVC ()

@end

@implementation GridMovieViewClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadConfiguration];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;

//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self refresh];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)BtnSearch:(id)sender {
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchMovieClassVC *view=[story instantiateViewControllerWithIdentifier:@"SearchMovieClassVC"];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)BtnFilter:(id)sender {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vote_average"
                                                 ascending:NO];
    NSArray *sortedArray = [self.moviesArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSLog(@"My Sorted Array %@",sortedArray);
    
    self.moviesArray = sortedArray;
    [self.collectionView reloadData];

}

#pragma mark UICollection View Delgates calls
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.moviesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    DetailsMovieCellClassVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *movieDict = self.moviesArray[indexPath.row];
    cell.lblMovieName.text = movieDict[@"original_title"];
    cell.imgMmovie.contentMode = UIViewContentModeScaleAspectFill;
    if (movieDict[@"poster_path"] != [NSNull null]) {
        NSString *imageUrl = [self.imagesBaseUrlString stringByAppendingString:movieDict[@"poster_path"]];
        [cell.imgMmovie setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"TMDB"]];
    }
    
   
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    
        float cellWidth = (screenWidth / 4.0)-15;
        CGSize size = CGSizeMake(cellWidth*1.5, cellWidth*1.5);
        return size;
}


- (void)collectionView:(UICollectionView* )collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailsMovieClassVC *view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailsMovieClassVC"];
    view.moviesArray = self.moviesArray;
    view.currentRow = indexPath.row;
    [self.navigationController pushViewController:view animated:YES];
    
    
    
}

- (void) loadConfiguration {
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbConfiguration withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if (!error)
            self.imagesBaseUrlString = [response[@"images"][@"base_url"] stringByAppendingString:@"w92"];
        else
            [errorAlertView show];
    }];
}

- (void) refresh {
    NSArray *optionsArray = @[kJLTMDbMoviePopular, kJLTMDbMovieUpcoming, kJLTMDbMovieTopRated];
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    [[JLTMDbClient sharedAPIInstance] GET:optionsArray[arc4random() % [optionsArray count]] withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if (!error) {
            self.moviesArray = response[@"results"];
            [self.collectionView reloadData];
        }else
            [errorAlertView show];
        [self.refreshControl endRefreshing];
    }];
}



@end
