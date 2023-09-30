<?php

namespace App\Http\Controllers\admin;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\Vente;
use Illuminate\Http\Request;

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

        return response()->json($produitsVendus, 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erreur lors de la recuperations des vente : ' . $e], 404);
        }
    }
    
}
