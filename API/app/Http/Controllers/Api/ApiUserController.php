<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;

class ApiUserController extends Controller
{
    /* The `rentali_user` function is a method within the `ApiUserController` class
    that handles user registration and login functionality for the Rentali app. */
    public function rentali_user(Request $request){
        $action = (new CrypController)->decrypt($request->action);
        $resp = array();
        $data = array();
        try{
            //Register a new user to the app
            if($action == 'rentali_want_to_register_now'){
                $user_name = (new CrypController)->decrypt($request->user_name);
                $email_address = (new CrypController)->decrypt($request->email);
                $phone_number = (new CrypController)->decrypt($request->phone_number);
                $password = (new CrypController)->decrypt($request->password);

                $check_email = User::where('email',$email_address)->first();
                if($check_email){
                    $resp['status'] = 'error';
                    $resp['message'] = 'email already exist';
                    $resp['data'] = 'email already exist';
                    return response()->json($resp, 200);
                }else{
                    $check_phone = User::where('phone_number',$phone_number)->first();
                    if($check_phone){
                        $resp['status'] = 'error';
                        $resp['message'] = 'phone number already exist';
                        $resp['data'] = 'phone number already exist';
                        return response()->json($resp, 200);
                    }else{
                        $new_user = new User();
                        $new_user->user_name = $user_name;
                        $new_user->email = $email_address;
                        $new_user->role = 'user';
                        $new_user->status = '0';
                        $new_user->code_verif = $this->generateRandomNumber();
                        $new_user->phone_number = $phone_number;
                        $new_user->password = Hash::make($password);
                        $new_user->save();

                        $data["email"] = $email_address;
                        $data["title"] = 'Rental verification code';
                        $data["body"] = $new_user->code_verif;

                        Mail::send('email.register', $data, function($message)use($data) {
                            $message->to($data["email"], $data["email"])
                                ->subject($data["title"]);
                        });

                        $resp['status'] = 'success';
                        $resp['message'] = 'user is register well';
                        $resp['data'] = $new_user;
                        return response()->json($resp, 200);
                    }
                }
                //get the value here
            }
            //login new user
            if($action == 'rentali_want_to_login_user_now'){
                $email_address = (new CrypController)->decrypt($request->email);
                $password = (new CrypController)->decrypt($request->password);
                $isValidPassword = false;

                $check_user = User::where('email',$email_address)->first();
                if($check_user){
                    if($check_user->status == '0'){
                        //renvois le mail pour verification
                        $data["email"] = $email_address;
                        $data["title"] = 'Rental verify your email';
                        $data["body"] = $this->generateRandomNumber();
                        Mail::send('email.register', $data, function($message)use($data) {
                            $message->to($data["email"], $data["email"])
                                ->subject($data["title"]);
                        });

                        $resp['status'] = 'error';
                        $resp['message'] = 'Verify your email';
                        $resp['data'] = 'Verify your email';
                        return response()->json($resp, 200);
                    }else if($check_user->status == '2'){
                        //l'utilisater a demande a supprimer son compte
                        $resp['status'] = 'error';
                        $resp['message'] = 'User request to delete account';
                        $resp['data'] = 'User request to delete account';
                        return response()->json($resp, 200);
                    }else{

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
                    }
                }else{
                    $resp['status'] = 'error';
                    $resp['message'] = 'This email not exist';
                    $resp['data'] = 'This email not exist';
                    return response()->json($resp, 200);
                }
            }
            //Check if email exist
            if($action == 'rentali_want_to_check_email_user_now'){
                $email_address = (new CrypController)->decrypt($request->email);

                $check_user = User::where('email',$email_address)->first();
                if($check_user){
                    if($check_user->status == '0'){
                        //renvois le mail pour verification
                        $data["email"] = $email_address;
                        $data["title"] = 'Rental verify your email';
                        $data["body"] = $this->generateRandomNumber();
                        Mail::send('email.verification_code', $data, function($message)use($data) {
                            $message->to($data["email"], $data["email"])
                                ->subject($data["title"]);
                        });

                        $resp['status'] = 'success';
                        $resp['message'] = 'Verify your email';
                        $resp['data'] = 'Verify your email';
                        return response()->json($resp, 200);
                    }else if($check_user->status == '2'){
                        //l'utilisater a demande a supprimer son compte
                        $resp['status'] = 'error';
                        $resp['message'] = 'User request to delete account';
                        $resp['data'] = 'User request to delete account';
                        return response()->json($resp, 200);
                    }else{
                        $data["email"] = $email_address;
                        $data["title"] = 'Rental for change password';
                        $data["body"] = $this->generateRandomNumber();
                        Mail::send('email.verification_code', $data, function($message)use($data) {
                            $message->to($data["email"], $data["email"])
                                ->subject($data["title"]);
                        });

                        $resp['status'] = 'success';
                        $resp['message'] = 'Rental for change password';
                        $resp['data'] = 'Rental for change password';
                        return response()->json($resp, 200);
                    }
                }else{
                    $resp['status'] = 'error';
                    $resp['message'] = 'This email not exist';
                    $resp['data'] = 'This email not exist';
                    return response()->json($resp, 200);
                }
            }
            //Check if email and code is ok
            if($action == 'rentali_want_to_check_email_user_now'){
                $email_address = (new CrypController)->decrypt($request->email);
                $code = (new CrypController)->decrypt($request->code);

                $check_user = User::where('email',$email_address)->first();
                if($check_user){
                    if($check_user->status == '0'){
                        if($check_user->code_verif == $code){
                            //renvois le mail pour Felicitation
                            $data["email"] = $email_address;
                            $data["title"] = 'Success activate your account';
                            $data["body"] = $this->generateRandomNumber();
                            Mail::send('email.success_activate_account', $data, function($message)use($data) {
                                $message->to($data["email"], $data["email"])
                                    ->subject($data["title"]);
                            });

                            $check_user->status = '1';
                            $check_user->save();
                            $resp['status'] = 'success';
                            $resp['message'] = 'Success activate your account';
                            $resp['data'] = $check_user;
                            return response()->json($resp, 200);
                        }else{
                            $resp['status'] = 'error';
                            $resp['message'] = 'Incorrect code';
                            $resp['data'] = 'Incorrect code';
                            return response()->json($resp, 400);
                        }

                    }else if($check_user->status == '2'){
                        //l'utilisater a demande a supprimer son compte
                        $resp['status'] = 'error';
                        $resp['message'] = 'User request to delete account';
                        $resp['data'] = 'User request to delete account';
                        return response()->json($resp, 400);
                    }
                }else{
                    $resp['status'] = 'error';
                    $resp['message'] = 'This email not exist';
                    $resp['data'] = 'This email not exist';
                    return response()->json($resp, 200);
                }
            }
        }catch (\Exception $e){
            $resp['status'] = 'error';
            $resp['message'] = $e->getMessage();
            $resp['data'] = $e->getMessage();
            return response()->json($resp, 404);
        }
    }

    function generateRandomNumber()
    {
        // Générer un nombre aléatoire entre 1000 et 9999
        $randomNumber = rand(1000, 9999);

        return $randomNumber;
    }
}
