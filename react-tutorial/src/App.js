import React from 'react';
import './App.css';
import jsonContrat from './abis/contratReputation.json';
import Web3 from 'web3';

class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      Web3: null,
      account: '',
      contratReputation: '',
      pseudo: '',
      user: '',
      pseudo2: '',
      loading: true
    }
    //permet de lancer a fonction inscription depuis l'évènement onclick html (fonctionne sans)
    //this.sinscrire = this.sinscrire.bind(this)
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
    this.setState({
      networkId: networkId
    })
    const networkData = jsonContrat.networks[networkId]
    if(networkData) {
    const _contratReputation = new web3.eth.Contract(jsonContrat.abi, networkData.address)
    this.setState({
      contratReputation : _contratReputation._address,
    })
    } else {
    window.alert('contratReputation contract not deployed to detected network.')
    }
    }

    async sinscrire(pseudo) {
      const {account, web3, contratReputation} = this.state
      const contract = new web3.eth.Contract(jsonContrat.abi, contratReputation)
      await contract.methods.inscription(pseudo).send({from: account})
      alert("L'utilisateur a bien été incris.")
    }

    async verifier(adresse) {
      const {web3, contratReputation}= this.state
      const contract = new web3.eth.Contract(jsonContrat.abi, contratReputation)
      const verif = await contract.methods.estInscris(adresse).call()
      if(verif) {
        this.setState({
          verif:"vous êtes bien inscris"
        })
    } else {this.setState({
          verif: "vous n'êtes pas inscris"
    })}
  }

    async reputation(pseudo) {
      const {web3, contratReputation}= this.state
      const contract = new web3.eth.Contract(jsonContrat.abi, contratReputation)
      this.setState ({
        reputation: "votre réputation est de: " + await contract.methods.reputation(pseudo).call()
      })
    }

    async bannir(pseudo) {
      const {web3, contratReputation, account}= this.state
      const contract = new web3.eth.Contract(jsonContrat.abi, contratReputation)
      await contract.methods.bannir(pseudo).send({from: account})
      this.setState ({
        bannis: "l'utilisateur: " + pseudo + " a été bannis"
      })
    }

    async ajouterDemande(remuneration, delai, description, reputMini) {
      const {web3, contratReputation, account}= this.state
      const contract = new web3.eth.Contract(jsonContrat.abi, contratReputation)
      let amount = 10 * 1.2;
      await contract.methods.ajouterDemande(remuneration, delai, description, reputMini ).send({from: account, value: web3.utils.toWei(amount.toString(),'ether')})
      this.setState ({
        demande: "la demande " + description + " a été ajoutée."
      })
    }

    render() {
      const { contratReputation, networkId, account, pseudo,  user, verif, pseudo2, reputation, bannis, pseudo3,
      descriptionDemande, remunDemande, delaiDemande, reputMiniDemande, demande } = this.state
      return (
      <div class="container-fluid">
      <nav class="navbar navbar-light bg-primary">
      <div class="text-light font-weight-bold">ACCUEIL</div>
      <div class="text-light font-weight-bold">Défi #2: Place de marché d’illustrateurs indépendants</div>
      <div class="btn-group">
      <button class="btn btn-primary dropdown-toggle">Mon compte</button>
      </div>
      </nav><br/>

      <div class="row">

  <div class="col-md-3 bg-light rounded-lg">
    <div class="form-group border-bottom border-primary">
    <label class="font-weight-bold offset-md-3">Vérifier une inscription:</label>
    </div>
    <div class= "form-group">
    <label>Merci de renseigner l'adresse de l'utilisateur:</label>
    <input class="form-control" onChange={adresse => this.setState({user: adresse.target.value})}></input>
    </div>
    <div class= "form-group">
       <button type="submit" class="btn btn-primary" onClick={() => this.verifier(user)}>Vérifier</button>
       </div>
       <div class= "form-group">
    <label>{verif}</label>
    </div>
    </div>

    <div class="col-md-4 offset-md-1 bg-light rounded-lg">
      <div class="form-group border-bottom border-primary">
        <label class="font-weight-bold offset-md-4">Vos données de connexions:</label>
      </div>
      <div class="form-group">
        <div class="row">
          <label class="font-weight-bold">réseau:</label>
          <div class="offset-md-2">
            <label>{networkId}</label>
          </div>   
        </div>
      </div>
      <div class="form-group">
        <div class="row">
          <label class="font-weight-bold">Adresse du contrat:</label>
          <div class="offset-md-2">
            <label>{contratReputation}</label>
          </div>   
        </div>
      </div>
      <div class="form-group">
        <div class="row">
          <label class="font-weight-bold">Adresse de connexion (msg.sender):</label>
          <div class="offset-md-2">
            <label id="reseau">{account}</label>
          </div>   
        </div>
      </div>
    </div>

    <div class="col-md-3 bg-light offset-md-1 rounded-lg">
      <div class="form-group border-bottom border-primary">
      <label class="font-weight-bold offset-md-4">S'inscrire:</label>
      </div>
      <div class= "form-group">
    <label>Pseudo:</label>
    <input type="email" class="form-control" onChange={pseudo => this.setState({pseudo: pseudo.target.value})}></input>
    </div>
    <div class= "form-group">
       <button onClick={() => this.sinscrire(pseudo)} class="btn btn-primary">Créer un compte</button>
       </div>
    </div>

    </div><br/>
    <div class="row">

  <div class="col-md-3 bg-light rounded-lg">
    <div class="form-group border-bottom border-primary">
    <label class="font-weight-bold offset-md-3">Obtenir sa réputation:</label>
    </div>
    <div class= "form-group">
    <label>Merci de renseigner votre pseudo:</label>
    <input class="form-control" onChange={adresse => this.setState({pseudo2: adresse.target.value})}></input>
    </div>
    <div class= "form-group">
       <button onClick={() => this.reputation(pseudo2)} class="btn btn-primary">Réputation</button>
       </div>
       <div class= "form-group">
    <label>{reputation}</label>
    </div>
    </div>

    <div class="col-md-4 offset-md-1 bg-light rounded-lg">
    <div class="form-group border-bottom border-primary">
    <label class="font-weight-bold offset-md-4">Bannir un utilisateur:</label>
    </div>
    <div class= "form-group">
    <label>Merci de renseigner le pseudo de l'utilisateur:</label>
    <input class="form-control" onChange={adresse => this.setState({pseudo3: adresse.target.value})}></input>
    </div>
    <div class= "form-group">
       <button onClick={() => this.bannir(pseudo3)} class="btn btn-primary">Bannir</button>
       </div>
       <div class= "form-group">
    <label>{bannis}</label>
    </div>
    </div>

    <div class="col-md-3 offset-md-1 bg-light rounded-lg">
    <div class="form-group border-bottom border-primary">
    <label class="font-weight-bold offset-md-4">Ajouter une demande:</label>
    </div>
    <div class= "form-group">
    <label>Description:</label>
    <input class="form-control" onChange={adresse => this.setState({descriptionDemande: adresse.target.value})}></input>
    </div>
    <div class= "form-group">
    <label>Rémunération:</label>
    <input class="form-control" onChange={adresse => this.setState({remunDemande: adresse.target.value})}></input>
    </div>
    <div class= "form-group">
    <label>Réputation minimum exigée:</label>
    <input class="form-control" onChange={adresse => this.setState({reputMiniDemande: adresse.target.value})}></input>
    </div>
    <div class= "form-group">
    <label>Délai d'acceptation (en semaine):</label>
    <input class="form-control" onChange={adresse => this.setState({delaiDemande: adresse.target.value})}></input>
    </div>
    <div class= "form-group">
       <button onClick={() => this.ajouterDemande(remunDemande, delaiDemande, descriptionDemande, reputMiniDemande)} class="btn btn-primary">Soumettre la demande</button>
       </div>
       <div class= "form-group">
    <label>{demande}</label>
    </div>
    </div>

    </div>

      </div>
      );
      }
}  

export default App;
