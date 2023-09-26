<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class CrypController extends Controller
{
    public function encrypt($text){
        return openssl_encrypt($text, "aes-256-cbc", "kufulismartlockislachoixaveczaza", 0, "hellotoutlemonde");
    }

    public function decrypt($text){
        return openssl_decrypt($text, "aes-256-cbc", "kufulismartlockislachoixaveczaza", 0, "hellotoutlemonde");
    }
}
