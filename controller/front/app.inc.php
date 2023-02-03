<?php

namespace MTGIntegrate\Controller\Front;

class App extends \RS\Controller\Front{
    function actionIndex(){
        $category = \RS\Orm\Request::make()
        ->select('id','name','parent')
        ->from(new \Catalog\Model\Orm\Dir)
        ->where(['public'=>1, 'is_spec_dir'=>'N'])
        ->exec();
        while ($cat = $category->fetchObject()){
            $categories[$cat->parent][] = $cat;
        }
        $ex = \RS\Config\Loader::byModule('externalapi');
        $token = $ex['api_key'];
        if ($token!=''){
            $token = '-'.$token;
        }
        $config = \RS\Config\Loader::byModule('mtgintegrate');
        if ($config['product_get']==0){
            $prod = 'all';
        }else{
            $prod = 'stock';
        }
        $config_logo = \RS\Config\Loader::getSiteConfig();
        $zone_api = new \Banners\Model\ZoneApi();
        $zone_id = $zone_api->getIdByAlias($config['banner'], 'alias');
        if ($zone_id){
            $zone = $zone_api->getById($zone_id);
            $banners = $zone->getBanners();
        }else{
            $banners = [];
        }
        $cost_id = \Catalog\Model\CostApi::getDefaultCostId();
        if (isset($config['main_category'])){
            $products = [];
            $prod_id = \RS\Orm\Request::make()
            ->select('product_id')
            ->from(new \Catalog\Model\Orm\Xdir)
            ->where(['dir_id'=>$config['main_category']])
            ->exec();
            while ($id = $prod_id->fetchObject()){
                if ($prod=='all'){
                    $where = "id=$id->product_id AND public = 1";
                }
                if ($prod=='stock'){
                    $where = "id=$id->product_id AND num > 0 AND public = 1";
                }
                $product = \RS\Orm\Request::make()
                ->select('id','title, short_description')
                ->from(new \Catalog\Model\Orm\Product)
                ->where($where)
                ->exec()->fetchObject();
                if (!isset($product->id)){
                    continue;
                }
                $cost = \RS\Orm\Request::make()
            ->select('cost_original_val', "cost_original_currency")
            ->from(new \Catalog\Model\Orm\Xcost)
            ->where(["product_id"=>$product->id, "cost_id"=>$cost_id])
            ->exec()->fetchObject();
            $image = \RS\Orm\Request::make()
            ->select('servername')
            ->from(new \Photo\Model\Orm\Image)
            ->where(["type"=>"catalog", "linkid"=>$product->id])
            ->exec()->getOneField('servername');
            $currency = \RS\Orm\Request::make()
            ->select('stitle')
            ->from(new \Catalog\Model\Orm\Currency)
            ->where(['id'=>$cost->cost_original_currency])
            ->exec()->getOneField('stitle');
            $product->currency = $currency;
            $cost_add = \RS\Orm\Request::make()
            ->select('val_znak', 'val')
            ->from(new \Catalog\Model\Orm\Typecost)
            ->where(["id"=>1])
            ->exec()->fetchObject();
            if ($cost_add->val_znak!=""){
                if ($cost_add->val_znak=="+"){
                    $product->cost = $cost->cost_original_val+$cost_add->val;
                }else{
                    $product->cost = $cost->cost_original_val-$cost_add->val;
                }
            }else{
            $product->cost = $cost->cost_original_val;
            }
            $product->image = $image;
            $products[]=$product;
            }
        }else{
            $products = [];
        }
        $this->view->assign([
            'categories' => $categories,
            'key' => $token,
            'prod' => $prod,
            'logo' => $config_logo,
            'products' => $products,
            'cat' => isset($config['main_category']) ? true : false,
            'banners' => $banners,
            'zone' => !empty($zone) ? $zone : '',
        ]);
        $this->wrapOutput(false);
        return $this->view->fetch("front/".$config['view_type']."/app.tpl");
    }
}