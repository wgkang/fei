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
// | 会员投稿管理
// +----------------------------------------------------------------------
namespace app\member\controller;

use app\cms\model\Cms as Cms_Model;
use app\member\model\MemberContent as Member_Content_Model;
use think\Db;

class Content extends MemberBase
{
    protected function initialize()
    {
        parent::initialize();
        $this->Cms_Model = new Cms_Model;
    }

    public function publish()
    {
        $groupinfo = $this->_check_group_auth($this->userinfo['groupid']);
        //判断每日投稿数
        /*$this->content_check_db = pc_base::load_model('content_check_model');
        $todaytime = strtotime(date('y-m-d', SYS_TIME));
        $_username = $this->memberinfo['username'];
        $allowpostnum = $this->content_check_db->count("`inputtime` > $todaytime AND `username`='$_username'");
        if ($grouplist[$memberinfo['groupid']]['allowpostnum'] > 0 && $allowpostnum >= $grouplist[$memberinfo['groupid']]['allowpostnum']) {
        showmessage(L('allowpostnum_deny') . $grouplist[$memberinfo['groupid']]['allowpostnum'], HTTP_REFERER);
        }*/
        if ($this->request->isPost()) {
            $data = $this->request->post(false);
            //判断会员组投稿是否需要审核
            if ($groupinfo['allowpostverify']) {
                $data['status'] = 1;
            } else {
                $data['status'] = 0;
            }
            $catid = intval($data['modelField']['catid']);
            if (empty($catid)) {
                $this->error("请指定栏目ID！");
            }
            $category = Db::name('Category')->find($catid);
            if (empty($category)) {
                $this->error('该栏目不存在！');
            }
            if ($category['type'] == 2) {
                $data['modelFieldExt'] = isset($data['modelFieldExt']) ? $data['modelFieldExt'] : [];
                try {
                    $id = $this->Cms_Model->addModelData($data['modelField'], $data['modelFieldExt']);
                } catch (\Exception $ex) {
                    $this->error($ex->getMessage());
                }
            }
            //添加投稿记录
            if ($id) {
                Member_Content_Model::create([
                    'catid' => $catid,
                    'content_id' => $id,
                    'uid' => $this->userid,
                    'username' => $this->userinfo['username'],
                    'create_time' => time(),
                    'status' => $data['status'],
                ]);
            }
            if ($data['status'] == 1) {
                $this->success('操作成功，内容已通过审核！');
            } else {
                $this->success('操作成功，等待管理员审核！');
            }
        } else {
            $step = $this->request->param('step/d', 1);
            if ($step == 1) {
                return $this->fetch('/declaration');
            }
            $catid = $this->request->param('catid/d', 0);
            $tree = new \util\Tree();
            $tree->icon = array('&nbsp;&nbsp;&nbsp;│ ', '&nbsp;&nbsp;&nbsp;├─ ', '&nbsp;&nbsp;&nbsp;└─ ');
            $tree->nbsp = '&nbsp;&nbsp;&nbsp;';
            $str = "<option value='\$catidurl' \$selected \$disabled>\$spacer \$catname</option>";
            $array = cache("Category");
            foreach ($array as $k => $v) {
                $array[$k] = $v = Db::name('Category')->find($v['id']);
                if ($v['id'] == $catid) {
                    $array[$k]['selected'] = "selected";
                }
                //含子栏目和单页不可以发表
                if ($v['child'] == 1 || $v['type'] == 1) {
                    $array[$k]['disabled'] = "disabled";
                    $array[$k]['catidurl'] = url('publish', array('step' => 2));
                } else {
                    $array[$k]['disabled'] = "";
                    $array[$k]['catidurl'] = url('publish', array('step' => 2, 'catid' => $v['id']));
                }
            }
            $tree->init($array);
            $categoryselect = $tree->get_tree(0, $str, 0);
            //如果有选择栏目的情况下
            if ($catid) {
                $category = Db::name('Category')->find($catid);
                if (empty($category)) {
                    $this->error('该栏目不存在！');
                }
                if ($category['type'] == 2) {
                    $modelid = $category['modelid'];
                    $fieldList = $this->Cms_Model->getFieldList($modelid);
                    $this->assign([
                        'catid' => $catid,
                        'fieldList' => $fieldList,
                    ]);
                }
            }
            $this->assign("categoryselect", $categoryselect);
            return $this->fetch('/publish');
        }

    }

    public function published()
    {
        return $this->fetch('/published');

    }

    //检查会员组权限
    private function _check_group_auth($groupid)
    {
        $grouplist = cache("Member_Group"); //会员模型
        if (!$grouplist[$groupid]['allowpost']) {
            $this->error('你没有权限投稿，请升级会员组！');
        }
        return $grouplist[$groupid];
    }

}
