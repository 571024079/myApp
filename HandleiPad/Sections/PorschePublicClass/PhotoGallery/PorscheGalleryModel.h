//
//  PorscheGalleryModel.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PorscheGallerSchemeInfo;
@interface PorscheGalleryModel : NSObject
@property (nonatomic, strong) NSArray<PorscheGallerSchemeInfo *> *schemeinfo;   // 方案图片信息
@property (nonatomic, strong) NSArray<PorscheResponserPictureVideoModel *> *aroundcarinfo; // 环车图片信息
@property (nonatomic, strong) NSArray<ZLCamera *> *carpics;
@property (nonatomic, strong) NSNumber *currentSchemeid;

- (void)convertPorscheResponserPictureVideoModelToZLCamera;

@end

@interface PorscheGallerSchemeInfo : NSObject

@property (nonatomic, strong) NSNumber *schemeid;
@property (nonatomic, strong) NSString *schemename;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSArray <PorscheResponserPictureVideoModel *> *solutionattalist;
@property (nonatomic, strong) NSArray <ZLCamera *> *schemepics;
@end
