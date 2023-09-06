import 'package:apptei/src/widget/extends_files.dart';
import 'package:qr_widget/qr_widget.dart';
import 'package:apptei/src/services/escaner_model.dart';

class IngresoCampusPage extends StatefulWidget {
  IngresoCampusPage({Key? key}) : super(key: key);

  @override
  _IngresoCampusPageState createState() => _IngresoCampusPageState();
}

class _IngresoCampusPageState extends State<IngresoCampusPage> {
  late bool isLoading = true;
  late bool hasValidCode = false;
  late bool enmesa = false;
  late bool generaqr = false;
  String qrCodeData = "";
  String titulo = "Codigo de Ingreso";
  String lugarvotacion = "Sin Asignar";
  String rolmesa = "Sin Asignar";
  String lugarmesa = "Sin Asignar";
  String carrera = "Sin Asignar";
  String facultad = "Sin Asignar";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final queryParams = {
        'user': context.userId.toString(),
        'action': 'loadQrIngresoCampus'
      };
      final response = await BackendService.get(
          '${urlConsumo}/apimobile/v1/tei/ingresocampus/',
          params: queryParams);
      if (response['success'] == true) {
        setState(() {
          isLoading = false;
          hasValidCode = true;
          generaqr = response['generaqr'];
          enmesa = response['enmesa'];
          qrCodeData = response['qrCodeData'];
          titulo = response['periodo'];
          lugarvotacion = response['lugarvotacion'];
          rolmesa = response['rolmesa'];
          lugarmesa = response['lugarmesa'];
          carrera = response['carrera'];
          facultad = response['coordinacion'];
        });
      } else {
        setState(() {
          hasValidCode = false;
          isLoading = false;
          qrCodeData = response['msg'];
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        hasValidCode = false;
        qrCodeData = "${error}";
      });
    }
  }

  Widget buildQrCodeSection(
      bool generatesQr, String qrCodeData, String lugarvotacion) {
    if (generatesQr) {
      return Column(
        children: [
          SizedBox(height: 20),
          QrImageView(
            data: qrCodeData,
            version: QrVersions.auto,
            size: 200.0,
          ),
          SizedBox(height: 20),
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      boldText("Nombres", ColorResources.grey6B7, 11),
                      SizedBox(height: 10),
                      boldText("Apellidos", ColorResources.grey6B7, 11),
                      SizedBox(height: 10),
                      boldText("Lugar Votación", ColorResources.grey6B7, 11),
                      SizedBox(height: 10),
                      boldText("Facultad", ColorResources.grey6B7, 11),
                      SizedBox(height: 10),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 10),
                      boldText(
                          context.userFirstName, ColorResources.blue1D3, 11),
                      SizedBox(height: 10),
                      boldText(
                          context.userLastName, ColorResources.blue1D3, 11),
                      SizedBox(height: 10),
                      boldText(lugarvotacion, ColorResources.blue1D3, 11),
                      SizedBox(height: 10),
                      boldText(facultad, ColorResources.blue1D3, 11),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  boldText(carrera, ColorResources.blue1D3, 14),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      return Container(); // Widget vacío si no genera el código QR
    }
  }

  Widget buildEnMesaSection(bool isEnMesa, String rolmesa, String lugarmesa) {
    if (isEnMesa && !generaqr) {
      return Column(
        children: [
          SizedBox(height: 40),
          boldText(
            "Usted es miembro de la junta receptora \n ${lugarmesa}",
            ColorResources.redD90,
            18,
            TextAlign.center,
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      boldText("Nombres", ColorResources.grey6B7, 14),
                      SizedBox(height: 10),
                      boldText("Apellidos", ColorResources.grey6B7, 14),
                      SizedBox(height: 10),
                      boldText("Rol", ColorResources.grey6B7, 14),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 10),
                      boldText(
                          context.userFirstName, ColorResources.blue1D3, 14),
                      SizedBox(height: 10),
                      boldText(
                          context.userLastName, ColorResources.blue1D3, 14),
                      SizedBox(height: 10),
                      boldText(rolmesa, ColorResources.blue1D3, 14),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              EscanearQrModel(context.userId).scanQRCode(context);
            },
            child: Container(
              height: 40,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorResources.orange1D2,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                    color: ColorResources.white,
                  ),
                ],
                border: Border.all(
                  color: ColorResources.white,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_2_sharp,
                    color: ColorResources.white,
                    size: 40,
                  ),
                  SizedBox(width: 2),
                  mediumText(
                    "Tomar Asistencia",
                    ColorResources.white,
                    20,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      if (!generaqr) {
        return Column(children: [
          SizedBox(height: 20),
          Center(
            child: SvgPicture.asset(
              Images.NoInternetPage,
              height: 200,
              width: 300,
            ),
          ),
          SizedBox(height: 40),
          boldText(
            "Usted no es miembro de mesa receptora del voto, ni del personal de logistica",
            ColorResources.orange1D2,
            30,
            TextAlign.center,
          ),
        ]);
      } else {
        return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: boldText("Ingreso al Campus", ColorResources.orange1D2, 20),
      ),
      backgroundColor: ColorResources.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasValidCode
              ? Padding(
                  padding: EdgeInsets.only(top: 5, left: 30, right: 30),
                  child: Center(
                    child: Column(
                      children: [
                        boldText(
                          "${titulo}",
                          ColorResources.blue1D3,
                          14,
                          TextAlign.center,
                        ),
                        // Luego, en tu build:
                        Column(
                          children: [
                            buildQrCodeSection(
                                generaqr, qrCodeData, lugarvotacion),
                            buildEnMesaSection(enmesa, rolmesa, lugarmesa),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        regularText(
                          "Error: \n ${qrCodeData}",
                          ColorResources.redD90,
                          14,
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/menu');
                          },
                          child: Container(
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ColorResources.greyF1F.withOpacity(0.1),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                  color:
                                      ColorResources.black111.withOpacity(0.02),
                                ),
                              ],
                              border: Border.all(
                                color: ColorResources.black.withOpacity(0.06),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  Images.qrCode2,
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(width: 3),
                                mediumText(
                                  "Realizar nueva consulta",
                                  ColorResources.blue1D3,
                                  14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
