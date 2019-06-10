export default function(server) {

  /*
    Seed your development database using your factories.
    This data will not be loaded in your tests.
  */

  server.createList('app', 8, 'withLiveBuild');
  server.createList('public-key', 5);
  server.create('host-app', {
    name: 'HotDoc',
    id: 'current'
  });
}
