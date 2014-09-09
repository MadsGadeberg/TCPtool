//
//  TcpAdapter.c
//  TCP Tool
//
//  Created by Mads Gadeberg Jensen on 26/08/14.
//  Copyright (c) 2014 Mads Gadeberg Jensen. All rights reserved.
//

#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>	//inet_addr
#include <string.h>
#include <assert.h>

int socket_desc;
struct sockaddr_in server;

int initSocket(){
    socket_desc = socket(AF_INET , SOCK_STREAM , 0);
    return socket_desc;
}

int connectToHost(const char *address, int port){
    server.sin_addr.s_addr = inet_addr(address);
    server.sin_family = AF_INET;
    server.sin_port = htons( port );
    
    return connect(socket_desc , (struct sockaddr *)&server , sizeof(server));
}

long sendMessage(const char *msg){
    return send(socket_desc , msg , strlen(msg) , 0);
}