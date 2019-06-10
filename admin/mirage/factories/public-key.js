import { Factory } from 'ember-cli-mirage';
import faker from 'faker';

export default Factory.extend({
  fingerprint: () => faker.random.alphaNumeric(20).match(/../g).join(':'),
  name: faker.hacker.phrase
});
