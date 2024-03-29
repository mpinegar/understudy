//
//  Copyright 2009-2011 Kirk Kelsey.
//
//  This file is part of Understudy.
//
//  Understudy is free software: you can redistribute it and/or modify it under
//  the terms of the GNU Lesser General Public License as published by the Free
//  Software Foundation, either version 3 of the License, or (at your option)
//  any later version.
//
//  Understudy is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
//  for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with Understudy.  If not, see <http://www.gnu.org/licenses/>.

#import <Cocoa/Cocoa.h>

#import <BRHeaders/BRBaseMediaAsset.h>

#import "Base/UNDAsset.h"
#import "Base/UNDBaseAsset.h"

@class BRTextMenuItemLayer;
@class BRImageManager;
@class BRMediaType;

@class UNDYouTubeFeed;

@interface UNDYouTubeAsset : UNDBaseAsset<UNDAsset>
{
 @private
  NSString* description_;
  long duration_;
  NSString* videoID_; // the YT identifier for the video
  NSDate* published_;
  float starrating_;
  NSString* thumbnailID_;
  NSURL* url_;
  BOOL isVideo_;
  UNDYouTubeFeed* feedDelegate_;
}

// the init function may return nil if parsing fails
- (id)initWithXMLElement:(NSXMLElement*) dom;

- (NSString*)videoID;
@end
