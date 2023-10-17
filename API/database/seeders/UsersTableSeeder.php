<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('users')->insert([
            //Admin
            [
                'username'=>'Ntsama juliette ',
                'phone'=>'6543213456',
                'email'=>'Julientsama@gmail.com',
                'password'=>Hash::make('password'),
                'role'=>'admin',
            ],
        ]);
    }
}
