//
//  Copyright 2009, 2011 Kirk Kelsey.
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

#import "BBCiPlayer/UNDiPlayerController.h"

#import "BBCiPlayer/UNDiPlayerAsset.h"
#import "Utilities/UNDPluginControl.h"
#import "Utilities/UNDPreferenceManager.h"

@implementation UNDiPlayerController

- (id)initWithAsset:(UNDiPlayerAsset*)asset
{
  [super init];
  asset_ = [asset retain];
  return self;
}

- (void)dealloc
{
  [asset_ release];
  [pluginControl_ release];
  [super dealloc];
}

// <WebFrameLoadDelegate> callback once the video loads
- (void)webView:(WebView*)view didFinishLoadForFrame:(WebFrame*)frame
{
  if( frame != [view mainFrame] ) return;
  [window_ display];
  [window_ display];
  [window_ orderFrontRegardless];
  [window_ setLevel:NSScreenSaverWindowLevel];
  [self reveal];
}

- (void)controlWillActivate
{
  [super controlWillActivate];
  [NSApplication sharedApplication];
  NSRect rect = [[UNDPreferenceManager screen] frame];
  mainView_ = [[[WebView alloc] initWithFrame:rect] retain];
  [[[mainView_ mainFrame] frameView] setAllowsScrolling:NO];
  [mainView_ setFrameLoadDelegate:self];
  window_ = [[[NSWindow alloc] initWithContentRect:rect 
                                         styleMask:0 
                                           backing:NSBackingStoreBuffered 
                                             defer:YES] retain];
  [window_ setContentView:mainView_];
  NSURLRequest* pageRequest = [NSURLRequest requestWithURL:[asset_ url]];
  NSLog(@"loading url: %@",[asset_ url]);
  [[mainView_ mainFrame] loadRequest:pageRequest];
  pluginControl_ = [[UNDPluginControl alloc] initWithView:mainView_];
}

- (void)controlWillDeactivate
{
  [super controlWillDeactivate];
  [self returnToFR];
  [mainView_ close]; // subclasses should set this to be the primary web view
  [window_ close];
  window_ = nil;
}

- (void)playPause
{
  [pluginControl_ sendPluginKeyCode:49 withCharCode:0]; // space-bar
}

- (void)fastForward
{
  [pluginControl_ sendPluginKeyCode:48  withCharCode:9]; // tab
}

@end
