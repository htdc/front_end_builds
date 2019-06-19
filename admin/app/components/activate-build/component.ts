import Component from '@glimmer/component';
import { dropTask } from 'ember-concurrency-decorators';
import Build from 'admin/models/build';
import { get, set, computed } from '@ember/object';
import { inject as service } from '@ember/service';
import Store from 'ember-data/store';

type Args = {
  build: Build
};

export default class ActivateBuild extends Component<Args> {
  @service store!: Store;
  @dropTask
  activate = function*(this: ActivateBuild) {
    const appProxy = get(this.args.build, 'app');
    const appId = get(appProxy, 'id');
    const app = this.store.peekRecord('app', appId);
    if (app) {
      set(app, 'liveBuild', this.args.build);
      yield app.save();
    }
  }

  @computed('args.build.isLive')
  get buttonClass() {
    if (this.args.build.isLive) {
      return 'green';
    }
    return '';
  }
}
