<?php
namespace MTGIntegrate\Model\ExternalApi\Products;

class Get_description extends \ExternalApi\Model\AbstractMethods\AbstractMethod{

    protected function process($product_id){
        $product = \RS\Orm\Request::make()
        ->select('short_description')
        ->from(new \Catalog\Model\Orm\Product)
        ->where(['id'=>$product_id])
        ->exec()->getOneField('short_description');
        return array(
            'response' => array(
                'product' => isset($product) ? $product : null,
            )
        );
    }
}