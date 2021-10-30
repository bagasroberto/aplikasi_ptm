import 'package:flutter/material.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Form",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
//Variable
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController selectDate = TextEditingController();
  TextEditingController jumlahDiskon = TextEditingController();
  TextEditingController grandTotal = TextEditingController();
  TextEditingController kembalian = TextEditingController();
  String nota = '';
  String nama = '';
  String jenis = 'Biasa';
  var jenisItems = ['Biasa', 'Pelanggan', 'Pelanggan Istimewa'];
  int jumlah = 0;
  double diskon = 0;
  int ppn = 0;
  int bayar = 0;
  int _kembalian = 0;
  bool _boxChecked = false;
  int selectedRadioLibur = 0;
  String libur = 'Tidak';
  int selectedRadioSaudara = 0;
  String saudara = 'Tidak';
  var jenisBarang = [];

  Map<String, bool> checkItems = {
    'ABC': false,
    'BBB': false,
    'XYZ': false,
    'WWW': false,
  };
  var tmpArray = [];
  String date = "";
  DateTime selectedDate = DateTime.now();

// Function
  void prosesInput() {
    FormState form = this.formKey.currentState!;
    ScaffoldState scaffold = this.scaffoldKey.currentState!;
    SnackBar message = SnackBar(
      content: Text('Proses validasi berhasil!'),
    );

    if (form.validate()) {
      scaffold.showSnackBar(message);
      checkItems.forEach((key, value) {
        if (value == true) {
          tmpArray.add(key);
        }
      });
      if (!_boxChecked) {
        // The checkbox wasn't checked
        Text("Tolong Masukkan Minimal 1 Hobby");
      } else {
        // Every of the data in the form are valid at this point
        form.save();
      }
      _kembalian = bayar - jumlah;
      this.kembalian.text = _kembalian.toString();
    }
  }

  void hitung() {
    checkItems.forEach((key, value) {
      if (value == true) {
        jenisBarang.add(key);
      }
    });

    diskon = jumlah * diskon;
    jumlah -= diskon.toInt();
    if (libur == 'Tidak') {
      jumlah -= 0;
    } else if (libur == 'Ya') {
      jumlah -= 2500;
    }
    if (saudara == 'Tidak') {
      jumlah += 3000;
    } else if (saudara == 'Ya') {
      jumlah -= 5000;
    }
    if (checkItems['ABC'] == true) {
      jumlah += 100;
    }
    if (checkItems['BBB'] == true) {
      jumlah -= 500;
    }
    if (checkItems['XYZ'] == true) {
      jumlah += 200;
    }
    if (checkItems['WWW'] == true) {
      jumlah -= 100;
    }

    jumlah += ((ppn / 100) * jumlah).toInt();
    this.grandTotal.text = jumlah.toString();
  }

  void _reset() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => Home(),
      ),
    );
  }

  radioLibur(int val) {
    setState(() {
      selectedRadioLibur = val;
    });
  }

  radioSaudara(int val) {
    setState(() {
      selectedRadioSaudara = val;
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1945),
      lastDate: DateTime(2077),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        this.selectDate.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Form Mahasiswa"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Container(
              margin: EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Nota'),
                        SizedBox(width: 50),
                        Container(
                            width: 250,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Masukkan Nomor Nota',
                                labelText: 'No Nota',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? value) {
                                nota = value!;
                              },
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Nomor nota tidak boleh kosong';
                                }
                              },
                            )),
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Nama'),
                        SizedBox(width: 35),
                        Container(
                          width: 250,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Masukkan Nama Pembeli',
                              labelText: 'Nama Pembeli',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String? value) {
                              nama = value!;
                            },
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Nama pembeli tidak boleh kosong';
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
//Dropdownbutton
                    Row(
                      children: <Widget>[
                        Text('Jenis'),
                        SizedBox(width: 20),
                        Container(
                          child: DropdownButton(
                            value: jenis,
                            icon: Icon(Icons.keyboard_arrow_down),
                            items: jenisItems.map((String items) {
                              return DropdownMenuItem(
                                  value: items, child: Text(items));
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                jenis = newValue!;
                              });
                              if (jenis == 'Biasa') {
                                diskon = 0;
                              } else if (jenis == 'Pelanggan') {
                                diskon = 0.02;
                              } else if (jenis == 'Pelanggan Istimewa') {
                                diskon = 0.04;
                              }
                            },
                          ),
                        )
                      ],
                    ),

//DatePicker
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Tanggal Beli'),
                        SizedBox(width: 25),
                        Container(
                          width: 250,
                          child: TextFormField(
                            controller: selectDate,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Tanggal Beli',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Mohon pilih tanggal beli barang !';
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    RaisedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text("Choose Date"),
                    ),

                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Jumlah'),
                        SizedBox(width: 30),
                        Container(
                          width: 250,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Masukkan Jumlah Pembelian',
                              labelText: 'Jumlah Pembelian',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String? value) {
                              jumlah = int.parse(value!);
                              this.jumlahDiskon.text =
                                  ((diskon * jumlah)).toString();
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Jumlah Pembelian tidak boleh kosong';
                              }
                            },
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Diskon'),
                        SizedBox(width: 30),
                        Container(
                          width: 250,
                          child: TextFormField(
                            controller: jumlahDiskon,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Jumlah Diskon',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),

//Radiocheckbutton
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Hari Libur'),
                        SizedBox(width: 30),
                        Container(
                          width: 250,
                          child: Wrap(
                            children: <Widget>[
                              RadioListTile<int>(
                                  title: Text('Tidak'),
                                  value: 0,
                                  groupValue: selectedRadioLibur,
                                  onChanged: (val) {
                                    radioLibur(val!);
                                    libur = 'Tidak';
                                  }),
                              RadioListTile<int>(
                                  title: Text('Ya'),
                                  value: 1,
                                  groupValue: selectedRadioLibur,
                                  onChanged: (val) {
                                    radioLibur(val!);
                                    libur = 'Ya';
                                  })
                            ],
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Saudara'),
                        SizedBox(width: 30),
                        Container(
                          width: 250,
                          child: Wrap(
                            children: <Widget>[
                              RadioListTile<int>(
                                  title: Text('Tidak'),
                                  value: 0,
                                  groupValue: selectedRadioSaudara,
                                  onChanged: (val) {
                                    radioSaudara(val!);
                                    saudara = 'Tidak';
                                  }),
                              RadioListTile<int>(
                                  title: Text('Ya'),
                                  value: 1,
                                  groupValue: selectedRadioSaudara,
                                  onChanged: (val) {
                                    radioSaudara(val!);
                                    saudara = 'Ya';
                                  })
                            ],
                          ),
                        )
                      ],
                    ),

//Checkboxbutton
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Jenis Barang'),
                        SizedBox(width: 25),
                        Container(
                          width: 250,
                          child: Wrap(
                            children: checkItems.keys.map((String key) {
                              return new CheckboxListTile(
                                title: new Text(key),
                                value: checkItems[key],
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                                onChanged: (bool? value) {
                                  setState(() {
                                    checkItems[key] = value!;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('PPN'),
                        SizedBox(width: 43),
                        Container(
                          width: 250,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Masukkan PPN',
                              labelText: 'PPN',
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (value) {
                              ppn = int.parse(value);
                              hitung();
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'PPN tidak boleh kosong';
                              }
                            },
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Grand Total'),
                        SizedBox(width: 43),
                        Container(
                          width: 250,
                          child: TextFormField(
                            readOnly: true,
                            controller: grandTotal,
                            decoration: InputDecoration(
                              labelText: 'Total',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Dibayar'),
                        SizedBox(width: 43),
                        Container(
                          width: 250,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Masukkan Jumlah Bayar',
                              labelText: 'Jumlah Bayar',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              bayar = int.parse(value);
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Jumlah Bayar tidak boleh kosong';
                              }
                            },
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Text('Kembali'),
                        SizedBox(width: 43),
                        Container(
                          width: 250,
                          child: TextFormField(
                            readOnly: true,
                            controller: kembalian,
                            decoration: InputDecoration(
                              labelText: 'Kembali',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),

//Image
                    SizedBox(height: 8),
                    Image.asset(
                      'gambar/untag_template.png',
                      width: 200,
                    ),
                    SizedBox(height: 8),
// buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            child: Text('Proses'),
                            onPressed: () {
                              setState(() {
                                prosesInput();
                              });
                            }),
                        SizedBox(width: 20),
                        RaisedButton(
                          child: Text('Reset'),
                          onPressed: () {
                            _reset();
                            tmpArray.clear();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))));
  }
}
