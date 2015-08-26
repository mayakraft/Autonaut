

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

#ifndef ELEMENTARY_AUTOMATA
#define ELEMENTARY_AUTOMATA

#include "stdlib.h"
#include "math.h"
#include "stdio.h"
#include "string.h"
#include "automata.h"

elementaryAutomata makeElementaryAutomata(unsigned int width, unsigned int height, unsigned char rule, unsigned char *primary){

    int w = width;// + height*2;
    int h = height;
    
//    unsigned char *data = malloc(sizeof(unsigned char) * (w+h*2) * h);
    unsigned char *data = malloc(sizeof(unsigned char) * (w) * h);
    
    // Initial conditions
    if(primary == NULL){
        memset(data,0,sizeof(unsigned char) * (w));//+h*2) );
//        data[ h+((int)(w*.5)) ] = 1;
        data[ ((int)(w*.5)) ] = 1;
    }
    else{
        memcpy(data, primary, width);
    }

    //Elementary Cellular Automata Computation
    for(int j = 1; j < h; j++){
        for(int i = 1; i < w; i++){//for(int i = -h+(j-1)+1; i < w+h-(j-1); i++){
            unsigned int offset = w*(j-1);
            unsigned char bit = (data[(i-1)+offset] << 2) | (data[(i)+offset] << 1) | (data[(i+1)+offset]);
            data[i+w*j] = (rule >> bit) & 1;
        }
    }

    elementaryAutomata eca;
    eca.data = data;//malloc(sizeof(unsigned char)*width*height);
    eca.width = width;
    eca.height = height;
    eca.rule = rule;
//    for(int i = 0; i < height; i++){
//        for(int j = 0; j < width; j++){
//            eca.data[j+width*i] = data[h + i*(w+h*2)];
////        memcpy(eca.data[i*width], data[i*(w+h*2)], width);
//        }
//    }
    return eca;
}


void gifData(elementaryAutomata eca){
    
}

void deleteElementaryAutomata(elementaryAutomata eca){
    free(eca.data);
}

void makeRandomRow(unsigned char *data, unsigned int count){
    data = malloc(sizeof(unsigned char)*count);
    for(int i = 0; i < count; i++)
        data[i] = arc4random()%2;
}

unsigned char* binaryArrayChar(unsigned char input){
    unsigned char *array = malloc(sizeof(unsigned char)*8);
    int powerer, countDown = input;
    for(int i=7;i>=0;i--){
        array[i] = 0;
        powerer = pow(2,i);
        if(countDown >= powerer){
            array[i] = 1;
            countDown -= powerer;
        }
    }
    return array;
}


//    else if(randomStart == 2){
//        float smooth[w];
//        int before, after, afteragain, beforeagain, afterall, first, last;
//        for(int i = 0; i < w; i++){
//            first = i-3;
//            beforeagain = i-2;
//            before = i-1;
//            after = i+1;
//            afteragain = i+2;
//            afterall = i+3;
//            last = i+4;
//            if(first < 0) first = 0;
//            if(beforeagain < 0) beforeagain = 0;
//            if(before < 0) before = 0;
//            if(after >= w) after = w-1;
//            if(afteragain >= w) afteragain = w-1;
//            if(afterall >= w) afterall = w-1;
//            if(last >= w) last = w-1;
//            smooth[i] = data[i]*2/9.0 + data[first]/9.0 + data[beforeagain]/9.0 + data[before]/9.0 + data[after]/9.0 + data[afteragain]/9.0 + data[afterall]/9.0 + data[last]/9.0;
//        }
//        for(int i = 0; i < w; i++){
//            if(smooth[i] > .5)
//                data[i] = 1;
//            else
//                data[i] = 0;
//        }
//    }

#endif

