/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "BRLayer.h"
#import "BRMenuItemLayer-Protocol.h"

@class BRAutoScrollingTextLayer, BRImageLayer, BRTextLayer, BRWaitSpinnerLayer, NSDictionary;

@interface BRTextMenuItemLayer : BRLayer <BRMenuItemLayer>
{
    BRAutoScrollingTextLayer *_textLine;
    BRImageLayer *_rightIconLayer;
    NSDictionary *_rightIconInfo;
    BRImageLayer *_leftIconLayer;
    NSDictionary *_leftIconInfo;
    BRImageLayer *_textIconLayer;
    NSDictionary *_textIconInfo;
    BRTextLayer *_rightJustifiedTextLayer;
    BRWaitSpinnerLayer *_spinner;
    BOOL _highlighted;
    BOOL _dimmed;
}

+ (id)folderMenuItem;
+ (id)networkMenuItem;
+ (id)menuItem;
+ (id)progressMenuItem;
+ (id)progressFolderItem;
+ (id)shuffleMenuItem;
- (id)init;
- (void)dealloc;
- (id)baseTextAttributes;
- (id)centeredTextAttributes;
- (void)setRightIconInfo:(id)fp8;
- (id)rightIconInfo;
- (void)setLeftIconInfo:(id)fp8;
- (id)leftIconInfo;
- (void)setTextIconInfo:(id)fp8;
- (id)textIconInfo;
- (void)setTitle:(id)fp8;
- (void)setTitle:(id)fp8 withAttributes:(id)fp12;
- (id)title;
- (void)setRightJustifiedText:(id)fp8 attributes:(id)fp12;
- (void)setRightJustifiedText:(id)fp8;
- (id)rightJustifiedText;
- (void)setDimmed:(BOOL)fp8;
- (BOOL)dimmed;
- (void)setWaitSpinnerActive:(BOOL)fp8;
- (BOOL)waitSpinnerActive;
- (struct CGRect)frameForCellBounds:(struct CGSize)fp8;
- (void)layoutSublayers;
- (void)highlight;
- (void)unHighlight;
- (void)scrollItemIfNecessary;
- (void)stopScrollingItem;
- (id)axItemText;

@end
