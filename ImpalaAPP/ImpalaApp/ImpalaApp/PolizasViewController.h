//
//  PolizasViewController.h
//  ImpalaApp
//
//  Created by Guillermo Vera on 3/26/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomCell.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
@protocol PolizaDelegate<NSObject>
@required
-(void)didClickedRefreshButton;
@end
@interface PolizasViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate>
@property (nonatomic, assign) id <PolizaDelegate>delegate; //delegates are weak!!!
- (IBAction)settingsPressed:(id)sender;


@end
