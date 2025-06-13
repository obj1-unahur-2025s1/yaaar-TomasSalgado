class Barco{

  var misionACumplir
  const capacidad
  const tripulacion = #{}

  method cantidadTripulantes(){
    return tripulacion.size()
  }
  
  method tieneSuficienteTripulacion(){
    return self.cantidadTripulantes() >= (capacidad * 0.90)
  }

  method cambiarMision(unaMision){
    misionACumplir = unaMision
    const tripulacionQueNoCumple = tripulacion.filter({t => not unaMision.esUtil(t)})

    tripulacion.removeAll(tripulacionQueNoCumple)

  }
  method cantidadTripulantesPasadosDeGrog(){
    return tripulacion.count({t => t.estaPasadoDeGrog()})
  }

  method puedeCumplirMision(mision){
    return mision.puedeCompletarMision(self)  // falta algo
  }

  method agregarPirataATripulacion(unPirata){
    if(capacidad > self.cantidadTripulantes() && unPirata.esUtilPara(misionACumplir)){
      tripulacion.add(unPirata)
    }
  }

  method puedeSerSaqueadoPor(unPirata){
    return unPirata.estaPasadoDeGrog()
  }

  method esVulnerable(otroBarco){
    return otroBarco.cantidadTripulantes() / 2 >= self.cantidadTripulantes() 
  }

  method estanTodosPasadosDeGrog(){
    return tripulacion.all({t => t.estaPasadoDeGrog()})
  }

  method anclarEnCiudadCostera(unaCiudad){
    tripulacion.forEach({t => t.tomarTragoDeGrog()})
    tripulacion.forEach({t => t.gastarMoneda()})
    self.removerAlMasBorracho()
    unaCiudad.sumarHabitante()
  }

  method removerAlMasBorracho(){
    tripulacion.max({t => t.nivelEbriedad()}).remove()
  }



}

class Pirata{

  var nivelEbriedad
  var dinero
  const property items = []


  method agregarItem(unItem){
    items.add(unItem)
  }

  method nivelEbriedad(){
    return nivelEbriedad
  }
  
  method dinero(){
    return dinero
  }
  
  method estaPasadoDeGrog(){
    return nivelEbriedad >= 90
  }

  method puedeSaquearCiudad(){
    return nivelEbriedad >= 50
  }

  method gastarMoneda(){
    dinero = (dinero - 1).max(0)
  } 
/*
  method esUtilPara(mision){
    return mision.cumpleRequerimientos(self)
  }
*/
  method tieneLlaveDeCofre(){
    return items.contains("llaveDeCofre")
  }

  method seAnimaA(unObjetivo){
    return unObjetivo.puedeSerAtacado(self)
  }

  method esUtil(mision){
    return mision.esUtil(self)
  }

  method tomarTragoDeGrog(){
    nivelEbriedad += 5
  }



}

class Espia inherits Pirata{
  
}

/*

object busquedaDelTesoro{

  method cumpleRequerimientos(unPirata){
    return unPirata.dinero() <= 5 &&
      (  unPirata.items().contains("mapa")
     || unPirata.items().contains("grogXD") 
     || unPirata.items().contains("brujula") )
  }
  method barcoCumpleRequerimientos(unBarco){
    return unBarco.tripulantes().any( { t => t.tieneLlaveDeCofre() } )
  }

}

object convertirseEnLeyenda {
  
  var itemObligatorio = "mapa"

  method cambiarItemObligatorio(unItem){
    itemObligatorio = unItem
  }

  method cumpleRequerimientos(unPirata){
    return unPirata.items().size() >= 10 && unPirata.items().contains(itemObligatorio)
  }
  
  method barcoCumpleRequerimientos(unBarco){
    return true
  }
}

object saqueo {



  method cumpleRequerimientos(unPirata){
    return unPirata.dinero() < monedasNecesarias.valor() && unPirata.seAnimaASaquearlo(self)
  }

}

object monedasNecesarias{

  var property valor = 15
}

*/

class Mision{

  method puedeCompletarMision(unBarco){
    return unBarco.tieneSuficienteTripulacion()
  }
}

class BusquedaDelTesoro inherits Mision{

const itemsRequeridos = #{"mapa", "brujula", "grog"}

   override method puedeCompletarMision(unBarco){
    return  super(unBarco)  && unBarco.tripulantes().any( { t => t.tieneLlaveDeCofre() } )
  }

  method esUtil(unPirata){
    return unPirata.dinero() <= 5 && not unPirata.items().asSet().intersection(itemsRequeridos).isEmpty()

  }

}

class Leyenda inherits Mision{

  const itemObligatorio

  method esUtil(unPirata){
    return unPirata.items().size() >= 10 && unPirata.items().contains(itemObligatorio)
  }
}

object monedasNecesarias{

  var property valor = 15
}

class Saqueo inherits Mision{

  const objetivo

  method esUtil(unPirata){
    unPirata.dinero() <= monedasNecesarias.valor() && unPirata.seAnimaA(objetivo)
  }

}

class Ciudad{

  var habitantes

  method puedeSerSaqueadoPor(unPirata){
    return unPirata.puedeSaquearCiudad()
  }

  method esVulnerable(otroBarco){
    return  (otroBarco.cantidadTripulantes() >= habitantes * 0.4 ) || otroBarco.estanTodosPasadosDeGrog()
  }

  method sumarHabitante(){
    habitantes = habitantes + 1
  }


}