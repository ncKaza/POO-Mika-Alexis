<?php
declare(strict_types=1);

// ============================================================
// UtilisateurDAO - Inscription et connexion sur la table `utilisateur`
//
// Le mot de passe n'est JAMAIS stocke en clair : on range dans la colonne
// `mot_de_passe_hache` le resultat de password_hash(), impossible a inverser.
// A la connexion, password_verify() compare la saisie au hachage.
// ============================================================

class UtilisateurDAO
{
    private PDO $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    /**
     * CREATE - Inscrit un nouvel utilisateur.
     * Retourne son id, ou null si l'email est deja pris.
     */
    public function inscrire(string $email, string $pseudo, string $motDePasse): ?int
    {
        if ($this->trouverParEmail($email) !== null) {
            return null;
        }

        // PASSWORD_DEFAULT suit les recommandations de PHP et evolue avec les versions.
        $hache = password_hash($motDePasse, PASSWORD_DEFAULT);

        $stmt = $this->pdo->prepare(
            "INSERT INTO utilisateur (email, pseudo, mot_de_passe_hache)
             VALUES (:email, :pseudo, :hache)"
        );
        $stmt->execute([
            ':email'  => $email,
            ':pseudo' => $pseudo,
            ':hache'  => $hache,
        ]);

        return (int) $this->pdo->lastInsertId();
    }

    /**
     * Verifie un couple email / mot de passe.
     * Retourne l'utilisateur SANS son hachage, ou null si les identifiants sont faux.
     */
    public function connecter(string $email, string $motDePasse): ?array
    {
        $utilisateur = $this->trouverParEmail($email);

        if ($utilisateur === null) {
            return null;
        }

        if (!password_verify($motDePasse, $utilisateur['mot_de_passe_hache'])) {
            return null;
        }

        // Le hachage ne doit jamais sortir de cette classe.
        unset($utilisateur['mot_de_passe_hache']);

        return $utilisateur;
    }

    /**
     * READ - Recherche par email (sert aussi a verifier qu'il est libre).
     * Attention : le tableau retourne CONTIENT le hachage, usage interne.
     */
    public function trouverParEmail(string $email): ?array
    {
        $stmt = $this->pdo->prepare("SELECT * FROM utilisateur WHERE email = :email");
        $stmt->execute([':email' => $email]);
        $utilisateur = $stmt->fetch();

        return $utilisateur === false ? null : $utilisateur;
    }

    /**
     * READ - Recupere un utilisateur par son id, sans son hachage.
     */
    public function trouverParId(int $id): ?array
    {
        $stmt = $this->pdo->prepare(
            "SELECT id_utilisateur, email, pseudo, role, date_creation
             FROM utilisateur WHERE id_utilisateur = :id"
        );
        $stmt->execute([':id' => $id]);
        $utilisateur = $stmt->fetch();

        return $utilisateur === false ? null : $utilisateur;
    }
}
