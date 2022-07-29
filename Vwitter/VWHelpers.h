//
//  VWHelpers.h
//  Vwitter
//
//  Created by Christina Li on 7/14/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define CAST_TO_CLASS_OR_NIL(object_, class_) ((object_ && [object_ isKindOfClass:class_.class]) ? (id)object_ : nil)

NS_ASSUME_NONNULL_END
