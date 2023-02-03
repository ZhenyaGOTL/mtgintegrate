<?php

namespace MTGIntegrate\Model;

use \RS\Orm\PropertyIterator;
use \RS\Orm\Type;


use \RS\Orm\FormObject;

class AddBot extends FormObject
{
    public function __construct()
    {
        parent::__construct(new \RS\Orm\PropertyIterator([
            'token' => new \RS\Orm\Type\Varchar([
                'description' => t('Телеграмм токен бота'),
                'checker' => ['ChkEmpty', t('Не указан токен')],
            ]),
        ]));
    }
}