export default function(server) {

  /*
    Seed your development database using your factories.
    This data will not be loaded in your tests.
  */

  server.createList('app', 10);
  server.create('host-app', {
    name: 'hotdoc_rails_backend'
  });
}
