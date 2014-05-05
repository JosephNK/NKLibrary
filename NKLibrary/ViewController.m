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
    
    [self performSelector:@selector(test2) withObject:nil afterDelay:1.0f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)test2 {
    //NSString *url = @"http://download.thinkbroadband.com/5MB.zip";
    //NSString *url = @"http://www.ipadenclosures.com/php-oak/themes/global/admin_images/Apple_gray_logo.png";
    NSString *url = @"http://58.181.32.102:7000/net/index2.php";
    NSDictionary *parameters = @{@"foo": @"한글", @"bar": @"123"};
    NKURLConnection *manager = [NKURLConnection manager];
    manager.request.requestURL = url;
    manager.request.parameters = parameters;
    manager.request.dataType = NKURLDataTypeJSON;
    //manager.request.HTTPMethod = @"POST";
    //manager.connection.async = YES;
    [manager readyRequest:manager.request
               connection:manager.connection
            responseBlock:^(NSURLResponse *response) {
                // Receive Response!
                //LLog(@"Receive Response!");
            } receiveBlock:^(NSData *data) {
                // Receive Data!
                //LLog(@"Receive Data!");
            } successBlock:^(NSData *data) {
                // success!
                //self.imageView.image = [UIImage imageWithData:data];
                LLog(@"Success! = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            } errorBlock:^(NSError *error) {
                // error!
                LLog(@"Error! = %@", [error description]);
            }
    ];
}

@end
