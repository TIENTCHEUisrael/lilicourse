import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lilicourse/Provider/ProviderAdress.dart';
import 'package:lilicourse/Provider/ProviderAdressLiv.dart';
import 'package:lilicourse/Provider/ProviderCommande.dart';
import 'package:lilicourse/main.dart';
import 'package:lilicourse/models/adresse/Adresse/AdressApi.dart';
import 'package:lilicourse/models/adresse/AdresseLivraison/AdressLivApi.dart';
import 'package:lilicourse/models/adresse/AdresseLivraison/AdresseLivraison.dart';
import 'package:lilicourse/models/adresse/AdresseRamassage/AdressRamApi.dart';
import 'package:lilicourse/models/adresse/AdresseRamassage/AdresseRamassage.dart';
import 'package:lilicourse/models/commande/commandeApi.dart';
import 'package:lilicourse/widgets/dataTable.dart';
import 'package:lilicourse/widgets/locationInput.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Animations/DelayedAnimation.dart';
import '../../Provider/ProviderAdressRam.dart';
import '../../Provider/providerUser.dart';
import '../../models/adresse/Adresse/Adresse.dart';
import '../../models/commande/commande.dart';
import '../../models/user/user.dart';
import '../../widgets/appBar.dart';
import '../../widgets/bas.dart';
import '../../widgets/containFirst.dart';
import 'PaiementPage.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  PlaceLocation? start;
  PlaceLocation? destination;
  List<AdressRam>? _adressRam;
  List<AdressLiv>? _adressLiv;
  List<Adresse>? _adress;
  List<Commande>? _commande;
  bool _isloading = true;
  bool isLoading = false;
  AdressLiv? adressLiv;
  AdressRam? adressRam;
  Adresse? adresse;
  Commande? commande;
  int currentStep = 0;
  Color? colorIn = Colors.transparent;
  Color? colorOut = Colors.transparent;
  double t1 = 10;
  double t2 = 10;
  double t3 = 10;
  double t4 = 10;
  double h1 = 15;
  double h2 = 9;
  double h3 = 12;

  int _value = 1;
  int _value2 = 1;
  int _value3 = 1;
  bool isCompleted = false;

  String type = "Colis";
  String taille = "Taille XS";
  String poids = "2";
  String planification = "Rien";
  PlaceLocation? _pickedLocation;

  String? localisationrecepteur;
  final localisationR = TextEditingController();
  final namerecepteur = TextEditingController();
  final contactrecepteur = TextEditingController();
  final emailrecepteur = TextEditingController();
  final instructionrecepteur = TextEditingController();
  String civiliterecepteur = "Feminin";

  String? localisationRamassage;
  final localisationE = TextEditingController();
  final nameemetteur = TextEditingController();
  final contactemetteur = TextEditingController();
  final emailemetteur = TextEditingController();
  final instructionemetteur = TextEditingController();
  String civiliteemetteur = "Feminin";

  @override
  void initState() {
    super.initState();
  }

  Future<void> getAdressRam() async {
    _adressRam = await AdressRamApi.getAdressRam();
    setState(() {
      _isloading = false;
    });
  }

  Future<void> getAdressLiv() async {
    _adressLiv = await AdressLivApi.getAdressLiv();
    setState(() {
      _isloading = false;
    });
  }

  Future<void> getAdress() async {
    _adress = await AdressApi.getAdress();
    setState(() {
      _isloading = false;
    });
  }

  Future<void> getCommande() async {
    _commande = await CommandeApi.getcommandes();
    setState(() {
      _isloading = false;
    });
  }

  AdressRam addAdressRamassage(BuildContext ctx) {
    var adR = AdressRam(
      localisationRam: localisationRamassage!,
      nameEmetteur: nameemetteur.text,
      contactEmetteur: int.parse(contactemetteur.text),
      emailEmetteur: emailemetteur.text,
      civiliteEmetteur: civiliteemetteur,
      instruction: instructionemetteur.text,
      updatedAt: DateTime.now().toString(),
    );
    var proAdl = Provider.of<AdRProvider>(ctx, listen: false);
    proAdl.createAdressRam(adR).then((value) {
      if (value!['statut'] == true) {
        setState(
          () {
            adressRam = value['adresseRam'];
          },
        );
        print('OK2');
        print(adressRam);
        Provider.of<AdRProvider>(context, listen: false)
            .setAdressRam(adressRam!);
        print('..................................................');
        Fluttertoast.showToast(
          msg: "Message:${value['message']}",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Error:${value['message']}",
        );
      }
    });
    return adressRam!;
  }

  AdressLiv addAdressLivraison(BuildContext ctx) {
    var adL = AdressLiv(
        localisationLiv: localisationrecepteur!,
        nameRecepteur: namerecepteur.text,
        contactRecepteur: int.parse(contactrecepteur.text),
        emailRecepteur: emailrecepteur.text,
        civiliteRecepteur: civiliterecepteur,
        instruction: instructionrecepteur.text,
        updatedAt: DateTime.now().toString());
    var proAdl = Provider.of<AdLProvider>(ctx, listen: false);
    proAdl.createAdresseLiv(adL).then((value) {
      if (value!['statut'] == true) {
        setState(
          () {
            adressLiv = value['adressLiv'];
          },
        );
        print('OK');
        print(adressLiv);
        /*Provider.of<AdLProvider>(context, listen: false)
            .setAdressLiv(adressLiv!);*/
        Fluttertoast.showToast(
          msg: "Message:${value['message']}",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Error:${value['message']}",
        );
      }
    });
    return adressLiv!;
  }

  Adresse addAdress(BuildContext ctx) {
    print('Bonjour');
    print(adressLiv);
    var ad = Adresse(
        adresslivid: adressLiv!.adressLivId!,
        adressramid: adressRam!.adressRamId!,
        poids: poids,
        taille: taille,
        type: type,
        planification: planification,
        updatedAt: DateTime.now().toString());
    var proAdl = Provider.of<AdProvider>(ctx, listen: false);
    proAdl.createAdresse(ad).then((value) {
      if (value!['statut'] == true) {
        setState(
          () {
            adresse = value['adresse'];
          },
        );
        Provider.of<AdProvider>(context, listen: false).setAdress(adresse!);
        print('....................................................');
        print('succesfully$adresse.................................');
        Fluttertoast.showToast(
          msg: "Message:${value['message']}",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Error:${value['message']}",
        );
      }
    });
    return adresse!;
  }

  Commande addCommande(BuildContext ctx) {
    var auth = Provider.of<AuthProvider>(ctx, listen: false);
    var ad = Provider.of<AdProvider>(ctx, listen: false);
    var us = auth.user;
    var adre = ad.adresse;
    var com = Commande(
        client_id: us.id!,
        adresse_id: adre.adressId!,
        statut: "false",
        updated_at: DateTime.now().toString());
    setState(
      () {
        commande = com;
        isLoading = false;
      },
    );
    var proAdl = Provider.of<CommProvider>(ctx);
    proAdl.createACommande(commande!).then((value) {
      if (value['statut'] == true) {
        setState(
          () {
            commande = value['commande'];
          },
        );
        Provider.of<CommProvider>(context, listen: false)
            .setCommande(commande!);
        print('succesfully$commande..........................................');
        Fluttertoast.showToast(
          msg: "Message:${value['message']}",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Error:${value['message']}",
        );
      }
    });
    return commande!;
  }

  void _selectPlaceR(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    if (_pickedLocation!.latitude == null ||
        _pickedLocation!.longitude == null) {
    } else {
      var bob = Provider.of<AdRProvider>(context, listen: false)
          .getPlaceAdress(_pickedLocation!.latitude, _pickedLocation!.longitude)
          .then(
        (value) {
          setState(() {
            start = _pickedLocation;
            localisationE.text = value;
            localisationRamassage = value;
          });
          print(localisationRamassage);
        },
      );
    }
  }

  void _selectPlaceL(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    if (_pickedLocation!.latitude == null ||
        _pickedLocation!.longitude == null) {
      print('Error');
    } else {
      var bob = Provider.of<AdRProvider>(context, listen: false)
          .getPlaceAdress(_pickedLocation!.latitude, _pickedLocation!.longitude)
          .then(
        (value) {
          setState(() {
            destination = _pickedLocation;
            localisationR.text = value;
            localisationrecepteur = value;
          });
          print(localisationrecepteur);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        Text('Delivery Page', style: GoogleFonts.poppins(color: Colors.black)),
      ),
      body: isCompleted
          ? buildCompleted(context)
          : Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: Colors.blue),
              ),
              child: Stepper(
                type: StepperType.horizontal,
                steps: getSteps(),
                currentStep: currentStep,
                //lorsque on reparr en avant d'un step
                onStepContinue: () {
                  final isLastStep = currentStep == getSteps().length - 1;
                  if (isLastStep) {
                    setState(() {
                      isCompleted = true;
                    });
                    print('completed');
                  } else {
                    setState(() {
                      currentStep += 1;
                    });
                  }
                },
                //lorsque on revient en arriere d'un step
                onStepCancel: currentStep == 0
                    ? null
                    : () {
                        setState(() {
                          currentStep -= 1;
                        });
                      },
                //Au clic sur un step
                onStepTapped: (step) {
                  setState(() {
                    currentStep =
                        step; //Pour permettre de defiler en cliquand tu l'un des step
                  });
                },
                controlsBuilder: (context, ControlsDetails details) {
                  final isLastStep = currentStep == getSteps().length - 1;
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: DelayedAnimation(
                            delay: 150,
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: Text(
                                'Next',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        if (currentStep != 0)
                          Expanded(
                            child: DelayedAnimation(
                              delay: 200,
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                //Customiser nos bouton
              ),
            ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text(''),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                containFirst(
                    imagePath: 'assets/images/delivery/svg/request.svg',
                    text: 'Demander une livraison'),
                Card(
                  elevation: 8,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Que souhaitez vous envoyer ou recevoir ?',
                          style: GoogleFonts.poppins(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.elasticInOut,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  type = "Colis";
                                  colorIn = Colors.blueGrey;
                                  colorOut = Colors.transparent;
                                });
                                print(type);
                              },
                              child: Column(
                                children: [
                                  const Card(
                                    //color: Colors.grey,
                                    elevation: 4,
                                    child: Icon(
                                      Icons.collections,
                                      size: 90,
                                      color: blue_button,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        border: Border.all(color: colorIn!)),
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                      'Colis',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: blue_button),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.elasticInOut,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  type = "Courriel";
                                  colorIn = Colors.transparent;
                                  colorOut = Colors.blueGrey;
                                });
                                print(type);
                              },
                              child: Column(
                                children: [
                                  const Card(
                                    elevation: 4,
                                    child: Icon(
                                      Icons.contact_mail,
                                      size: 90,
                                      color: blue_button,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        border: Border.all(color: colorOut!)),
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                      'Courrier',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: blue_button),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text(''),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                containFirst(
                    imagePath: 'assets/images/delivery/svg/info.svg',
                    text: 'Demander une livraison'),
                Card(
                  elevation: 8,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Caracteristique de votre Colis',
                          style: GoogleFonts.poppins(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                poids = "2";
                                t1 = 10;
                                t2 = 10;
                                t3 = 10;
                                t4 = 15;
                                print('poids:$poids');
                              });
                            },
                            child: Card(
                              elevation: 4,
                              child: Container(
                                padding: EdgeInsets.all(t4),
                                child: Column(
                                  children: [
                                    Text(
                                      '<3 KG',
                                      style: GoogleFonts.poppins(
                                          color: blue_button),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '+500 XAF',
                                      style: GoogleFonts.poppins(
                                          color: blue_button),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                poids = "3";
                                t1 = 15;
                                t2 = 10;
                                t3 = 10;
                                t4 = 10;
                                print('poids:$poids');
                              });
                            },
                            child: Card(
                              elevation: 4,
                              child: Container(
                                padding: EdgeInsets.all(t1),
                                child: Column(
                                  children: [
                                    Text(
                                      '3-10 KG',
                                      style: GoogleFonts.poppins(
                                          color: blue_button),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '+1500 XAF',
                                      style: GoogleFonts.poppins(
                                          color: blue_button),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                poids = "11";
                                t1 = 10;
                                t2 = 15;
                                t3 = 10;
                                t4 = 10;
                                print('poids:$poids');
                              });
                            },
                            child: Card(
                              elevation: 4,
                              child: Container(
                                padding: EdgeInsets.all(t2),
                                child: Column(
                                  children: [
                                    Text(
                                      '11-20 KG',
                                      style: GoogleFonts.poppins(
                                          color: blue_button),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '+3000',
                                      style: GoogleFonts.poppins(
                                          color: blue_button),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            setState(
                              () {
                                poids = "21";
                                t3 = 15;
                                t2 = 10;
                                t1 = 10;
                                t4 = 10;
                                print('poids:$poids');
                              },
                            );
                          },
                          child: Card(
                            elevation: 4,
                            child: Container(
                              padding: EdgeInsets.all(t3),
                              child: Column(
                                children: [
                                  Text(
                                    '>21KG',
                                    style:
                                        GoogleFonts.poppins(color: blue_button),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '+5000 XAF',
                                    style:
                                        GoogleFonts.poppins(color: blue_button),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: _value3,
                                  onChanged: (value) {
                                    setState(() {
                                      _value3 = value as int;
                                      taille = "Taille XS";
                                      print('taille:$taille');
                                    });
                                  },
                                ),
                                Text(
                                  'Taille XS (L:200 l:140 H:50)',
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 2,
                                  groupValue: _value3,
                                  onChanged: (value) {
                                    setState(() {
                                      _value3 = value as int;
                                      taille = "Taille S";
                                      print('taille:$taille');
                                    });
                                  },
                                ),
                                Text(
                                  'Taille S (L:310 l:210 H:80)',
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text(''),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                containFirst(
                    imagePath: 'assets/images/delivery/svg/pickup.svg',
                    text: 'Pickup Details'),
                Card(
                  elevation: 8,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            const Icon(Icons.info,
                                size: 25, color: blue_button),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Information transmitter',
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                icon: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  width: 10,
                                  height: 10,
                                  child: const Icon(
                                    Icons.info,
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Name of sender",
                                //border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(left: 8.0, top: 16.0),
                              ),
                              controller: nameemetteur,
                              style: const TextStyle(fontSize: 12),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                icon: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  width: 10,
                                  height: 10,
                                  child: const Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email of sender",
                                //border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(left: 8.0, top: 16.0),
                              ),
                              controller: emailemetteur,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(fontSize: 12),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                icon: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  width: 10,
                                  height: 10,
                                  child: const Icon(
                                    Icons.phone,
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Contact of sender",
                                contentPadding:
                                    const EdgeInsets.only(left: 8.0, top: 16.0),
                              ),
                              controller: contactemetteur,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 3,
                                ),
                                const Icon(Icons.info,
                                    size: 25, color: blue_button),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Civility transmitter',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15, color: Colors.blue),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: _value3,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _value3 = value as int;
                                        civiliteemetteur = "Masculin";
                                      },
                                    );
                                    print(civiliteemetteur);
                                  },
                                ),
                                Text(
                                  'Masculin',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Radio(
                                  value: 2,
                                  groupValue: _value3,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _value3 = value as int;
                                        civiliteemetteur = "Feminin";
                                      },
                                    );
                                    print(civiliteemetteur);
                                  },
                                ),
                                Text(
                                  'Feminin',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.maps_home_work,
                                    size: 25, color: blue_button),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Localisation",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, color: Colors.blue)
                                    //textAlign: TextAlign.start,
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      LocationInput(
                        controller: localisationE,
                        onselectPlace: _selectPlaceR,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(Icons.comment,
                              size: 25, color: blue_button),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("Instruction",
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.blue)
                              //textAlign: TextAlign.start,
                              ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, bottom: 10),
                        child: TextField(
                          controller: instructionemetteur,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText:
                                  'Your instruction fo the delivery man about the transmitter of the course'),
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text(''),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                containFirst(
                    imagePath: 'assets/images/delivery/svg/deposit.svg',
                    text: 'Deposit Details'),
                Card(
                  elevation: 8,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            const Icon(Icons.info,
                                size: 25, color: blue_button),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Instruction receiver",
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                icon: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  width: 10,
                                  height: 10,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Name of receiver",
                                //border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(left: 8.0, top: 16.0),
                              ),
                              controller: namerecepteur,
                              style: const TextStyle(fontSize: 12),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                icon: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  width: 10,
                                  height: 10,
                                  child: const Icon(
                                    Icons.mail,
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email of receiver",

                                //border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(left: 8.0, top: 16.0),
                              ),
                              controller: emailrecepteur,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(fontSize: 12),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                icon: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  width: 10,
                                  height: 10,
                                  child: const Icon(
                                    Icons.phone_android,
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Contact of receiver",
                                //border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(left: 8.0, top: 16.0),
                              ),
                              controller: contactrecepteur,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                const Icon(Icons.note,
                                    size: 25, color: blue_button),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Civility",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, color: Colors.blue)
                                    //textAlign: TextAlign.start,
                                    ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: _value3,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _value3 = value as int;
                                        civiliterecepteur = "Masculin";
                                      },
                                    );
                                    print(civiliterecepteur);
                                  },
                                ),
                                Text(
                                  'Masculin',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Radio(
                                  value: 2,
                                  groupValue: _value3,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _value3 = value as int;
                                        civiliterecepteur = "Feminin";
                                      },
                                    );
                                    print(civiliterecepteur);
                                  },
                                ),
                                Text(
                                  'Feminin',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                const Icon(Icons.info,
                                    size: 25, color: blue_button),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Localisation of receiver",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, color: Colors.blue)
                                    //textAlign: TextAlign.start,
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      LocationInput(
                        controller: localisationR,
                        onselectPlace: _selectPlaceL,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          const Icon(Icons.comment,
                              size: 25, color: blue_button),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("Instruction",
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.blue)
                              //textAlign: TextAlign.start,
                              ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, bottom: 10),
                        child: TextField(
                          controller: instructionrecepteur,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText:
                                  'Give the instruction about the receiver of your course'),
                          style: GoogleFonts.poppins(fontSize: 12),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 4,
          title: const Text(''),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                containFirst(
                    imagePath: 'assets/images/delivery/svg/w.svg',
                    text: 'Demander une livraison'),
                Card(
                  elevation: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Delivery planning',
                          style: GoogleFonts.poppins(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _value = value as int;
                                      planification = "Aussitot que possiibe";
                                    },
                                  );
                                  print(planification);
                                },
                              ),
                              Text('Aussitot que possible',
                                  style: GoogleFonts.poppins(fontSize: 15)),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _value = value as int;
                                      planification = "Dans 1 heure";
                                    },
                                  );
                                  print(planification);
                                },
                              ),
                              Text('1h:00',
                                  style: GoogleFonts.poppins(fontSize: 15)),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _value = value as int;
                                      planification = "Dans 2 heures";
                                    },
                                  );
                                  print(planification);
                                },
                              ),
                              Text('2h:00',
                                  style: GoogleFonts.poppins(fontSize: 15)),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 4,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _value = value as int;
                                      planification = "Dans 30 minutes";
                                    },
                                  );
                                  print(planification);
                                },
                              ),
                              Text('30 min',
                                  style: GoogleFonts.poppins(fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Give as much time as you want',
                          style: GoogleFonts.poppins(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: Text(
                          'This will be taken into account in the fees',
                          style: GoogleFonts.poppins(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 5 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 5,
          title: const Text(''),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                containFirst(
                    imagePath: 'assets/images/delivery/svg/information.svg',
                    text: 'Demander une livraison'),
                Card(
                  elevation: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Summary',
                          style: GoogleFonts.poppins(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          "Delivery information",
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.blue),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 5, right: 5, top: 8, bottom: 5),
                        padding: const EdgeInsets.only(
                            left: 3, right: 3, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Package size: "),
                                Text(taille),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Package weight: "),
                                Text(poids == null ? " " : poids.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Type of package: "),
                                Text(
                                  type == null ? " " : type.toString(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Planification: "),
                                Text(planification == null
                                    ? " "
                                    : planification.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          "Pickup information: ",
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.blue),
                        ),
                      ),
                      DataTableWidget(
                        name: nameemetteur.text,
                        email: emailemetteur.text,
                        contact: contactemetteur.text,
                        civility:
                            civiliteemetteur == null ? " " : civiliteemetteur,
                        localisation: localisationRamassage == null
                            ? " "
                            : localisationRamassage!,
                        instruction: instructionemetteur.text,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          "Deposit information",
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.blue),
                        ),
                      ),
                      DataTableWidget(
                        name: namerecepteur.text,
                        email: emailrecepteur.text,
                        contact: contactrecepteur.text,
                        civility:
                            civiliterecepteur == null ? " " : civiliterecepteur,
                        localisation: localisationrecepteur == null
                            ? " "
                            : localisationrecepteur!,
                        instruction: instructionrecepteur.text,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                        child:
                            Text('**************Recapitulatif****************'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ];

  Widget buildCompleted(BuildContext ctx) {
    AuthProvider auth = Provider.of<AuthProvider>(ctx);
    AdLProvider auth1 = Provider.of<AdLProvider>(ctx);
    AdProvider auth2 = Provider.of<AdProvider>(ctx);
    AdRProvider auth3 = Provider.of<AdRProvider>(ctx);
    CommProvider auth4 = Provider.of<CommProvider>(ctx);
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Center(
                  child: Lottie.asset(
                      'assets/images/delivery/lotties/regis.json',
                      fit: BoxFit.cover)),
            ],
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Do you want to save your request?',
                  style: GoogleFonts.poppins(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(5),
                      primary: blue_button,
                      textStyle: GoogleFonts.poppins(fontSize: 18),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                    onPressed: () {
                      if (localisationE.text.isEmpty ||
                          nameemetteur.text.isEmpty ||
                          contactemetteur.text.isEmpty ||
                          emailemetteur.text.isEmpty ||
                          civiliteemetteur.isEmpty ||
                          instructionemetteur.text.isEmpty ||
                          localisationR.text.isEmpty ||
                          namerecepteur.text.isEmpty ||
                          emailrecepteur.text.isEmpty ||
                          contactrecepteur.text.isEmpty ||
                          civiliterecepteur.isEmpty ||
                          instructionrecepteur.text.isEmpty ||
                          poids == null ||
                          taille.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Error:['One Value is null']}",
                        );
                      } else if (start == null || destination == null) {
                        Fluttertoast.showToast(
                          msg:
                              "Error:['Start Location or Destination location is null']}",
                        );
                      } else {
                        setState(
                          () {
                            isLoading = true;
                          },
                        );
                        print("");
                        print(
                            '..................STARTING.....................');
                        print("");
                        var adressRamassage = AdressRam(
                          localisationRam: localisationE.text,
                          nameEmetteur: nameemetteur.text,
                          contactEmetteur: int.parse(contactemetteur.text),
                          emailEmetteur: emailemetteur.text,
                          civiliteEmetteur: civiliteemetteur,
                          instruction: instructionemetteur.text,
                          updatedAt: DateTime.now().toString(),
                        );
                        auth3.createAdressRam(adressRamassage).then(
                          (respo) {
                            if (respo!['statut']) {
                              AdressRam adR = respo['adressRam'];
                              print(adR);
                              Provider.of<AdRProvider>(context, listen: false)
                                  .setAdressRam(adR);

                              var adressLivraison = AdressLiv(
                                localisationLiv: localisationR.text,
                                nameRecepteur: namerecepteur.text,
                                contactRecepteur:
                                    int.parse(contactrecepteur.text),
                                emailRecepteur: emailrecepteur.text,
                                civiliteRecepteur: civiliterecepteur,
                                instruction: instructionrecepteur.text,
                                updatedAt: DateTime.now().toString(),
                              );
                              print("");
                              print(
                                  '..........................FINISH ADRESSE RAMASSAGE.................');
                              print("");
                              auth1.createAdresseLiv(adressLivraison).then(
                                (value) {
                                  if (value!['statut']) {
                                    AdressLiv adL = value['adressLiv'];
                                    print(adL);
                                    Provider.of<AdLProvider>(context,
                                            listen: false)
                                        .setAdressLiv(adL);
                                    var adress = Adresse(
                                      adresslivid: adL.adressLivId!,
                                      adressramid: adR.adressRamId!,
                                      poids: poids,
                                      taille: taille,
                                      type: type,
                                      planification: planification,
                                      updatedAt: DateTime.now().toString(),
                                    );
                                    print("");
                                    print(
                                        '......................FINISH ADRESSE LIVRAISON......................');
                                    print("");
                                    auth2.createAdresse(adress).then(
                                      (other) {
                                        if (other!['statut'] == true) {
                                          Adresse ad = other['adress'];
                                          print(ad);
                                          Provider.of<AdProvider>(context,
                                                  listen: false)
                                              .setAdress(ad);
                                          print("");
                                          print(
                                              '.............................FINISH ADRESSE........................');
                                          print("");
                                          User us = auth.user;
                                          print(us);
                                          var commande = Commande(
                                            client_id: us.id!,
                                            adresse_id: ad.adressId!,
                                            statut: "true",
                                            updated_at:
                                                DateTime.now().toString(),
                                          );

                                          auth4.createACommande(commande).then(
                                            (or) {
                                              if (or['statut']) {
                                                Commande co = or['commande'];
                                                print(co);
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Message: Commande,Adresse, AdressLiv and AdressRam are Added",
                                                );
                                                Provider.of<CommProvider>(
                                                        context,
                                                        listen: false)
                                                    .setCommande(co);
                                                print(
                                                    '....................FINISH COMMANDE.....................');
                                                print("");
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                print("");
                                                print(
                                                    "...................................FINISH............................");
                                                print("");

                                                Navigator.pushReplacement(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return PaiementPage(
                                                        st: start!,
                                                        de: destination!,
                                                        us: us,
                                                        ad: ad,
                                                        adL: adL,
                                                        adR: adR,
                                                        com: co,
                                                      );
                                                    },
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      //Premiere animation de bas en haut
                                                      var begin = const Offset(
                                                          1.0, 0.0);
                                                      var end = Offset.zero;
                                                      var tween = Tween(
                                                          begin: begin,
                                                          end: end);
                                                      return SlideTransition(
                                                        position: animation
                                                            .drive(tween),
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: "Error:${or['message']}",
                                                );
                                              }
                                            },
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Error:${other['message']}",
                                          );
                                        }
                                      },
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Error:${value['message']}",
                                    );
                                  }
                                },
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "Error:${respo['message']}",
                              );
                            }
                            Fluttertoast.showToast(
                              msg: "Message:${respo['message']}",
                            );
                          },
                        );
                      }
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: GoogleFonts.poppins(fontSize: 18),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: red_button),
                    ),
                    onPressed: () => setState(() {
                      isCompleted = false;
                      currentStep = 0;
                      /*email.clear();
                      numero.clear();*/
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 150),
          bas(),
        ],
      ),
    );
  }
}
