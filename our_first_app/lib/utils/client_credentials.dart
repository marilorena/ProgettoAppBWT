// singleton for the client credentials
class Credentials {
  final String id;
  final String secret;

  Credentials._constructor(this.id, this.secret); // private constructor

  factory Credentials.getCredentials(){
    return Credentials._constructor('238BR6', '447a1a825a0ff1846b3b3f35024dd7d4');
  }
}