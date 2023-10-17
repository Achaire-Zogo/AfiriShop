<?php

use App\Http\Controllers\admin\ApiProductController;
use App\Http\Controllers\Api\ApiUserController;
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
Route::post('/product',[App\Http\Controllers\admin\ApiProductController::class,'storeP']);
Route::post('/vente',[App\Http\Controllers\admin\ApiProductController::class,'storeV']);
Route::get('/vente_recup_day',[App\Http\Controllers\admin\ApiProductController::class,'getSalesToday']);
Route::get('/vente_recup_month',[App\Http\Controllers\admin\ApiProductController::class,'getSalesLastMonth']);
Route::get('/vente_recup_week',[App\Http\Controllers\admin\ApiProductController::class,'getSalesLastWeek']);
Route::get('/vente_recup_year',[App\Http\Controllers\admin\ApiProductController::class,'getSalesLastYear']);
Route::get('/produit_details/{id}',[ApiProductController::class,'getProductInfo']);
