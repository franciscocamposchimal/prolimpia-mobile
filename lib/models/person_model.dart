class Person {
  String usrNumcon;
  String usrNombre;
  String usrDomici;
  int usrZona;
  int usrRuta;
  int usrProg;
  int usrCvetar;
  int usrConsum;
  String usrMesFac;
  int usrClave;
  String usrFecultPago;
  String usrFlPago;
  int usrAdeudo;
  int usrFactur;
  int usrIva;
  int usrSubtotal;
  int usrSubsidio;
  int usrTotal;
  String crtAviso;
  String crtCorte;
  int usrActivo;
  String email;
  String telefono;

  Person(
      {this.usrNumcon,
      this.usrNombre,
      this.usrDomici,
      this.usrZona,
      this.usrRuta,
      this.usrProg,
      this.usrCvetar,
      this.usrConsum,
      this.usrMesFac,
      this.usrClave,
      this.usrFecultPago,
      this.usrFlPago,
      this.usrAdeudo,
      this.usrFactur,
      this.usrIva,
      this.usrSubtotal,
      this.usrSubsidio,
      this.usrTotal,
      this.crtAviso,
      this.crtCorte,
      this.usrActivo,
      this.email,
      this.telefono});

  Person.fromJson(Map<String, dynamic> json) {
    usrNumcon = json['USR_NUMCON'].toString();
    usrNombre = json['USR_NOMBRE'];
    usrDomici = json['USR_DOMICI'];
    usrZona= json['USR_ZONA'];
    usrRuta = json['USR_RUTA'];
    usrProg = json['USR_PROGR'];
    usrCvetar = json['USR_CVETAR'];
    usrConsum = json['USR_CONSUM'];
    usrMesFac = json['USR_MESFAC'];
    usrClave = json['USR_CLAVE'];
    usrFecultPago = json['USR_FECULTPAGO'];
    usrFlPago = json['USR_FLPAGO'];
    usrAdeudo = json['USR_ADEUDO'];
    usrFactur = json['USR_FACTUR'];
    usrIva = json['USR_IVA'];
    usrSubtotal = json['USR_SUBTOTAL'];
    usrSubsidio = json['USR_SUBSIDIO'];
    usrTotal = json['USR_TOTAL'];
    crtAviso = json['CRT_AVISO'];
    crtCorte = json['CRT_CORTE'];
    usrActivo = json['USR_ACTIVO'];
    email = json['EMAIL'];
    telefono = json['TELEFONO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['USR_NUMCON'] = this.usrNumcon;
    data['USR_NOMBRE'] = this.usrNumcon;
    data['USR_DOMICI'] = this.usrDomici;
    data['USR_ZONA'] = this.usrZona;
    data['USR_RUTA'] = this.usrRuta;
    data['USR_PROGR'] = this.usrProg;
    data['USR_CVETAR'] = this.usrCvetar;
    data['USR_CONSUM'] = this.usrConsum;
    data['USR_MESFAC'] = this.usrMesFac;
    data['USR_CLAVE'] = this.usrClave;
    data['USR_FECULTPAGO'] = this.usrFecultPago;
    data['USR_FLPAGO'] = this.usrFlPago;
    data['USR_ADEUDO'] = this.usrAdeudo;
    data['USR_FACTUR'] = this.usrFactur;
    data['USR_IVA'] = this.usrIva;
    data['USR_SUBTOTAL'] = this.usrSubtotal;
    data['USR_SUBSIDIO'] = this.usrSubsidio;
    data['USR_TOTAL'] = this.usrTotal;
    data['CRT_AVISO'] = this.crtAviso;
    data['CRT_CORTE'] = this.crtCorte;
    data['USR_ACTIVO'] = this.usrActivo;
    data['EMAIL'] = this.email;
    data['TELEFONO'] = this.telefono;
    return data;
  }
}

class Persons {
  List<Person> personas = new List();

  Persons.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    
    jsonList.forEach((item) {
      final persona = Person.fromJson(item);
      personas.add(persona);
    });
  }
}
