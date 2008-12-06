//
//  FeedMenuController.m
//  Understudy FR Appliance
//
//  Created by Kirk Kelsey
//  Copyright 2008. All rights reserved.
//

#import "FeedMenuController.h"
#import "VideoAsset.h"
#import "VideoController.h"

#import <BackRow/BRControllerStack.h>
#import <BackRow/BRComboMenuItemLayer.h>
#import <BackRow/BRTextMenuItemLayer.h>

#import <Foundation/NSXMLDocument.h>

@implementation FeedMenuController

- (id)initWithUrl:(NSURL*)url
{
  [super init];
  _url = [url retain];

  [self setListTitle:@"Feed"];
  [[self list] setDatasource:self];
  _items = [[NSMutableArray array] retain];
  id item = [BRTextMenuItemLayer progressMenuItem];
  [item  setTitle:@"Loading"];
  [_items addObject:item];
  _assets = [[NSMutableArray array] retain];
  _lastrebuild = [[NSDate distantPast] retain];
  [self performSelectorInBackground:@selector(asyncRebuild:) withObject:nil];
  return self;
}

- (void)dealloc
{
  [_url release];
  [_items release];
  [_assets release];
  [super dealloc];
}

- (void)_errorState
{
  if( [_assets count] == 0 ){
    [_items removeAllObjects];
    id empty = [BRTextMenuItemLayer menuItem];
    [empty setTitle:@"Error Loading Queue"];
    [empty setDimmed:YES];
    [_items addObject:empty];
    [[self list] reload];
  }
}

- (void)rebuildMenu
{
  if( [_lastrebuild timeIntervalSinceNow] > (- 60 * 5)) return;
  [_lastrebuild release];
  _lastrebuild = [[NSDate date] retain];

  NSMutableArray* items = [NSMutableArray array];
  NSMutableArray* assets = [NSMutableArray array];
  NSError* err;
  NSXMLDocument* doc = [[NSXMLDocument alloc] initWithContentsOfURL:_url 
                                                            options:0
                                                              error:&err];
  if( !doc )
  {
    [self _errorState];
    return;
  }
  NSXMLElement* root = [doc rootElement];
  NSXMLElement* channel = [[root elementsForName:@"channel"] objectAtIndex:0];
  NSEnumerator* feeditems = [[channel elementsForName:@"item"] objectEnumerator];
  NSXMLElement* feeditem;
  while( (feeditem = [feeditems nextObject]) ){
    VideoAsset* asset = [[VideoAsset alloc] initWithXMLElement:feeditem];
    BRTextMenuItemLayer* menuitem = [BRTextMenuItemLayer menuItem];
    [menuitem setTitle: [asset seriesName]];
    [menuitem setRightJustifiedText:[asset episodeInfo]];
    [assets insertObject:asset atIndex:0];
    [items insertObject:menuitem atIndex:0];
  }
  [_items autorelease];
  [_assets autorelease];
  _items = [items retain];
  _assets = [assets retain];
  [[self list] reload];
  [self updatePreviewController];
}

- (void)asyncRebuild:(id)a
{
  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  [self rebuildMenu];
  [pool release];
}

#pragma mark BRController

- (void)controlWasActivated
{
  //[self rebuildMenu];
  [self performSelectorInBackground:@selector(asyncRebuild:) withObject:nil];
  [super controlWasActivated];
}

#pragma mark BRMenuController

- (void)itemSelected:(long)itemIndex
{
  VideoController* con;
  if( ![self rowSelectable:itemIndex] ) return;
  VideoAsset* asset = (VideoAsset*) [_assets objectAtIndex:itemIndex];
  con = [[VideoController alloc] initWithVideoAsset:asset];
  [[self stack] pushController:con];
}

#pragma mark BRMediaMenuController

- (BRControl*)previewControlForItem:(long)itemIndex
{
  if( [_assets count] == 0 || itemIndex > [_assets count]) return nil;
  id asset = [_assets objectAtIndex:itemIndex];
  return [BRMediaPreviewControllerFactory previewControlForAsset:asset
                                                    withDelegate:asset];
}

#pragma mark BRMenuListItemProvider
- (long)itemCount
{
  return [_items count];
}

- (NSString*)titleForRow:(long)row
{
  return [[_assets objectAtIndex:row] title];
}

- (BRLayer<BRMenuItemLayer>*)itemForRow:(long)row
{
  return [_items objectAtIndex:row];
}

-(float)heightForRow:(long)row
{
  return 0;
}

-(BOOL)rowSelectable:(long)row
{
  return ([_assets count] == [_items count]);
}


@end
