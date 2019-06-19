import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import { dropTask } from 'ember-concurrency-decorators';
import { Owner } from '@glimmer/di';
import RouterService from '@ember/routing/router-service';
import Store from 'ember-data/store';
import PublicKey from 'admin/models/public-key';

type Args = {};

export default class NewSshKeyPage extends Component {
  @service router!: RouterService;
  @service store!: Store;
  publicKey: PublicKey;
  constructor(owner: Owner, args: Args) {
    super(owner, args);
    this.publicKey = this.store.createRecord('public-key');
  }

  cancel() {
    this.publicKey.deleteRecord();
    this.router.transitionTo('public-keys.index');
  }

  @dropTask
  create = function*(this: NewSshKeyPage) {
    yield this.publicKey.save();
    yield this.router.transitionTo('public-keys.index');
  };
}
