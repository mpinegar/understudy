/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "BRController.h"
#import "BRApplianceControllerIconProtocol-Protocol.h"

@class BRHeaderControl, BRListControl;

/// \addtogroup BackRow

/// \ingroup BackRow
@interface BRMenuController : BRController <BRApplianceControllerIconProtocol>
{
    BRListControl *_list;
    BRHeaderControl *_header;
    id _selectedObject;
    BOOL _preSelectedIndexCalculated;
}

- (id)init;
- (void)dealloc;
- (id)list;
- (id)header;
- (void)setSelectedItem:(long)fp8;
- (long)selectedItem;
- (long)itemCount;
- (void)itemSelected:(long)fp8;
- (id)keyForSavedSelection;
- (int)soundForSelectingItem:(long)fp8;
- (BOOL)indexForPreviousSelection:(long *)fp8;
- (void)setPreSelectedIndex;
- (long)defaultIndex;
- (void)controlWasActivated;
- (void)controlWasDeactivated;
- (void)willBePushed;
- (void)willBePopped;
- (BOOL)isVolatile;
- (void)setSelectedObject:(id)fp8;
- (id)selectedObject;
- (id)loadModelData;
- (void)refreshControllerForModelUpdate;
- (BOOL)isCurrentSelectionValidForModelData:(id)fp8;
- (BOOL)shouldRefreshForUpdateToObject:(id)fp8;
- (void)setApplianceIcon:(id)fp8;
- (void)setApplianceIconHidden:(BOOL)fp8;
- (struct CGRect)applianceIconFrame;

@end

