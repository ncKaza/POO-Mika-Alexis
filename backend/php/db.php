<?php
declare(strict_types=1);

// ============================================================
// Connexion PDO - NC Explorer
// A adapter selon ta config XAMPP (identifiants par defaut : root / mot de passe vide)
// ============================================================

$host = 'localhost';
$port = '3306';
$dbname = 'nc_explorer';
$user = 'root';
$password = '';

try {
    $pdo = new PDO(
        "mysql:host={$host};port={$port};dbname={$dbname};charset=utf8mb4",
        $user,
        $password,
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]
    );
} catch (PDOException $e) {
    // En dev uniquement : ne jamais afficher le message d'erreur brut en production
    die('Erreur de connexion à la base de données : ' . $e->getMessage());
}
