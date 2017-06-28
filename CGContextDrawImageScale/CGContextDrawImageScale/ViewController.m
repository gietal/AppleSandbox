//
//  ViewController.m
//  CGContextDrawImageScale
//
//  Created by gietal-dev on 6/16/17.
//  Copyright © 2017 gietal-dev. All rights reserved.
//

#import "ViewController.h"
#import "ImageView.h"

@implementation ViewController {
    
    __weak IBOutlet NSTextField *scaleTextField;
    __weak IBOutlet ImageView *imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];


}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    // Do any additional setup after loading the view.
    [scaleTextField setStringValue:@"1"];
    [imageView setChunkSize:CGSizeMake(99, 99)];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)onScaleSliderChanged:(NSSlider *)sender {
    NSString *str = [NSString stringWithFormat:@"%.2f", [sender floatValue] ];
    [scaleTextField setStringValue:str];
    [imageView setImageScale:[sender floatValue]];
}


@end
