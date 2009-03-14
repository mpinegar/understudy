/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "BRMediaAsset-Protocol.h"
#import "BRMediaProvider-Protocol.h"

@interface BRBaseMediaAsset : NSObject <BRMediaAsset>
{
    id <BRMediaProvider> _provider;
}

+ (id)defaultImageForMediaType:(id)fp8;
- (id)initWithMediaProvider:(id)fp8;
- (void)dealloc;
- (id)provider;
- (id)assetID;
- (id)artist;
- (id)artistForSorting;
- (id)title;
- (id)titleForSorting;
- (id)mediaSummary;
- (id)mediaDescription;
- (id)copyright;
- (long)duration;
- (long)performanceCount;
- (id)cast;
- (id)directors;
- (id)producers;
- (void)incrementPerformanceCount;
- (void)incrementPerformanceOrSkipCount:(unsigned int)fp8;
- (BOOL)hasBeenPlayed;
- (void)setHasBeenPlayed:(BOOL)fp8;
- (id)mediaURL;
- (id)previewURL;
- (id)mediaUTI;
- (BOOL)hasCoverArt;
- (id)coverArtID;
- (id)thumbnailArtID;
- (id)coverArt;
- (id)thumbnailArt;
- (id)coverArtForBookmarkTimeInMS:(unsigned int)fp8;
- (id)dateAcquired;
- (id)datePublished;
- (id)mediaType;
- (id)primaryGenre;
- (id)genres;
- (int)primaryCollectionOrder;
- (int)physicalMediaID;
- (id)seriesName;
- (id)seriesNameForSorting;
- (id)broadcaster;
- (id)episodeNumber;
- (unsigned int)season;
- (unsigned int)episode;
- (id)mediaCollections;
- (float)userStarRating;
- (void)setUserStarRating:(float)fp8;
- (id)rating;
- (float)starRating;
- (id)publisher;
- (id)composer;
- (id)composerForSorting;
- (BOOL)hasVideoContent;
- (BOOL)isDisabled;
- (BOOL)isProtectedContent;
- (id)playbackRightsOwner;
- (void)setBookmarkTimeInSeconds:(unsigned int)fp8;
- (void)setBookmarkTimeInMS:(unsigned int)fp8;
- (unsigned int)bookmarkTimeInSeconds;
- (unsigned int)bookmarkTimeInMS;
- (unsigned int)startTimeInSeconds;
- (unsigned int)startTimeInMS;
- (unsigned int)stopTimeInSeconds;
- (unsigned int)stopTimeInMS;
- (id)primaryCollection;
- (id)primaryCollectionTitle;
- (id)collections;
- (id)dateAcquiredString;
- (id)datePublishedString;
- (void)logDescription;
- (id)resolution;
- (id)authorName;
- (id)keywords;
- (id)viewCount;
- (id)category;
- (BOOL)isInappropriate;
- (int)grFormat;
- (BOOL)canBePlayedInShuffle;
- (BOOL)isLocal;
- (id)coverArtNoDefault;
- (void)skip;
- (id)imageID;
- (void)registerAsPendingImageProvider:(id)fp8;
- (void)loadImage:(id)fp8;
- (void)willBeDeleted;
- (BOOL)isEqual:(id)fp8;
- (unsigned int)hash;

@end
