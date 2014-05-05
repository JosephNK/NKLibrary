//
//  NKURL_ENUM.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 5..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

typedef NS_ENUM(NSUInteger, NKURLDataType) {
    // HTTPHeaderField("Content-Type") Set "application/x-www-form-urlencoded";
    // HTTPHeaderField("Accept") Set "*/*";
    NKURLDataTypeTEXT,
    
    // HTTPHeaderField("Content-Type") Set "application/json;";
    // HTTPHeaderField("Accept") Set "application/json;";
    NKURLDataTypeJSON,
    
    // HTTPHeaderField("Content-Type") Set "application/json;";
    // HTTPHeaderField("Accept") Set "*/*";
    NKURLDataTypeReceiveJSON,
    
    // HTTPHeaderField("Content-Type") Set "*/*";
    // HTTPHeaderField("Accept") Set "application/json;";
    NKURLDataTypeResponseJSON,
};