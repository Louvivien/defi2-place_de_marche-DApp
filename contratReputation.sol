pragma solidity ^0.5.0;

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
        if (_reputMember[_addressMember[user]] >= 0) {
        return true;
        } else {
            return false;
        }
    }
    
    //function qui donne la réputation d'un participant
    function reputation(string memory pseudo) public view returns (uint256) {
        return _reputMember[pseudo];
    }
    
    //Fonction qui permet à un utilisateur de s'inscrire sur la plateforme
    function inscription(string memory pseudo) public {
        //Vérifie d'abord que le participant n'est pas déjà inscris
        //Faux: require(_reputMember[_addressMember[msg.sender]] >= 0, "ce participant est déjà inscris ou a été bannis");
        require(!estInscris(msg.sender), "Ce participant est déjà inscrit");
        //ajoute le participant
        _reputMember[pseudo] = 1;
        
        //ajoute également son adresse
        _addressMember[msg.sender] = pseudo;
    }
    
    //Function qui bannis un participant (sa réputation est modifiée à zéro)
    function bannir(string memory pseudo) public {
        //Vérifie que l'initiateur de cette opération est bien l'administrateur
        require(msg.sender == _admin, "Vous n'avez pas les droits nécessaires pour effectuer cette opération");
        
        //modification de la réputation
        _reputMember[pseudo] = 0;
    }

                        //Fin de la partie 1//

                        //partie 2: Liste des demandes//
        //Variable Choix de type enum
        enum _choix{ouverte, encours, fermee}

        //On créé la structure de demande qui permet à une entreprise de formuler une demande
    struct Demandes {
        //adresse de l'emetteur de la demande
        address emetteur;
        //rémunération
        uint remuneration;
        //Délai d'acceptation
        uint delai;
        //Description de la tâche recherchée
        string description;
        //Etat de la demande
        _choix choix;
        //réputation minimum
        uint reputMinim;
        //liste des candidats postulant
        mapping(address => string) candidats;
    }

    //On créé la variable des demandes de type struct Demandes
    Demandes[] _listDemandes;

    //Fonction qui permet à une entreprise d'ajouter une demande
    function ajouterDemande(uint remuneration, uint delai, string memory description, uint reputMinim) public payable {
        //On vérifie d'abord que l'entreprise est bien inscris sur la plateforme
        require(estInscris(msg.sender), "Vous devez d'abords vous inscrire");
        //On vérifie que la rémunération proposée est différente de 0
        require(remuneration > 0, "Merci de précisier la rémunération");
        //On vérifie que le montant payé par l'entreprise émettrice est bien égal à la rémunération + 2%
        require(msg.value >= (remuneration * 102)/100, "Merci de déposer le montant de la rémunération + 2%");

        //On alimente le tableau _listDemandes
        _listDemandes.push(Demandes(msg.sender, remuneration, delai, description, _choix.ouverte, reputMinim));
    }

    //Fonction qui renvoie la liste des offres formulées par les entreprises
    function listOffres() public view returns (string memory) {
        //On vérifie que le demandeur est bien inscris sur la plateforme
        require(estInscris(msg.sender), "Vous devez être inscris pour pouvoir consulter les offres");

        //retourne tous les éléments de la variable tableau _listDemandes: me renvoie une erreur dans Remix la syntaxe n'est pas bonne
        //le .join ne semble pas fonctionné dans solidity
        return _listDemandes.join;
    }
    
                                //Fin de la partie 2//
}