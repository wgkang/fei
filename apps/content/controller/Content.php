<?php
// +----------------------------------------------------------------------
// | Yzncms [ 御宅男工作室 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2007 http://yzncms.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 御宅男 <530765310@qq.com>
// +----------------------------------------------------------------------
namespace app\content\controller;
use think\Url;
use think\Request;
use app\content\model\ContentModel;
use app\common\controller\Adminbase;

class Content extends Adminbase
{
	//显示内容管理首页
    public function index()
    {
        return $this->fetch();
    }

    //显示栏目菜单列表
    public function public_categorys()
    {
        $categorys = cache('Category');
        foreach ($categorys as $rs) {
            $rs = getCategory($rs['catid']);
            if ($rs['type'] == 2 && $rs['child'] == 0) {
                continue;
            }

            $data = array(
                'catid' => $rs['catid'],
                'parentid' => $rs['parentid'],
                'catname' => $rs['catname'],
                'type' => $rs['type'],
            );

             //终极栏目
            if ($rs['child'] == 0) {
                $data['target'] = 'right';
                $data['url'] = Url::build('Content/classlist', array('catid' => $rs['catid']));
            } else {
                $data['isParent'] = true;
            }

            //单页
            if ($rs['type'] == 1 && $rs['child'] == 0) {
                $data['url'] = Url::build('Content/add', array('catid' => $rs['catid']));
            }

            $json[] = $data;
        }
        $this->assign('json', json_encode($json));
    	return $this->fetch();
    }

    //栏目信息列表
    public function classlist() {
        $catid = Request::instance()->param('catid/d', 0);
        //当前栏目信息
        $catInfo = getCategory($catid);
        if (empty($catInfo)) {
            $this->error('该栏目不存在！');
        }
        //查询条件
        $where = array();
        $where['catid'] = array('EQ', $catid);
        $where['status'] = array('EQ', 99);
        //栏目所属模型
        $modelid = $catInfo['modelid'];
        //栏目扩展配置
        $setting = $catInfo['setting'];
        //检查模型是否被禁用
        if (getModel($modelid, 'disabled')) {
            $this->error('模型被禁用！');
        }
        //实例化模型
        $model = ContentModel::getInstance($modelid);
        $data = $model->where($where)->order(array("id" => "DESC"))->select();

        $this->assign('data', $data);
        return $this->fetch();
    }



}