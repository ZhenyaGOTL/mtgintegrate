<?php
namespace MTGIntegrate\Model\ExternalApi\Products;

class Get_num extends \ExternalApi\Model\AbstractMethods\AbstractMethod{

    protected function process($product_id){
        $product = \RS\Orm\Request::make()
        ->select('num')
        ->from(new \Catalog\Model\Orm\Product)
        ->where(['id'=>$product_id])
        ->exec()->getOneField('num');
        return array(
            'response' => array(
                'num' => (integer)isset($product) ? $product : null,
            )
        );
    }
}