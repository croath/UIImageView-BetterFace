//
//  ViewController.m
//  bf
//
//  Created by croath on 13-10-22.
//  Copyright (c) 2013年 Croath. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    [_view0 setImage:[UIImage imageNamed:@"up3.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
