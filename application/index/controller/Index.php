<?php
namespace app\index\controller;

use think\Controller;
use app\index\model\Visits;
use app\admin\model\Wechat;

class Index extends Controller
{
    public function index()
    {
        return '<style type="text/css">*{ padding: 0; margin: 0; } div{ padding: 4px 48px;} a{color:#2E5CD5;cursor: pointer;text-decoration: none} a:hover{text-decoration:underline; } body{ background: #fff; font-family: "Century Gothic","Microsoft yahei"; color: #333;font-size:18px;} h1{ font-size: 100px; font-weight: normal; margin-bottom: 12px; } p{ line-height: 1.6em; font-size: 42px }</style><div style="padding: 24px 48px;"> <h1>:) </h1><p> YznCMS V' . config('version.yzncms_version') . '<br/><span style="font-size:30px">你值得信赖的PHP框架</span></p></div>';
    }

    public function visits(){
        $data = $this->request->param();
        $data['created_time'] = date('Y-m-d', time());
        Visits::create($data);

        return json(['code' => 0, 'success' => true]);
    }

    public function getwx() {
        $linkId = $this->request->param('id/d', '');
        $result = Wechat::order(array('id' => 'DESC'))->where([ 'link_id' => $linkId])->select()->toArray();
        $count = count($result);
        if ($count === 0){
            return "var stxlwx='';";
        }
        $wechat = $result[mt_rand(0, count($result) - 1)];

        return  "var stxlwx='{$wechat['number']}';";
    }
}
