<?php
namespace MTGIntegrate\Config;

class Handlers extends \RS\Event\HandlerAbstract
{
    function init(){
        $this->bind('getroute');
        $this->bind('module.afteruninstall.mtgintegrate');
    }

    public static function getRoute($routes){
        $routes[] = new \RS\Router\Route('MTGIntegrate-Front-App', ['/app'], ['controller'=>'MTGIntegrate-Front-App','Act'=>'index'], 'App');
        return $routes;
    } 
    public static function moduleAfterUninstallMtgintegrate($module_item, $event){
        $c = curl_init('https://telegram.citypeople.ru/tgintegrate/'.$_SERVER['HTTP_HOST'].'/delete');
        $header = [
            'Content-type: application/json',
        ];
        curl_setopt($c, CURLOPT_POST, true);
        curl_setopt($c, CURLOPT_HTTPHEADER, $header);
        curl_setopt($c, CURLOPT_RETURNTRANSFER, true);
        curl_exec($c);
        curl_close($c);
    }
}