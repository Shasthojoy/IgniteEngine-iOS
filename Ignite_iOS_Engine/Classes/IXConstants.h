//
//  IXConstants.h
//  Ignite iOS Engine (IX)
//
//  Created by Robert Walsh on 10/9/13.
//  Copyright (c) 2013 Apigee, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IX_dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread])\
    {\
        block();\
    }\
    else\
    {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

// SPECIAL
extern NSString* const kIX_DUMMY_DATA_MODEL_ENTITY_NAME;
extern NSString* const kIX_ID;
extern NSString* const kIX_TYPE;

// ACTION TYPES
extern NSString* const kIX_ALERT;
extern NSString* const kIX_MODIFY;
extern NSString* const kIX_REFRESH;
extern NSString* const kIX_SET;
extern NSString* const kIX_FUNCTION;

// RANDOMS
extern NSString* const kIX_ANIMATED;
extern NSString* const kIX_TITLE;
extern NSString* const kIX_SUB_TITLE;
extern NSString* const kIX_STYLE;
extern NSString* const kIX_OK;
extern NSString* const kIX_CANCEL;
extern NSString* const kIX_TOUCH;
