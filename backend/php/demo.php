<?php
error_reporting(E_ALL); ini_set('display_errors', '1');

require_once __DIR__ . '/db.php';
require_once __DIR__ . '/LieuDAO.php';
require_once __DIR__ . '/CategorieDAO.php';

$lieuDAO = new LieuDAO($pdo);
$categorieDAO = new CategorieDAO($pdo);

echo "=== Catégories disponibles ===\n";
foreach ($categorieDAO->listerToutes() as $categorie) {
    echo "- {$categorie['libelle']} (id {$categorie['id_categorie']})\n";
}

echo "\n=== Lieux de la Province Nord ===\n";
foreach ($lieuDAO->listerTous(null, 'Nord') as $lieu) {
    echo "- {$lieu['nom']} [{$lieu['categorie_libelle']}] ({$lieu['commune']})\n";
}

echo "\n=== Recherche : 'plage' ===\n";
foreach ($lieuDAO->listerTous('plage') as $lieu) {
    echo "- {$lieu['nom']}\n";
}

echo "\n=== Détail du lieu n°1 ===\n";
$lieu = $lieuDAO->trouverParId(1);
if ($lieu !== null) {
    echo "{$lieu['nom']} - {$lieu['description']}\n";
    echo "Coordonnées : {$lieu['latitude']}, {$lieu['longitude']}\n";
    echo "Photos associées : " . count($lieu['photos']) . "\n";
} else {
    echo "Aucun lieu trouvé avec cet id.\n";
}
