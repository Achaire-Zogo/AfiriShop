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

        // Requête pour récupérer les produits vendus aujourd'hui
        $produitsVendus = Vente::whereDate('dateVente', $aujourdhui)
            ->with('produit') // Si vous avez une relation avec le modèle Produit
            ->get();

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

    public function getSalesLastMonth()
{
    try {
        // Récupérez la date d'aujourd'hui
        $aujourdHui = now();

        // Récupérez la date d'il y a un mois
        $unMoisAgo = $aujourdHui->subMonth();

        // Requête pour récupérer les produits vendus il y a un mois
        $produitsVendusUnMoisAgo = Vente::whereDate('dateVente', '>=', $unMoisAgo)
            ->whereDate('dateVente', '<=', $aujourdHui)
            ->with('produit') // Si vous avez une relation avec le modèle Produit
            ->get();

        return response()->json($produitsVendusUnMoisAgo, 200);
    } catch (\Exception $e) {
        return response()->json(['message' => 'Erreur lors de la récupération des ventes du mois : ' . $e], 404);
    }
}

public function getSalesLastWeek()
{
    try {
        // Récupérez la date d'aujourd'hui
        $aujourdHui = now();

        // Récupérez la date d'il y a une semaine
        $uneSemaineAgo = $aujourdHui->subWeek();

        // Requête pour récupérer les produits vendus il y a une semaine
        $produitsVendusUneSemaineAgo = Vente::whereDate('dateVente', '>=', $uneSemaineAgo)
            ->whereDate('dateVente', '<=', $aujourdHui)
            ->with('produit') // Si vous avez une relation avec le modèle Produit
            ->get();

        return response()->json($produitsVendusUneSemaineAgo, 200);
    } catch (\Exception $e) {
        return response()->json(['message' => 'Erreur lors de la récupération des ventes de la semaine : ' . $e], 404);
    }
}
public function getSalesLastYear()
{
    try {
        // Récupérez la date d'aujourd'hui
        $aujourdHui = now();

        // Récupérez la date d'il y a un an
        $unAnAgo = $aujourdHui->subYear();

        // Requête pour récupérer les produits vendus l'année dernière
        $produitsVendusUnAnAgo = Vente::whereDate('dateVente', '>=', $unAnAgo)
            ->whereDate('dateVente', '<=', $aujourdHui)
            ->with('produit') // Si vous avez une relation avec le modèle Produit
            ->get();

        return response()->json($produitsVendusUnAnAgo, 200);
    } catch (\Exception $e) {
        return response()->json(['message' => 'Erreur lors de la récupération des ventes de l\'année dernière : ' . $e], 404);
    }
}




}
