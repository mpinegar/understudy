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

#include <regex.h>

#import "UNDNetflixPlayer.h"
#import "UNDPasswordProvider.h"
#import "UNDPluginControl.h"
#import "UNDPreferenceManager.h"
#import "UNDVolumeControl.h"

#import "BRSettingsFacade.h"

#import <ApplicationServices/ApplicationServices.h>
#import <Carbon/Carbon.h>
#import <IOKit/IOKitLib.h>

#define AGENTSTRING @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_1; en-us)"\
" AppleWebKit/531.9 (KHTML, like Gecko) Version/4.0.3 Safari/531.9"

//void changeVolume (float delta);

@implementation UNDNetflixPlayer

@synthesize shouldReturnToFR = shouldReturnToFR_;

int64_t SystemIdleTime(void) {
  int64_t idlesecs = -1;
  io_iterator_t iter = 0;
  if (IOServiceGetMatchingServices(kIOMasterPortDefault,
                                   IOServiceMatching("IOHIDSystem"),
                                   &iter) == KERN_SUCCESS)
  {
    io_registry_entry_t entry = IOIteratorNext(iter);
    if (entry) {
      CFMutableDictionaryRef dict = NULL;
      if (IORegistryEntryCreateCFProperties(entry, &dict, kCFAllocatorDefault, 0)
          == KERN_SUCCESS)
      {
        CFNumberRef obj = CFDictionaryGetValue(dict, CFSTR("HIDIdleTime"));
        if (obj) {
          int64_t nanoseconds = 0;
          if (CFNumberGetValue(obj, kCFNumberSInt64Type, &nanoseconds)) {
            // Divide by 10^9 to convert from nanoseconds to seconds.
            idlesecs = (nanoseconds >> 30);
          }
        }
        CFRelease(dict);
      }
      IOObjectRelease(entry);
    }
    IOObjectRelease(iter);
  }
  return idlesecs;
}

// Sets the mouse cursor visibility based on user activity. Repeatedly calls
// itself with a delay until the player terminates.
- (void) manageMouseVisibility
{
  int64_t time;
  time = SystemIdleTime();
  if (time < 5) CGDisplayShowCursor(kCGDirectMainDisplay);
  else CGDisplayHideCursor(kCGDirectMainDisplay);
  [self performSelector:@selector(manageMouseVisibility)
             withObject:nil
             afterDelay:1];
}

- (void)dealloc
{
  [pluginControl_ release];
  [super dealloc];
}

- (void)loadURL:(NSURL*)url
{
  NSScreen* screen = [UNDPreferenceManager screen];
  NSRect rect = [screen frame];
  rect.origin.x = rect.origin.y = 0;
  mainView_ = [[WebView alloc] initWithFrame:rect];
  [mainView_ setCustomUserAgent:AGENTSTRING];
  [[[mainView_ mainFrame] frameView] setAllowsScrolling:NO];
  [mainView_ setFrameLoadDelegate:self];
  window_ = [[NSWindow alloc] initWithContentRect:rect
                                        styleMask:NSBorderlessWindowMask
                                          backing:NSBackingStoreBuffered
                                            defer:YES
                                           screen:screen];
  [window_ display];
  [window_ orderFrontRegardless];
  [window_ setLevel:NSScreenSaverWindowLevel];
  [window_ setContentView:mainView_];
  NSURLRequest* pageRequest = [NSURLRequest requestWithURL:url];
  [[mainView_ mainFrame] loadRequest:pageRequest];
  pluginControl_ = [[UNDPluginControl alloc] initWithView:mainView_];
}

// Looks for a new window containing the full-screen version of the player.
- (NSWindow*)findFullscreenWindow
{
  if (fsWindow_) return fsWindow_;

  // check the set of windows belonging to the application. we created one
  // explicitly so any other large window is the flash player creating it's own
  NSArray* windows = [[NSApplication sharedApplication] windows];
  int expectedWindows = 1;
  [[windows retain] autorelease];
  if ([windows count] <= expectedWindows) return nil;

  for (NSWindow* window in windows){
    if (window != window_) {
      NSLog(@"fullscreen window found");
      fsWindow_ = [window retain];
      [fsWindow_ setDelegate:self];
      [window_ setLevel:NSNormalWindowLevel];
      [window_ orderBack:self];
    }
  }

  return fsWindow_;
}

// Attempts to activate the full-screen mode.
-(void)fullscreen
{
  // Click in the center of the screen, which should ensure that the player has
  // input focus, then enter the 'f' key to full-screen.
  WebView* view = (WebView*)[pluginControl_ plugin];
  NSSize size = [view frame].size;

  NSPoint fsPoint, basePoint;
  fsPoint.y = size.width/2;
  fsPoint.x = size.height/2;

  basePoint = [view convertPointToBase:fsPoint];

  // press 'f' to activate Netflix (silverlight) player fullscreen
  [pluginControl_ sendPluginKeyCode:3 withCharCode:0];
}

// Periodically checks for a fullscreen window. Since the user can click the
// button explicitly it doesn't suffice to check when it's done programatically.
- (void)lookForFullscreen
{
  if (!fsWindow_) [self findFullscreenWindow];
  [self performSelector:@selector(lookForFullscreen)
             withObject:nil
             afterDelay:1];
}

// Repeatedly tries to enter full-screen mode by calling the `fullscreen'
// method until a full screen window seems to have been created.
- (void)attemptFullscreen
{
  if (!fsWindow_) {
    [self fullscreen];
    [self performSelector:@selector(attemptFullscreen)
               withObject:nil
               afterDelay:1];
  }
}

// make sure the user is logged into the site
- (bool)ensureLogin
{
  static int tried = false;
  if( tried ) return NO;
  tried = true;

  WebScriptObject* script = [mainView_ windowScriptObject];
  NSString *setUser, *setPass, *submit;
  NSString* user = [UNDPreferenceManager accountForService:@"www.netflix.com"];
  [[user retain] autorelease];
  if( !user ) return NO;

  NSString* pass = [UNDPasswordProvider passwordForService:@"www.netflix.com"
                                                   account:user];
  [[pass retain] autorelease];

  if( !user ) return NO;

  setUser = @"document.getElementsByName('email').item(0).value = '%@'";
  setPass = @"document.getElementsByName('password1').item(0).value = '%@'";
  submit  = @"document.getElementsByName('login_form').item(0).submit()";
  setUser = [NSString stringWithFormat:setUser,user];
  setPass = [NSString stringWithFormat:setPass,pass];
  [script evaluateWebScript:setUser];
  [script evaluateWebScript:setPass];
  [script evaluateWebScript:submit];
  return YES;
}

// activate the application
- (void)activate
{
  NSString* name =
    [[[[NSProcessInfo processInfo] processName] retain] autorelease];
  NSString* source =
    @"tell application \"System Events\" to activate application \"%@\"";
  source = [NSString stringWithFormat:source,name];
  NSAppleScript* script = [[[NSAppleScript alloc] initWithSource:source] autorelease];
  NSDictionary* err;
  [script executeAndReturnError:&err];
}

// <WebFrameLoadDelegate> callback once the video loads
- (void)webView:(WebView*)view didFinishLoadForFrame:(WebFrame*)frame
{
  if( frame != [view mainFrame] ) return;
  [self activate];
  [self ensureLogin];
  [self attemptFullscreen];
  [self lookForFullscreen];
}

- (void)playPause
{
  [pluginControl_ sendPluginKeyCode:49 withCharCode:0];
}

- (void)fastForward
{
  if (fsWindow_) {
    NSLog(@"ff");

    CGEventRef e1,e2,e3,e4;
    e1 = CGEventCreateKeyboardEvent(NULL, 56, true);
    e2 = CGEventCreateKeyboardEvent(NULL, 124, true);
    e3 = CGEventCreateKeyboardEvent(NULL, 124, false);
    e4 = CGEventCreateKeyboardEvent(NULL, 56, false);
    CGEventPost(1,e1);
    CGEventPost(1,e2);
    CGEventPost(1,e3);
    CGEventPost(1,e4);
    CFRelease(e1);
    CFRelease(e2);
    CFRelease(e2);
    CFRelease(e4);
  }
}

- (void)rewind
{
}

- (void)returnToFrontRow
{
  if (shouldReturnToFR_) {
    // launch Front Row using the launcher app (not the application itself)
    NSWorkspace* work = [NSWorkspace sharedWorkspace];
    [work launchAppWithBundleIdentifier:@"com.apple.frontrowlauncher"
                                options:NSWorkspaceLaunchDefault
         additionalEventParamDescriptor:[NSAppleEventDescriptor nullDescriptor]
                       launchIdentifier:nil];
    [NSApp performSelector:@selector(terminate:) withObject:self afterDelay:5];
  } else {
    [NSApp terminate:self];
  }
}

- (void)sendRemoteButtonEvent:(RemoteControlEventIdentifier)event
                  pressedDown:(BOOL)pressedDown
                remoteControl:(RemoteControl*)remoteControl
{
  // ignore button release events
  switch(event){
    case kRemoteButtonPlus:
      changeVolume (0.05);
      break;
    case kRemoteButtonMinus:
      changeVolume (-0.05);
      break;
    case kRemoteButtonMenu:
      [self returnToFrontRow];
      break;
    case kRemoteButtonPlay:
      [self playPause];
      break;
    case kRemoteButtonRight:
      [self fastForward];
      break;
    case kRemoteButtonLeft:
      [self rewind];
      break;
  }
}

#pragma mark NSWindowDelegate methods
// Use these to keep track of what happens to the full-screen window. It's the
// easiest way to determine if our actions succeed, and we'll know if the user
// did something using their mouse

// when the full screen window closes we bring the main window back
- (void)windowWillClose:(NSNotification *)notification
{
//  NSLog (@"window will close");
  fsWindow_ = nil;
  [window_ setLevel:NSScreenSaverWindowLevel];
  [window_ display];
  [window_ orderFrontRegardless];
}

@end
