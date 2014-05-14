//
//  TRInternalAppAuthService.h
//  TRInternalAppAuth
//
//  Copyright 2011 Thomson Reuters Global Resources. All rights reserved.
//  Proprietary and confidential information of TRGR.  Disclosure, use, or 
//  reproduction without the written authorization of TRGR is prohibited.
//

#ifdef _DEBUG
#define TR_USE_DEBUG_MACROS
#elif DEBUG
#define TR_USE_DEBUG_MACROS
#endif

#ifdef TR_USE_DEBUG_MACROS

    #ifndef TRInternalAppAuthDLog
        #define TRInternalAppAuthDLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
    #endif

    #ifndef TRInternalAppAuthALog
        #define TRInternalAppAuthALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
    #endif

#else

    #ifndef TRInternalAppAuthDLog
        #define TRInternalAppAuthDLog(...) do { } while (0)
    #endif

    #ifndef NS_BLOCK_ASSERTIONS
        #define NS_BLOCK_ASSERTIONS
    #endif

    #ifndef TRInternalAppAuthALog
        #define TRInternalAppAuthALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
    #endif

#endif

#ifndef TRAssert
    #define TRAssert(condition, ...) do { if (!(condition)) { TRInternalAppAuthALog(__VA_ARGS__); }} while(0)
#endif

// The version of the framework
#define TR_INTERNAL_APP_AUTH_VERSION @"2.0.1"

// The name of the notification that will be sent when the user has successfully authenticated, sent immediately before the modal auth view is dismissed
#define TRInternalAppAuthorizationWasSuccessfulNotification @"TRInternalOnlyAppAuthorizationWasSuccessfulNotification"

@interface TRInternalAppAuthService : UIViewController {
}

// Returns YES if the user is already authorized, NO if not.
+ (BOOL)isAuthorized;

// Presents a modal view controller, from the given root view controller, that allows the user to authenticate.
// An NSNotification with name TRInternalOnlyAppAuthorizationWasSuccessfulNotification is posted on success
// NOTE: The rootViewController must already be added as a subview to the app's UIWindow when this method is called
+ (void)authorizeUserModallyFromRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated;

@end
