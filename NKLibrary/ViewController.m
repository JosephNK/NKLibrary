//
//  ViewController.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 4..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "ViewController.h"

#import "NKMacro.h"

//#import "NKURLConnectionOperation.h"

#import "NKURLConnection.h"

@interface ViewController ()
@property (nonatomic) NSOperationQueue *queue;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSAssert(self.view, @"View must not be nil.");
//    int a = 0;
//    NSAssert(a == 0, @"a is not 0" );
    
//    [self performSelector:@selector(test2) withObject:nil afterDelay:3.0f];
    
    _queue = [[NSOperationQueue alloc] init];
    [_queue setMaxConcurrentOperationCount:1];

//    [self performSelector:@selector(test3) withObject:nil afterDelay:3.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(id)sender {
    [self test3];
}

- (void)test2 {
    //NSString *url = @"http://download.thinkbroadband.com/5MB.zip";
    //NSString *url = @"http://www.wowlolfunny.com/wp-content/uploads/2014/05/wow-wallpaper-1.jpg";
    //NSString *url = @"http://58.181.32.102:7000/net/index2.php";
    //NSString *url = @"http://farm7.staticflickr.com/6191/6075294191_4c8ca20409.jpg";
}

- (void)test3 {
/*
    {
        NSString *URLString = @"https://httpbin.org/delay/1";
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]
                                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                                timeoutInterval:60.0];
        [request setHTTPMethod: @"GET"];
        
        NKURLConnectionOperation *operation = [NKURLConnectionOperation
                                               request:request
                                               success:^(NKURLConnectionOperation *operation, id responseData) {
                                                   NSLog(@"success in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
                                                   if (responseData) {
                                                       NSLog(@"[1] get data size: %d", [(NSData *)responseData length]);
                                                   }
                                               } failure:^(NKURLConnectionOperation *operation, NSError *error) {
                                                   NSLog(@"failure in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
                                                   if (error) {
                                                       NSLog(@"error : %@", [error description]);
                                                   }
                                               }];
        
        [_queue addOperation:operation];
        //[operation start];
        //[operation cancel];
        //[operation start];
    }
    
    {
        NSString *URLString = @"http://farm7.staticflickr.com/6191/6075294191_4c8ca20409.jpg";
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]
                                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                                timeoutInterval:60.0];
        [request setHTTPMethod: @"GET"];
        
        NKURLConnectionOperation *operation = [NKURLConnectionOperation
                                               request:request
                                               success:^(NKURLConnectionOperation *operation, id responseData) {
                                                   NSLog(@"success in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
                                                   if (responseData) {
                                                       NSLog(@"[2] get data size: %d", [(NSData *)responseData length]);
                                                   }
                                               } failure:^(NKURLConnectionOperation *operation, NSError *error) {
                                                   NSLog(@"failure in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
                                                   if (error) {
                                                       NSLog(@"error : %@", [error description]);
                                                   }
                                               }];
        
        [_queue addOperation:operation];
        //[operation start];
        //[operation cancel];
        //[operation start];
    }
*/
    {
        
        NKURLConnection *connection = [NKURLConnection manager];
        
//        NSString *URLString = @"http://farm7.staticflickr.com/6191/6075294191_4c8ca20409.jpg";
//        [connection requestHttpURL:URLString method:@"POST" parameters:nil
//                           success:^(NKURLConnectionOperation *operation, id responseData) {
//                               NSLog(@"success in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
//                               if (responseData) {
//                                   NSLog(@"[1] get data size: %d", [(NSData *)responseData length]);
//                               }
//                           } error:^(NKURLConnectionOperation *operation, NSError *error) {
//                               NSLog(@"failure in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
//                               if (error) {
//                                   NSLog(@"error : %@", [error description]);
//                               }
//                           }];
//        NSString *URLString1 = @"https://httpbin.org/delay/1";
//        [connection requestHttpURL:URLString1 method:@"POST" parameters:nil
//                           success:^(NKURLConnectionOperation *operation, id responseData) {
//                               NSLog(@"success in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
//                               if (responseData) {
//                                   NSLog(@"[2] get data size: %d", [(NSData *)responseData length]);
//                               }
//                           } error:^(NKURLConnectionOperation *operation, NSError *error) {
//                               NSLog(@"failure in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
//                               if (error) {
//                                   NSLog(@"error : %@", [error description]);
//                               }
//                           }];
        NSString *URLString2 = @"http://www.wowlolfunny.com/wp-content/uploads/2014/05/wow-wallpaper-1.jpg";
        [connection requestHttpURL:URLString2 method:@"POST" parameters:nil
                           success:^(NKURLConnectionOperation *operation, id responseData) {
                               NSLog(@"success in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
                               if (responseData) {
                                   NSLog(@"[3] get data size: %d", [(NSData *)responseData length]);
                                   self.imageView.image = [UIImage imageWithData:responseData];
                               }
                           } error:^(NKURLConnectionOperation *operation, NSError *error) {
                               NSLog(@"failure in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
                               if (error) {
                                   NSLog(@"error : %@", [error description]);
                               }
                           }];
//        NSString *URLString3 = @"https://posttestserver.com/post.php";
//        NSDictionary *parameters3 = @{@"key":@"value"};
//        [connection requestHttpURL:URLString3 method:@"POST" parameters:parameters3
//                           success:^(NKURLConnectionOperation *operation, id responseData) {
//                               NSLog(@"success in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
//                               if (responseData) {
//                                   NSLog(@"[4] get data size: %d", [(NSData *)responseData length]);
//                               }
//                           } error:^(NKURLConnectionOperation *operation, NSError *error) {
//                               NSLog(@"failure in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
//                               if (error) {
//                                   NSLog(@"error : %@", [error description]);
//                               }
//                           }];
    }
    
}

@end
