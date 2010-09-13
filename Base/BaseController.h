//                                                                -*- objc -*-
//  Copyright 2008-2009 Kirk Kelsey.
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
#import <WebKit/WebKit.h>
#import <IOKit/pwr_mgt/IOPMLib.h>

#import "BRTextWithSpinnerController.h"

@interface BaseController : BRTextWithSpinnerController {
 @protected
  WebView* mainView_; // subclasses should set this to be the primary web view
  NSWindow* menushield_; // window used to cover the menu bar
  id pluginView_; // WebNetscapePluginDocumentView beneath the mainView (if any)
}


// orders out the FR interface to reveal an understudy player
- (void)reveal;

// brings the FR interface back, and takes any views (main or plugin) out of
// fullscreen mode.
- (void)returnToFR;

// subclasses should override (default does nothing):
- (void)playPause;
- (void)fastForward;
- (void)rewind;
@end

