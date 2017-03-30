//
//  PorscheVideoPlayer.h
//  HandleiPad
//
//  Created by Robin on 16/11/4.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <AVKit/AVKit.h>

typedef void(^PorscheVideoPlayerDeleteBlcok)(NSNumber *videoId);
@interface PorscheVideoPlayer : AVPlayerViewController

@property (nonatomic, copy) PorscheVideoPlayerDeleteBlcok deleteBlock;
@property (nonatomic) BOOL isScanModel;
- (instancetype)initWithURL:(NSURL *)URL videoId:(NSNumber *)videoId;

@end
