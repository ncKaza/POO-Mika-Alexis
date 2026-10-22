<?php
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');

require_once __DIR__ . '/../db.php';

$stmt = $pdo->query('SELECT id, nom, avis, note FROM restaurant');
echo json_encode($stmt->fetchAll());