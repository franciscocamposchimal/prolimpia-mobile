class Payment {
  int idCb;
  String numcon;
  String nombre;
  String domici;
  int zona;
  int ruta;
  int progr;
  int cvetar;
  String fpago;
  String faviso;
  int saldoant;
  int saldopost;
  int iva;
  int total;
  int efectivo;
  int cambio;
  String tipopago;
  String tusuario;
  String tpc;
  String referencia;
  String estado;

  Payment(
      {this.idCb,
      this.numcon,
      this.nombre,
      this.domici,
      this.zona,
      this.ruta,
      this.progr,
      this.cvetar,
      this.fpago,
      this.faviso,
      this.saldoant,
      this.saldopost,
      this.iva,
      this.total,
      this.efectivo,
      this.cambio,
      this.tipopago,
      this.tusuario,
      this.tpc,
      this.referencia,
      this.estado});

  Payment.fromJson(Map<String, dynamic> json) {
    idCb = json['id_cb'];
    numcon = json['numcon'];
    nombre = json['nombre'];
    domici = json['domici'];
    zona = json['zona'];
    ruta = json['ruta'];
    progr = json['progr'];
    cvetar = json['cvetar'];
    fpago = json['fpago'];
    faviso = json['faviso'];
    saldoant = json['saldoant'];
    saldopost = json['saldopost'];
    iva = json['iva'];
    total = json['total'];
    efectivo = json['efectivo'];
    cambio = json['cambio'];
    tipopago = json['tipopago'];
    tusuario = json['tusuario'];
    tpc = json['tpc'];
    referencia = json['referencia'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_cb'] = this.idCb;
    data['numcon'] = this.numcon;
    data['nombre'] = this.nombre;
    data['domici'] = this.domici;
    data['zona'] = this.zona;
    data['ruta'] = this.ruta;
    data['progr'] = this.progr;
    data['cvetar'] = this.cvetar;
    data['fpago'] = this.fpago;
    data['faviso'] = this.faviso;
    data['saldoant'] = this.saldoant;
    data['saldopost'] = this.saldopost;
    data['iva'] = this.iva;
    data['total'] = this.total;
    data['efectivo'] = this.efectivo;
    data['cambio'] = this.cambio;
    data['tipopago'] = this.tipopago;
    data['tusuario'] = this.tusuario;
    data['tpc'] = this.tpc;
    data['referencia'] = this.referencia;
    data['estado'] = this.estado;
    return data;
  }
}