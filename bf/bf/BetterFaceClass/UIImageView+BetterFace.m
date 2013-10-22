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
    if (![self needsBetterFace]) {
        [self setBetterFaceImage:image];
        return;
    }
    
    [self faceDetect:image];
    CALayer *layer = [CALayer layer];
    layer.frame = [self.layer bounds];
    layer.contents = (id)image.CGImage;
    [self.layer addSublayer:layer];
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
        NSLog(@">>>>> 人脸监测【失败】啦 ～！！！");
        
    } else {
        NSLog(@">>>>> 人脸监测【成功】～！！！>>>>>> ");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self markAfterFaceDetect:features size:CGSizeMake(CGImageGetWidth(aImage.CGImage), CGImageGetHeight(aImage.CGImage))];
        });
    }
}

-(void)markAfterFaceDetect:(NSArray *)features size:(CGSize)size{
    for (CIFaceFeature *f in features){
        NSLog(@"%f %f", f.bounds.origin.x, f.bounds.origin.y);
        CGFloat xScale = self.bounds.size.width / size.width;
        CGFloat yScale = self.bounds.size.height / size.height;
        CGRect rect = CGRectMake(f.bounds.origin.x * xScale,
                                 (size.height - f.bounds.origin.y - f.bounds.size.height) * yScale,
                                 f.bounds.size.width * xScale,
                                 f.bounds.size.height * yScale);
        
        UIView *v = [[UIView alloc] initWithFrame:rect];
        [v setBackgroundColor:[UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:0.3f]];
        [self addSubview:v];
    }
}

@end
