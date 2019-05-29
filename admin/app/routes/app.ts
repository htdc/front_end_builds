import Route from '@ember/routing/route';

export default class Apps extends Route {
  model(params: { app_id: string }) {
    return this.store.findRecord('app', params.app_id);
  }
}
