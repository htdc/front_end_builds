import { Factory } from 'ember-cli-mirage';
import faker from 'faker';

export default Factory.extend({
  sha: faker.random.uuid,
  branch: () => faker.random.arrayElement(['master', 'feature', 'staging']),
  createdAt: faker.date.past,
  location: faker.internet.url
});
