<?php
/**
 * Created by PhpStorm.
 * User: king
 * Date: 2020-05-19
 * Time: 21:17
 */

namespace app\admin\controller;

use app\admin\model\Links as LinksModel;
use app\admin\model\AdminUser;
use app\admin\model\Wechat;
use app\index\model\Visits;
use app\admin\service\User;
use app\common\controller\Adminbase;

class Links extends Adminbase {

    /**
     * 列表页
     * @return mixed|\think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index()
    {
        $userInfo = User::instance()->getInfo();
        if ($this->request->isAjax()) {
            $result = LinksModel::order(array('id' => 'DESC'))->where(['user' => $userInfo['id']])->select()->toArray();
            foreach ($result as &$link){
                $link['visits'] = 0;
                $wechat = Wechat::where(['link_id' => $link['id']])->select()->toArray();
                foreach ($wechat as $item){
                    $link['visits'] += Visits::where(['wechat' => $item['number'], 'created_time' => date('Y-m-d', time())])->count();
                }
                $link['link'] = url("index/index/getwx", "id={$link['id']}", '', true);
            }
            $total = count($result);
            $result = array("code" => 0, "count" => $total, "data" => $result);
            return json($result);
        }

        $this->assign('isAdmin', $userInfo['roleid'] === 1);
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
        if ($this->request->isPost()) {
            $data = $this->request->param();
            $data['created_time'] = date('Y-m-d H:i:s', time());
            if (LinksModel::create($data)) {
                $this->success("添加成功！", url("index"));
            } else {
                $this->error('添加失败！');
            }
        } else {
            $this->assign("userList", AdminUser::order(['id' => 'DESC'])->select()->toArray());
            return $this->fetch();
        }
    }

    /**
     * 修改
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function edit()
    {
        if ($this->request->isPost()) {
            $data = $this->request->param();
            if (LinksModel::update($data)) {
                $this->success("编辑成功！", url("index"));
            } else {
                $this->error('编辑失败！');
            }
        } else {
            $id = $this->request->param('id/d', '');
            $result = LinksModel::where(["id" => $id])->find();

            $this->assign("data", $result);
            $this->assign("userList", AdminUser::order(['id' => 'DESC'])->select()->toArray());
            $userInfo = User::instance()->getInfo();
            $this->assign('isAdmin', $userInfo['roleid'] === 1);
            return $this->fetch();
        }

    }

    /**
     * 删除
     */
    public function delete()
    {
        $id = $this->request->param('id/d');
        if (empty($id)) {
            $this->error('ID错误');
        }
        if (LinksModel::destroy($id) !== false) {
            $this->success("删除成功！");
        } else {
            $this->error("删除失败！");
        }
    }
}