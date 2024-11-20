//
// GLDraw.cpp
// GLGeometryLib
//
// Created by Sergei Iakovlev on 16.11.2024
// Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

#include "GLDraw.hpp"

// Vertex Shader Source
const char* vertexShaderSource = R"(
attribute vec4 a_Position;
uniform mat4 u_Transform;
void main() {
gl_Position = u_Transform * a_Position;
}
)";

// Fragment Shader Source
const char* fragmentShaderSource = R"(
precision mediump float;
uniform vec4 u_Color;
void main() {
gl_FragColor = u_Color;
}
)";


GLuint compileShader(GLenum type, const char* source) {
    GLuint shader = glCreateShader(type);
    glShaderSource(shader, 1, &source, nullptr);
    glCompileShader(shader);

    GLint compileStatus;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus);
    if (compileStatus != GL_TRUE) {
        char buffer[512];
        glGetShaderInfoLog(shader, sizeof(buffer), nullptr, buffer);
        printf("Shader Compilation Error: %s\n", buffer);
    }
    return shader;
}


void drawGeometry(Geometry *geometry) {
    // Compile Shaders
    GLuint vertexShader = compileShader(GL_VERTEX_SHADER, vertexShaderSource);
    GLuint fragmentShader = compileShader(GL_FRAGMENT_SHADER, fragmentShaderSource);

    // Create Shader Program
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);

    // Use the program
    glUseProgram(program);

    // Get attribute and uniform locations
    GLint positionAttrib = glGetAttribLocation(program, "a_Position");
    GLint colorUniform = glGetUniformLocation(program, "u_Color");

    // Set color
    glUniform4f(colorUniform, 1.0f, 0.0f, 0.0f, 1.0f);

    // Upload vertex data
    GLuint vbo;
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(geometry->triangles) * geometry->trianglesCount, geometry->triangles, GL_STATIC_DRAW);

    // Set up vertex attribute pointers
    glEnableVertexAttribArray(positionAttrib);
    glVertexAttribPointer(positionAttrib, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), nullptr);
    
    // Prepare rotation matrix
    GLuint transformLoc = glGetUniformLocation(program, "u_Transform");
    glUniformMatrix4fv(transformLoc, 1, GL_FALSE, geometry->rotationMatrix);

    // Clear the screen
    glClear(GL_COLOR_BUFFER_BIT);

    // Draw
    glDrawArrays(GL_TRIANGLES, 0, geometry->trianglesCount / 2);

    // Cleanup
    glDeleteBuffers(1, &vbo);
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    glDeleteProgram(program);
}
