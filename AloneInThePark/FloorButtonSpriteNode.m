//
//  FloorButtonSpriteNode.m
//  AloneInThePark
//
//  Created by Elton Mendes on 21/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import "FloorButtonSpriteNode.h"

@implementation FloorButtonSpriteNode

-(id)initWithTexture:(SKTexture *)texture{
    self = [super initWithTexture:texture];
    self.position = CGPointMake(550, 200);
    [self setScale:0.1];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    self.physicsBody.dynamic = NO;
    self.physicsBody.affectedByGravity = YES;
    
    return self;
}
@end
