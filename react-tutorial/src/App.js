import React from 'react';
import './App.css';
import contratReputation from './abis/contratReputation.json';
import Web3 from 'web3';

class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      Web3: null,
      account: '',
      contratReputation: '',
      loading: true
    }
    //permet de lancer a fonction inscription depuis l'évènement onclick html
    //this.inscription = this.inscription.bind(this)
  }

  //charge le web3, et récupère les infos de la blockchain sur laquelle on est connecté
  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.ethereum) {
      window.web3= new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('non-ethereum browser detected. you should consider trying metamask!')
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3
    // Load account
    const accounts = await web3.eth.getAccounts()
    this.setState({
    account: accounts[0],
    web3: web3
    })
    const networkId = await web3.eth.net.getId()
    const networkData = contratReputation.networks[networkId]
    if(networkData) {
    const _contratReputation = new web3.eth.Contract(contratReputation.abi, networkData.address)
    this.setState({
    _contratReputation : _contratReputation._address,
    })
    } else {
    window.alert('contratReputation contract not deployed to detected network.')
    }
    }

    render() {
      return (
      <div class="container-fluid">
      <nav class="navbar navbar-light bg-primary">
      <div class="text-light font-weight-bold">ACCUEIL</div>
      <dic class="text-light font-weight-bold">Défi #2: Place de marché d’illustrateurs indépendants</dic>
      <div class="btn-group">
      <button class="btn btn-primary dropdown-toggle">Mon compte</button>
      </div>
      </nav><br/>
      <form class="col-lg-3 border border-dark rounded-lg">
  <div class="form-group">
    <label for="InputEmail1">Adresse Mail:</label>
    <input type="email" class="form-control" id="inputMail"></input>
    <small id="emailHelp" class="form-text text-muted">Votre adresse ne sera jamais communiquée.</small>
  </div>
  <div class="form-group">
    <label for="InputPassword1">Mot de passe:</label>
    <input type="password" class="form-control" id="inputMotDePasse"></input>
  </div>
  <button type="submit" class="btn btn-primary">Se connecter</button>
</form>
      </div>
      );
      }
}  

export default App;
