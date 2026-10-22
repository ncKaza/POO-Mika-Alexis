-- ============================================================
-- NC Explorer - Données de test
-- A exécuter APRES nc_explorer_schema.sql
-- Note : coordonnées GPS approximatives, à vérifier/affiner
--        avant tout usage en production.
-- ============================================================

USE nc_explorer;

-- ------------------------------------------------------------
-- Catégories
-- ------------------------------------------------------------
INSERT INTO categorie (libelle, icone) VALUES
('Nature', 'leaf'),
('Culture', 'landmark'),
('Patrimoine', 'monument'),
('Panorama', 'mountain'),
('Plage', 'umbrella-beach');

-- ------------------------------------------------------------
-- Lieux (Province Sud)
-- ------------------------------------------------------------
INSERT INTO lieu (nom, description, latitude, longitude, commune, province, infos_pratiques, id_categorie) VALUES
('Parc zoologique et forestier Michel-Corbasson',
 'Parc animalier et forestier presentant la faune et la flore endemiques de Nouvelle-Caledonie.',
 -22.223000, 166.482000, 'Nouméa', 'Sud', 'Ouvert tous les jours, entree payante.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Nature')),

('Centre culturel Tjibaou',
 'Centre culturel dedie a la culture kanak, concu par larchitecte Renzo Piano.',
 -22.243600, 166.464400, 'Nouméa', 'Sud', 'Ferme le lundi, visites guidees disponibles.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Culture')),

('Phare Amédée',
 'Phare metallique historique situe sur un ilot au large de Nouméa, accessible en bateau.',
 -22.479400, 166.473900, 'Nouméa', 'Sud', 'Accessible uniquement par excursion en bateau.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Patrimoine')),

('Parc provincial de la Rivière Bleue',
 'Reserve naturelle avec foret humide, kayak et randonnee.',
 -22.116700, 166.716700, 'Yaté', 'Sud', 'Reservation en ligne recommandee, acces payant.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Nature')),

('Chutes de la Madeleine',
 'Cascade et zone de baignade naturelle en foret.',
 -22.100000, 166.833300, 'Yaté', 'Sud', 'Baignade possible selon la saison.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Nature')),

('Roche Percée et le Bonhomme',
 'Formation rocheuse emblematique sur la cote, point de vue remarquable.',
 -21.580700, 165.473900, 'Bourail', 'Sud', 'Acces libre, parking a proximite.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Panorama')),

('Plage de Poé',
 'Longue plage de sable blanc bordant le lagon, spot de surf reconnu.',
 -21.616700, 165.316700, 'Bourail', 'Sud', 'Acces libre.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Plage')),

('Fort Téremba',
 'Ancien bagne et fort militaire du XIXe siecle, site historique restaure.',
 -21.666700, 165.716700, 'Moindou', 'Sud', 'Visites guidees en saison.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Patrimoine')),

('Piscine naturelle de la baie d''Oro',
 'Piscine naturelle turquoise entouree de pins colonnaires, sur l''Ile des Pins.',
 -22.666700, 167.483300, 'L''Île-des-Pins', 'Sud', 'Acces en pirogue traditionnelle depuis la baie.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Plage'));

-- ------------------------------------------------------------
-- Lieux (Province Nord)
-- ------------------------------------------------------------
INSERT INTO lieu (nom, description, latitude, longitude, commune, province, infos_pratiques, id_categorie) VALUES
('Cœur de Voh',
 'Formation vegetale naturelle en forme de coeur, visible principalement depuis les airs.',
 -20.950000, 164.683300, 'Voh', 'Nord', 'Meilleure vue depuis un point de vue en hauteur ou en vol.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Panorama')),

('La Poule de Hienghène',
 'Formation rocheuse emblematique de la cote Nord, en forme de poule.',
 -20.683300, 164.933300, 'Hienghène', 'Nord', 'Visible depuis la route cotiere, point de vue accessible.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Nature')),

('Mont Panié',
 'Point culminant de la Nouvelle-Caledonie (environ 1628 m), reserve naturelle.',
 -20.583300, 164.766700, 'Hienghène', 'Nord', 'Randonnee de plusieurs jours, guide recommande.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Nature')),

('Plage de Tiéti',
 'Plage de sable fin bordee de cocotiers sur la cote Est.',
 -20.950000, 165.333300, 'Poindimié', 'Nord', 'Acces libre.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Plage'));

-- ------------------------------------------------------------
-- Lieux (Îles Loyauté)
-- ------------------------------------------------------------
INSERT INTO lieu (nom, description, latitude, longitude, commune, province, infos_pratiques, id_categorie) VALUES
('Falaises de Jokin',
 'Falaises calcaires offrant un point de vue spectaculaire sur locean.',
 -20.766700, 167.200000, 'Lifou', 'Iles Loyaute', 'Acces libre, prudence pres des falaises.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Panorama')),

('Pont de Mouli',
 'Pont reliant Ouvéa a lilot Mouli, bordant des plages de sable blanc.',
 -20.633300, 166.566700, 'Ouvéa', 'Iles Loyaute', 'Acces libre, point de vue depuis le pont.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Plage')),

('Aquarium naturel de Maré',
 'Piscine naturelle peu profonde riche en poissons multicolores.',
 -21.516700, 168.016700, 'Maré', 'Iles Loyaute', 'Ideal pour le snorkeling, acces libre.',
 (SELECT id_categorie FROM categorie WHERE libelle = 'Nature'));
