<?php

namespace App\Http\Controllers\admin;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\Vente;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ApiProductController extends Controller
{
    public function storeP(Request $request)
    {
        try {
            $data = $request->json()->all();
            $produits = $data['produit'];
            foreach ($produits as $produitData) {
                $produit = new Product();
                $produit->nomProduit = $produitData['nomProduit'];
                $produit->description = $produitData['description'];
                $produit->prixAchat = $produitData['prixAchat'];
                $produit->prixVente = $produitData['prixVente'];
                $produit->quantite = $produitData['quantite'];
                $produit->created_at = $produitData['creationDate'];
                $produit->save();
            }


            return response()->json(['message' => 'product_success'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error ' .$e], 404);
        }
    }

    public function storeV(Request $request)
    {
        try {
            $data = $request->json()->all();
            $ventes = $data['vente'];
            foreach ($ventes as $venteData) {
                $vente = new Vente();
                $vente->IDProduit = $venteData['IDProduit'];
                $vente->dateVente = $venteData['dateVente'];
                $vente->quantiteVendue = $venteData['quantiteVendue'];
                $vente->montantVente = $venteData['montantVente'];
                $vente->save();
            }

            return response()->json(['message' => 'vente_sucess'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de l\'enregistrement de la vente : ' . $e], 404);
        }
    }

    public function getSalesToday()
    {
        try {
        $aujourdhui = now()->format('Y-m-d');
        $query = DB::table('ventes')
            ->join('products', 'ventes.IDProduit', '=', 'products.id')
            ->where('dateVente', 'like', '%' . $aujourdhui . '%')
            ->select(
                'ventes.IDProduit',
                'products.NomProduit',
                'products.Description',
                'products.prixAchat',
                'products.prixVente',
                'ventes.dateVente',
                DB::raw('SUM(ventes.quantiteVendue) AS totalQuantiteVendue'),
                DB::raw('SUM(ventes.montantVente) AS total'),
            )
            ->groupBy('ventes.IDProduit', 'products.NomProduit', 'products.Description','products.prixAchat','products.prixVente','ventes.dateVente');

        $result = $query->get();

        return response()->json($result, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de la recuperations des ventes : ' . $e], 404);
        }
    }

    public function getSalesLastWeek()
    {
        try {
            $aujourdHui = now();
            // Pour obtenir le premier jour de la semaine en cours (lundi)
            $debutSemaine = $aujourdHui->startOfWeek()->format('Y-m-d');
            $aujourdHui = now()->format('Y-m-d');
            $query = DB::table('ventes')
                ->join('products', 'ventes.IDProduit', '=', 'products.id')
                ->whereDate('dateVente', '>=', $debutSemaine)
                ->whereDate('dateVente', '<=', $aujourdHui)
                ->select(
                    'ventes.IDProduit',
                    'products.NomProduit',
                    'products.Description',
                    'products.prixAchat',
                    'products.prixVente',
                    
                    DB::raw('SUM(ventes.quantiteVendue) AS totalQuantiteVendue'),
                    DB::raw('SUM(ventes.montantVente) AS total')
                )
                ->groupBy(         'ventes.IDProduit',
                'products.NomProduit', 'products.Description', 'products.prixAchat', 'products.prixVente');
            
            $result = $query->get();            
            return response()->json($result, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de la récupération des ventes de la semaine : ' . $e], 404);
        }
    }
    

    public function getSalesLastMonth()
    {
        try {
            $aujourdHui = now();

            $unMoisAgo = $aujourdHui->startOfMonth()->format('Y-m-d');
            $aujourdHui = now()->format('Y-m-d');
            $query = DB::table('ventes')
    ->join('products', 'ventes.IDProduit', '=', 'products.id')
    ->whereDate('dateVente', '>=', $unMoisAgo)
    ->whereDate('dateVente', '<=', $aujourdHui)
    ->select(
        'ventes.IDProduit',
        'products.NomProduit',
        'products.Description',
        'products.prixAchat',
        'products.prixVente',
        DB::raw('SUM(ventes.quantiteVendue) AS totalQuantiteVendue'),
        DB::raw('SUM(ventes.montantVente) AS total')
    )
    ->groupBy('ventes.IDProduit', 'products.NomProduit', 'products.Description', 'products.prixAchat', 'products.prixVente');

$result = $query->get();
            return response()->json($result, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de la récupération des ventes du mois : ' . $e], 404);
        }
    }
    
    public function getSalesLastYear()
    {
        try {
            $aujourdhui = now()->format('Y');

            $query = DB::table('ventes')
            ->join('products', 'ventes.IDProduit', '=', 'products.id')
            ->where('dateVente', 'like',  $aujourdhui . '%')

            ->select(
                'ventes.IDProduit',
                'products.NomProduit',
                'products.Description',
                'products.prixAchat',
                'products.prixVente',
                DB::raw('SUM(ventes.quantiteVendue) AS totalQuantiteVendue'),
                DB::raw('SUM(ventes.montantVente) AS total')
            )
            ->groupBy('ventes.IDProduit', 'products.NomProduit', 'products.Description', 'products.prixAchat', 'products.prixVente');
        
        $result = $query->get();
        
    
            return response()->json($result, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de la récupération des ventes de l\'année dernière : ' . $e], 404);
        }
    }

    public function getProductInfo($id)
    {
        try {
            // Utilisez une seule requête SQL pour récupérer les informations du produit et les ventes associées
            $productInfo = Product::join('ventes', 'products.id', '=', 'ventes.IDProduit')
                ->where('products.id', $id)
                ->select(
                    'products.id as product_id',
                    'products.NomProduit',
                    'products.Description',
                    'products.prixAchat',
                    'products.prixVente',
                    'ventes.dateVente',
                    'ventes.quantiteVendue',
                    'ventes.montantVente'
                )
                ->get();
                return response()->json($productInfo, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de la récupération des informations du produit : ' . $e], 404);
        }
    }

    


}
