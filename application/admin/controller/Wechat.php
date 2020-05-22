<?php
/**
 * Created by PhpStorm.
 * User: king
 * Date: 2020-05-22
 * Time: 14:00
 */

namespace app\admin\controller;

use app\admin\model\Wechat as WeChatModel;
use app\admin\model\Links as LinksModel;
use app\index\model\Visits;
use app\admin\service\User;
use app\common\controller\Adminbase;

class Wechat extends Adminbase {

    /**
     * 当前连接关联的微信号列表
     * @return mixed|\think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index()
    {
        $userInfo = User::instance()->getInfo();
        $linkId = $this->request->param('linkId/d', '');
        if ($this->request->isAjax()) {
            if (!LinksModel::where(["id" => $linkId, 'user' => $userInfo['id']])->find()){
                $result = [$linkId,$userInfo['id']];
            }else{
                $result = WeChatModel::order(array('id' => 'DESC'))->where([ 'link_id' => $linkId])->select()->toArray();
                foreach ($result as &$item){
                    $item['visits1'] = Visits::where(['wechat_id' => $item['id'], 'created_time' => date('Y-m-d', time()), 'region' => '1'])->count();
                    $item['visits2'] = Visits::where(['wechat_id' => $item['id'], 'created_time' => date('Y-m-d', time()), 'region' => '2'])->count();
                    $item['visits3'] = Visits::where(['wechat_id' => $item['id'], 'created_time' => date('Y-m-d', time()), 'region' => '3'])->count();
                }
            }
            $total = count($result);
            $result = array("code" => 0, "count" => $total, "data" => $result);
            return json($result);
        }

        $this->assign('isAdmin', $userInfo['roleid'] === 1);
        $this->assign('linkId', $linkId);
        return $this->fetch();
    }

    /**
     * 添加
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function add()
    {
        $userInfo = User::instance()->getInfo();
        if ($this->request->isPost()) {
            $data = $this->request->param();
            if (!LinksModel::where(["id" => $data['link_id'], 'user' => $userInfo['id']])->find()){
                $this->error('添加失败。');
            }
            $wechat = explode(',', $data['number']);

            if ($data['status'] === '1'){
                $data['online_time'] = date('Y-m-d H:i:s', time());
            }else{
                $data['offline_time'] = date('Y-m-d H:i:s', time());
            }

            $error = '';
            foreach ($wechat as $item){
                $data['number'] = trim($item);
                if (!WeChatModel::create($data)){
                    $error .= ' '.$item;
                }
            }

            if (!$error) {
                $this->success("添加成功！", url("index?linkId=".$data['link_id']));
            } else {
                $this->error('以下微信添加失败:'.$error);
            }
        } else {
            $linkId = $this->request->param('linkId/d', '');
            $this->assign("linkId", $linkId);
            return $this->fetch();
        }
    }

    /**
     * 修改微信号和备注
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function edit()
    {
        $userInfo = User::instance()->getInfo();

        if ($this->request->isPost()) {
            $data = $this->request->param();
            if (!LinksModel::where(["id" => $data['link_id'], 'user' => $userInfo['id']])->find()){
                $this->error('编辑失败。');
            }
            if (WeChatModel::update($data)) {
                $this->success("编辑成功！", url("index?linkId={$data['link_id']}"));
            } else {
                $this->error('编辑失败！');
            }
        } else {
            $id = $this->request->param('id/d', '');
            $this->assign("data", WeChatModel::where(["id" => $id])->find());
            return $this->fetch();
        }

    }

    /**
     * 删除
     */
    public function delete()
    {
        $userInfo = User::instance()->getInfo();
        $id = $this->request->param('id/d');
        if (empty($id)) {
            $this->error('ID错误');
        }
        $wechat = WeChatModel::where(["id" => $id])->find()->toArray();
        if (!LinksModel::where(["id" => $wechat['link_id'], 'user' => $userInfo['id']])->find()){
            $this->error('编辑失败。');
            return;
        }
        if (WeChatModel::destroy($id) !== false) {
            $this->success("删除成功！");
        } else {
            $this->error("删除失败！");
        }
    }

    // 上线下线
    public function setState(){
        $data = $this->request->param();
        if ($data['status'] === '1'){
            $data['online_time'] = date('Y-m-d H:i:s', time());
        }else{
            $data['offline_time'] = date('Y-m-d H:i:s', time());
        }

        if (WeChatModel::update($data)) {
            $this->success("编辑成功！");
        } else {
            $this->error('编辑失败！');
        }
    }
}