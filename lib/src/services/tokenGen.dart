import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final secretRef = FirebaseFirestore.instance.collection("secretKey");

generateToken(String userID) {
  // var secret = readSecretFirestore();
  var builder = new JWTBuilder();
  var token = builder
    ..expiresAt = new DateTime.now().add(new Duration(days: 1))
    ..setClaim('data', {'userId': userID})
    ..getToken(); // returns token without signature

  var signer =
      new JWTHmacSha256Signer("secret"); // has to get secret from somewhere
  var signedToken = builder.getSignedToken(signer);
  print(signedToken); // prints encoded JWT
  var stringToken = signedToken.toString();

  return stringToken;
}
