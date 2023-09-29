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
                'email'=>'ntsama@gmail.com',
                'password'=>Hash::make('password'),
                'role'=>'admin',
            ],
            [
                'username'=>'Bayon idris Donald ',
                'phone'=>'657150979',
                'email'=>'bayonidris@gmail.com',
                'password'=>Hash::make('123456'),
                'role'=>'admin',
            ],
            [
                'username'=>'Gerant',
                'phone'=>'6543013456',
                'email'=>'gerant@gmail.com',
                'password'=>Hash::make('password'),
                'role'=>'gerant',
            ],
            [
                'username'=>'ZAZ',
                'phone'=>'657515280',
                'email'=>'dylanabouma@gmail.com',
                'password'=>Hash::make('password'),
                'role'=>'admin',
            ],
        ]);
    }
}
