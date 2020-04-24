alias art="php artisan"

alias migrate="php artisan migrate"

alias db-reset="php artisan migrate:reset && php artisan migrate --seed"

alias laravel-clear="art view:clear && art clear && art route:clear && art cache:clear && art config:clear"

alias laravel-flush="art queue:flush && art queue:restart && art horizon:purge  && sudo supervisorctl restart all"

alias l-clear="sudo chmod -R 777 storage/ && sudo chmod -R 777 bootstrap/cache/ && laravel-clear && composer dump-autoload"

