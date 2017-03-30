//
//  PorscheVideoPlayer.m
//  HandleiPad
//
//  Created by Robin on 16/11/4.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheVideoPlayer.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PorscheVideoPlayer ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSNumber *videoId;
@end

@implementation PorscheVideoPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewWithUrl:_url];
}

- (instancetype)initWithURL:(NSURL *)URL videoId:(NSNumber *)videoId
{
    self = [super init];
    if (self) {
        self.url = URL;
        self.videoId = videoId;
    }
    return self;
}

- (void)setupViewWithUrl:(NSURL *)url {
    self.allowsPictureInPicturePlayback = NO;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(dismissAVPlayer) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(KEY_WINDOW.bounds.size.width - 65, KEY_WINDOW.bounds.size.height - 40, 50, 30);
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    if (!_isScanModel)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(videoPlayerdeleteVideo) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(CGRectGetMinX(backButton.frame) - 80, KEY_WINDOW.bounds.size.height - 40, 50, 30);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [self.view addSubview:button];
    }

    self.player = [[AVPlayer alloc]initWithURL:url];
}

- (void)videoPlayerdeleteVideo {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除" message:@"确定删除视频？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil];
    [alertView show];
}

- (void)dismissAVPlayer {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        if (self.deleteBlock) {
            self.deleteBlock(self.videoId);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc {
    
    NSLog(@"视频播放器被释放！！！！！！！");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
