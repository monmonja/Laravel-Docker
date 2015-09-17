#!/usr/bin/env bash

rm -Rf www

curl -LOk https://github.com/fians/larapack/raw/master/larapack.zip
unzip -o larapack.zip
mv larapack www

cp -r ./template_app/. www
cd www
php artisan key:generate

npm install
bower install

rm larapack.zip
rm -Rf laravel-6