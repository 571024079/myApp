//
//  PorscheGalleryModel.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheGalleryModel.h"

@implementation PorscheGalleryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"schemeinfo" : [PorscheGallerSchemeInfo class], @"aroundcarinfo":[PorscheResponserPictureVideoModel class]};
}

- (void)convertPorscheResponserPictureVideoModelToZLCamera
{
    _carpics = [ZLCamera convertToZLCameraFrom:self.aroundcarinfo];
    
    for (PorscheGallerSchemeInfo *scheme in self.schemeinfo)
    {
        scheme.schemepics = [ZLCamera convertToZLCameraFrom:scheme.solutionattalist];
    }
}

@end

@implementation PorscheGallerSchemeInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"solutionattalist":[PorscheResponserPictureVideoModel class]};
    
}

@end
