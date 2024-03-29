/*
 *     Generated by class-dump 3.3.1 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRSingleton.h"

@class NSMutableArray, NSMutableDictionary;

/// \addtogroup BackRow

/// \ingroup BackRow
@interface BRMenuSavedState : BRSingleton
{
    NSMutableArray *_currentStackPath;
    NSMutableDictionary *_cachedMenuState;
    BOOL _enabled;
}

+ (id)singleton;
+ (void)setSingleton:(id)arg1;
+ (void)controllerToBePushed:(id)arg1;
+ (void)controllerToBePopped:(id)arg1;
+ (void)saveSelection:(id)arg1 atIndex:(int)arg2;
+ (BOOL)previousSelectionForController:(id)arg1 previousSelection:(id *)arg2 previousIndex:(long *)arg3;
- (id)init;
- (void)dealloc;
- (void)setObject:(id)arg1 forKey:(id)arg2;
- (id)objectForKey:(id)arg1;
- (void)purge;
- (BOOL)enabled;
- (void)setEnabled:(BOOL)arg1;

@end

