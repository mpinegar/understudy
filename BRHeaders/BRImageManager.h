/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "BRSingleton.h"

@class NSLock, NSMutableArray, NSMutableDictionary, NSString;

@interface BRImageManager : BRSingleton
{
    unsigned long long _maxCacheSize;
    unsigned long long _cacheSize;
    NSString *_imageCachePath;
    NSMutableDictionary *_images;
    NSMutableDictionary *_remoteImageRequests;
    NSLock *_remoteImageLock;
    NSMutableArray *_jobQueue;
    BOOL _processJobs;
    BOOL _cachePurging;
    NSMutableArray *_activeDelegates;
}

+ (id)singleton;
+ (void)setSingleton:(id)fp8;
- (id)init;
- (void)dealloc;
- (BOOL)isImageAvailable:(id)fp8;
- (id)imageNameFromURL:(id)fp8;
- (id)writeImageFromURL:(id)fp8;
- (id)writeEncryptedImageFromURL:(id)fp8;
- (id)writeImageFromURL:(id)fp8 isEncrypted:(BOOL)fp12;
- (void)writeImage:(id)fp8 named:(id)fp12;
- (id)_resizingImageOptions;
- (void)_writeImageData:(id)fp8 named:(id)fp12;
- (id)imageNamed:(id)fp8;
- (void)removeImageNamed:(id)fp8;
- (void)remoteImageRequestForMediaID:(id)fp8;
- (void)receivedRemoteITunesImageHandle:(char **)fp8 forID:(id)fp12;
- (BOOL)receiveRemoteImageURL:(id)fp8 forID:(id)fp12;
- (void)receivedRemoteImage:(id)fp8 forID:(id)fp12;
- (BOOL)hasRemoteImageBeenRequestedForMediaID:(id)fp8;
- (void)purgeRemoteRequest;

@end

