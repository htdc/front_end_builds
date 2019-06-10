import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import RouterService from '@ember/routing/router-service';
import Store from 'ember-data/store';
import { dropTask } from 'ember-concurrency-decorators';
import { Owner } from '@glimmer/di';
import App from 'admin/models/app';

type Args = {};

export default class NewAppPage extends Component {
  @service router!: RouterService;
  @service store!: Store;
  app: App;
  constructor(owner: Owner, args: Args) {
    super(owner, args);
    this.app = this.store.createRecord('app');
  }
  cancel() {
    this.app.destroyRecord();
    this.router.transitionTo('apps.index');
  }

  @dropTask
  create = function*(this: NewAppPage) {
    yield this.app.save();
    yield this.router.transitionTo('apps.index');
  };

  toggleAutoActivate() {
    this.app.requireManualActivation = !this.app.requireManualActivation;
  }
}
