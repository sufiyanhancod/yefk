// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

abstract class IEnvironment {
  const IEnvironment();
  String get SERVER_URL;
  String get ANON_KEY;
  Duration get CONNECT_TIMEOUT;
  Duration get RECEIVE_TIMEOUT;
}

class ProductionEnv extends IEnvironment {
  const ProductionEnv();
  @override
  String get SERVER_URL => 'https://ngmqewfobapfktlshmkv.supabase.co';
  @override
  String get ANON_KEY => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5nbXFld2ZvYmFwZmt0bHNobWt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0NTQ4NDEsImV4cCI6MjA1ODAzMDg0MX0.3e1ros7lZEUHfhrebL-Xvs-N5AbPK8EIqzxJbSEIYnU';
  @override
  Duration get CONNECT_TIMEOUT => const Duration(seconds: 5000);
  @override
  Duration get RECEIVE_TIMEOUT => const Duration(seconds: 3000);
}

class StagingEnv extends IEnvironment {
  const StagingEnv();
  @override
  String get SERVER_URL => 'https://ngmqewfobapfktlshmkv.supabase.co';
  @override
  String get ANON_KEY => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5nbXFld2ZvYmFwZmt0bHNobWt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0NTQ4NDEsImV4cCI6MjA1ODAzMDg0MX0.3e1ros7lZEUHfhrebL-Xvs-N5AbPK8EIqzxJbSEIYnU';
  @override
  Duration get CONNECT_TIMEOUT => const Duration(seconds: 5000);
  @override
  Duration get RECEIVE_TIMEOUT => const Duration(seconds: 3000);
}

class DevelopmentEnv extends IEnvironment {
  const DevelopmentEnv();
  @override
  String get SERVER_URL => 'https://ngmqewfobapfktlshmkv.supabase.co';
  @override
  String get ANON_KEY => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5nbXFld2ZvYmFwZmt0bHNobWt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0NTQ4NDEsImV4cCI6MjA1ODAzMDg0MX0.3e1ros7lZEUHfhrebL-Xvs-N5AbPK8EIqzxJbSEIYnU';
  @override
  Duration get CONNECT_TIMEOUT => const Duration(seconds: 5000);
  @override
  Duration get RECEIVE_TIMEOUT => const Duration(seconds: 3000);
}
