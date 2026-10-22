<?php
declare(strict_types=1);

// ============================================================
// LieuDAO - CRUD sur la table `lieu`
// Utilise des requetes preparees (protection injection SQL)
// ============================================================

class LieuDAO
{
    private PDO $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    /**
     * CREATE - Ajoute un nouveau lieu (usage : administrateur, M7)
     */
    public function creer(array $data): int
    {
        $sql = "INSERT INTO lieu (nom, description, latitude, longitude, commune, province, infos_pratiques, id_categorie)
                VALUES (:nom, :description, :latitude, :longitude, :commune, :province, :infos_pratiques, :id_categorie)";

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            ':nom'             => $data['nom'],
            ':description'     => $data['description'] ?? null,
            ':latitude'        => $data['latitude'],
            ':longitude'       => $data['longitude'],
            ':commune'         => $data['commune'],
            ':province'        => $data['province'],
            ':infos_pratiques' => $data['infos_pratiques'] ?? null,
            ':id_categorie'    => $data['id_categorie'],
        ]);

        return (int) $this->pdo->lastInsertId();
    }

    /**
     * READ - Liste les lieux, avec filtres optionnels (usage : visiteur, M3)
     */
    public function listerTous(?string $recherche = null, ?string $province = null, ?int $idCategorie = null): array
    {
        $sql = "SELECT l.*, c.libelle AS categorie_libelle
                FROM lieu l
                JOIN categorie c ON c.id_categorie = l.id_categorie
                WHERE 1 = 1";
        $params = [];

        if ($recherche !== null && $recherche !== '') {
            $sql .= " AND l.nom LIKE :recherche";
            $params[':recherche'] = '%' . $recherche . '%';
        }
        if ($province !== null && $province !== '') {
            $sql .= " AND l.province = :province";
            $params[':province'] = $province;
        }
        if ($idCategorie !== null) {
            $sql .= " AND l.id_categorie = :id_categorie";
            $params[':id_categorie'] = $idCategorie;
        }

        $sql .= " ORDER BY l.nom";

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);

        return $stmt->fetchAll();
    }

    /**
     * READ - Recupere un lieu avec ses photos (usage : visiteur, M2)
     */
    public function trouverParId(int $id): ?array
    {
        $stmt = $this->pdo->prepare(
            "SELECT l.*, c.libelle AS categorie_libelle
             FROM lieu l
             JOIN categorie c ON c.id_categorie = l.id_categorie
             WHERE l.id_lieu = :id"
        );
        $stmt->execute([':id' => $id]);
        $lieu = $stmt->fetch();

        if ($lieu === false) {
            return null;
        }

        $stmtPhotos = $this->pdo->prepare(
            "SELECT * FROM photo WHERE id_lieu = :id ORDER BY ordre"
        );
        $stmtPhotos->execute([':id' => $id]);
        $lieu['photos'] = $stmtPhotos->fetchAll();

        return $lieu;
    }

    /**
     * UPDATE - Modifie un lieu existant (usage : administrateur, M7)
     */
    public function modifier(int $id, array $data): bool
    {
        $sql = "UPDATE lieu SET
                    nom             = :nom,
                    description     = :description,
                    latitude        = :latitude,
                    longitude       = :longitude,
                    commune         = :commune,
                    province        = :province,
                    infos_pratiques = :infos_pratiques,
                    id_categorie    = :id_categorie
                WHERE id_lieu = :id";

        $stmt = $this->pdo->prepare($sql);

        return $stmt->execute([
            ':nom'             => $data['nom'],
            ':description'     => $data['description'] ?? null,
            ':latitude'        => $data['latitude'],
            ':longitude'       => $data['longitude'],
            ':commune'         => $data['commune'],
            ':province'        => $data['province'],
            ':infos_pratiques' => $data['infos_pratiques'] ?? null,
            ':id_categorie'    => $data['id_categorie'],
            ':id'              => $id,
        ]);
    }

    /**
     * DELETE - Supprime un lieu (les photos liees sont supprimees en cascade)
     * (usage : administrateur, M7)
     */
    public function supprimer(int $id): bool
    {
        $stmt = $this->pdo->prepare("DELETE FROM lieu WHERE id_lieu = :id");

        return $stmt->execute([':id' => $id]);
    }
}
