<?php

// ============================================================
// API REST - /api/auth.php
// POST /api/auth.php?action=inscription  body : {email, pseudo, mot_de_passe}
// POST /api/auth.php?action=connexion    body : {email, mot_de_passe}
// ============================================================

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *'); // A restreindre en production
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

require_once __DIR__ . '/../db.php';
require_once __DIR__ . '/../UtilisateurDAO.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['erreur' => 'Méthode non autorisée']);
    exit;
}

$utilisateurDAO = new UtilisateurDAO($pdo);
$action = $_GET['action'] ?? '';
$data = json_decode(file_get_contents('php://input'), true);

if (!is_array($data)) {
    http_response_code(400);
    echo json_encode(['erreur' => 'Corps JSON invalide']);
    exit;
}

switch ($action) {

    case 'inscription':
        foreach (['email', 'pseudo', 'mot_de_passe'] as $champ) {
            if (empty($data[$champ])) {
                http_response_code(400);
                echo json_encode(['erreur' => "Le champ $champ est obligatoire"]);
                exit;
            }
        }

        if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Adresse email invalide']);
            exit;
        }

        if (mb_strlen($data['mot_de_passe']) < 6) {
            http_response_code(400);
            echo json_encode(['erreur' => 'Le mot de passe doit faire au moins 6 caractères']);
            exit;
        }

        $id = $utilisateurDAO->inscrire($data['email'], $data['pseudo'], $data['mot_de_passe']);

        if ($id === null) {
            http_response_code(409); // 409 Conflict : la ressource existe deja
            echo json_encode(['erreur' => 'Cette adresse email est déjà utilisée']);
            exit;
        }

        http_response_code(201);
        echo json_encode($utilisateurDAO->trouverParId($id));
        break;

    case 'connexion':
        foreach (['email', 'mot_de_passe'] as $champ) {
            if (empty($data[$champ])) {
                http_response_code(400);
                echo json_encode(['erreur' => "Le champ $champ est obligatoire"]);
                exit;
            }
        }

        $utilisateur = $utilisateurDAO->connecter($data['email'], $data['mot_de_passe']);

        if ($utilisateur === null) {
            // Message volontairement vague : ne pas reveler si l'email existe.
            http_response_code(401);
            echo json_encode(['erreur' => 'Email ou mot de passe incorrect']);
            exit;
        }

        echo json_encode($utilisateur);
        break;

    default:
        http_response_code(400);
        echo json_encode(['erreur' => "Action inconnue. Utilisez ?action=inscription ou ?action=connexion"]);
}
