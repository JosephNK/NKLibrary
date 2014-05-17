//
//  NKImageMetaData.h
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 8..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (ImageMetaData)

/**
 EXIF
 */
- (NSDictionary *)getEXIF;
- (NSString *)getEXIFUserComment;
- (NSString *)getEXIFFocalLength;
- (NSInteger)getEXIFShutterSpeed;
- (NSString *)getEXIFAperture;
- (NSInteger)getEXIFISO;
- (NSString *)getEXIFTaken;
- (void)setEXIFUserComment:(NSString*)comment;

/**
 TIFF
 */
- (NSDictionary *)getTIFF;
- (NSString *)getTIFFCameraModel;

@end




typedef NS_ENUM(NSInteger, NKImageMetaDataType) {
    NKImageMetaDataTypeDefalut,
    NKImageMetaDataTypeEXIF,
    NKImageMetaDataTypeTIFF
};

@interface NKImageMetaData : NSObject

- (NSDictionary *)getMetaDataWithFilePath:(NSString *)path withMetaDataType:(NKImageMetaDataType)metaType;
- (NSDictionary *)getMetaDataWithData:(NSData *)data withMetaDataType:(NKImageMetaDataType)metaType;

- (void)writeToFileWithData:(NSData *)imageData withMetaData:(NSDictionary *)metadata;

- (NSDictionary *)getOriginalImageSizeWithPath:(NSString *)path;

@end
