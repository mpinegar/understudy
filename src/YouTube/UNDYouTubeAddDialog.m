//
//  Copyright 2009,2011 Kirk Kelsey.
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

#import "UNDYouTubeAddDialog.h"

#import <PubSub/PubSub.h>

#import <BRHeaders/BRControllerStack.h>
#import <BRHeaders/BRListControl.h>
#import <BRHeaders/BRTextMenuItemLayer.h>
#import <BRHeaders/RUISoundHandler.h>

#import "Base/UNDMutableCollection.h"
#import "YouTube/UNDYouTubeAssetProvider.h"

@implementation UNDYouTubeAddDialog

typedef enum {
  kPasteboardUrl,
} YoutubeAssetOption;

- (id)init
{
  [super init];
  [self setTitle:@"YouTube Feeds"];
  feeds_ = [[NSMutableArray arrayWithObjects:@"", // Pasteboard Option.
             @"http://gdata.youtube.com/feeds/base/standardfeeds/most_recent?client=ytapi-youtube-browse&alt=rss",
             @"http://gdata.youtube.com/feeds/base/standardfeeds/recently_featured?client=ytapi-youtube-browse&alt=rss",
             @"http://gdata.youtube.com/feeds/base/standardfeeds/top_favorites?client=ytapi-youtube-browse&alt=rss",
             @"http://gdata.youtube.com/feeds/base/standardfeeds/top_favorites?client=ytapi-youtube-browse&alt=rss&time=today",
             @"http://gdata.youtube.com/feeds/base/standardfeeds/top_rated?client=ytapi-youtube-browse&alt=rss",
             @"http://gdata.youtube.com/feeds/base/standardfeeds/top_rated?client=ytapi-youtube-browse&alt=rss&time=today",
             @"http://gdata.youtube.com/feeds/base/standardfeeds/most_viewed?client=ytapi-youtube-browse&alt=rss&time=today",
             @"http://gdata.youtube.com/feeds/base/standardfeeds/most_viewed?client=ytapi-youtube-browse&alt=rss&time=this_week",
             @"http://gdata.youtube.com/feeds/base/standardfeeds/most_viewed?client=ytapi-youtube-browse&alt=rss&time=this_month",
             @"http://gdata.youtube.com/feeds/base/standardfeeds/most_viewed?client=ytapi-youtube-browse&alt=rss&time=all_time",
             nil] retain];
  titles_ = [[NSMutableArray arrayWithObjects:@"URL From Clipboard",
              @"Recently Added",
              @"Recently Featured",
              @"Top Favorites",
              @"Top Favorites Today",
              @"Top Rated",
              @"Top Rated Today",
              @"Most Popular: This Today",
              @"Most Popular: This Week",
              @"Most Popular: This Month",
              @"Most Popular: All Time", nil] retain];
  [[self list] setDatasource:self];
  return self;
}

- (void)dealloc
{
  [titles_ release];
  [feeds_ release];
  [super dealloc];
}

- (void)setCollection:(UNDMutableCollection*)collection
{
  collection_ = collection;
}

// call-back for an item having been selected
- (void)itemSelected:(long)index
{
  if (![self rowSelectable:index]) return;

  NSString *feed, *title;

  switch (index) {
  case kPasteboardUrl:
    title = @"YouTube Feed";
    feed = [[NSPasteboard generalPasteboard]
                        stringForType:@"NSStringPboardType"];
    break;
  default:
    feed = [feeds_ objectAtIndex:index];
    title = [titles_ objectAtIndex:index];
    break;
  }

  if (![NSURL URLWithString:feed]) {
    [RUISoundHandler playSound:kRUISoundError];
    return;
  }
  NSDictionary* asset =
    [NSDictionary dictionaryWithObjectsAndKeys:feed, @"URL", title, @"title",
                  UNDYouTubeAssetProviderId, @"provider", nil];
  [collection_ addAssetWithDescription:asset atIndex:LONG_MAX];
  [[PSClient applicationClient] addFeedWithURL:[NSURL URLWithString:feed]];

  [[self stack] popController];
}

# pragma mark BRMenuListItemProvider

- (long)itemCount{ return [feeds_ count]; }
- (float)heightForRow:(long)row
{
  (void)row;
  return 0;
}

- (BOOL)rowSelectable:(long)row
{
  (void)row;
  return YES;
}

- (id)titleForRow:(long)row{ return [titles_ objectAtIndex:row]; }

- (id)itemForRow:(long)row
{
  BRTextMenuItemLayer* item;
  item = [BRTextMenuItemLayer menuItem];
  [item setTitle:[self titleForRow:row]];
  return item;
}

@end
