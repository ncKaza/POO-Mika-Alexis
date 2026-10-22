-- ============================================================
-- NC Explorer - Script de création de la base de données
-- SGBD cible : MySQL / MariaDB (XAMPP / phpMyAdmin)
-- Convention de nommage : snake_case
-- ============================================================

CREATE DATABASE IF NOT EXISTS nc_explorer
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE nc_explorer;

-- ------------------------------------------------------------
-- Table : utilisateur
-- Compte visiteur inscrit (membre) ou administrateur
-- ------------------------------------------------------------
CREATE TABLE utilisateur (
    id_utilisateur      INT AUTO_INCREMENT PRIMARY KEY,
    email               VARCHAR(255) NOT NULL UNIQUE,
    pseudo              VARCHAR(100) NOT NULL,
    mot_de_passe_hache  VARCHAR(255) NOT NULL,
    role                ENUM('MEMBRE', 'ADMIN') NOT NULL DEFAULT 'MEMBRE',
    date_creation       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : categorie
-- Regroupe les lieux (Nature, Plage, Culture, Patrimoine, Panorama...)
-- ------------------------------------------------------------
CREATE TABLE categorie (
    id_categorie    INT AUTO_INCREMENT PRIMARY KEY,
    libelle         VARCHAR(100) NOT NULL UNIQUE,
    icone           VARCHAR(255)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : lieu
-- Lieu emblématique affiché sur la carte
-- ------------------------------------------------------------
CREATE TABLE lieu (
    id_lieu             INT AUTO_INCREMENT PRIMARY KEY,
    nom                 VARCHAR(150) NOT NULL,
    description         TEXT,
    latitude            DECIMAL(9,6) NOT NULL,
    longitude           DECIMAL(9,6) NOT NULL,
    commune             VARCHAR(100) NOT NULL,
    province            ENUM('Sud', 'Nord', 'Iles Loyaute') NOT NULL,
    infos_pratiques     TEXT,
    id_categorie        INT NOT NULL,

    CONSTRAINT fk_lieu_categorie
        FOREIGN KEY (id_categorie) REFERENCES categorie (id_categorie)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    INDEX idx_lieu_nom (nom),
    INDEX idx_lieu_province (province)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : photo
-- Photos rattachées à un lieu (1 lieu -> plusieurs photos)
-- ------------------------------------------------------------
CREATE TABLE photo (
    id_photo    INT AUTO_INCREMENT PRIMARY KEY,
    url         VARCHAR(500) NOT NULL,
    legende     VARCHAR(255),
    ordre       INT NOT NULL DEFAULT 0,
    id_lieu     INT NOT NULL,

    CONSTRAINT fk_photo_lieu
        FOREIGN KEY (id_lieu) REFERENCES lieu (id_lieu)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : avis
-- Avis déposé par un membre sur un lieu, soumis à modération
-- ------------------------------------------------------------
CREATE TABLE avis (
    id_avis         INT AUTO_INCREMENT PRIMARY KEY,
    note            TINYINT NOT NULL,
    commentaire     TEXT,
    date_avis       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    statut          ENUM('EN_ATTENTE', 'PUBLIE', 'REJETE') NOT NULL DEFAULT 'EN_ATTENTE',
    id_utilisateur  INT NOT NULL,
    id_lieu         INT NOT NULL,

    CONSTRAINT fk_avis_utilisateur
        FOREIGN KEY (id_utilisateur) REFERENCES utilisateur (id_utilisateur)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_avis_lieu
        FOREIGN KEY (id_lieu) REFERENCES lieu (id_lieu)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT chk_avis_note CHECK (note BETWEEN 1 AND 5)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : favori
-- Association (classe-association) entre un membre et un lieu
-- ------------------------------------------------------------
CREATE TABLE favori (
    id_utilisateur  INT NOT NULL,
    id_lieu         INT NOT NULL,
    date_ajout      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_utilisateur, id_lieu),

    CONSTRAINT fk_favori_utilisateur
        FOREIGN KEY (id_utilisateur) REFERENCES utilisateur (id_utilisateur)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_favori_lieu
        FOREIGN KEY (id_lieu) REFERENCES lieu (id_lieu)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
