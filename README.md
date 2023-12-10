# Intégration de données en SQL
Bonjour, voici une correction du TP noté de 2022 (Université Lyon 1, département informatique L3).

## SGBD
Pour ce projet, j'ai utilisé PostgreSQL. Pour l'interaction, j'ai utilisé psql en ligne de commande.

## Note 1
La première étape consiste à exécuter le fichier donné par le professeur :
```psql
  \i script_election_2022.sql
```
Ce script permet de créer la table 'election-2022' avec de nombreux attributs (voir le script pour les détails) et les tuples correspondants.

## Note 2
La deuxième étape consiste à exécuter le fichier 'mon_script.sql':

```psql
\i mon_script.sql
```
<span style="color:red;">ATTENTION</span>

**Si vous exécutez 'mon_script.sql', les tables seront créées mais les requêtes seront aussi exécutées, donc lisez le script attentivement.**

## Note 3 
Pour stocker les résultats de certaines requêtes dans un fichier externe :

```psql
\o nom_fichier
#Les prochaines requêtes seront donc stocker dans le fichier que vous mit en argument
```

Pour arrêter de stocker les résultats des requêtes dans un fichier :

```psql
\o
```

Si vous avez des questions, contactez-moi sur Discord en DM (ByWizKi).
**Lisez les scripts.**

Fait par Thiebaud Enzo 2023.
