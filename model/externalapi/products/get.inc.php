<?php
namespace MTGIntegrate\Model\ExternalApi\Products;

class Get extends \ExternalApi\Model\AbstractMethods\AbstractMethod{

    protected function process($category_id, $type){
        if ($type=='all'){
            $where = "maindir=$category_id AND public = 1";
        }
        if ($type=='stock'){
            $where = "maindir=$category_id AND num > 0 AND public = 1";
        }
        $product = \RS\Orm\Request::make()
        ->select('id','title, short_description')
        ->from(new \Catalog\Model\Orm\Product)
        ->where($where)
        ->exec();
        $cost_id = \Catalog\Model\CostApi::getDefaultCostId();
        while ($prod = $product->fetchObject()){
            $cost = \RS\Orm\Request::make()
            ->select('cost_original_val', "cost_original_currency")
            ->from(new \Catalog\Model\Orm\Xcost)
            ->where(["product_id"=>$prod->id, "cost_id"=>$cost_id])
            ->exec()->fetchObject();
            $image = \RS\Orm\Request::make()
            ->select('servername')
            ->from(new \Photo\Model\Orm\Image)
            ->where(["type"=>"catalog", "linkid"=>$prod->id])
            ->exec()->getOneField('servername');
            $currency = \RS\Orm\Request::make()
            ->select('stitle')
            ->from(new \Catalog\Model\Orm\Currency)
            ->where(['id'=>$cost->cost_original_currency])
            ->exec()->getOneField('stitle');
            $prod->currency = $currency;
            $cost_add = \RS\Orm\Request::make()
            ->select('val_znak', 'val')
            ->from(new \Catalog\Model\Orm\Typecost)
            ->where(["id"=>1])
            ->exec()->fetchObject();
            if ($cost_add->val_znak!=""){
                if ($cost_add->val_znak=="+"){
                    $prod->cost = $cost->cost_original_val+$cost_add->val;
                }else{
                    $prod->cost = $cost->cost_original_val-$cost_add->val;
                }
            }else{
            $prod->cost = $cost->cost_original_val;
            }
            $prod->image = $image;
            $products[]=$prod;
        }
        return array(
            'response' => array(
                'products' => isset($products) ? $products : null,
            )
        );
    }
}