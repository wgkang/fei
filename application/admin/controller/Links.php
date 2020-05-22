<?php
/**
 * Created by PhpStorm.
 * User: king
 * Date: 2020-05-19
 * Time: 21:17
 */

namespace app\admin\controller;

use app\admin\model\Links as Links_Model;
use app\admin\model\AdminUser;
use app\admin\service\User;
use app\common\controller\Adminbase;
use think\Db;

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
        if ($this->request->isAjax()) {
            $result = Links_Model::order(array('id' => 'DESC'))->select()->toArray();
            $total = count($result);
            $result = array("code" => 0, "count" => $total, "data" => $result);
            return json($result);
        }
        $userInfo = User::instance()->getInfo();
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
            if (Links_Model::create($data)) {
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
            if (Links_Model::update($data)) {
                $this->success("编辑成功！", url("index"));
            } else {
                $this->error('编辑失败！');
            }
        } else {
            $id = $this->request->param('id/d', '');
            $result = Links_Model::where(["id" => $id])->find();

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
        if (Links_Model::destroy($id) !== false) {
            $this->success("删除成功！");
        } else {
            $this->error("删除失败！");
        }
    }
}