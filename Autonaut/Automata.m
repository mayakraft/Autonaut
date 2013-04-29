//
//  Automata.m
//  Automatouch
//
//  Created by Robby on 12/31/12.
//  Copyright (c) 2012 Robby Kraft. All rights reserved.
//

#import "Automata.h"

@interface Automata()
{
    bool binaryRule[8];
}
@end

@implementation Automata

@synthesize image;
@synthesize cells;

-(Automata*) initwithRule:(int)ruleNumber width:(int)visibleWidth height:(int)height singlePoint:(BOOL)singlePoint
{
    int i, j;
    int width = visibleWidth + height*2;

    //                Computational Region
    //    |----------------- width ------------------|
    //
    //    +-----------+------------------+-----------+
    //    |  square   |  VISIBLE REGION  |   square  |
    //    |           |                  |           |
    //    |   H * H   |     W  *  H      |   H * H   |
    //    |           |                  |           |
    //    |           |   visibleWidth   |           |
    //    +-----------+------------------+-----------+
    //   to eclipse any effects due to null edge values

    //Convert Decimal to 8-bit Binary
    if(ruleNumber < 256 && ruleNumber >= 0)
    {
        int powerer, ruleNumberCopy = ruleNumber;
        for(i=7;i>=0;i--)
        {
            binaryRule[i] = false;
            powerer = pow(2,i);
            if(ruleNumberCopy >= powerer)
            {
                binaryRule[i] = true;
                ruleNumberCopy -= powerer;
            }
        }
    }
    else return nil;  //rule number must be between 0 and 255

    cells = malloc(sizeof(bool)*width*height);

    //Initial Conditions for Random Seeds
    if(singlePoint)
    {
        for(i = 0; i < width; i++){
            cells[i] = false;
        }
        cells[ ((int)((width)/2)) ] = true;
    }
    else
    {
        for(i = 0; i < width; i++){
            if(arc4random()%2 == 0) cells[i] = false;
            else cells[i] = true;
        }
    }
    //Initial Conditions for One Seed

    //Elementary Cellular Automata Computation
    for(j = 1;j < height; j++){
        for(i = 1;i < width; i++){
            if(((cells[(i-1)+width*(j-1)] && cells[i+width*(j-1)] && cells[(i+1)+width*(j-1)]) && binaryRule[7]) ||
               ( (cells[(i-1)+width*(j-1)] && cells[i+width*(j-1)] && !cells[(i+1)+width*(j-1)]) && binaryRule[6]) ||
               ( (cells[(i-1)+width*(j-1)] && !cells[i+width*(j-1)] && cells[(i+1)+width*(j-1)]) && binaryRule[5]) ||
               ( (cells[(i-1)+width*(j-1)] && !cells[i+width*(j-1)] && !cells[(i+1)+width*(j-1)]) && binaryRule[4]) ||
               ( (!cells[(i-1)+width*(j-1)] && cells[i+width*(j-1)] && cells[(i+1)+width*(j-1)]) && binaryRule[3]) ||
               ( (!cells[(i-1)+width*(j-1)] && cells[i+width*(j-1)] && !cells[(i+1)+width*(j-1)]) && binaryRule[2]) ||
               ( (!cells[(i-1)+width*(j-1)] && !cells[i+width*(j-1)] && cells[(i+1)+width*(j-1)]) && binaryRule[1]) ||
               ( (!cells[(i-1)+width*(j-1)] && !cells[i+width*(j-1)] && !cells[(i+1)+width*(j-1)]) && binaryRule[0]) )
                cells[i+width*j] = true;
            else cells[i+width*j] = false;
            
        }
    }

    ///////////////////////////////////////////////////////////
    //////////////////////   MAKE GIF   ///////////////////////
    ///////////////////////////////////////////////////////////
    
    unsigned char header[30] =                   /*  width  */ /*  height */ /*GCT*/
    {  '\x47','\x49','\x46','\x38','\x39','\x61','\x0f','\x00','\x0f','\x00','\x80','\x00','\x00',
        /*     color 1    *//*    color 2     */
        '\xff','\xff','\xff','\x00','\x00','\x00',
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
    if(height > 255){
        littleEndian = height/256.0;
        fractionalpart = fmodf(littleEndian, intpart);
        header[8] = header[26] = 1+(int)(255*(littleEndian-((int)(littleEndian))));
        header[9] = header[27] = (int)littleEndian;
    }
    else header[8] = header[26] = height;
    
    NSMutableData *imageData = [[NSMutableData alloc] initWithBytes:header length:sizeof(unsigned char)*30];
    //NSLog(@"%@", imageData);
    
    i = 0;
    j = 0;
    int count = 0;
    unsigned char off= '\x00';
    unsigned char on = '\x01';
    unsigned char line[2] = {96+1,'\x80'};  //96 uncompressed bytes to follow (plus one x80 CLEAR bit)
    
    for (j=0;j<height;j++)
    {
        for(i=0;i<visibleWidth;i++)
        {
            if(count==0) [imageData appendBytes:&line length:2];

            if(cells[height+i+width*j]) [imageData appendBytes:&off length:1];
            else [imageData appendBytes:&on length:1];
            
            count++;
            if(count == 96) count = 0;
        }
    }
    
    [imageData appendBytes:footer length:4];
    image = [UIImage imageWithData:imageData];
    return self;
}

-(UIImage*) getImage
{
    return image;
}
@end
