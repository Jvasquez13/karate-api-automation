function fn() {
  var config = {
    baseUrl: 'https://restful-booker.herokuapp.com',
    username: 'admin',
    password: 'password123'
  };

  // Request the auth token once per run and share it with every feature as authToken
  var auth = karate.callSingle('classpath:booker/auth/auth.feature', config);
  config.authToken = auth.token;

  return config;
}
