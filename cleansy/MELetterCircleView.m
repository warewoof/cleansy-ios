#import "MELetterCircleView.h"

@implementation MELetterCircleView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    NSParameterAssert(text);
    self = [super initWithFrame:frame];
    if (self)
    {
        self.text = text;
    }
    return self;
}

// Override to set the circle's background color.
// The view's background will always be clear.
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.circleColor = backgroundColor;
    [super setBackgroundColor:[UIColor clearColor]];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.circleColor setFill];
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect),
                    CGRectGetWidth(rect)/2, 0, 2*M_PI, YES);
    CGContextFillPath(context);
    
    [self drawSubtractedText:self.text inRect:rect inContext:context];
    
}

- (void)drawSubtractedText:(NSString *)text inRect:(CGRect)rect
                 inContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    // Magic blend mode
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    
    
    CGFloat pointSize =
    [self optimumFontSizeForFont:[UIFont boldSystemFontOfSize:100.f]
                          inRect:rect
                        withText:text];
    
    UIFont *font = [UIFont boldSystemFontOfSize:pointSize];
    
    // Move drawing start point for centering label.
    CGContextTranslateCTM(context, 0,
                          (CGRectGetMidY(rect) - (font.lineHeight/2)));
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(rect), font.lineHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label.layer drawInContext:context];
    
    // Restore the state of other drawing operations
    CGContextRestoreGState(context);
}

-(CGFloat)optimumFontSizeForFont:(UIFont *)font inRect:(CGRect)rect
                        withText:(NSString *)text
{
    // For current font point size, calculate points per pixel
    CGFloat pointsPerPixel = font.lineHeight / font.pointSize;
    
    // Scale up point size for the height of the label.
    // This represents the optimum size of a single letter.
    CGFloat desiredPointSize = rect.size.height * pointsPerPixel;
    
    if ([text length] == 1)
    {
        // In the case of a single letter, we need to scale back a bit
        //  to take into account the circle curve.
        // We could calculate the inner square of the circle,
        // but this is a good approximation.
        desiredPointSize = .80*desiredPointSize;
    }
    else
    {
        // More than a single letter. Let's make room for more.
        desiredPointSize = desiredPointSize / [text length];
    }
    
    return desiredPointSize;
}
@end