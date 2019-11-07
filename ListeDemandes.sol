pragma solidity ^0.5.0;

/*
Ce qui ne fonctionne pas :
- on ne peut pas verifier que le membre existe deja
    - j'essaye de faire une fonction pour ca dans l'autre fichier
- le depot d'argent 
*/


import ".contratReputation.sol";

contract Demandes is Reputation {

// on creé une structure de demande avec ses proprietes
	struct Demande {
		uint offre;
		uint delai;
		string description;
		string statut;
		uint reputationMinimum;
		//string[] listeCandidats;
	}
	
	mapping (address => Demande) demandes;
	address[] public listeDemandes;

// ajouter une demande
    function ajouterDemande(address _address, uint  _offre, uint _delai, string memory _description, uint _reputationMinimum) public {
        //La fonction suivante ne fonctionne pas
        //require(_addressMember[_address] >= 0, “Nous vous invitons à vous inscrire afin de déposer une demande”);

        // on fait une variable demande et on on l’associe a notre mapping
        Demande storage demande = demandes[_address];

        //on définit les propriétés du mapping avec nos inputs
        demande.offre = _offre;
        demande.delai = _delai;
        demande.description = _description;
        demande.statut = "OUVERTE";
        //ici je ne n'arrive pas a utiliser enum comme conseillé dans l'énoncé
        demande.reputationMinimum = _reputationMinimum;
        
        listeDemandes.push(_address) -1;

    }

    //on va faire une fonction qui va nous retourner la liste des demandes
    function voirDemandes() view public returns (address[] memory) {
	    return listeDemandes;
    }

    //et une fonction qui permet d’avoir le detail de la demande a partir d’une adresse
    function voirDemande(address _address) view public returns (uint, uint, string memory, string memory, uint) {
	    return (
	        demandes[_address].offre, 
	        demandes[_address].delai, 
	        demandes[_address].description, 
	        demandes[_address].statut,
	        demandes[_address].reputationMinimum
	        );
    }
}




