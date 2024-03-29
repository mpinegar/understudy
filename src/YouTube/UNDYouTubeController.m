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
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
//  for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with Understudy.  If not, see <http://www.gnu.org/licenses/>.

#import "YouTube/UNDYouTubeController.h"

#import <stdint.h>

#import "Utilities/UNDPreferenceManager.h"
#import "YouTube/UNDYouTubeAsset.h"
#import "YouTube/UNDYouTubeAssetProvider.h"

@implementation UNDYouTubeController

- (id)initWithAsset:(UNDYouTubeAsset*)asset
{
  asset_ = [asset retain];
  return [super init];
}

#define EMBED_URL @"http://youtube.com/apiplayer?enablejsapi=1&fs=1"

- (void)load
{
  [NSApplication sharedApplication];
  NSRect rect = [[UNDPreferenceManager screen] frame];
  view_ = [[WebView alloc] initWithFrame:rect];
  [[[view_ mainFrame] frameView] setAllowsScrolling:NO];
  [view_ setFrameLoadDelegate:self];
  [view_ setResourceLoadDelegate:self];
  window_ = [[NSWindow alloc] initWithContentRect:rect
                                        styleMask:0
                                          backing:NSBackingStoreBuffered
                                            defer:YES];
  [window_ setContentView:view_];
  NSURL* url = [NSURL URLWithString:EMBED_URL];
  NSURLRequest* request = [NSURLRequest requestWithURL:url];
  [[view_ mainFrame] loadRequest:request];
}


- (id)_playerFunction:(NSString*)func{
  NSString* call;
  WebScriptObject* script = [[[view_ windowScriptObject] retain] autorelease];

  call = @"document.getElementsByTagName('EMBED')[0].";
  call = [call stringByAppendingString:func];
  return [script evaluateWebScript:call];
}

/// Returns the desired video quality specified in user preferences.
- (NSString*)videoQuality
{
  UNDYouTubeAssetProvider* provider = [[UNDYouTubeAssetProvider alloc] init];
  NSDictionary* prefs
    = [[UNDPreferenceManager sharedInstance]
        prefsForProvider:[provider providerId]];
  NSString* quality = [prefs objectForKey:@"quality"];
  if (!quality) quality = @"default";
  return [[quality retain] autorelease];
}

// Instruct the page to actually load the video. This will fail if the flash
// player has had a chance to fully load, so cannot be invoked from the webview
// notification routines (but does work based on later user input).
- (BOOL)enqueueVideo
{
  NSString* load = @"loadVideoById('%@',0,'%@')";
  load = [NSString stringWithFormat:load,
                   [asset_ videoID], [self videoQuality]];
  [self _playerFunction:load];

  // if there is a video URL, then the video is loading (or loaded)
  loaded_ = ([self _playerFunction:@"getVideoUrl()"] != nil);
  return loaded_;
}

- (void)attemptEnqueue
{
  while (!loaded_) {
    sleep(1);
    [self performSelectorOnMainThread:@selector(enqueueVideo)
                           withObject:nil
                        waitUntilDone:YES];
  }
}

// <WebFrameLoadDelegate> callback once the video loads
- (void)webView:(WebView*)view didFinishLoadForFrame:(WebFrame*)frame
{
  if (frame != [view mainFrame]) return;
  [window_ display];
  [window_ orderFrontRegardless];
  [window_ setLevel:CGShieldingWindowLevel()];
  [self reveal];
  [self performSelectorInBackground:@selector(attemptEnqueue) withObject:nil];
}

- (void)controlWillActivate
{
  [self load];
}

- (void)controlWillDeactivate
{
  [self returnToFR];

  // FIXME: After 10.6.5, closing the view or window causes Front Row to
  // silently quit (no error, no crash report). The current work-around is to
  // pause the video and hide the window, but we're leaking the objects.

  [view_ stopLoading:self];
  [self _playerFunction:@"pauseVideo()"];
  [window_ orderOut:self];

  // [view_ close];
  // view_ = nil;
  // [window_ close];
  // window_ = nil;
}


- (void)playPause
{
  if( !loaded_ ) return;
  NSNumber* result = [self _playerFunction:@"getPlayerState()"];
  if( (id)result == [WebUndefined undefined] ) return;
  switch( [result intValue] ){
    case -1: // unstarted
      break;
    case 0:  // ended
      break;
    case 1:  // playing
      [self _playerFunction:@"pauseVideo()"];
      break;
    case 2:  // paused
      [self _playerFunction:@"playVideo()"];
      break;
    case 3:  // buffering
      break;
    case 5:  // video cued
      break;
  }
}


// skip 10% of the way through the video
- (void)fastForward
{
  if( !loaded_ ) return;
  NSNumber* time = [self _playerFunction:@"getCurrentTime()"];
  NSNumber* duration = [self _playerFunction:@"getDuration()"];
  int target = [time intValue] + ([duration intValue])/10;
  NSString* seek = [NSString stringWithFormat:@"seekTo(%d,true)",target];
  [self _playerFunction:seek];
}

// jump back 5% of the way to the beginning of the video
- (void)rewind
{
  if( !loaded_ ) return;
  NSNumber* time = [self _playerFunction:@"getCurrentTime()"];
  NSNumber* duration = [self _playerFunction:@"getDuration()"];
  int target = [time intValue] + ([duration intValue])/20;
  NSString* seek = [NSString stringWithFormat:@"seekTo(%d,true)",target];
  [self _playerFunction:seek];
}

@end
