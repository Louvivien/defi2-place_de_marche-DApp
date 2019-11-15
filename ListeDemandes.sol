pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract Reputation {

                            //Partie 1: Mecanisme de réputation//

    //variable qui contiendra l'adresse de l'administrateur (celui qui déploie le contrat)
    address private _admin;
    //Variable qui stocke les participants inscrits par leur pseudo ou nom
    mapping (string => uint) public _reputMember;
    //Variable qui stocke l'adresse des participants
    mapping (address => string) public _addressMember;
    
    constructor() public {
        //L'administrateur est l'initiateur du contrat
        _admin = msg.sender;
    }

    //Fonction qui vérifie qu'un uilisateur est inscris sur la plateforme
    function estInscris(address user) public view returns(bool) {
        if (_reputMember[_addressMember[user]] > 0) {
        return true;
        } else {
            return false;
        }
    }

    //Fonction qui verifie qu'un pseudo nest pas deja attribue
        function pseudoDoublon(string memory pseudo) public view returns(bool) {
            if (_reputMember[pseudo] > 0) {
            return true;
            } else {
                return false;
            }
    } 

    //Fonction qui donne la réputation d'un participant
    function reputation(string memory pseudo) public view returns (uint256) {
        //Vérifie d'abord que le participant existe
        require(_reputMember[pseudo] > 0, "Ce participant est inconnu");
        
        return _reputMember[pseudo];
    }
    
    //Fonction qui permet à un utilisateur de s'inscrire sur la plateforme
    function inscription(string memory pseudo) public {
        //Vérifie d'abord que le participant n'est pas déjà inscris
        require(!estInscris(msg.sender), "Ce participant est déjà inscrit");
        //Vérifie ensuite que le pseudo n'est pas deja attribue
        require(!pseudoDoublon(pseudo), "Ce pseudo est deja utilise");
        //ajoute le participant
        _reputMember[pseudo] = 2;
        
        //ajoute également son adresse
        _addressMember[msg.sender] = pseudo;
    }
    
    //Fonction qui bannis un participant (sa réputation est modifiée à un)
    function bannir(string memory pseudo) public {
        //Vérifie que l'initiateur de cette opération est bien l'administrateur
        require(msg.sender == _admin, "Vous n'avez pas les droits nécessaires pour effectuer cette opération");
        
        //modification de la réputation
        _reputMember[pseudo] = 1;
    }

                        //Fin de la partie 1//

                        //partie 2: Liste des demandes//
        //Variable etat de type enum
        enum _etat{ouverte, encours, fermee}

        //On créé la structure de demande qui permet à une entreprise de formuler une demande
    struct Demandes {
        //adresse de l'emetteur de la demande
        address emetteur;
        //rémunération
        uint remuneration;
        //Délai d'acceptation en seconde
        uint delai;
        //Ddebut de la tache
        uint tDebut;
        //Description de la tâche recherchée
        string description;
        //Etat de la demande
        _etat etat;
        //réputation minimum
        uint256 reputMinim;
        //Adresse du candidat retenu
        address candidatRetenu;
        //Lien vers le travail de l'illustrateur
        string url;
        //Commentaire de l'illustrateur
        string commentaireCandidat;
        //Commentaire de l'entreprise
        string commentaireEntreprise;
    }

    //On créé la variable des demandes de type struct Demandes
    Demandes[] _listDemandes;
    //Variable qui va lister les candidats postulant par index de demandes
    mapping(address => uint) candidats;
    //ERREUR A CORRIGER : un candidat ne peut pas postuler a plusieurs offres


    //Fonction qui permet à une entreprise d'ajouter une demande
    function ajouterDemande(uint remuneration, uint delai, string memory description, uint reputMinim) public payable {
        //On vérifie d'abord que l'entreprise est bien inscris sur la plateforme
        require(estInscris(msg.sender), "Vous devez d'abords vous inscrire");
        //On vérifie que la rémunération proposée est différente de 0
        require(remuneration > 0, "Merci de préciser la rémunération");
        //On vérifie que le delai proposée est différente de 0
        require(delai > 0, "Merci de préciser un delai pour realiser le travail (en jours)");
        //On vérifie que le montant payé par l'entreprise émettrice est bien égal à la rémunération + 2%
        require(msg.value >= (remuneration * 102)/100, "Merci de déposer le montant de la rémunération + 2%");


        //On alimente le tableau _listDemandes (aucun candidat n'est retenu à ce niveau on alimente donc par défaut la variable candidat avec msg.sender, idem pour temps de debut qu'on met par defaut a zero)
        _listDemandes.push(Demandes(msg.sender, remuneration, delai, 0, description, _etat.ouverte, reputMinim, msg.sender, "", "",""));
    }

    //Fonction qui renvoie la liste des offres formulées par les entreprises 
    function listOffres() view public returns (Demandes[] memory) {
        //On vérifie que le demandeur est bien inscris sur la plateforme
        require(estInscris(msg.sender), "Vous devez être inscris pour pouvoir consulter les offres");

        //retourne tous les éléments de la variable tableau _listDemandes
        return _listDemandes;
       }

                                //Fin de la partie 2//

                                //Partie 3: Mécanisme de contractualisation//
    
    //Fonction qui permet à un candidat de postuler
    function postuler(uint index) public {
        //On vérifie que le demandeur est bien inscris sur la plateforme
        require(estInscris(msg.sender), "Vous devez être inscris pour pouvoir postuler");

        // On vérifie que l'indice indiqué est correcte 
        require(index < _listDemandes.length && index >= 0, "Vérifiez l'indice indiqué !");

        //On vérifie que la réputation du candidat est au moins égale à celle requise par l'entreprise
        require(_reputMember[_addressMember[msg.sender]] >= _listDemandes[index].reputMinim, "Vous n'avez pas la réputation nécessaire pour postuler.");

        //On ajoute le candidat à la liste des postulants pour cette demande
        candidats[msg.sender] = index;
        //ERREUR : un candidate ne peut pas postuler a plusieurs offre de cette facon
  
        
    }

     //Fonction qui permet à l'entreprise d'accepter une offre
    function accepterOffre(uint index, address candidat) public {

        //On vérifie que l'entreprise est bien l'initiatrice de la demande
        require(_listDemandes[index].emetteur == msg.sender, "Vous n'êtes pas l'initiateur de cette demande.");

        //On vérifie que le candidat indiqué a bien postulé à cette demande
        require(candidats[candidat] == index, "ce candidat n'a pas postulé à votre demande.");
        //ERREUR : un candidate ne peut pas postuler a plusieurs offre de cette facon


        _listDemandes[index].candidatRetenu = candidat;
        _listDemandes[index].etat = _etat.encours;
        _listDemandes[index].tDebut = now;
    }

    //Livraison du travail du candidat et rémunération
    function livraison(uint index, string memory lien) public {
        // On vérifie que l'appelant à cette fonction à bien été choisis par l'entreprise pour la demande indiquée
        require(_listDemandes[index].candidatRetenu == msg.sender, "Vous n'avez pas été choisi pour cette demande.");

        // On vérifie le statut de la demande
        require(_listDemandes[index].etat == _etat.encours, "Une livraison a deja été effectuée .");


        //On vérifie que le délai de livraison n'est pas dépassé, on l'initie à 2 semaines
        require(now <= _listDemandes[index].tDebut + _listDemandes[index].delai, "Vous avez dépassé le délai de livraison, l'entreprise peut vous sanctionner.");

        //Le lien est mis à disposition de l'entreprise, le statut devient fermée et l'illustrateur gagne un point de réputation
        //A MODIFIER : il faut hacher ce lien
        _listDemandes[index].url = lien;
    
        _listDemandes[index].etat = _etat.fermee;
        _reputMember[_addressMember[msg.sender]]++;

        //Le délai est remis à jour pour permettre aux deux parties de laisser un commentaire durant une durée limitée à une semaine
         _listDemandes[index].delai = now + 1 weeks;

    }       

    //Fonction qui va rémunérer un illustrateur
    function remunere(address payable illustrateur, uint montant) private {
            illustrateur.transfer(montant);
    }

    //Fonction qui permet à une entreprise de sanctionner celui qui realise la tache pour son retard
    function retard(uint index) public {
        //On vérifie que l'entreprise est bien l'initiatrice de la demande
        require(_listDemandes[index].emetteur == msg.sender, "Vous n'êtes pas l'initiateur de cette demande.");

        //On vérifie que le délai de livraison a bien été dépassé
        require(_listDemandes[index].tDebut + _listDemandes[index].delai > now, "Le délai de livraison n'a pas encore été dépassé.");

        //L'entreprise retire un point de réputation et un commentaire est spécifié
        _reputMember[_addressMember[_listDemandes[index].candidatRetenu]]--;
    }

    //Fonction qui permet de laisser un commentaire
    function commentaire(uint index, string memory commentaire) public {
        // On vérifie que l'indice indiqué est correcte 
        require(index < _listDemandes.length && index >= 0, "Vérifiez l'indice indiqué !");

        //On vérifie que le délai n'est pas dépassé
        require(_listDemandes[index].delai <= now, "Le délai pour laisser un commentaire est dépassé.");

        //On vérifie que le msg.sender est soit l'entreprise soit le candidat pour affecter le commentaire approprié
        if (msg.sender == _listDemandes[index].emetteur) {
            _listDemandes[index].commentaireEntreprise = commentaire;
        } else if (msg.sender == _listDemandes[index].candidatRetenu) {
            _listDemandes[index].commentaireCandidat = commentaire;
        }
    }

    }