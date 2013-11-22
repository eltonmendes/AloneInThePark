//
//  GameOverController.m
//  AloneInThePark
//
//  Created by Elton Mendes on 22/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import "GameOverController.h"

@implementation GameOverController

-(id)initWithTexture:(SKTexture *)texture{

    self = [super initWithTexture:texture];
    [self setScale:0.3];
    [self setAlpha:0.5];
    
    return self;
}


-(void)restartScene{
    
    NSLog(@"restarScene");
}


@end
