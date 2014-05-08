//
//  AVAudioSession+Util.h
//  Speaker_TEST
//
//  Created by JosephNK on 2014. 4. 16..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioSession (Util)

+ (void)configureAVAudioSessionForEarSpeaker;
+ (void)configureAVAudioSessionForSpeaker;

@end
