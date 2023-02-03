<?php
namespace MTGIntegrate\Model\ExternalApi\Telegram;

class Send extends \ExternalApi\Model\AbstractMethods\AbstractMethod{

    protected function process($message, $id){
        $c = curl_init('https://telegram.citypeople.ru/tgintegrate/'.$_SERVER['HTTP_HOST'].'/send');
        $post = [
            'message'=>$message,
            'id' => $id,
        ];
        $header = [
            "Content-type: application/json",
        ];
        curl_setopt($c, CURLOPT_POST, true);
        curl_setopt($c, CURLOPT_POSTFIELDS, json_encode($post));
        curl_setopt($c, CURLOPT_HTTPHEADER, $header);
        curl_setopt($c, CURLOPT_RETURNTRANSFER, true);
        curl_exec($c);
        curl_close($c);
        return array(
            'response' => array(
                'ok' => 'ok',
            )
        );
    }
}