import { Factory, trait, association } from 'ember-cli-mirage';
import faker from 'faker';

export default Factory.extend({
  name: faker.hacker.adjective,
  location: faker.internet.url,
  requireManualActivation: false,
  withLiveBuild: trait({
    liveBuild: association(),
    afterCreate(app, server) {
      app.update({
        builds: server.createList('build', 10)
      });
    }
  })
});
