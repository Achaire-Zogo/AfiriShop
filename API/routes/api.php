<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/auth',[App\Http\Controllers\admin\AuthController::class,'auth_afiri_shop']);
Route::post('/product',[App\Http\Controllers\admin\ProductController::class,'product']);
Route::post('/vente',[App\Http\Controllers\admin\VenteController::class,'vente']);
