//
//  weekendDelegate.h
//  hmg
//
//  Created by Hongxianyu on 16/4/20.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
#import "Brand1.h"
@protocol weekendDelegate <NSObject>

-(void) getSTORE:(Store *) STORE andBRAND:(Brand1 *) BRAND andSTARTDATE:(NSString *) STARTDATE andENDDATE:(NSString *) ENDDATE;

@end
