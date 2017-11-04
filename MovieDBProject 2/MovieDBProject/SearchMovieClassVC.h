//
//  SearchMovieClassVC.h
//  MovieDBProject
//
//  Created by iOS Dev on 11/3/17.
//  Copyright © 2017 Snsepro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchMovieClassVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (copy, nonatomic) NSString *imagesBaseUrlString;
@property (strong, nonatomic) NSArray *moviesArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)BtnBack:(id)sender;
@end
