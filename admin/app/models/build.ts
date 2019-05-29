import Model from 'ember-data/model';
import { belongsTo } from 'ember-data/relationships';
import attr from 'ember-data/attr';
import App from './app';
import { computed } from '@ember/object';

export default class Build extends Model {
  @belongsTo('app', { inverse: 'builds' }) app!: App;

  @attr('string') sha!: string;
  // Excluding job attr from old version as it's not used
  @attr('string') branch!: string;
  @attr('date') createdAt!: Date;

  @computed('app.liveBuildId')
  get isLive() {
    const liveBuild = this.app.liveBuild;
    if (!liveBuild) {
      return false;
    }
    return this.id === liveBuild.id;
  }

  activate() {
    throw "Not implemented";
  }

  @computed('sha')
  get shortSha() {
    return this.sha && this.sha.slice(0, 7);
  }

  @computed('app.location', 'isLive', 'id')
  get location() {
    const base = this.app.location;
    return this.isLive ? base : `${base}?id=${this.id}`;
  }
}

// DO NOT DELETE: this is how TypeScript knows how to look up your models.
declare module 'ember-data/types/registries/model' {
  export default interface ModelRegistry {
    build: Build;
  }
}
