# Défi #2: Place de marché d’illustrateurs indépendants

Le défi de cette semaine consiste à créer **une place de marché décentralisée pour illustrateurs indépendants**. Si le sujet vous inspire, vous pouvez arrêter la lecture ici en créant une  DApp avec :

-   Un mécanisme de réputation
    
-   Une liste de demandes et d’offres de services
    
-   Un mécanisme de contractualisation avec dépôt préalable

![](https://lh4.googleusercontent.com/DRPyaubiz-C3ZbMQLjWzVoO6Om2vW4YG1zALcWYemzcK57J85YeJiEukUY2YfEx-ImuK9JYpl0qrAkPEhmIQ9ZAmnP7Xz_4kkisiFJ0QB94V5sedJVNuzcgLPXEdhWTgEXtxsoTT)

# Mécanisme de réputation


-   Pour représenter la réputation, nous allons associer chaque utilisateur à une valeur entière
    
-   Lorsqu’un nouveau participant rejoint la plateforme, il appelle la fonction inscription() qui lui donne une réputation de 1. Il faut une réputation minimale pour accéder à la plupart des fonctionnalités. Un nom est aussi associé à l’adresse
    
-   (optionnel) Les adresses peuvent être bannies par un administrateur de la plateforme. Dans ce cas la réputation est mise à 0 et l’adresse ajoutée à la liste des adresses bannies. Lors de l’inscription l’adresse est vérifiée.
    

#

## Liste de demandes


-   Définir une structure de données pour chaque demande qui comprend:
    

-   La rémunération (en wei)
    
-   Le délai à compter de l’acceptation (en secondes)
    
-   Une description de la tâche à mener (champ texte)
    
-   L’état de la demande : OUVERTE, ENCOURS, FERMEE
    

-   [Aide: Penser aux énumérations enum Choix { A, B, C }]
    

-   Définir une réputation minimum pour pouvoir postuler
    
-   Une liste de candidats
    

-   Créer un tableau des demandes
    
-   Créer une fonction ajouterDemande() qui permet à une entreprise de formuler une demande. L’adresse du demandeur doit être inscrite sur la plateforme. L’entreprise doit en même temps déposer l’argent sur la plateforme correspondant à la rémunération + 2% de frais pour la plateforme.
    
-   Ecrire l’interface qui permet de lister ces offres.

## Mécanisme de contractualisation

-   Créer une fonction postuler() qui permet à un indépendant de proposer ses services. Il est alors ajouté à la liste des candidats
    
-   Créer une fonction accepterOffre() qui permet à l’entreprise d’accepter un illustrateur. La demande est alors ENCOURS jusqu’à sa remise
    
-   Ecrire une fonction livraison() qui permet à l’illustrateur de remettre le hash du lien où se trouve son travail. Les fonds sont alors automatiquement débloqués et peuvent être retirés par l’illustrateur. L’illustrateur gagne aussi un point de réputation
    
-   (optionnel) Permettre à l’entreprise de déclencher une fonction si l’illustrateur est en retard qui le sanctionne en lui retirant des points de réputation
    
-   (optionnel) Après la livraison, l’illustrateur peut placer un commentaire sur le profil de l’entreprise et inversement pendant une durée limitée. Les deux choisissent aussi le niveau de satisfaction (mauvais, correct, bon, très bon) qui se matérialise en points de réputation supplémentaires.

## Fonctionnalités supplémentaires (optionnel)


-   A la remise du travail, l’acceptation n’est pas automatique. L’entreprise a une semaine pour l’accepter. Si elle ne fait rien, les fonds sont débloqués. Elle peut refuser le travail.
    
-   Au moment de l’offre, l’entreprise suggère une liste d’arbitres parmi les membres de la plateforme. L’illustrateur choisit un des arbitres au moment de postuler. En cas de refus du travail remis par l’entreprise, l’arbitre doit se prononcer en faveur de l’entreprise ou de l’illustrateur
    
-   Permettre aux illustrateurs de lister leurs offres de services et aux entreprises de les solliciter
    
-   (Avancé) Créer un système de réputation partagé entre plusieurs plateformes similaires indépendantes. Un mécanisme doit garantir qu’aucune plateforme ne distribue beaucoup plus facilement des points

### Projet

| Nom | Lien Github | 
|:------------:|:-------------:| 
Hany Salah | [https://github.com/hany-s](https://github.com/hany-s) | 
Vivien Richaud | [https://github.com/Louvivien/](https://github.com/Louvivien/) | 




