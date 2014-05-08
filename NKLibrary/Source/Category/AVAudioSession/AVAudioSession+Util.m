//
//  AVAudioSession+Util.m
//  Speaker_TEST
//
//  Created by JosephNK on 2014. 4. 16..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "AVAudioSession+Util.h"

@implementation AVAudioSession (Util)

+ (void)configureAVAudioSessionForEarSpeaker {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error:nil];
}

+ (void)configureAVAudioSessionForSpeaker {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error:nil];
}

@end
