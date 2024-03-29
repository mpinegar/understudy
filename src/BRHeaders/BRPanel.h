/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "BRControl.h"

@class NSMutableArray;

/// \addtogroup BackRow

/// \ingroup BackRow
@interface BRPanel : BRControl
{
    NSMutableArray *_controls;
    NSMutableArray *_controlsInDeactivation;
    NSMutableArray *_controlsInActivation;
}

- (id)init;
- (void)dealloc;
- (void)setLayoutManager:(id)fp8;
- (id)layoutManager;
- (void)setNeedsLayout;
- (void)setControls:(id)fp8;
- (void)addControl:(id)fp8;
- (void)insertControl:(id)fp8 atIndex:(long)fp12;
- (void)insertControl:(id)fp8 above:(id)fp12;
- (void)insertControl:(id)fp8 below:(id)fp12;
- (void)removeControl:(id)fp8;
- (id)controls;
- (void)removeAllControls;
- (void)controlWillActivate;
- (void)controlWasActivated;
- (void)controlWillDeactivate;
- (void)controlWasDeactivated;
- (BOOL)brEventAction:(id)fp8;

@end

