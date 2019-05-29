import Route from '@ember/routing/route';

export default class Apps extends Route {
  model() {
    return this.store.findAll('app');
  }
}
