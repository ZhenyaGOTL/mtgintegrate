<?php 

namespace MTGIntegrate\Controller\Admin;

use \MTGIntegrate\Model\AddBot;
use \RS\Html\Toolbar\Button\Button;
use \RS\Html\Toolbar\Button\Save;
use \RS\Html\Toolbar\Button\SaveForm;
use \RS\Html\Toolbar\Button\Cancel;
use \RS\Html\Toolbar\Element;
use \RS\Orm\Type;
use \RS\Controller\Admin\Helper\CrudCollection;
use \RS\Orm\FormObject;
use \RS\Orm\PropertyIterator;
use \RS\View\Engine;
use \RS\Config\Loader;

class Ctrl extends \RS\Controller\Admin\Front{
    function actionAddBot(){
        $helper = new CrudCollection($this);
        $helper->setTopTitle(t('Добавить бота'));
        $form = new AddBot();
        $helper->setFormObject($form);
        $helper->viewAsForm();
        $helper->setBottomToolbar(new Element([
            'items' => [
                new SaveForm(null, t('Отправить заявку')),
                new Cancel($this->router->getAdminUrl('edit', ['mod' => 'mtgintegrate'], 'modcontrol-control'))
            ],
        ]));
        if($this->url->isPost())
        {
            $token = $this->url->post('token', TYPE_STRING, null);
            if ($token!==null){
            $url = "https://telegram.citypeople.ru/tgintegrate/".$_SERVER['HTTP_HOST'];
            $telegram = curl_init("https://api.telegram.org/bot$token/setWebhook?url=$url");
            curl_setopt($telegram, CURLOPT_HTTPGET, true);
            curl_setopt($telegram, CURLOPT_RETURNTRANSFER, true);
            $res = curl_exec($telegram);
            curl_close($telegram);
            $c = curl_init('https://telegram.citypeople.ru/tg_reg');
            $post = [
                'site' => $_SERVER['HTTP_HOST'],
                'bot_key' => $token,
            ];
            $header = [
                'Content-type: application/json'
            ];
            curl_setopt($c, CURLOPT_POST, true);
            curl_setopt($c, CURLOPT_POSTFIELDS, json_encode($post));
            curl_setopt($c, CURLOPT_HTTPHEADER, $header);
            curl_setopt($c, CURLOPT_RETURNTRANSFER, true);
            curl_exec($c);
            curl_close($c);
            $json = json_decode($res);
            if ($json->ok==true){
                return $this->result->setSuccessText('Бот добавлен')->setSuccess(true);
            }else{
                return $this->result->setErrors(['Что-то пошло не так'])->setSuccess(false);
            }
            }else{
                return $this->result->setErrors(['Что-то пошло не так'])->setSuccess(false);
            }
        }
        return $this->result->setTemplate( $helper['template'] );
    }
}