import Model from 'ember-data/model'
import attr from 'ember-data/attr';
import { computed } from '@ember/object';
import { capitalize } from '@ember/string';

export default class HostApp extends  Model {
  @attr('string') name!: string;

  @computed('name')
  get friendlyName() {
    return capitalize(this.name.replace(/_/g, ' '));
  }
}
// DO NOT DELETE: this is how TypeScript knows how to look up your models.
declare module 'ember-data/types/registries/model' {
  export default interface ModelRegistry {
    'host-app': HostApp;
  }
}
