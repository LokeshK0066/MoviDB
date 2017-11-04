//
//  DetailsMovieClassVC.h
//  MovieDBProject
//
//  Created by iOS Dev on 11/3/17.
//  Copyright © 2017 Snsepro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsMovieClassVC : UIViewController
@property (strong, nonatomic) NSArray *movieArray;
@property(assign, nonatomic)NSInteger currentRow;
- (IBAction)BtnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *moviesArray;

@end
