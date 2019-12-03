import React, { Component } from 'react';


//un component se presente sous la forme d'une classe
class Offres extends Component {


    //il va rendre graphiquement
    render() {
        let {popup} = this.state;
        
        return (
          <div className="container">
            {popup}
            <h1 className="col-lg bg-light rounded-lg">Liste des offres</h1>
            <div>{this.offres()}</div>
          </div>
        );
      }
    


}

export default Offres;
