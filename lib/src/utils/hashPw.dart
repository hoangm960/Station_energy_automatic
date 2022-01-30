import 'package:crypt/crypt.dart';

String getEncrypt(String pw, String salt) => Crypt.sha256(pw,
        salt: salt)
    .toString();

