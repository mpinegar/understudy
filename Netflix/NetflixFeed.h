//
//  Copyright 2008-2010 Kirk Kelsey.
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

#import <BRMediaMenuController.h>

#import "BaseUnderstudyAsset.h"
#import "FeedMenuController.h"
#import "NetflixAsset.h"

@class BRTextMenuItemLayer;

@interface NetflixFeed : BaseUnderstudyAsset
<FeedDelegate, UNDNetflixAssetUpdateDelegate>
{
 @private
  NSMutableArray* assets_;
  NSMutableArray* unfinishedAssets_;
  NSURL* url_;
  NSString* title_;
  FeedMenuController* controller_;
  unsigned updateSlots_;
  unsigned finishedAssets_;
}

- (id)initWithTitle:(NSString*)title forUrl:(NSURL*)url;

@end
