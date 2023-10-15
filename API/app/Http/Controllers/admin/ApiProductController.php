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
            // Récupérez la date d'aujourd'hui
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
            $uneSemaineAgo = $aujourdHui->subWeek();
    
            $query = DB::table('ventes')
                ->join('products', 'ventes.IDProduit', '=', 'products.id')
                ->whereDate('dateVente', '>=', $uneSemaineAgo)
                ->whereDate('dateVente', '<=', $aujourdHui)
                ->select(
                    'ventes.IDProduit',
                    'products.NomProduit',
                    'products.Description',
                    'products.prixAchat',
                    'products.prixVente',
                    'ventes.dateVente',
                    DB::raw('SUM(ventes.quantiteVendue) AS totalQuantiteVendue'),
                    DB::raw('SUM(ventes.montantVente) AS total')
                )
                ->groupBy('ventes.IDProduit', 'products.NomProduit', 'products.Description', 'products.prixAchat', 'products.prixVente', 'ventes.dateVente');
    
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
            $unMoisAgo = $aujourdHui->subMonth();
    
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
                    'ventes.dateVente',
                    DB::raw('SUM(ventes.quantiteVendue) AS totalQuantiteVendue'),
                    DB::raw('SUM(ventes.montantVente) AS total')
                )
                ->groupBy('ventes.IDProduit', 'products.NomProduit', 'products.Description', 'products.prixAchat', 'products.prixVente', 'ventes.dateVente');
    
            $result = $query->get();
    
            return response()->json($result, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de la récupération des ventes du mois : ' . $e], 404);
        }
    }
    
    public function getSalesLastYear()
    {
        try {
            $aujourdHui = now();
            $unAnAgo = $aujourdHui->subYear();
    
            $query = DB::table('ventes')
                ->join('products', 'ventes.IDProduit', '=', 'products.id')
                ->whereDate('dateVente', '>=', $unAnAgo)
                ->whereDate('dateVente', '<=', $aujourdHui)
                ->select(
                    'ventes.IDProduit',
                    'products.NomProduit',
                    'products.Description',
                    'products.prixAchat',
                    'products.prixVente',
                    'ventes.dateVente',
                    DB::raw('SUM(ventes.quantiteVendue) AS totalQuantiteVendue'),
                    DB::raw('SUM(ventes.montantVente) AS total')
                )
                ->groupBy('ventes.IDProduit', 'products.NomProduit', 'products.Description', 'products.prixAchat', 'products.prixVente', 'ventes.dateVente');
    
            $result = $query->get();
    
            return response()->json($result, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de la récupération des ventes de l\'année dernière : ' . $e], 404);
        }
    }
    


}
