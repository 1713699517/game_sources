//
//  FontMetric_iOS.mm
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#include "FontMetric.h"

#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

using namespace ptola;

static CGSize _calculateStringSize(NSString *str, id font, CGSize *constrainSize)
{
    NSArray *listItems = [str componentsSeparatedByString: @"\n"];
    CGSize dim = CGSizeZero;
    CGSize textRect = CGSizeZero;
    textRect.width = constrainSize->width > 0 ? constrainSize->width
    : 0x7fffffff;
    textRect.height = 10000;
    
    
    for (NSString *s in listItems)
    {
        CGSize tmp = [s sizeWithFont:font constrainedToSize:textRect];
        
        if (tmp.width > dim.width)
        {
            dim.width = tmp.width;
        }
        
        dim.height += tmp.height;
    }
    
    return dim;
}

CCSize CFontMetric::measureTextSize(const char *lpcszString, const char *lpcszFontFamily, float fFontSize, float fLineWidth)
{
    NSString * str  = [NSString stringWithUTF8String:lpcszString];
    NSString * fntName = [NSString stringWithUTF8String:lpcszFontFamily];
    CGSize dim, constrainSize;
    constrainSize.width = fLineWidth;
    
    // On iOS custom fonts must be listed beforehand in the App info.plist (in order to be usable) and referenced only the by the font family name itself when
    // calling [UIFont fontWithName]. Therefore even if the developer adds 'SomeFont.ttf' or 'fonts/SomeFont.ttf' to the App .plist, the font must
    // be referenced as 'SomeFont' when calling [UIFont fontWithName]. Hence we strip out the folder path components and the extension here in order to get just
    // the font family name itself. This stripping step is required especially for references to user fonts stored in CCB files; CCB files appear to store
    // the '.ttf' extensions when referring to custom fonts.
    fntName = [[fntName lastPathComponent] stringByDeletingPathExtension];
    
    // create the font
    id font = [UIFont fontWithName:fntName size:fFontSize];
    
    if (font)
    {
        dim = _calculateStringSize(str, font, &constrainSize);
    }
    else
    {
        if (!font)
        {
            font = [UIFont systemFontOfSize:fFontSize];
        }
        
        if (font)
        {
            dim = _calculateStringSize(str, font, &constrainSize);
        }
    }
    
    return CCSizeMake(dim.width, dim.height);

}

#endif