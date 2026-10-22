<?php

// ============================================================
// API REST - /api/lieux.php
// GET    /api/lieux.php                → liste (filtres : recherche, province, id_categorie)
// GET    /api/lieux.php?id=5           → un lieu avec ses photos
// POST   /api/lieux.php                → créer (body JSON)      [reservé admin - TODO auth]
// PUT    /api/lieux.php?id=5           → modifier (body JSON)   [reservé admin - TODO auth]
// DELETE /api/lieux.php?id=5           → supprimer               [reservé admin - TODO auth]
// ============================================================

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *'); // A restreindre en production
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

require_once __DIR__ . '/../db.php';
require_once __DIR__ . '/../LieuDAO.php';

$lieuDAO = new LieuDAO($pdo);
$methode = $_SERVER['REQUEST_METHOD'];

switch ($methode) {
    case 'GET':
        if (isset($_GET['id'])) {
            $lieu = $lieuDAO->trouverParId((int) $_GET['id']);
            if ($lieu === null) {
                http_response_code(404);
                echo json_encode(['erreur' => 'Lieu introuvable']);
                exit;
            }
            echo json_encode($lieu);
        } else {
            $recherche   = $_GET['recherche'] ?? null;
            $province    = $_GET['province'] ?? null;
            $idCategorie = isset($_GET['id_categorie']) ? (int) $_GET['id_categorie'] : null;

            echo json_encode($lieuDAO->listerTous($recherche, $province, $idCategorie));
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);

        $champsRequis = ['nom', 'latitude', 'longitude', 'commune', 'province', 'id_categorie'];
        if (!is_array($data) || count(array_diff($champsRequis, array_keys($data))) > 0) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Champs obligatoires manquants : ' . implode(', ', $champsRequis)]);
            exit;
        }

        $id = $lieuDAO->creer($data);
        http_response_code(201);
        echo json_encode(['id_lieu' => $id]);
        break;

    case 'PUT':
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Paramètre id manquant']);
            exit;
        }

        $data = json_decode(file_get_contents('php://input'), true);
        if (!is_array($data)) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Corps JSON invalide']);
            exit;
        }

        echo json_encode(['succes' => $lieuDAO->modifier((int) $_GET['id'], $data)]);
        break;

    case 'DELETE':
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Paramètre id manquant']);
            exit;
        }

        echo json_encode(['succes' => $lieuDAO->supprimer((int) $_GET['id'])]);
        break;

    default:
        http_response_code(405);
        echo json_encode(['erreur' => 'Méthode non autorisée']);
}
