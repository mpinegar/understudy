//
//  Copyright 2010,2011 Kirk Kelsey.
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

#import "Base/UNDAddAssetDialog.h"
#import "Base/UNDAssetFactory.h"
#import "Base/UNDUnknownAsset.h"
#import "Base/UNDMutableCollection.h"

@implementation UNDAssetFactory

static NSString* kAssetFactoryId = @"factory";

NSString* UNDAssetProviderNameKey  = @"provider";
NSString* UNDAssetProviderTitleKey = @"title";
NSString* UNDAssetProviderUrlKey   = @"URL";
NSString* UNDAssetProviderAssetsKey= @"assets";

- (id)init
{
  providers_ = [[NSMutableDictionary alloc] init];
  [self registerProvider:self];
  return self;
}

UNDAssetFactory* singleton_;
+ (id)singleton
{
  return singleton_;
}

+ (void)setSingleton:(UNDAssetFactory*)value
{
  singleton_ = value;
}

- (void)dealloc
{
  [providers_ release];
  [super dealloc];
}

- (NSObject<UNDAssetProvider>*)providerWithId:(NSString*)identifier
{
  return [providers_ objectForKey:identifier];
}

- (NSArray*)providers
{
  return [providers_ allValues];
}

- (void)registerProvider:(NSObject<UNDAssetProvider>*)provider
{
  [providers_ setObject:provider forKey:[provider providerId]];
}

/// An asset is always provided, though it may be a simple placeholder if the
/// content does not indicate a known provider. The content should be an array
/// or dictionary.
- (NSObject<UNDAsset>*)newAssetForContent:(NSDictionary*)content
{
  NSObject<UNDAsset>* asset = nil;

  NSDictionary* desc = (NSDictionary*)content;
  NSObject<UNDAssetProvider>* provider
    = [self providerWithId:[desc objectForKey:UNDAssetProviderNameKey]];
  asset = [provider newAssetForContent:desc];

  if (!asset) asset = [[UNDUnknownAsset alloc] initWithObject:content];
  return asset;
}

- (NSString*)providerId
{
  return [[kAssetFactoryId copy] autorelease];
}

/// Returns nil (this provider shouldn't appear in the menu).
- (NSString*)providerName
{
  return nil;
}

/// Returns nil.
- (BRController*)assetAdditionDialog
{
  return nil;
}

@end
