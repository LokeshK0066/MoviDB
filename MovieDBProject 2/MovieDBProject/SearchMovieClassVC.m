//
//  SearchMovieClassVC.m
//  MovieDBProject
//
//  Created by iOS Dev on 11/3/17.
//  Copyright © 2017 Snsepro. All rights reserved.
//

#import "SearchMovieClassVC.h"
#import <UIImageView+AFNetworking.h>
#import <JLTMDbClient.h>
#import "DetailsMovieClassVC.h"
#import "DetailsMovieCellClassVC.h"
#import <UIKit+AFNetworking.h>
#import <AFNetworking.h>
#import <UIKit/UIKit.h>

@interface SearchMovieClassVC ()
{
    BOOL searchEnabled;
}
@end

@implementation SearchMovieClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    DetailsMovieCellClassVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *movieDict = self.moviesArray[indexPath.row];
    cell.lblMovieName.text = movieDict[@"original_title"];
    cell.imgMmovie.contentMode = UIViewContentModeScaleAspectFill;
    if (movieDict[@"poster_path"] != [NSNull null]) {
        NSString *imageUrl = [@"https://image.tmdb.org/t/p/w500/" stringByAppendingString:movieDict[@"poster_path"]];
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
#pragma mark Search Movie Through API's

-(void)serviceSearchMovie :(NSString *)movieName{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *strCoverSpace = [movieName stringByReplacingOccurrencesOfString:@" "
                                                                   withString:@"%20"];;
    
    
    NSString *makeSearchURL = [NSString stringWithFormat:@"%@%@",@"https://api.themoviedb.org/3/search/movie?api_key=a70d3051c90db56027c07f8a03f52920&query=",strCoverSpace];
    
    
    
    NSURL *baseUrl = [NSURL URLWithString:makeSearchURL];
    
    AFHTTPSessionManager *baseAPIHandler = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl sessionConfiguration:configuration];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    baseAPIHandler.requestSerializer = requestSerializer;
    baseAPIHandler.responseSerializer.acceptableContentTypes = [baseAPIHandler.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    
    [baseAPIHandler GET:[NSString stringWithFormat:@"%@",baseUrl] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *data1 = responseObject;
        NSLog(@"JSON: %@", data1);
        if ([[data1 objectForKey:@"results"] count]) {
            self.moviesArray = data1[@"results"];
            [self.collectionView reloadData];
            
        }
        else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Oh-ho!!"
                                                                           message:@"No Movie Found."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    
}

- (IBAction)BtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Search delegate methods


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        searchEnabled = NO;
        [self.collectionView reloadData];
    }
    else {
        searchEnabled = YES;
    }
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchEnabled = YES;
    [self serviceSearchMovie:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    searchEnabled = NO;
    [self.collectionView reloadData];
    
}

@end
