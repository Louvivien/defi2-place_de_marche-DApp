pragma solidity ^0.5.0;

contract Reputation {
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
    
    //function qui donne la réputation d'un participant
    function reputation(string memory pseudo) public view returns (uint256) {
        return _reputMember[pseudo];
    }
    
    function inscription(string memory pseudo) public {
        //Vérifie d'abord que le participant n'est pas déjà inscris ou a été bannis
        require(_reputMember[_addressMember[msg.sender]] >= 0, "ce participant est déjà inscris ou a été bannis");
        
        //ajoute le participant
        _reputMember[pseudo] = 1;
        
        //ajoute également son adresse
        _addressMember[msg.sender] = pseudo;
    }
    
    //Function qui bannis un participant (sa réputation est modifiée à zéro)
    function bannir(string memory pseudo) private {
        //Vérifie que l'initiateur de cette opération est bien l'administrateur
        require(msg.sender == _admin, "Vous n'avez pas les droits nécessaires pour effectuer cette opération");
        
        //modification de la réputation
        _reputMember[pseudo] = 0;
    }


    //Function qui retourne si une adresse est membre ou non
    /*function isMember(address _address) public view returns(bool isIndeed) {
        //return (_addressMember[_address] != 0);
        
        }*/
    
}