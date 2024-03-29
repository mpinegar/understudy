//
//  Copyright 2008-2011 Kirk Kelsey.
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

#import "HuluFeed.h"
#import "HuluAsset.h"
#import "HuluController.h"

#import <Foundation/NSXMLDocument.h>

@implementation HuluFeed

- (id)initWithTitle:(NSString*)title forUrl:(NSURL*)url
{
  [super initWithTitle:title];
  url_ = [url retain];
  return self;
}

- (void)dealloc
{
  [url_ release];
  [super dealloc];
}

- (NSArray*)currentAssets
{
  NSMutableArray* assets = [[[NSMutableArray alloc] init] autorelease];
  NSError* err;
  NSXMLDocument* doc = [NSXMLDocument alloc];
  doc = [[doc initWithContentsOfURL:url_
                           options:0
                             error:&err] autorelease];
  if( !doc ) return nil;
  NSXMLElement* root = [doc rootElement];
  NSXMLElement* channel = [[root elementsForName:@"channel"] objectAtIndex:0];
  NSArray* feeditems = [channel elementsForName:@"item"];
  for( NSXMLElement* feeditem in feeditems )
  {
    HuluAsset* asset = [[HuluAsset alloc] initWithXMLElement:feeditem];
    [asset autorelease];
    [assets insertObject:asset atIndex:0];
  }
  [assets_ autorelease];
  assets_ = [assets retain];
  return assets;
}

- (BRController*)controller
{
  return [[[UNDMenuController alloc] initWithDelegate:self] autorelease];
}

- (BRControl*)preview
{
  return nil;
}

@end
