//
//  JokeCell.m
//  JOKE
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "JokeCell.h"

@interface JokeCell ()

{
    BOOL _selected;
    BOOL _bishiSelected;
}
@end

@implementation JokeCell

- (void)awakeFromNib {
    // Initialization code
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = 18;
    


}
- (IBAction)dianzanAction:(AnimationButton *)sender {
    
    [self.dianZan popOutsideWithDuration:0.5];
    
}
- (IBAction)bishiAction:(id)sender {
    [self.contempt popInsideWithDuration:0.5];

}

//  重绘分割线颜色
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(10, rect.size.height - 1, rect.size.width - 20, 1));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
