import { belongsTo, hasMany } from 'ember-data/relationships';
import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { not, sort } from '@ember/object/computed';
import Build from './build';

export default class App extends Model {
  @attr('string') name!: string;
  @attr('string') apiKey!: string;
  @attr('string') locaiton!: string;
  @attr('boolean') requireManualActivation!: boolean;
  @not('requireManualActivation') activateNewDeploys!: boolean;

  buildsSorting = ['createdAt:desc'];

  @sort('builds', 'buildsSorting') orderedBuilds!: Build[];

  @hasMany('build') builds?: Build[];

  @belongsTo('build') liveBuild?: Build;
}

// DO NOT DELETE: this is how TypeScript knows how to look up your models.
declare module 'ember-data/types/registries/model' {
  export default interface ModelRegistry {
    'app': App;
  }
}
