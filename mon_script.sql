-- On vérifie que les bureaux de vote sont bien dans une seule circonscription.-- elle renvoie 0 ligne.
-- Elle ne renvoie aucune ligne. (Donc prédicat vérifier).
select 
    "Code du b.vote", 
    count(distinct "Code de la circonscription") 
from tpeval."election-2022" 
group by "Code du b.vote" 
having count (distinct "Code de la circonscription") > 1;

-- Création du schema pour l'exemple (changer le nom si vous voulez tester)
drop schema if exists tp_exemple_enzo cascade;
create schema tp_exemple_enzo;

-- Création des tables
create table tp_exemple_enzo.circonscription(
    "code_circo" DECIMAL NOT NULL,
    "libelle" varchar(255)
);

create table tp_exemple_enzo."bureaux"(
    "code_bureau" DECIMAL NOT NULL,
    "code_circo" DECIMAL NOT NULL,
    "inscrit" DECIMAL,
    "abstentions" DECIMAL,
    "votants" DECIMAL,
    "blancs" DECIMAL,
    "nuls" DECIMAL
);

create table tp_exemple_enzo."candidats"(
    "num_panneau" DECIMAL NOT NULL,
    "nom" varchar(255),
    "prenom" varchar(255),
    "sexe" varchar(255)
);

create table tp_exemple_enzo."obtient"(
    "code_bureau" DECIMAL NOT NULL,
    "num_panneau" DECIMAL NOT NULL,
    "voix" DECIMAL NOT NULL
);
/* 
Ajout des contraintes, 
je le fais pas lors de la création de la table car c'est plus claire sur les étapes,
mais vous pouvez tout faire dans un seul bloc 
*/


alter table tp_exemple_enzo."circonscription" 
add constraint prim_key_cons 
primary key (code_circo);

alter table tp_exemple_enzo."bureaux"
add constraint prim_key_bur 
primary key (code_bureau);

alter table tp_exemple_enzo."bureaux"
add constraint for_key_bur 
foreign key (code_circo) 
references tp_exemple_enzo."circonscription"(code_circo);
/* Notes on pourrait aussi ajouter une contrainte pour 
vérifier que le sexe est soit 'M' ou 'F' (on fait confiance aux données)
*/
alter table tp_exemple_enzo."candidats" 
add constraint prim_key_cand 
primary key (num_panneau);

alter table tp_exemple_enzo."obtient"
add constraint for_key_obt
foreign key (code_bureau) 
references tp_exemple_enzo."bureaux"(code_bureau);

alter table tp_exemple_enzo."obtient"
add constraint for_key_obt2
foreign key (num_panneau) 
references tp_exemple_enzo."candidats"(num_panneau);

alter table tp_exemple_enzo."obtient"
add constraint prim_key_obt
primary  key (code_bureau, num_panneau);

-- Ajout des tuples dans la table circonscription à partir des données de la table (election-2022)
insert into tp_exemple_enzo."circonscription" (code_circo, libelle)
select distinct 
    "Code de la circonscription" as code_circo, "Libellé de la circonscription" as libelle 
from tpeval."election-2022" 
group by "Code de la circonscription", "Libellé de la circonscription";

-- Ajout des tuples dans la table bureaux à partir des données de la table (election-2022)
insert into tp_exemple_enzo."bureaux"
(code_bureau, code_circo, inscrit, abstentions, votants, blancs, nuls)
select distinct
    "Code du b.vote" as code_bureau,
    "Code de la circonscription" as code_circo,
    "Inscrits" as inscrit,
    "Abstentions" as abstentions,
    "Votants" as votants,
    "Blancs" as blancs,
    "Nuls" as nuls 
    from tpeval."election-2022";


-- Ajout des tuples dans la table candidats à partir des données de la table (election-2022)
insert into tp_exemple_enzo."candidats"
(num_panneau, nom, prenom, sexe)
select distinct  
    "N°Panneau" as num_panneau,
    "Nom" as nom,
    "Prénom" as prenom,
    "Sexe" as sexe
    from tpeval."election-2022"; 

-- Ajout des tuples dans la table obtient à partir des données de la table (election-2022)
insert into tp_exemple_enzo."obtient"
(code_bureau, num_panneau, voix)
select  
    "Code du b.vote" as code_bureau,
    "N°Panneau" as num_panneau,
    SUM("Voix") as voix
    from tpeval."election-2022"
    group by "N°Panneau", "Code du b.vote";

-- Donner le pourcentage des voix pour chaque candidats du bureau de vote nº307
select 
    num_panneau as Panneau,
    nom as Nom,
    prenom as Prenom,
    ((voix*100)/(votants-blancs-nuls)) as Score
    from tp_exemple_enzo.obtient
    join tp_exemple_enzo.candidats using (num_panneau)
    join tp_exemple_enzo.bureaux using(code_bureau)
    where "code_bureau" = 307
    group by num_panneau, nom, prenom, voix, votants, blancs, nuls;

-- Donner le pourcentage des voix pour chaque candidats bureau de la commune de Lyon
select
    num_panneau as Panneau,
    prenom as Prenom,
    nom as Nom,
    SUM(voix*100)/SUM(votants-blancs-nuls) as Score
    from tp_exemple_enzo."obtient"
    join tp_exemple_enzo."candidats" using (num_panneau)
    join tp_exemple_enzo."bureaux" using (code_bureau)
    group by num_panneau, prenom, nom
    order by Score DESC;

-- Donner le pourcentage de voix le plus haut pour chaque circonscriptions
select 
    circonscription as Circonscription,
    MAX(Score) as Score 
    from (select
        code_circo as Circonscription,
        num_panneau as Panneau,
        prenom as Prenom,
        nom as Nom,
        SUM(voix*100)/SUM(votants-blancs-nuls) as Score
        from tp_exemple_enzo.obtient
        join tp_exemple_enzo.candidats using (num_panneau)
        join tp_exemple_enzo.bureaux using (code_bureau)
        join tp_exemple_enzo.circonscription using(code_circo)
        group by circonscription, Panneau, Prenom, Nom
        order by code_circo ASC, Score DESC)
    as sub group by Circonscription;

-- Si vous avez des questions il faut me dm sur discord 'ByWizKi'


