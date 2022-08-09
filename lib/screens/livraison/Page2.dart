import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lilicourse/Provider/ProviderAdress.dart';
import 'package:lilicourse/Provider/ProviderAdressLiv.dart';
import 'package:lilicourse/Provider/ProviderCommande.dart';
import 'package:lilicourse/main.dart';
import 'package:lilicourse/widgets/dataTable.dart';
import 'package:lilicourse/widgets/locationInput.dart';
import 'package:provider/provider.dart';
import '../../Animations/DelayedAnimation.dart';
import '../../Provider/ProviderAdressRam.dart';
import '../../models/adresse/Adresse/Adresse.dart';
import '../../widgets/appBar.dart';
import '../../widgets/containFirst.dart';
import 'PageMap.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  int currentStep = 0;
  Color? colorIn = Colors.transparent;
  Color? colorOut = Colors.transparent;
  double t1 = 10;
  double t2 = 10;
  double t3 = 10;
  double h1 = 15;
  double h2 = 9;
  double h3 = 12;

  int _value = 1;
  int _value2 = 1;
  int _value3 = 1;
  bool isCompleted = false;

  String? type;
  String taille = "Taille M";
  double? poids;
  String? planification;
  PlaceLocation? _pickedLocation;

  String? localisationrecepteur;
  final localisationR = TextEditingController();
  final namerecepteur = TextEditingController();
  final contactrecepteur = TextEditingController();
  final emailrecepteur = TextEditingController();
  final instructionrecepteur = TextEditingController();
  String? civiliterecepteur;

  String? localisationRamassage;
  final localisationE = TextEditingController();
  final nameemetteur = TextEditingController();
  final contactemetteur = TextEditingController();
  final emailemetteur = TextEditingController();
  final instructionemetteur = TextEditingController();
  String? civiliteemetteur;

  @override
  void initState() {
    super.initState();
  }

  void addAdresse() {}
  void addAdressLivraison() {}
  void addAdressRamassage() {}

  void addCommande() {}
  void _selectPlaceR(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    if (_pickedLocation!.latitude == null ||
        _pickedLocation!.longitude == null) {
    } else {
      print('ok');
      var bob = Provider.of<AdRProvider>(context, listen: false)
          .getPlaceAdress(_pickedLocation!.latitude, _pickedLocation!.longitude)
          .then((value) {
        setState(() {
          localisationE.text = value;
          localisationRamassage = value;
        });
        print(localisationRamassage);
      });
    }
  }

  void _selectPlaceL(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    if (_pickedLocation!.latitude == null ||
        _pickedLocation!.longitude == null) {
      print('Error');
    } else {
      print('ok');
      var bob = Provider.of<AdRProvider>(context, listen: false)
          .getPlaceAdress(_pickedLocation!.latitude, _pickedLocation!.longitude)
          .then((value) {
        setState(() {
          localisationR.text = value;
          localisationrecepteur = value;
        });
        print(localisationrecepteur);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CommProvider com = Provider.of<CommProvider>(context);
    AdProvider ad = Provider.of<AdProvider>(context);
    AdRProvider adR = Provider.of<AdRProvider>(context);
    AdLProvider adL = Provider.of<AdLProvider>(context);

    return Scaffold(
      appBar: buildAppBar(
        context,
        Text('Delivery Page', style: GoogleFonts.poppins(color: Colors.black)),
      ),
      body: isCompleted
          ? buildCompleted()
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
                                poids = 3;
                                t1 = 15;
                                t2 = 10;
                                t3 = 10;
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
                                      '0-3 KG',
                                      style: GoogleFonts.poppins(
                                          color: blue_button),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '+0 XAF',
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
                              setState(
                                () {
                                  poids = 7;
                                  t2 = 15;
                                  t1 = 10;
                                  t3 = 10;
                                  print('poids:$poids');
                                },
                              );
                            },
                            child: Card(
                              elevation: 4,
                              child: Container(
                                padding: EdgeInsets.all(t2),
                                child: Column(
                                  children: [
                                    Text(
                                      '4-7 KG',
                                      style: GoogleFonts.poppins(
                                          color: blue_button),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '+1000 XAF',
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
                              setState(
                                () {
                                  poids = 10;
                                  t3 = 15;
                                  t2 = 10;
                                  t1 = 10;

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
                                      '8-10 KG',
                                      style: GoogleFonts.poppins(
                                          color: blue_button),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '+3000 XAF',
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
                                      taille = "Taille M";
                                      print('taille:$taille');
                                    });
                                  },
                                ),
                                Text(
                                  'Taille M',
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
                                  'Taille S',
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
                            Text(
                              "Localisation",
                              style: GoogleFonts.poppins(fontSize: 14),
                              //textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      LocationInput(
                        controller: localisationE,
                        onselectPlace: _selectPlaceR,
                      ),
                      Text(
                        'Instruction',
                        style: GoogleFonts.poppins(),
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
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text(''),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                containFirst(
                    imagePath: 'assets/images/delivery/svg/delivery.svg',
                    text: 'Demander une livraison'),
                Card(
                  elevation: 8,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Deposit Details',
                          style: GoogleFonts.poppins(fontSize: 15),
                          textAlign: TextAlign.center,
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
                                border: InputBorder.none,
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
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(left: 8.0, top: 16.0),
                              ),
                              controller: emailrecepteur,
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
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(left: 8.0, top: 16.0),
                              ),
                              controller: contactrecepteur,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Civility',
                              style: GoogleFonts.poppins(fontSize: 14),
                              //textAlign: TextAlign.start,
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
                            Text(
                              "Localisation of receiver",
                              style: GoogleFonts.poppins(fontSize: 14),
                              //textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      LocationInput(
                        controller: localisationR,
                        onselectPlace: _selectPlaceL,
                      ),
                      Text(
                        'Instruction of receiver',
                        style: GoogleFonts.poppins(),
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
                    imagePath: 'assets/images/delivery/svg/delivery.svg',
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
                                    },
                                  );
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
                                    },
                                  );
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
                                    },
                                  );
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
                                    },
                                  );
                                },
                              ),
                              Text('30 min',
                                  style: GoogleFonts.poppins(fontSize: 15)),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 5,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _value = value as int;
                                    },
                                  );
                                },
                              ),
                              Text('Rien',
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
                    imagePath: 'assets/images/delivery/svg/delivery.svg',
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
                          style: GoogleFonts.poppins(fontSize: 15),
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
                                Text("$poids"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Type of package: "),
                                Text(
                                  type == null ? " " : type!,
                                ),
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
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ),
                      DataTableWidget(
                        name: nameemetteur.text,
                        email: emailemetteur.text,
                        contact: contactemetteur.text,
                        civility:
                            civiliteemetteur == null ? " " : civiliteemetteur!,
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
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ),
                      DataTableWidget(
                        name: namerecepteur.text,
                        email: emailrecepteur.text,
                        contact: contactrecepteur.text,
                        civility: civiliterecepteur == null
                            ? " "
                            : civiliterecepteur!,
                        localisation: localisationrecepteur == null
                            ? " "
                            : localisationrecepteur!,
                        instruction: instructionrecepteur.text,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                        child: Text('Recapitulatif'),
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
          state: currentStep > 6 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 6,
          title: const Text(''),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                containFirst(
                    imagePath: 'assets/images/delivery/svg/delivery.svg',
                    text: 'Demander une livraison'),
                Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Paiements ',
                          style: GoogleFonts.poppins(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              print('Orange Money');
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(h1),
                                  child: Card(
                                    elevation: 4,
                                    child: Image.asset(
                                      "assets/images/image2.png",
                                      height: 110,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    "Orange money",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: blue_button),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print('Mobile Money');
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(h2),
                                  child: Card(
                                    elevation: 4,
                                    child: Image.asset(
                                      "assets/images/image3.jpg",
                                      height: 110,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    "Mobile Money",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: blue_button),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            print('PayPal money');
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(h3),
                                child: Card(
                                  elevation: 4,
                                  child: Image.asset(
                                    "assets/images/image1.png",
                                    height: 110,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  "Paypal Money",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
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
                ),
              ],
            ),
          ),
        ),
      ];

  Widget buildCompleted() {
    return SingleChildScrollView(
      child: Column(
        children: [
          containFirst(
              imagePath: 'assets/images/delivery/svg/delivery.svg',
              text: 'Demander une livraison'),
          Card(
            elevation: 5,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Recapitulatif',
                    style: GoogleFonts.poppins(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: blue_button,
                        textStyle: GoogleFonts.poppins(fontSize: 18),
                      ),
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.poppins(),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const TimeWaiting();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              //Premiere animation de bas en haut
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var tween = Tween(begin: begin, end: end);
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        textStyle: GoogleFonts.poppins(fontSize: 18),
                      ),
                      child: const Text('Reset'),
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
          ),
        ],
      ),
    );
  }
}
