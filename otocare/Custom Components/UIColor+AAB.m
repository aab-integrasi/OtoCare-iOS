//
//  UIColor+AAB.m
//  otocare
//
//  Created by Asuransi Astra Buana on 8/15/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "UIColor+AAB.h"

@implementation UIColor (AAB)

+ (UIColor *)AABBlue{
    return [UIColor colorWithRed:(0x57 / 255.0) green:(0xC9 / 255.0) blue:(0xE8 / 255.0) alpha:1.0];
}

+ (UIColor *)AABDeepBlue{ // sekarang label --> header
    return [UIColor colorWithRed:(0x28 / 255.0) green:(0x8D / 255.0) blue:(0xC1 / 255.0) alpha:1.0];
}

+ (UIColor *)AABLightBlue{//sekarang header -->detail
       return [UIColor colorWithRed:(0x00 / 255.0) green:(0x5C / 255.0) blue:(0xB9 / 255.0) alpha:1.0];

}
+ (UIColor *)AABThinBlue{ //sekarang detail -->label
       return [UIColor colorWithRed:(0x80 / 255.0) green:(0xC3 / 255.0) blue:(0xE0 / 255.0) alpha:1.0];

}

+ (UIColor *)AABLightThinBlue{
//       return [UIColor colorWithRed:(0x74 / 255.0) green:(0xCC / 255.0) blue:(0xDD / 255.0) alpha:1.0];
           return [UIColor colorWithRed:(0xA4 / 255.0) green:(0xCC / 255.0) blue:(0xEC / 255.0) alpha:1.0];
}

@end
