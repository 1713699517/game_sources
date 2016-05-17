//
//  _PP_IOS_Recharge.cpp
//  GameBox
//
//  Created by wrc on 13-10-15.
//
//

#include "_PP_IOS_Recharge.h"

#if (AGENT_SDK_CODE == 5)
#import "RootViewController.h"
#import <PPAppPlatformKit/PPAppPlatformKit.h>

#include "UserCache.h"
using namespace ptola;

bool CPP_IOS_Recharge::init()
{
    if(!CCNode::init())
        return false;
     
    int time = [[NSDate date] timeIntervalSince1970];

    //测试  testjie 密码:111111
    char szUID[64];
    char szSID[64];
    strcpy( szUID, CUserCache::sharedUserCache()->getObject("uid"));
    strcpy( szSID, CUserCache::sharedUserCache()->getObject("sid"));
    int uid = atoi(szUID);
    int sid = atoi(szSID);
    
    NSString *strBillNo  = [[NSString alloc] initWithFormat:@"%d-%d", uid, time];
    NSString *strRole    = [[NSString alloc] initWithFormat:@"%d-%d", sid, uid];

    //购买价格 1pp币 = 10钻石
    int nPrice = getPrice();
    [[PPAppPlatformKit sharedInstance] exchangeGoods:nPrice
                                              BillNo:strBillNo
                                           BillTitle:@"商品"
                                              RoleId:strRole
                                              ZoneId:0];

    return true;
}

/**
 * @brief     兑换道具
 * @noti      只有余额大于道具金额时候才有客户端回调。余额不足的情况取决与paramIsLongComet参数，paramIsLongComet = YES，则为充值兑换。回调给服务端，paramIsLongComet = NO ，则只是打开充值界面
 * @param     INPUT paramPrice      商品价格，价格必须为大于等于1的int类型
 * @param     INPUT paramBillNo     商品订单号，订单号长度请勿超过30位，参有特殊符号
 * @param     INPUT paramBillTitle  商品名称
 * @param     INPUT paramRoleId     角色id，回传参数若无请填0
 * @param     INPUT paramZoneId     开发者中心后台配置的分区id，若无请填写0
 * @return    无返回
 */


#endif
