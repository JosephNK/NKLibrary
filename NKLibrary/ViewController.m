//
//  ViewController.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 4..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "ViewController.h"

#import "NKURLConnection.h"
#import "NKMacro.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSAssert(self.view, @"View must not be nil.");
//    int a = 0;
//    NSAssert(a == 0, @"a is not 0" );
    
//    [self performSelector:@selector(test) withObject:nil afterDelay:2.0f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test {
    NSString *url = @"http://download.thinkbroadband.com/5MB.zip";
    //NSString *url = @"http://www.ipadenclosures.com/php-oak/themes/global/admin_images/Apple_gray_logo.png";
    
    NKURLConnection *manager = [NKURLConnection manager];
    [manager requestWithURL:url
                       type:NKURLTypeGET
                 parameters:nil
                      async:NO
       receiveResponseBlock:^(NSURLResponse *response) {
           // Receive Response!
           LLog(@"Receive Response!");
       } receiveDataBlock:^(NSData *data) {
           // Receive Data!
           LLog(@"Receive Data!");
       } completeBlock:^(NSData *data) {
           // success!
           LLog(@"Success!");
       } errorBlock:^(NSError *error) {
           // error!
           LLog(@"Error!");
       }
    ];
}

@end
