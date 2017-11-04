//
//  DetailsMovieClassVC.m
//  MovieDBProject
//
//  Created by iOS Dev on 11/3/17.
//  Copyright © 2017 Snsepro. All rights reserved.
//

#import "DetailsMovieClassVC.h"
#import "DetailsMovieCellClassVC.h"
#import <UIImageView+AFNetworking.h>

@interface DetailsMovieClassVC ()

@end

@implementation DetailsMovieClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView reloadData];


    // Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSIndexPath *nextItem = [NSIndexPath indexPathForItem:_currentRow inSection:0];
    [self.collectionView scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark UICollection View Delgates calls

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.moviesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    DetailsMovieCellClassVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *movieDict = self.moviesArray[indexPath.row];
    cell.lblMovieName.text = movieDict[@"original_title"];
//    cell.imgMmovie.contentMode = UIViewContentModeScaleAspectFill;
    if (movieDict[@"poster_path"] != [NSNull null]) {
        NSString *imageUrl = [@"https://image.tmdb.org/t/p/w780/" stringByAppendingString:movieDict[@"poster_path"]];
        [cell.imgMmovie setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"TMDB"]];
    }
    
    cell.lblMovieOverview.text = movieDict[@"overview"];
    cell.lblRelasedate.text = [NSString stringWithFormat:@"Releasing Date:- %@",movieDict[@"release_date"]];
    
    NSString *strLength = [NSString stringWithFormat:@"%@",movieDict[@"vote_average"]];
    NSInteger textLength = [strLength length];

    if (textLength >= 3) {
        cell.lblMovieRates.text = [[NSString stringWithFormat:@"%@",movieDict[@"vote_average"]]substringToIndex:3];
    }else{
        cell.lblMovieRates.text = [[NSString stringWithFormat:@"%@",movieDict[@"vote_average"]]substringToIndex:1];
        
    }
    
    return cell;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    
    float cellWidth = screenWidth;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}


- (IBAction)BtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
