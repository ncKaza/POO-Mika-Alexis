<?php

// ============================================================
// API REST - /api/categories.php
// GET    /api/categories.php           → liste de toutes les catégories
// GET    /api/categories.php?id=2      → une catégorie
// POST   /api/categories.php           → créer (body JSON)     [reservé admin - TODO auth]
// PUT    /api/categories.php?id=2      → modifier (body JSON)  [reservé admin - TODO auth]
// DELETE /api/categories.php?id=2      → supprimer              [reservé admin - TODO auth]
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
require_once __DIR__ . '/../CategorieDAO.php';

$categorieDAO = new CategorieDAO($pdo);
$methode = $_SERVER['REQUEST_METHOD'];

switch ($methode) {
    case 'GET':
        if (isset($_GET['id'])) {
            $categorie = $categorieDAO->trouverParId((int) $_GET['id']);
            if ($categorie === null) {
                http_response_code(404);
                echo json_encode(['erreur' => 'Catégorie introuvable']);
                exit;
            }
            echo json_encode($categorie);
        } else {
            echo json_encode($categorieDAO->listerToutes());
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        if (!is_array($data) || !isset($data['libelle'])) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Le champ libelle est obligatoire']);
            exit;
        }

        $id = $categorieDAO->creer($data['libelle'], $data['icone'] ?? null);
        http_response_code(201);
        echo json_encode(['id_categorie' => $id]);
        break;

    case 'PUT':
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Paramètre id manquant']);
            exit;
        }

        $data = json_decode(file_get_contents('php://input'), true);
        if (!is_array($data) || !isset($data['libelle'])) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Le champ libelle est obligatoire']);
            exit;
        }

        echo json_encode(['succes' => $categorieDAO->modifier((int) $_GET['id'], $data['libelle'], $data['icone'] ?? null)]);
        break;

    case 'DELETE':
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Paramètre id manquant']);
            exit;
        }

        try {
            echo json_encode(['succes' => $categorieDAO->supprimer((int) $_GET['id'])]);
        } catch (PDOException $e) {
            http_response_code(409);
            echo json_encode(['erreur' => 'Impossible de supprimer : des lieux sont encore rattachés à cette catégorie']);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(['erreur' => 'Méthode non autorisée']);
}
