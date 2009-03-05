//
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

#import "ManageFeedsDialog.h"
#import "RenameDialog.h"
#import "UNDPreferenceManager.h"

#import <BackRow/BRControllerStack.h>
#import <BackRow/BRTextMenuItemLayer.h>

@implementation ManageFeedsDialog

enum ManageOptionEnum
{
  AddOption = 0,
  RemoveOption,
  RenameOption,
  MoveOption,
  OptionCount // this must be immediately after the last valid option
};
typedef enum ManageOptionEnum ManageOption;

- (id)init
{
  [super init];
  [self setTitle:[self title]];
  addController_ = [[AddFeedDialog alloc] init];
  [[self list] setDatasource:self];
  return self;
}

- (void)_presentMoveDialog
{
  [moveDialog_ release];
  moveDialog_ = [[BROptionDialog alloc] init];
  [moveDialog_ setTitle:@"Move Feed"];
  UNDPreferenceManager* prefs = [UNDPreferenceManager sharedInstance];
  int i;
  for(i = 0; i<[prefs feedCount]; i++)
    [moveDialog_ addOptionText:[prefs titleAtIndex:i]];  
  [moveDialog_ setActionSelector:@selector(_moveFrom) target:self];
  [[self stack] pushController:moveDialog_];  
}

- (void)_moveFrom
{
  [moveDialog_ setPrimaryInfoText:@"Select new position." 
                   withAttributes:nil];
  [moveDialog_ setActionSelector:@selector(_moveTo) target:self];
  // misusing the |tag|, rather than using the user info
  [moveDialog_ setTag:[moveDialog_ selectedIndex]];
}

- (void)_moveTo
{
  long from = [moveDialog_ tag];
  long to = [moveDialog_ selectedIndex];
  [[UNDPreferenceManager sharedInstance] moveFeedFromIndex:from toIndex:to];
  [[self stack] popController];
}

- (void)_presentRemoveDialog
{
  [removeDialog_ release];
  removeDialog_ = [[BROptionDialog alloc] init];
  [removeDialog_ setTitle:@"Remove Feed"];
  
  UNDPreferenceManager* prefs = [UNDPreferenceManager sharedInstance];
  int i;
  for(i = 0; i<[prefs feedCount]; i++)
    [removeDialog_ addOptionText:[prefs titleAtIndex:i]];  
  [removeDialog_ setActionSelector:@selector(_remove) target:self];
  [[self stack] pushController:removeDialog_];
}

// call back for the remove dialog
- (void)_remove
{
  long index = [removeDialog_ selectedIndex];
  [[UNDPreferenceManager sharedInstance] removeFeedAtIndex:index];
  [[self stack] popController];
}

- (void)_presentRenameDialog
{
  RenameDialog* rename = [[RenameDialog alloc] init];
  [[self stack] pushController:rename];
  [rename autorelease];
}

#pragma mark Controller

- (void)itemSelected:(long)index
{
  ManageOption option = (ManageOption)index;
  switch( option )
  {
    case AddOption:
      [[self stack] pushController:addController_];
      break;
    case RemoveOption:
      [self _presentRemoveDialog];
      break;
    case RenameOption:
      [self _presentRenameDialog];
      break;
    case MoveOption:
      [self _presentMoveDialog];
      break;
    case OptionCount:
      break;
  }
}

- (void)controlWillActivate
{
  [super controlWillActivate];
  [[self list] reload];
  if( ![self rowSelectable:[self selectedItem]] )
    [self setSelectedItem:0];
}

#pragma mark MenuListItemProvider

- (long)itemCount{ return OptionCount; }
- (float)heightForRow:(long)row{ return 0; }
- (BOOL)rowSelectable:(long)row
{
  return (row == 0 || [[UNDPreferenceManager sharedInstance] feedCount] > 0); 
}

- (NSString*)titleForRow:(long)row
{ 
  ManageOption option = (ManageOption)row;
  switch (option) {
    case AddOption: return @"Add Feed";
    case RemoveOption: return @"Remove";
    case RenameOption: return @"Rename";
    case MoveOption: return @"Move";
    case OptionCount: break;
  }
  return @"";
}

- (BRLayer<BRMenuItemLayer>*)itemForRow:(long)row
{
  BRTextMenuItemLayer* item = [BRTextMenuItemLayer menuItem];
  [item setTitle:[self titleForRow:row]];
  if( ![self rowSelectable:row] ) [item setDimmed:YES];
  return item;
}

#pragma mark Understudy Asset
- (BRLayer<BRMenuItemLayer>*)menuItem
{
  BRTextMenuItemLayer* manager = [BRTextMenuItemLayer menuItem];
  [manager setTitle:[self title]];
  return manager;
}

- (BRController*)controller{ return self; }

- (NSString*)title
{
  return @"Manage Feeds";
}

- (NSArray*)containedAssets
{
  return nil;
}

- (BRControl*)preview
{
  return nil;
}

@end
