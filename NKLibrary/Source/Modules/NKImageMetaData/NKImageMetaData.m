//
//  NKImageMetaData.m
//  NKLibrary
//
//  Created by JosephNK on 2014. 5. 8..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "NKImageMetaData.h"
#import "NKARCMacro.h"

@implementation NSMutableDictionary (ImageMetaData)

#define EXIF_DICT [self objectForKey:(NSString *)kCGImagePropertyExifDictionary]
#define TIFF_DICT [self objectForKey:(NSString *)kCGImagePropertyTIFFDictionary]
#define IPTC_DICT [self objectForKey:(NSString *)kCGImagePropertyIPTCDictionary]

#pragma mark -
#pragma mark EXIF

- (NSDictionary *)getEXIF {
    return EXIF_DICT;
}

- (NSString *)getEXIFUserComment {
    return [EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifUserComment];
}

- (NSString *)getEXIFFocalLength {
    return [EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifFocalLength];
}

- (NSInteger)getEXIFShutterSpeed {
    float rawShutterSpeed = [[EXIF_DICT objectForKey:(NSString *)kCGImagePropertyExifExposureTime] floatValue];
    NSInteger decShutterSpeed = (1 / rawShutterSpeed);
    return decShutterSpeed; // e.g., 1/%d
}

- (NSString *)getEXIFAperture {
    return [EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifFNumber];
}

- (NSInteger)getEXIFISO {
    return [[[EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifISOSpeedRatings] objectAtIndex:0] integerValue];
}

- (NSString *)getEXIFTaken {
    return [EXIF_DICT objectForKey:(NSString*)kCGImagePropertyExifDateTimeDigitized];
}

- (void)setEXIFUserComment:(NSString*)comment {
    [EXIF_DICT setObject:comment forKey:(NSString*)kCGImagePropertyExifUserComment];
}

#pragma mark -
#pragma mark TIFF

- (NSDictionary *)getTIFF {
    return TIFF_DICT;
}

- (NSString *)getTIFFCameraModel {
    return [TIFF_DICT objectForKey:(NSString*)kCGImagePropertyTIFFModel];
}

@end



@implementation NKImageMetaData

#pragma mark -
#pragma mark Get MetaData

- (NSDictionary *)getMetaDataWithFilePath:(NSString *)path withMetaDataType:(NKImageMetaDataType)metaType {
    CFURLRef refUrl = NK_BRIDGE_CAST(CFURLRef, [NSURL fileURLWithPath:path]);
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL(refUrl, NULL);
    NSDictionary *metadata = NK_BRIDGE_CAST(NSDictionary *, CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL));
    NSMutableDictionary *getMetadata = [NSMutableDictionary dictionaryWithDictionary:metadata];
    
    CFRelease(imageSource);
    
    switch (metaType) {
        case NKImageMetaDataTypeEXIF:
            return [getMetadata getEXIF];
            break;
        case NKImageMetaDataTypeTIFF:
            return [getMetadata getTIFF];
            break;
        default:
            break;
    }
    
    return getMetadata;
}

- (NSDictionary *)getMetaDataWithData:(NSData *)data withMetaDataType:(NKImageMetaDataType)metaType {
    CFDataRef refData = NK_BRIDGE_CAST(CFDataRef, data);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData(refData, NULL);
    NSDictionary *metadata = NK_BRIDGE_CAST(NSDictionary *, CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL));
    NSMutableDictionary *getMetadata = [NSMutableDictionary dictionaryWithDictionary:metadata];
    
    CFRelease(imageSource);
    
    switch (metaType) {
        case NKImageMetaDataTypeEXIF:
            return [getMetadata getEXIF];
            break;
        case NKImageMetaDataTypeTIFF:
            return [getMetadata getTIFF];
            break;
        default:
            break;
    }
    
    return getMetadata;
}

#pragma mark -
#pragma mark Set MetaData

- (NSDictionary *)setUserComment:(NSString *)comment withFilePath:(NSString *)path {
    NSMutableDictionary *metaData = [[self getMetaDataWithFilePath:path withMetaDataType:NKImageMetaDataTypeEXIF] mutableCopy];
    [metaData setEXIFUserComment:comment];
    
    return metaData;
}

- (NSDictionary *)setUserComment:(NSString *)comment withData:(NSData *)data {
    NSMutableDictionary *metaData = [[self getMetaDataWithData:data withMetaDataType:NKImageMetaDataTypeEXIF] mutableCopy];
    [metaData setEXIFUserComment:comment];
    
    return metaData;
}

#pragma mark -
#pragma mark Write To File

- (void)writeToFileWithFilePath:(NSString *)filepath withMetaData:(NSDictionary *)metadata {
    // Creating Image source from image url
    CFURLRef fileURL = NK_BRIDGE_CAST(CFURLRef, [NSURL fileURLWithPath:filepath]);
    CFURLRef url = CFURLCreateFilePathURL(NULL, (CFURLRef)fileURL, NULL);
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL(url, NULL);
    
    if (!imageSource) {
        NSLog(@"Error: Could not create image source");
    }
    
    CFStringRef UTI = CGImageSourceGetType(imageSource); //this is the type of image (e.g., CFSTR("public.jpeg"))
    
    // This will be the data CGImageDestinationRef will write into
    CFMutableDataRef data = CFDataCreateMutable(kCFAllocatorDefault, 0);
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData(data, UTI, 1, NULL);
    
    if (!imageDestination) {
        NSLog(@"Error: Could not create image destination");
    }
    
    // Add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CFDictionaryRef properties = NK_BRIDGE_CAST(CFDictionaryRef, metadata);
    CGImageDestinationAddImageFromSource(imageDestination, imageSource, 0, properties);
    
    BOOL success = NO;
    success = CGImageDestinationFinalize(imageDestination);
    if (!success) {
        NSLog(@"Error: Could not create data from image destination");
    }
    
    NSLog(@"fileURL : %@", fileURL);
    // Write the data into the url
    [(__bridge NSMutableData *) data writeToURL:(__bridge NSURL *)(fileURL) atomically:YES];
    
    // CleanUp
    if (url)
        CFRelease(url);
    if (data)
        CFRelease(data);
    if (imageSource)
        CFRelease(imageSource);
    if (UTI)
        CFRelease(UTI);
    if (imageDestination)
        CFRelease(imageDestination);
}

- (void)writeToFileWithData:(NSData *)imagedata withMetaData:(NSDictionary *)metadata {
    // Creating Image source from image url
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imagedata, NULL);
    
    if (!imageSource) {
        NSLog(@"Error: Could not create image source");
    }
    
    CFStringRef UTI = CGImageSourceGetType(imageSource); //this is the type of image (e.g., CFSTR("public.jpeg"))
    
    // This will be the data CGImageDestinationRef will write into
    CFMutableDataRef data = CFDataCreateMutable(kCFAllocatorDefault, 0);
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData(data, UTI, 1, NULL);
    
    if (!imageDestination) {
        NSLog(@"Error: Could not create image destination");
    }
    
    // Add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(imageDestination, imageSource, 0, (__bridge CFDictionaryRef)metadata);
    
    BOOL success = NO;
    success = CGImageDestinationFinalize(imageDestination);
    if (!success) {
        NSLog(@"Error: Could not create data from image destination");
    }
    
    // Write the data into the file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image1.png"]; //Add the file name
    [(__bridge NSMutableData *)data writeToFile:filePath atomically:YES]; //Write the file
    
    // CleanUp
    if (data)
        CFRelease(data);
    if (imageSource)
        CFRelease(imageSource);
    if (UTI)
        CFRelease(UTI);
    if (imageDestination)
        CFRelease(imageDestination);
}

#pragma mark -
#pragma mark Etc

- (NSDictionary *)getOriginalImageSizeWithPath:(NSString *)path {
    NSData *data = [path dataUsingEncoding:NSUTF8StringEncoding];
    const void *bytes = [data bytes];
    int length = [data length];
    uint8_t *uint8Data = (uint8_t*)bytes;
    
    CFURLRef url = CFURLCreateFromFileSystemRepresentation (kCFAllocatorDefault,
                                                            uint8Data,
                                                            length,
                                                            false);
    if (!url) {
        //printf ("* * Bad input file path\n");
        return nil;
    }
    
    CGImageSourceRef myImageSource;
    
    myImageSource = CGImageSourceCreateWithURL(url, NULL);
    
    CFDictionaryRef imagePropertiesDictionary;
    
    imagePropertiesDictionary = CGImageSourceCopyPropertiesAtIndex(myImageSource,0, NULL);
    
    CFNumberRef imageWidth = (CFNumberRef)CFDictionaryGetValue(imagePropertiesDictionary, kCGImagePropertyPixelWidth);
    CFNumberRef imageHeight = (CFNumberRef)CFDictionaryGetValue(imagePropertiesDictionary, kCGImagePropertyPixelHeight);
    
    int w = 0;  int h = 0;
    
    CFNumberGetValue(imageWidth, kCFNumberIntType, &w);
    CFNumberGetValue(imageHeight, kCFNumberIntType, &h);
    
    CFRelease(imagePropertiesDictionary);
    CFRelease(myImageSource);
    
    NSDictionary *dict = @{@"width" : [NSString stringWithFormat:@"%d", w], @"height" : [NSString stringWithFormat:@"%d", h]};
    return dict;
}

@end
