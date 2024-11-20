//
// GLGeometryLib.h
// GLGeometryLib
//
// Created by Sergei Iakovlev on 17.11.2024
// Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

#ifndef GLGeometryLib_h
#define GLGeometryLib_h

#import <Foundation/Foundation.h>

@interface IBTGeometry : NSObject

-(instancetype)init:(float *)points count:(int)count;

-(void)apply:(float)rotation;
-(void)draw;

@end

#endif /* GLGeometryBridge_h */
