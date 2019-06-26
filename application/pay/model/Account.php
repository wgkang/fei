<?php
// +----------------------------------------------------------------------
// | Yzncms [ 御宅男工作室 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2018 http://yzncms.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 御宅男 <530765310@qq.com>
// +----------------------------------------------------------------------

// +----------------------------------------------------------------------
// | 支付模块模型
// +----------------------------------------------------------------------
namespace app\pay\model;

use app\member\model\Member;
use app\member\service\User as home_user;
use \think\Model;

class Account extends Model
{
    protected $name = 'pay_account';
    // 定义时间戳字段名
    protected $autoWriteTimestamp = true;
    protected $createTime = 'addtime';
    protected $updateTime = false;

    public function getStatusAttr($value)
    {
        $status = ['succ' => '交易成功', 'failed' => '交易失败', 'error' => '交易错误', 'progress' => '交易处理中', 'timeout' => '交易超时', 'cancel' => '交易取消', 'waitting' => '等待付款', 'unpay' => '未付款'];
        return $status[$value];
    }

    public function getPaytimeAttr($value)
    {
        if (!empty($value)) {
            return date('Y-m-d H:i:s', $value);
        } else {
            return '';
        }
    }

    /**
     * 发起订单支付
     * @param float  $money
     * @param string $paytype
     */
    public function submitOrder($money, $pay_type = 'wechat')
    {
        $epay = cache('Pay_Config');
        if ($epay[$pay_type] && $epay[$pay_type]['status']) {
            $uid = home_user::instance()->isLogin() ? home_user::instance()->id : 0;
            $username = home_user::instance()->isLogin() ? home_user::instance()->username : '未知';
            $data = [
                'trade_sn' => date("Ymdhis") . sprintf("%08d", $uid) . mt_rand(1000, 9999),
                'uid' => $uid,
                'username' => $username,
                'type' => 1,
                'money' => $money,
                'payamount' => 0,
                'pay_type' => 'recharge',
                'payment' => trim($epay[$pay_type]['name']),
                'ip' => request()->ip(1),
                'status' => 'unpay',
            ];
            $order = self::create($data);
            $notifyurl = request()->root(true) . '/pay/index/epay/type/notify/pay_type/' . $pay_type;
            $returnurl = request()->root(true) . '/pay/index/epay/type/return/pay_type/' . $pay_type;
            \app\pay\library\Service::submitOrder($money, $order->trade_sn, $pay_type, "充值{$money}元", $notifyurl, $returnurl);
            exit;
        } else {
            throw new Exception("支付方式不存在");
        }

    }

    /**
     * 订单结算
     * @param int    $orderid
     * @param string $payamount
     * @param string $memo
     * @return bool
     */
    public function settle($orderid, $payamount = null, $memo = '')
    {
        $order = self::getByTradeSn($orderid);
        if (!$order) {
            return false;
        }
        if ($order->getData('status') != 'succ') {
            $order->money = $payamount ? $payamount : $order->money;
            $order->paytime = time();
            $order->status = 'succ';
            $order->save();
            // 更新会员余额
            $user = Member::get($order->uid);
            if ($user) {
                $before = $user->amount;
                $after = $user->amount + $order->money;
                //更新会员信息
                $user->save(['amount' => $after]);
                //写入日志
                //MoneyLog::create(['user_id' => $order->user_id, 'money' => $order->amount, 'before' => $before, 'after' => $after, 'memo' => '充值']);
            }
        }
        return true;
    }

}
