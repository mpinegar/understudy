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

#import "UNDYouTubeFeed.h"
#import "UNDYouTubeAsset.h"

@implementation UNDYouTubeFeed

- (id)initWithTitle:(NSString*)title forUrl:(NSURL*)url
{
  [super initWithTitle:title];

  NSString* temp = [url absoluteString];
  temp = [UNDYouTubeFeed canonicalFormOfURL:temp];
  url_ = [[NSURL URLWithString:temp] retain];

  return self;
}

- (void)dealloc
{
  [url_ release];
  [super dealloc];
}

- (NSArray*)currentAssets
{
  NSError* err;
  NSXMLDocument* doc = [[NSXMLDocument alloc] initWithContentsOfURL:url_
                                                            options:0
                                                              error:&err];
  [doc autorelease];
  if (!doc) return nil;
  NSMutableArray* assets = [NSMutableArray array];
  NSXMLElement* feed = [doc rootElement];
  NSArray* entries = [feed elementsForName:@"entry"];
  for (NSXMLElement* item in entries) {
    UNDYouTubeAsset* asset = [[UNDYouTubeAsset alloc] initWithXMLElement:item];
    if (asset) [assets addObject:[asset autorelease]];
  }
  return assets;
}

+ (NSString*)canonicalFormOfURL:(NSString*)url
{
  // remove alt properties
  url = [url stringByReplacingOccurrencesOfString:@"&alt=rss" withString:@""];

  // make sure the client property is ytapi-youtube-user
  NSRange client = [url rangeOfString:@"client="];
  if( client.location == NSNotFound ){
    if( [url rangeOfString:@"?"].location == NSNotFound )
      url = [url stringByAppendingString:@"?client=ytapi-youtube-user"];
    else
      url = [url stringByAppendingString:@"&client=ytapi-youtube-user"];
  }else{
    // look for value after the client=
    NSString* value = [url substringFromIndex:client.location+client.length];
    int valPos = [value rangeOfString:@"&"].location;
    if( valPos == NSNotFound ) valPos = [value length];
    NSRange valRange = NSMakeRange(client.location+client.length,valPos);
    [url stringByReplacingCharactersInRange:valRange
                                 withString:@"client=ytapi-youtube-user"];

  }
  // make sure the version property is set as v=2
  if( [url rangeOfString:@"v=2"].location == NSNotFound )
    url = [url stringByAppendingString:@"&v=2"];
  return url;
}
@end
