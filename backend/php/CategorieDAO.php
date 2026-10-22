<?php
declare(strict_types=1);

// ============================================================
// CategorieDAO - CRUD sur la table `categorie`
// ============================================================

class CategorieDAO
{
    private PDO $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    /**
     * READ - Liste toutes les categories (usage : filtres visiteur, M3)
     */
    public function listerToutes(): array
    {
        $stmt = $this->pdo->query("SELECT * FROM categorie ORDER BY libelle");

        return $stmt->fetchAll();
    }

    /**
     * READ - Recupere une categorie par son id
     */
    public function trouverParId(int $id): ?array
    {
        $stmt = $this->pdo->prepare("SELECT * FROM categorie WHERE id_categorie = :id");
        $stmt->execute([':id' => $id]);
        $categorie = $stmt->fetch();

        return $categorie === false ? null : $categorie;
    }

    /**
     * CREATE - Ajoute une categorie (usage : administrateur, M7)
     */
    public function creer(string $libelle, ?string $icone = null): int
    {
        $stmt = $this->pdo->prepare(
            "INSERT INTO categorie (libelle, icone) VALUES (:libelle, :icone)"
        );
        $stmt->execute([':libelle' => $libelle, ':icone' => $icone]);

        return (int) $this->pdo->lastInsertId();
    }

    /**
     * UPDATE - Modifie une categorie (usage : administrateur, M7)
     */
    public function modifier(int $id, string $libelle, ?string $icone = null): bool
    {
        $stmt = $this->pdo->prepare(
            "UPDATE categorie SET libelle = :libelle, icone = :icone WHERE id_categorie = :id"
        );

        return $stmt->execute([':libelle' => $libelle, ':icone' => $icone, ':id' => $id]);
    }

    /**
     * DELETE - Supprime une categorie
     * Attention : echouera si des lieux y sont encore rattaches (contrainte ON DELETE RESTRICT)
     */
    public function supprimer(int $id): bool
    {
        $stmt = $this->pdo->prepare("DELETE FROM categorie WHERE id_categorie = :id");

        return $stmt->execute([':id' => $id]);
    }
}
