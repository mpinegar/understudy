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

#import "LoadingAsset.h"
#import "NetflixFeed.h"
#import "NetflixController.h"

#import <BRControllerStack.h>
#import <BRComboMenuItemLayer.h>
#import <BRTextMenuItemLayer.h>

#import <Foundation/NSXMLDocument.h>

@implementation NetflixFeed

- (id)initWithTitle:(NSString*)title forUrl:(NSURL*)url
{
  [super init];
  title_ = [title copy];
  url_ = [url retain];
  return self;
}

- (void)dealloc
{
  [title_ release];
  [url_ release];
  [super dealloc];
}

- (NSArray*)currentAssets
{
  NSMutableArray* assets = [NSMutableArray array];
  NSError* err;
  NSXMLDocument* doc = [[NSXMLDocument alloc] initWithContentsOfURL:url_ 
                                                            options:0
                                                              error:&err];
  if( !doc ) return nil;
  NSXMLElement* root = [doc rootElement];
  NSXMLElement* channel = [[root elementsForName:@"channel"] objectAtIndex:0];
  NSArray* feeditems = [channel elementsForName:@"item"];
  for( NSXMLElement* feeditem in feeditems ){
    NetflixAsset* asset = [[NetflixAsset alloc] initWithXMLElement:feeditem];
    [assets addObject:asset];
    [asset setDelegate:self];
  }
  assets_ = assets;
  return assets;
}

- (NSString*)title{ return title_; }
- (BRLayer<BRMenuItemLayer>*)menuItem
{
  BRTextMenuItemLayer*item = [BRTextMenuItemLayer folderMenuItem];
  [item setTitle:[self title]];
  return item;
}

- (BRController*)controller
{
  if (!controller_)
    controller_ = [[FeedMenuController alloc] initWithDelegate:self];
  return controller_;
}

- (void)assetUpdated:(NetflixAsset*)asset
{
  [[controller_ list] reload];
}

@end
