//
//  ViewController.m
//  Autonaut
//
//  Created by Robby on 8/19/15.
//  Copyright (c) 2015 Robby. All rights reserved.
//

#import "ViewController.h"
#include "automata.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGSize size = CGSizeMake(100, 100);
    
    elementaryAutomata eca = makeElementaryAutomata(size.width, size.height, 90, NULL);
    printf("\n(%d x %d) RULE:%d\n",eca.width, eca.height, eca.rule);
    
    for(int i = 0; i < eca.width; i++){
        for(int j = 0; j < eca.height; j++){
            if(eca.data[i*eca.width+j])
                printf("#");
            else
                printf(".");
        }
        printf("\n");
    }
    
    UIImage *ecaImage = [self ImageWithData:eca.data Width:eca.width Height:eca.height Foreground:[UIColor whiteColor] Background:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] Scale:1.0];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ecaImage];
    [self setView:imageView];

    imageView.layer.magnificationFilter = kCAFilterNearest;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIImage*) ImageWithData:(unsigned char*)data Width:(unsigned int)width Height:(unsigned int)height Foreground:(UIColor*)foreground Background:(UIColor*)background Scale:(CGFloat)scale
{
    if(width > 65535 || height > 65535){
        NSLog(@"width or height cannot exceed 65,535 pixels");
        return nil;
    }
    int visibleWidth = width;
    int visibleHeight = height;
    NSLog(@"FOREGROUND: %@",foreground);
    NSLog(@"BACKGROUND: %@",background);
    NSLog(@"GIF begins");
    CGColorSpaceRef foregroundColorSpace = CGColorGetColorSpace([foreground CGColor]);
    CGColorSpaceRef backgroundColorSpace = CGColorGetColorSpace([background CGColor]);
    if(foregroundColorSpace == kCGColorSpaceModelMonochrome)
        NSLog(@"MATCH 1");
    if(foregroundColorSpace == kCGColorSpaceModelDeviceN)
        NSLog(@"MATCH 2");
    if(foregroundColorSpace == kCGColorSpaceModelRGB)
        NSLog(@"MATCH 3");
    NSLog(@"FG COLORSPACE: %@",foregroundColorSpace);
    NSLog(@"BG COLORSPACE: %@",backgroundColorSpace);
    const CGFloat *lights = CGColorGetComponents([foreground CGColor]);
    const CGFloat *darks = CGColorGetComponents([background CGColor]);
    NSLog(@" LIGHT    DARK");
    for(int i = 0; i < 3; i++)
        NSLog(@"%f %f", lights[i], darks[i]);
    
    unsigned char light_r = lights[0]*255.0;
    unsigned char light_g = lights[1]*255.0;
    unsigned char light_b = lights[2]*255.0;
    unsigned char dark_r = darks[0]*255.0;
    unsigned char dark_g = darks[1]*255.0;
    unsigned char dark_b = darks[2]*255.0;
    
    unsigned char header[30] =                   /*  width  */ /*  height */ /*GCT*/
    {  '\x47','\x49','\x46','\x38','\x39','\x61','\x0f','\x00','\x0f','\x00','\x80','\x00','\x00',
//        /*     color 1    *//*    color 2     */
//        '\xff','\xff','\xff','\x00','\x00','\x00',
        /*     color 1    *//*    color 2     */
        light_r,light_g,light_b,dark_r,dark_g,dark_b,
        /*   left  */ /*   top   */  /*  width  */ /*  height *//*LCT*//*LZW Minimum code size */
        '\x2c','\x00','\x00','\x00','\x00','\x0f','\x00','\x0f','\x00','\x00','\x07'};
    /* 1 Byte to Follow*//*EOI STOP*//*EndOfImage*//*GIFFileTerminator*/
    unsigned char footer[4] = {'\x01','\x81','\x00','\x3b'};
    
    // set image size in header
    float littleEndian, fractionalpart, intpart = 0.0;
    if(visibleWidth > 255){
        littleEndian = visibleWidth/256.0;
        fractionalpart = fmodf(littleEndian, intpart);
        header[6] = header[24] = 1+(int)(255*(littleEndian-((int)(littleEndian))));
        header[7] = header[25] = (int)littleEndian;
    }
    else header[6] = header[24] = visibleWidth;
    if(visibleHeight > 255){
        littleEndian = visibleHeight/256.0;
        fractionalpart = fmodf(littleEndian, intpart);
        header[8] = header[26] = 1+(int)(255*(littleEndian-((int)(littleEndian))));
        header[9] = header[27] = (int)littleEndian;
    }
    else header[8] = header[26] = visibleHeight;
    
    NSMutableData *imageData = [[NSMutableData alloc] initWithBytes:header length:sizeof(unsigned char)*30];
    
    int count = 0;
    unsigned char off= '\x00';
    unsigned char on = '\x01';
    unsigned char line[2] = {96+1,'\x80'};  //96 uncompressed bytes to follow (plus one x80 CLEAR bit)
    
    for (int j=0;j<visibleHeight;j++){
        for(int i=0;i<visibleWidth;i++){
            if(count==0)
                [imageData appendBytes:&line length:2];
            if(data[i+width*j])
                [imageData appendBytes:&off length:1];
            else
                [imageData appendBytes:&on length:1];
            count++;
            if(count == 96) count = 0;
        }
//        if(j == ((int)(visibleHeight/2.0)))
//            NSLog(@"Halfway there");
    }
//    NSLog(@"GIF done");
    [imageData appendBytes:footer length:4];
//    return [UIImage imageWithData:imageData];
    return [UIImage imageWithData:imageData scale:scale];
}


@end
