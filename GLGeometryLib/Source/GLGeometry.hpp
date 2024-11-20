//
// GLGeometry.hpp
// GLGeometryLib
//
// Created by Sergei Iakovlev on 19.11.2024
// Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

#ifndef GLGeometry_hpp
#define GLGeometry_hpp

#include <stdio.h>
#include <OpenGLES/ES2/gl.h>


class Geometry {
    
public:
    Geometry(GLfloat *, GLint);
    ~Geometry();
    
    GLfloat *triangles = nullptr;
    GLint trianglesCount = 0;
    
    GLfloat rotationMatrix[16];
    
    void applyRotation(GLfloat degree);
    
private:
    void triangulate(GLfloat *vertice, GLint size, GLfloat*& triangles, GLint &trianglesSize);
    
};

#endif /* GLGeometry_hpp */
