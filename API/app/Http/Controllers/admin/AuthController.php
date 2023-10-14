<?php

namespace App\Http\Controllers\admin;

use App\Http\Controllers\Api\CrypController;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;

class AuthController extends Controller
{
    public function auth_afiri_shop(Request $request){
        $action = (new CrypController)->decrypt($request->action);
        $resp = array();
        $data = array();

        try{
            if($action == 'afiri_want_to_add_user_now'){
                $usename = (new CrypController)->decrypt($request->username);
                $email = (new CrypController)->decrypt($request->email);
                $phone = (new CrypController)->decrypt($request->phone);
                $role = (new CrypController)->decrypt($request->role);
                if($usename == '' || $email == '' || $phone == '' || $role == ''){
                    $resp['status'] = 'error';
                    $resp['message'] = 'empty';
                    $resp['data'] = 'empty';
                    return response()->json($resp, 200);
                }else{
                    $check_user = User::where('email',$email)->first();
                    if($check_user){
                        $resp['status'] = 'error';
                        $resp['message'] = 'email_exist';
                        $resp['data'] = 'email_exist';
                        return response()->json($resp, 200);
                    }else{
                        $check_phone = User::where('phone',$phone)->first();
                        if($check_phone){
                            $resp['status'] = 'error';
                            $resp['message'] = 'phone_exist';
                            $resp['data'] = 'phone_exist';
                            return response()->json($resp, 200);
                        }else{
                            $new_user = new User();
                            $new_user->username = $usename;
                            $new_user->email = $email;
                            $new_user->phone = $phone;
                            $new_user->role = $role;
                            $new_user->password = Hash::make('password');
                            $new_user->save();
                            $resp['status'] = 'success';
                            $resp['message'] = 'user list';
                            $resp['data'] = $new_user;
                            return response()->json($resp, 200);
                        }
                    }
                }
            }


            if($action == 'afiri_want_to_get_all_user_now'){
                $check_user = User::all();
                if($check_user->count() > 0){
                    $resp['status'] = 'success';
                    $resp['message'] = 'user list';
                    $resp['data'] = $check_user;
                    return response()->json($resp, 200);
                }else{
                    $resp['status'] = 'error';
                    $resp['message'] = 'no user';
                    $resp['data'] = 'no user';
                    return response()->json($resp, 200);
                }
            }

            if($action == 'afiri_want_to_delete_user_now'){
                $id = (new CrypController)->decrypt($request->id);
                $check_user = User::where('id',$id)->first();
                if($check_user){
                    $check_user->delete();
                    $resp['status'] = 'success';
                    $resp['message'] = 'user deleted';
                    $resp['data'] = $check_user;
                    return response()->json($resp, 200);
                }else{
                    $resp['status'] = 'error';
                    $resp['message'] = 'no user exit';
                    $resp['data'] = 'no user';
                    return response()->json($resp, 200);
                }
            }

            if($action == 'afiri_want_to_login_user_now'){
                $email_address = (new CrypController)->decrypt($request->email);
                $password = (new CrypController)->decrypt($request->password);

                $check_user = User::where('email',$email_address)->first();
                if($check_user){
                    $isValidPassword = Hash::check($password, $check_user->password);
                    if($isValidPassword){
                        $resp['status'] = 'true';
                        $resp['message'] = 'login success';
                        $resp['data'] = $check_user;
                        return response()->json($resp, 200);
                    }else{
                        $resp['status'] = 'error';
                        $resp['message'] = 'Incorrect password';
                        $resp['data'] = 'Incorrect password';
                        return response()->json($resp, 200);
                    }
                }else{
                    $resp['status'] = 'error';
                    $resp['message'] = 'This email not exist';
                    $resp['data'] = 'This email not exist';
                    return response()->json($resp, 200);
                }
            }
            //Check if email exist
            if($action == 'afiri_want_to_check_email_user_now'){
                $email_address = (new CrypController)->decrypt($request->email_admin);

                $check_user = User::where('email',$email_address)->first();
                if($check_user){
                    $code = $this->generateRandomNumber();
                    $data["email"] = $email_address;
                    $data["title"] = 'AFIRI-SHOP Code de verification';
                    $data["body"] = 'Votre code de verification est '.$code.' copier et rentrer dans l\'application';
                    $send_mail = Mail::send('email.verification_code', $data, function($message)use($data) {
                        $message->to($data["email"], $data["email"])
                            ->subject($data["title"]);
                    });
                    if($send_mail){
                        $check_user->code_verif = $code;
                        $check_user->save();
                        $resp['status'] = 'success';
                        $resp['message'] = 'AFIRI-SHOP for change password';
                        $resp['data'] = $check_user;
                        return response()->json($resp, 200);
                    }
                }else{
                    $resp['status'] = 'error';
                    $resp['message'] = 'This email not exist';
                    $resp['data'] = 'This email not exist';
                    return response()->json($resp, 200);
                }
            }
            //Check if code is correct and email
            if($action == 'afiri_want_to_check_email_user_code_now'){
                $email_address = (new CrypController)->decrypt($request->email);
                $code = (new CrypController)->decrypt($request->code);

                $check_user = User::where('email',$email_address)->first();
                if($check_user){
                    if($check_user->code_verif == $code){
                        $resp['status'] = 'success';
                        $resp['message'] = 'Success code ';
                        $resp['data'] = $check_user;
                        return response()->json($resp, 200);
                    }else{
                        $resp['status'] = 'error';
                        $resp['message'] = 'Incorrect code';
                        $resp['data'] = 'Incorrect code';
                        return response()->json($resp, 400);
                    }
                }else{
                    $resp['status'] = 'error';
                    $resp['message'] = 'This email not exist';
                    $resp['data'] = 'This email not exist';
                    return response()->json($resp, 200);
                }
            }
            //change user password
            if($action == 'afiri_want_to_change_user_password_now'){
                $email_address = (new CrypController)->decrypt($request->email);
                $password = (new CrypController)->decrypt($request->password);

                $check_user = User::where('email',$email_address)->first();
                if($check_user){

                    $data["email"] = $email_address;
                    $data["title"] = 'AFIRI-SHOP Changement de mot de passe';
                    $data["body"] = 'Votre Nouveau mot de passe est '.$password;
                    $send_mail = Mail::send('email.password_change', $data, function($message)use($data) {
                        $message->to($data["email"], $data["email"])
                            ->subject($data["title"]);
                    });
                    if($send_mail){
                        $check_user->password = Hash::make($password);
                        $check_user->save();
                        $resp['status'] = 'success';
                        $resp['message'] = 'login success';
                        $resp['data'] = $check_user;
                        return response()->json($resp, 200);
                    }
                }else{
                    $resp['status'] = 'error';
                    $resp['message'] = 'This email not exist';
                    $resp['data'] = 'This email not exist';
                    return response()->json($resp, 200);
                }
            }
        }catch (\Exception $e){
            $resp['status'] = 'catch';
            $resp['message'] = 'this have and error';
            $resp['data'] = $e->getMessage();
            return response()->json($resp, 200);
        }
    }

    function generateRandomNumber()
    {
        // Générer un nombre aléatoire entre 1000 et 9999
        $randomNumber = rand(1000, 9999);

        return $randomNumber;
    }
}
