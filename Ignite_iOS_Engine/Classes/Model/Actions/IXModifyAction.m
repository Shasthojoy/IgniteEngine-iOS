//
//  IXModifyAction.m
//  Ignite iOS Engine (IX)
//
//  Created by Robert Walsh on 10/15/13.
//  Copyright (c) 2013 Apigee, Inc. All rights reserved.
//

#import "IXModifyAction.h"

#import "IXSandbox.h"
#import "IXBaseObject.h"
#import "IXActionContainer.h"
#import "IXAppManager.h"
#import "IXViewController.h"
#import "IXNavigationViewController.h"
#import "IXLayout.h"
#import "IXBaseControl.h"
#import "IXBaseDataProvider.h"

@implementation IXModifyAction

-(void)performModify
{
    NSArray* objectIDs = [[self actionProperties] getCommaSeperatedArrayListValue:kIX_ID defaultValue:nil];
    
    if( objectIDs != nil && [self parameterProperties] != nil )
    {
        IXBaseObject* ownerObject = [[self actionContainer] ownerObject];
        IXSandbox* sandbox = [ownerObject sandbox];
        for( NSString* objectID in objectIDs )
        {
            if( [objectID isEqualToString:@"session"] )
            {
                IXPropertyContainer* sessionProperties = [[IXAppManager sharedAppManager] sessionProperties];
                [sessionProperties addPropertiesFromPropertyContainer:[self parameterProperties] evaluateBeforeAdding:YES replaceOtherPropertiesWithTheSameName:YES];
            }
            else
            {
                NSArray* objectsWithID = [sandbox getAllControlAndDataProvidersWithID:objectID
                                                                       withSelfObject:ownerObject];
                for( IXBaseObject* baseObject in objectsWithID )
                {
                    [[baseObject propertyContainer] addPropertiesFromPropertyContainer:[self parameterProperties] evaluateBeforeAdding:YES replaceOtherPropertiesWithTheSameName:YES];

                    [baseObject applySettings];
                    
                    if( [baseObject isKindOfClass:[IXBaseDataProvider class]] )
                    {
                        [((IXBaseDataProvider*)baseObject) loadData:NO];
                    }
                }
            }
        }

        if( [[self parameterProperties] hasLayoutProperties] )
        {
            [[[[IXAppManager sharedAppManager] currentIXViewController] containerControl] layoutControl];
        }
    }
}

-(void)execute
{
    float duration = [[self actionProperties] getFloatPropertyValue:@"duration" defaultValue:0.0f];
    NSString *animationStyle = [[self actionProperties] getStringPropertyValue:@"animation_style" defaultValue:nil];
    
        UIViewAnimationCurve animationCurve;
    
        if ( [animationStyle isEqualToString:@"ease_in_out"] )
            animationCurve = UIViewAnimationCurveEaseInOut;
        else if ( [animationStyle isEqualToString:@"ease_in"] )
            animationCurve = UIViewAnimationCurveEaseIn;
        else if ( [animationStyle isEqualToString:@"ease_out"] )
            animationCurve = UIViewAnimationCurveEaseOut;
        else if ( [animationStyle isEqualToString:@"linear"] )
            animationCurve = UIViewAnimationCurveLinear;
        else
            animationCurve = UIViewAnimationCurveEaseInOut;
    
    if( duration > 0.0f )
    {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options: animationCurve | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [weakSelf performModify];
                         } completion:nil];
    }
    else
    {
        [self performModify];
    }
}

@end
