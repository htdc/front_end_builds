import Route from '@ember/routing/route';

export default class AppIndexRoute extends Route {
  model() {
    return this.store.findAll('app');
  }
}
