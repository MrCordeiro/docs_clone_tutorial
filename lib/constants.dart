import 'package:flutter_dotenv/flutter_dotenv.dart';


String host = "http://${dotenv.get('IP_ADDRESS', fallback: "0.0.0.0")}:3001";
