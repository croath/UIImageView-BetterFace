//
//  ViewController.m
//  bf
//
//  Created by croath on 13-10-22.
//  Copyright (c) 2013年 Croath. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+BetterFace.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [_view0.layer setBorderColor:[UIColor grayColor].CGColor];
    [_view0.layer setBorderWidth:0.5f];
    [_view0 setContentMode:UIViewContentModeScaleAspectFill];
    [_view0 setClipsToBounds:YES];
    
    [_view1.layer setBorderColor:[UIColor grayColor].CGColor];
    [_view1.layer setBorderWidth:0.5f];
    [_view1 setContentMode:UIViewContentModeScaleAspectFill];
    [_view1 setClipsToBounds:YES];
    [_view1 setNeedsBetterFace:YES];
    [_view1 setFast:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tabPressed:(id)sender {
    NSString *imageStr = @"";
    switch ([sender tag]) {
        case 0:
            imageStr = @"up1.jpg";
            break;
        case 1:
            imageStr = @"up2.jpg";
            break;
        case 2:
            imageStr = @"up3.jpg";
            break;
        case 3:
            imageStr = @"up4.jpg";
            break;
        case 4:
            imageStr = @"l1.jpg";
            break;
        case 5:
            imageStr = @"l2.jpg";
            break;
        case 6:
            imageStr = @"l3.jpg";
            break;
        case 7:
            imageStr = @"l4.jpg";
            break;
        case 8:
            imageStr = @"m1.jpg";
            break;
        case 9:
            imageStr = @"m2.jpg";
            break;
        default:
            break;
    }
    
    [_view0 setImage:[UIImage imageNamed:imageStr]];
    [_view1 setImage:[UIImage imageNamed:imageStr]];
}
@end
