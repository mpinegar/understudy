/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

@class NSString;

/// \addtogroup BackRow

/// \ingroup BackRow
@interface RUIPreferences : NSObject
{
    NSString *_domain;
    BOOL _syncOnWrite;
}

+ (id)sharedFrontRowPreferences;
- (id)initWithDomain:(id)fp8;
- (void)dealloc;
- (id)domain;
- (void)setSynchronizeOnWrite:(BOOL)fp8;
- (void)syncNow;
- (id)objectForKey:(id)fp8;
- (int)integerForKey:(id)fp8;
- (float)floatForKey:(id)fp8;
- (BOOL)boolForKey:(id)fp8;
- (BOOL)boolForKey:(id)fp8 withValueForMissingPrefs:(BOOL)fp12;
- (id)stringForKey:(id)fp8;
- (id)descriptionForKey:(id)fp8;
- (BOOL)canSetPreferencesForKey:(id)fp8;
- (BOOL)setInteger:(int)fp8 forKey:(id)fp12;
- (BOOL)setFloat:(float)fp8 forKey:(id)fp12;
- (BOOL)setBool:(BOOL)fp8 forKey:(id)fp12;
- (BOOL)setObject:(id)fp8 forKey:(id)fp12;

@end
