//
//  ViewController.m
//  SOAPEngine AppleTV
//
//  Created by Danilo Priore on 29/11/15.
//  Copyright © 2015 Danilo Priore. All rights reserved.
//

#import "ViewController.h"
#import <SOAPEngineTV/SOAPEngine.h>

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *verses;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SOAPEngine *soap = [[SOAPEngine alloc] init];
    soap.userAgent = @"SOAPEngine";
    soap.licenseKey = @"eJJDzkPK9Xx+p5cOH7w0Q+AvPdgK1fzWWuUpMaYCq3r1mwf36Ocw6dn0+CLjRaOiSjfXaFQBWMi+TxCpxVF/FA==";
    soap.actionNamespaceSlash = YES;
    
    [soap setValue:@"Genesis" forKey:@"BookName"];
    [soap setIntegerValue:1 forKey:@"chapter"];
    [soap requestURL:@"http://www.prioregroup.com/services/americanbible.asmx" soapAction:@"http://www.prioregroup.com/GetVerses" completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
        
        verses = dict[@"BibleBookChapterVerse"];
        [self.collectionView reloadData];
        
    } failWithError:^(NSError *error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SOAPEngine" message:error.description preferredStyle:UIAlertControllerStyleAlert];
        [self showViewController:alert sender:nil];
        
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [verses count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    NSDictionary *verse = verses[indexPath.row];

    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.layer.borderWidth = 1.0;
    cell.layer.cornerRadius = 5.0;

    UILabel *title = [cell viewWithTag:1];
    title.text = [NSString stringWithFormat:@"%@\nChapter %@ Verse %@", verse[@"BookName"], verse[@"Chapter"], verse[@"Verse"]];
    
    UILabel *descr = [cell viewWithTag:2];
    descr.text = verse[@"Text"];
    
    return cell;
}


@end
