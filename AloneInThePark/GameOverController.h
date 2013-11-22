//
//  GameOverController.h
//  AloneInThePark
//
//  Created by Elton Mendes on 22/11/13.
//  Copyright (c) 2013 Elton Mendes Vieira Junior. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverController : SKSpriteNode

@property(nonatomic,retain)SKScene * scene;

-(void)restartScene;

@end
