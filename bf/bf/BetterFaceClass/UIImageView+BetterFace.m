//
//  UIImageView+BetterFace.m
//  bf
//
//  Created by croath on 13-10-22.
//  Copyright (c) 2013年 Croath. All rights reserved.
//

#import "UIImageView+BetterFace.h"
#import <objc/runtime.h>

@implementation UIImageView (BetterFace)

void hack_uiimageview_bf(){
    Method oriSetImgMethod = class_getInstanceMethod([UIImageView class], @selector(setImage:));
    Method newSetImgMethod = class_getInstanceMethod([UIImageView class], @selector(setBetterFaceImage:));
    method_exchangeImplementations(newSetImgMethod, oriSetImgMethod);
}

- (void)setBetterFaceImage:(UIImage *)image{
    [self setBetterFaceImage:image];
    if (![self needsBetterFace]) {
        return;
    }
    
    [self faceDetect:image];
}

char fooKey;
- (void)setNeedsBetterFace:(BOOL)needsBetterFace{
    objc_setAssociatedObject(self,
                             &fooKey,
                             [NSNumber numberWithBool:needsBetterFace],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)needsBetterFace{
    NSNumber *associatedObject = objc_getAssociatedObject(self, &fooKey);
    return [associatedObject boolValue];
}

- (void)faceDetect:(UIImage *)aImage
{
    CIImage* image = [CIImage imageWithCGImage:aImage.CGImage];
    NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                      forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:opts];
    
    //Pull out the features of the face and loop through them
    NSArray* features = [detector featuresInImage:image];
    
    if ([features count]==0) {
        NSLog(@"no faces");
        
    } else {
        NSLog(@"succeed %d faces", [features count]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self markAfterFaceDetect:features size:CGSizeMake(CGImageGetWidth(aImage.CGImage), CGImageGetHeight(aImage.CGImage))];
        });
    }
}

-(void)markAfterFaceDetect:(NSArray *)features size:(CGSize)size{
    CGRect fixedRect = CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);
    CGFloat rightBorder = 0, bottomBorder = 0;
    for (CIFaceFeature *f in features){
        NSLog(@"%f %f", f.bounds.origin.x, f.bounds.origin.y);
        CGRect oneRect = f.bounds;
        oneRect.origin.y = size.height - oneRect.origin.y - oneRect.size.height;
        
        fixedRect.origin.x = MIN(oneRect.origin.x, fixedRect.origin.x);
        fixedRect.origin.y = MIN(oneRect.origin.y, fixedRect.origin.y);
        
        rightBorder = MAX(oneRect.origin.x + oneRect.size.width, rightBorder);
        bottomBorder = MAX(oneRect.origin.y + oneRect.size.height, bottomBorder);
    }
    
    fixedRect.size.width = rightBorder - fixedRect.origin.x;
    fixedRect.size.height = bottomBorder - fixedRect.origin.y;
    
    CGPoint fixedCenter = CGPointMake(fixedRect.origin.x + fixedRect.size.width / 2.0,
                                      fixedRect.origin.y + fixedRect.size.height / 2.0);
    CGPoint offset = CGPointZero;
    CGSize finalSize = size;
    if (size.width / size.height > self.bounds.size.width / self.bounds.size.height) {
        //move horizonal
        finalSize.height = self.bounds.size.height;
        finalSize.width = size.width/size.height * finalSize.height;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        while (offset.x >= 0 && offset.x + self.bounds.size.width <= finalSize.width) {
            if (fixedCenter.x - offset.x <= self.bounds.size.width * 0.5) {
                break;
            } else {
                offset.x += 1;
            }
        }
        offset.x = -offset.x - 1;
    } else {
        //move vertical
        finalSize.width = self.bounds.size.width;
        finalSize.height = size.height/size.width * finalSize.width;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        while (offset.y >= 0 && offset.y + self.bounds.size.height <= finalSize.height) {
            if (fixedCenter.y - offset.y <= self.bounds.size.height * 0.3) {
                break;
            } else {
                offset.y += 1;
            }
        }
        offset.y = -offset.y - 1;
    }
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(offset.x,
                             offset.y,
                             finalSize.width,
                             finalSize.height);
    layer.contents = (id)self.image.CGImage;
    [self.layer addSublayer:layer];
}

@end
