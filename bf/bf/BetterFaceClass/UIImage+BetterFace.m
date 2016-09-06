//
//  UIImage+BetterFace.m
//  bf
//
//  Created by liuyan on 13-11-25.
//  Copyright (c) 2013年 Croath. All rights reserved.
//

#import "UIImage+BetterFace.h"

#define GOLDEN_RATIO (0.618)

#ifdef BF_DEBUG
#define BFLog(format...) NSLog(format)
#else
#define BFLog(format...)
#endif

@implementation UIImage (BetterFace)

- (UIImage *)betterFaceImageForSize:(CGSize)size
                           accuracy:(BFAccuracy)accurary;
{
    NSArray *features = [UIImage _faceFeaturesInImage:self accuracy:accurary];
    
    if ([features count]==0) {
        BFLog(@"no faces");
        return nil;
    } else {
        BFLog(@"succeed %lu faces", (unsigned long)[features count]);
        return [self _subImageForFaceFeatures:features
                                         size:size];
    }
}

- (UIImage *)_subImageForFaceFeatures:(NSArray *)faceFeatures size:(CGSize)size
{
    CGRect fixedRect = CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);
    CGFloat rightBorder = 0, bottomBorder = 0;
    CGSize imageSize = self.size;
    
    for (CIFaceFeature * faceFeature in faceFeatures){
        CGRect oneRect = faceFeature.bounds;
        // Mirror the frame of the feature
        oneRect.origin.y = imageSize.height - oneRect.origin.y - oneRect.size.height;
        
        // Always get the minimum x & y
        fixedRect.origin.x = MIN(oneRect.origin.x, fixedRect.origin.x);
        fixedRect.origin.y = MIN(oneRect.origin.y, fixedRect.origin.y);
        
        // Calculate the faces rectangle
        rightBorder = MAX(oneRect.origin.x + oneRect.size.width, rightBorder);
        bottomBorder = MAX(oneRect.origin.y + oneRect.size.height, bottomBorder);
    }
    
    // Calculate the size of rectangle of faces
    fixedRect.size.width = rightBorder - fixedRect.origin.x;
    fixedRect.size.height = bottomBorder - fixedRect.origin.y;
    
    CGPoint fixedCenter = CGPointMake(fixedRect.origin.x + fixedRect.size.width / 2.0,
                                      fixedRect.origin.y + fixedRect.size.height / 2.0);
    CGPoint offset = CGPointZero;
    CGSize finalSize = imageSize;
    if (imageSize.width / imageSize.height > size.width / size.height) {
        //move horizonal
        finalSize.height = size.height;
        finalSize.width = imageSize.width/imageSize.height * finalSize.height;
        
        // Scale the fixed center with image scale(scale image to adjust image view)
        fixedCenter.x = finalSize.width/imageSize.width * fixedCenter.x;
        fixedCenter.y = finalSize.width/imageSize.width * fixedCenter.y;
        
        offset.x = fixedCenter.x - size.width * 0.5;
        if (offset.x < 0) {
            // Move outside left
            offset.x = 0;
        } else if (offset.x + size.width > finalSize.width) {
            // Move outside right
            offset.x = finalSize.width - size.width;
        }
        
        // If you want the final image is fit to the image view, you should set the width adjust the image view.
        finalSize.width = size.width;
    } else {
        //move vertical
        finalSize.width = size.width;
        finalSize.height = imageSize.height/imageSize.width * finalSize.width;
        
        // Scale the fixed center with image scale(scale image to adjust image view)
        fixedCenter.x = finalSize.width/imageSize.width * fixedCenter.x;
        fixedCenter.y = finalSize.width/imageSize.width * fixedCenter.y;
        
        offset.y = fixedCenter.y - size.height * (1 - GOLDEN_RATIO);
        if (offset.y < 0) {
            // Move outside top
            offset.y = 0;
        } else if (offset.y + size.height > finalSize.height){
            // Move outside bottom
            // offset.y = finalSize.height = size.height;
            offset.y = finalSize.height - size.height;
        }
        
        // If you want the final image is fit to the image view, you should set the height adjust the image view.
        finalSize.height = size.height;
    }
    
    // The finalSize is just fit the image view now, so we should scale the frame to the image size.
    CGFloat scale = imageSize.width/finalSize.width;
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    // Get the final image rect
    CGRect finalRect = CGRectApplyAffineTransform(CGRectMake(offset.x, offset.y, finalSize.width, finalSize.height),transform);
    // Creat image
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], finalRect);
    UIImage *subImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return subImage;
}

#pragma mark - Util

+ (NSArray *)_faceFeaturesInImage:(UIImage *)image accuracy:(BFAccuracy)accurary
{
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    NSString *accuraryStr = (accurary == kBFAccuracyLow) ? CIDetectorAccuracyLow : CIDetectorAccuracyHigh;
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy: accuraryStr}];
    
    return [detector featuresInImage:ciImage];
}

@end
