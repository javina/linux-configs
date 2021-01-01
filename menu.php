<?php

namespace Lgps\Signals\Menu;

use Auth;
use JeroenNoten\LaravelAdminLte\Menu\Builder;
use JeroenNoten\LaravelAdminLte\Menu\Filters\FilterInterface;
use Laratrust;


class MenuFilter implements FilterInterface
{
    public function transform($item)
    {
        if (isset($item['can']))
        {
            if(!Auth::user()->hasPermission($item['can']))
                return false;
        }

        return $item;
    }
}
