/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "BRController.h"

@class BRCenteredLayoutManager, BRHeaderControl, BRListControl, BRTextControl, NSDictionary, NSMutableArray;

/// \addtogroup BackRow

/// \ingroup BackRow
@interface BROptionDialog : BRController
{
    int _tag;
    int _currentSelection;
    int _defaultIndex;
    NSDictionary *_userInfo;
    BRHeaderControl *_header;
    BRListControl *_list;
    NSMutableArray *_options;
    id _delegate;
    SEL _actionSelector;
    BRTextControl *_primaryTextControl;
    BRTextControl *_secondaryTextControl;
    BRTextControl *_labelControl;
    BRCenteredLayoutManager *_layoutManager;
}

- (id)init;
- (void)dealloc;
- (void)setTitle:(id)fp8;
- (void)setIcon:(id)fp8 horizontalOffset:(float)fp12 kerningFactor:(float)fp16;
- (void)setActionSelector:(SEL)fp8 target:(id)fp12;
- (void)addOptionText:(id)fp8;
- (void)addOptionText:(id)fp8 isDefault:(BOOL)fp12;
- (id)selectedText;
- (long)selectedIndex;
- (void)setPrimaryInfoText:(id)fp8 withAttributes:(id)fp12;
- (void)setSecondaryInfoText:(id)fp8 withAttributes:(id)fp12;
- (void)setLabel:(id)fp8 withAttributes:(id)fp12;
- (void)setMenuWidthFactor:(float)fp8;
- (void)setTag:(int)fp8;
- (int)tag;
- (void)setUserInfo:(id)fp8;
- (id)userInfo;

@end

