<?php
namespace MTGIntegrate\Config;
use \RS\Orm\Type;

class File extends \RS\Orm\ConfigObject{
    function _init(){
        parent::_init()->append(array(
            'product_get' => new Type\Integer(array(
                'description' => t('Товары выгружаемые в телеграмм'),
                'listFromArray'=> [[
                    '0' => 'Все',
                    '1' => 'В наличии',
                ]],
                'default' => 0,
            )),
            'view_type' => new Type\Varchar(array(
                'description' => t('Вид магазина'),
                'listFromArray'=> [[
                    'default' => 'Стандарный'
                ]],
                'default' => 'default',
            )),
            'main_category' => new Type\Integer(array(
                'description' => t('Категория для основной страницы'),
                'tree' => [['\Catalog\Model\DirApi', 'staticSpecTreeList']]
            )),
            'banner' => new Type\Varchar(array(
                'description' => t('Выберите баннерную зону'),
                'list' => [['\Banners\Model\ZoneApi', 'staticSelectAliasList']],
            ))
        ));
    }
    public static function getDefaultValues(){
        return parent::getDefaultValues()+[
            'tools' => [
                [
                    'url' => \RS\Router\Manager::obj()->getAdminUrl('addBot', [], 'mtgintegrate-ctrl'),
                    'title' => t('Подключить бота'),
                    'description' => t('Подключает бота телеграмм к вашему сайту'),
                    'class' => 'crud-add',
                ],
            ]
        ];
    }
}